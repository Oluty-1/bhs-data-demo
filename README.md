# Better-Health Data Architecture Demo

Visual demo comparing regular tables vs partitioned tables for multi-country data.

## What This Demo Shows

1. **Data Distribution**: 70 Nigerian patients, 30 Ivorian patients
2. **Regular Table**: All data mixed together
3. **Partitioned Table**: Same data, physically separated by country
4. **Performance Comparison**: Side-by-side query speed comparison

## Prerequisites

- Docker Desktop installed
- Port 3306 and 5000 available

## How to Run

### 1. Start the demo
```bash
cd /mnt/user-data/outputs
docker-compose up --build
```

Wait for this message:
```
better-health-demo  | * Running on all addresses (0.0.0.0)
better-health-demo  | * Running on http://127.0.0.1:5000
```

### 2. Open in browser
```
http://localhost:5000
```

### 3. Run the demo
- Click "Query Nigeria Data" button
- Click "Query Côte d'Ivoire Data" button
- Compare the results

## What You'll See

**Regular Table:**
- Scans ALL rows (Nigeria + CI mixed)
- Slower query time
- No optimization

**Partitioned Table:**
- Only scans relevant partition (partition pruning)
- Faster query time
- MySQL automatically routes to correct partition

## Demo Features

✅ **Visual Stats Dashboard** - See data distribution  
✅ **Side-by-Side Comparison** - Regular vs Partitioned  
✅ **Real Performance Metrics** - Actual query times  
✅ **Partition Pruning Proof** - EXPLAIN output showing which partition was used  
✅ **Beautiful UI** - Professional looking demo  

## Stopping the Demo

```bash
docker-compose down
```

## Troubleshooting

**Port already in use:**
```bash
# Stop any existing MySQL
docker stop $(docker ps -q)

# Or change ports in docker-compose.yml
```

**Database not ready:**
- Wait 10-15 seconds after starting
- MySQL needs time to initialize

**Reset everything:**
```bash
docker-compose down -v
docker-compose up --build
```

## Demo Script for Presentation

1. **Introduction (1 min)**
   - "We have 100 patients: 70 from Nigeria, 30 from Côte d'Ivoire"
   - "Let's see how different architectures perform"

2. **Show Regular Table (1 min)**
   - Click "Query Nigeria Data"
   - "Notice: scans all 100 rows even for Nigeria-only query"
   - Point out query time

3. **Show Partitioned Table (1 min)**
   - "Same query, partitioned table"
   - "Notice: Only scans p_nigeria partition (70 rows)"
   - Point out faster time

4. **Highlight Benefits (1 min)**
   - "Partition pruning = automatic optimization"
   - "No code changes needed"
   - "Same query, MySQL handles routing"

5. **Q&A (1 min)**

Total: 5 minutes

## Key Points to Emphasize

🎯 **Partition Pruning**: MySQL automatically skips irrelevant partitions  
🎯 **No Code Changes**: Application doesn't need to know about partitions  
🎯 **Real Performance Gain**: Measurable improvement in query time  
🎯 **Scalability**: Adding Ghana = one ALTER command  

## Files Included

```
.
├── docker-compose.yml     # Orchestrates MySQL + Flask app
├── Dockerfile            # Flask app container
├── app.py               # Python Flask backend
├── init.sql             # Database setup + sample data
├── templates/
│   └── index.html       # Visual demo interface
└── README.md           # This file
```

## What Happens Behind the Scenes

1. Docker starts MySQL 8.0 with sample data
2. Creates two tables: `patients_regular` and `patients_partitioned`
3. Inserts 100 patient records (70 NG, 30 CI)
4. Flask app runs queries and measures timing
5. Web UI displays results visually

## Technical Details

**Database:**
- MySQL 8.0
- 100 patient records
- Partitioned by `country_code` (LIST COLUMNS)

**Query Comparison:**
```sql
-- Both tables get same query
SELECT * FROM patients WHERE country_code = 'NG' AND email LIKE 'a%'

-- Regular: Scans all 100 rows
-- Partitioned: Scans only p_nigeria partition (70 rows)
```

**Performance Measurement:**
- Python `time.time()` before/after query
- Converts to milliseconds
- Shows EXPLAIN output to prove partition pruning

## Customization

**Add more data:**
Edit `init.sql` and add more INSERT statements

**Change countries:**
Edit partition definitions in `init.sql`:
```sql
PARTITION BY LIST COLUMNS(country_code) (
    PARTITION p_nigeria VALUES IN ('NG'),
    PARTITION p_ghana VALUES IN ('GH')  -- Add Ghana
);
```

**Adjust UI colors:**
Edit CSS in `templates/index.html`