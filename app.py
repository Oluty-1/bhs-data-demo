from flask import Flask, render_template, jsonify
import pymysql
import os
import time

app = Flask(__name__)

def get_db_connection():
    return pymysql.connect(
        host=os.getenv('DB_HOST', 'localhost'),
        user=os.getenv('DB_USER', 'root'),
        password=os.getenv('DB_PASSWORD', 'demo123'),
        database=os.getenv('DB_NAME', 'better_health_db'),
        cursorclass=pymysql.cursors.DictCursor
    )

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/stats')
def get_stats():
    conn = get_db_connection()
    cursor = conn.cursor()
    
    cursor.execute("SELECT COUNT(*) as total FROM nigeria_patients")
    ng_count = cursor.fetchone()['total']
    
    cursor.execute("SELECT COUNT(*) as total FROM cotedivoire_patients")
    ci_count = cursor.fetchone()['total']
    
    total_count = ng_count + ci_count
    
    cursor.close()
    conn.close()
    
    return jsonify({
        'nigeria': ng_count,
        'cotedivoire': ci_count,
        'total': total_count
    })

@app.route('/api/compare/<country>')
def compare_all(country):
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Determine table name for separate tables approach
        table_name = 'nigeria_patients' if country == 'NG' else 'cotedivoire_patients'
        country_name = 'Nigeria' if country == 'NG' else 'Côte d\'Ivoire'
        
        # OPTION 1: SEPARATE TABLES
        start = time.time()
        cursor.execute(f"SELECT * FROM {table_name} WHERE email LIKE 'a%'")
        separate_results = cursor.fetchall()
        separate_duration = (time.time() - start) * 1000
        
        cursor.execute(f"EXPLAIN SELECT * FROM {table_name} WHERE email LIKE 'a%'")
        separate_explain = cursor.fetchall()
        
        # OPTION 3: PARTITIONED TABLE
        start = time.time()
        cursor.execute("""
            SELECT * FROM patients_partitioned 
            WHERE country_code = %s AND email LIKE 'a%%'
        """, (country,))
        partitioned_results = cursor.fetchall()
        partitioned_duration = (time.time() - start) * 1000
        
        try:
            cursor.execute("""
                EXPLAIN PARTITIONS 
                SELECT * FROM patients_partitioned 
                WHERE country_code = %s
            """, (country,))
            partitioned_explain = cursor.fetchall()
        except Exception:
            # EXPLAIN PARTITIONS might not be available, try regular EXPLAIN
            cursor.execute("""
                EXPLAIN 
                SELECT * FROM patients_partitioned 
                WHERE country_code = %s
            """, (country,))
            partitioned_explain = cursor.fetchall()
        
        cursor.close()
        conn.close()
        
        # Calculate improvements
        separate_vs_partitioned = 0
        if separate_duration > 0:
            separate_vs_partitioned = ((separate_duration - partitioned_duration) / separate_duration) * 100
        
        return jsonify({
            'country': country_name,
            'separate_tables': {
                'duration_ms': round(separate_duration, 2),
                'table_used': table_name,
                'results_count': len(separate_results),
                'rows_examined': separate_explain[0].get('rows', 0) if separate_explain else 0,
                'pros': ['Clear separation', 'Simple queries'],
                'cons': ['Code duplication', 'Hard to scale', 'Complex cross-country queries']
            },
            'partitioned': {
                'duration_ms': round(partitioned_duration, 2),
                'partition_used': partitioned_explain[0].get('partitions', 'N/A') if partitioned_explain else 'N/A',
                'results_count': len(partitioned_results),
                'pros': ['Automatic optimization', 'No code changes', 'Easy scaling', 'Best performance'],
                'cons': ['PK includes country_code']
            },
            'improvement_percent': round(separate_vs_partitioned, 1),
            'separate_databases_note': 'Same as separate tables but requires 2 MySQL instances (2x cost + complexity)'
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3000, debug=True)