-- OPTION 1: SEPARATE TABLES PER COUNTRY
CREATE TABLE nigeria_patients (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email)
) ENGINE=InnoDB;

CREATE TABLE cotedivoire_patients (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email)
) ENGINE=InnoDB;

-- OPTION 2: PARTITIONED TABLE (RECOMMENDED)
CREATE TABLE patients_partitioned (
    id BIGINT AUTO_INCREMENT,
    country_code VARCHAR(2) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id, country_code),
    INDEX idx_country (country_code),
    INDEX idx_email (email, country_code)
) ENGINE=InnoDB
PARTITION BY LIST COLUMNS(country_code) (
    PARTITION p_nigeria VALUES IN ('NG'),
    PARTITION p_cotedivoire VALUES IN ('CI')
);

-- Insert sample data for Nigeria (70 records) into SEPARATE TABLES
INSERT INTO nigeria_patients (first_name, last_name, email, phone) VALUES
('Adebayo', 'Okonkwo', 'adebayo.okonkwo@email.com', '+234801234567'),
('Chioma', 'Nwosu', 'chioma.nwosu@email.com', '+234802345678'),
('Emeka', 'Eze', 'emeka.eze@email.com', '+234803456789'),
('Funmi', 'Adeniran', 'funmi.adeniran@email.com', '+234804567890'),
('Gbenga', 'Okafor', 'gbenga.okafor@email.com', '+234805678901'),
('Halima', 'Yusuf', 'halima.yusuf@email.com', '+234806789012'),
('Ibrahim', 'Musa', 'ibrahim.musa@email.com', '+234807890123'),
('Joke', 'Adeyemi', 'joke.adeyemi@email.com', '+234808901234'),
('Kemi', 'Balogun', 'kemi.balogun@email.com', '+234809012345'),
('Lekan', 'Oyekunle', 'lekan.oyekunle@email.com', '+234801123456'),
('Maryam', 'Abdullahi', 'maryam.abdullahi@email.com', '+234802234567'),
('Ngozi', 'Chukwu', 'ngozi.chukwu@email.com', '+234803345678'),
('Oluwaseun', 'Babatunde', 'oluwaseun.babatunde@email.com', '+234804456789'),
('Peter', 'Obi', 'peter.obi@email.com', '+234805567890'),
('Queen', 'Ajayi', 'queen.ajayi@email.com', '+234806678901'),
('Rasheed', 'Ibrahim', 'rasheed.ibrahim@email.com', '+234807789012'),
('Sade', 'Williams', 'sade.williams@email.com', '+234808890123'),
('Tunde', 'Fashola', 'tunde.fashola@email.com', '+234809901234'),
('Uche', 'Okoro', 'uche.okoro@email.com', '+234801012345'),
('Victoria', 'Agu', 'victoria.agu@email.com', '+234802123456'),
('Wale', 'Adebisi', 'wale.adebisi@email.com', '+234803234567'),
('Yemi', 'Ogunbiyi', 'yemi.ogunbiyi@email.com', '+234804345678'),
('Zainab', 'Mohammed', 'zainab.mohammed@email.com', '+234805456789'),
('Akin', 'Oladele', 'akin.oladele@email.com', '+234806567890'),
('Blessing', 'Udoh', 'blessing.udoh@email.com', '+234807678901'),
('Chidi', 'Nnamdi', 'chidi.nnamdi@email.com', '+234808789012'),
('Daniel', 'Benson', 'daniel.benson@email.com', '+234809890123'),
('Esther', 'Akpan', 'esther.akpan@email.com', '+234801901234'),
('Felix', 'Onyeka', 'felix.onyeka@email.com', '+234802012345'),
('Grace', 'Nkechi', 'grace.nkechi@email.com', '+234803123456'),
('Henry', 'Okeke', 'henry.okeke@email.com', '+234804234567'),
('Ifeanyi', 'Chukwuka', 'ifeanyi.chukwuka@email.com', '+234805345678'),
('Jennifer', 'Amadi', 'jennifer.amadi@email.com', '+234806456789'),
('Kunle', 'Alabi', 'kunle.alabi@email.com', '+234807567890'),
('Lola', 'Oseni', 'lola.oseni@email.com', '+234808678901'),
('Michael', 'Ojo', 'michael.ojo@email.com', '+234809789012'),
('Nneka', 'Igwe', 'nneka.igwe@email.com', '+234801890123'),
('Obinna', 'Nwankwo', 'obinna.nwankwo@email.com', '+234802901234'),
('Peace', 'Effiong', 'peace.effiong@email.com', '+234803012345'),
('Segun', 'Afolabi', 'segun.afolabi@email.com', '+234804123456'),
('Taiwo', 'Kehinde', 'taiwo.kehinde@email.com', '+234805234567'),
('Uchenna', 'Opara', 'uchenna.opara@email.com', '+234806345678'),
('Vincent', 'Dike', 'vincent.dike@email.com', '+234807456789'),
('Wumi', 'Adewale', 'wumi.adewale@email.com', '+234808567890'),
('Xavier', 'Chinedu', 'xavier.chinedu@email.com', '+234809678901'),
('Yetunde', 'Okafor', 'yetunde.okafor@email.com', '+234801789012'),
('Zahra', 'Bello', 'zahra.bello@email.com', '+234802890123'),
('Ahmed', 'Suleiman', 'ahmed.suleiman@email.com', '+234803901234'),
('Bimpe', 'Olamide', 'bimpe.olamide@email.com', '+234804012345'),
('Chinedu', 'Obi', 'chinedu.obi@email.com', '+234805123456'),
('Damilola', 'Ogunleye', 'damilola.ogunleye@email.com', '+234806234567'),
('Ebube', 'Okafor', 'ebube.okafor@email.com', '+234807345678'),
('Folake', 'Adeniyi', 'folake.adeniyi@email.com', '+234808456789'),
('Gideon', 'Nwachukwu', 'gideon.nwachukwu@email.com', '+234809567890'),
('Hassan', 'Aliyu', 'hassan.aliyu@email.com', '+234801678901'),
('Ifeoma', 'Okonkwo', 'ifeoma.okonkwo@email.com', '+234802789012'),
('Joseph', 'Okoli', 'joseph.okoli@email.com', '+234803890123'),
('Khadijah', 'Usman', 'khadijah.usman@email.com', '+234804901234'),
('Lanre', 'Adeyemo', 'lanre.adeyemo@email.com', '+234805012345'),
('Mojisola', 'Adeola', 'mojisola.adeola@email.com', '+234806123456'),
('Nnamdi', 'Azikiwe', 'nnamdi.azikiwe@email.com', '+234807234567'),
('Obiageli', 'Nnaji', 'obiageli.nnaji@email.com', '+234808345678'),
('Patrick', 'Eze', 'patrick.eze@email.com', '+234809456789'),
('Rachael', 'Uzoma', 'rachael.uzoma@email.com', '+234801567890'),
('Samuel', 'Adebayo', 'samuel.adebayo@email.com', '+234802678901'),
('Temitope', 'Oluwole', 'temitope.oluwole@email.com', '+234803789012'),
('Usman', 'Garba', 'usman.garba@email.com', '+234804890123'),
('Vivian', 'Okoro', 'vivian.okoro@email.com', '+234805901234'),
('Wasiu', 'Ayinde', 'wasiu.ayinde@email.com', '+234806012345'),
('Yinka', 'Oladipo', 'yinka.oladipo@email.com', '+234807123456');

-- Insert sample data for Côte d'Ivoire (30 records) into SEPARATE TABLES
INSERT INTO cotedivoire_patients (first_name, last_name, email, phone) VALUES
('Kouadio', 'Yao', 'kouadio.yao@email.com', '+22507123456'),
('Amoin', 'Koffi', 'amoin.koffi@email.com', '+22507234567'),
('Adjoua', 'N\'Guessan', 'adjoua.nguessan@email.com', '+22507345678'),
('Koffi', 'Kouassi', 'koffi.kouassi@email.com', '+22507456789'),
('Aké', 'Diallo', 'ake.diallo@email.com', '+22507567890'),
('Bamba', 'Traoré', 'bamba.traore@email.com', '+22507678901'),
('Yasmine', 'Coulibaly', 'yasmine.coulibaly@email.com', '+22507789012'),
('Mamadou', 'Touré', 'mamadou.toure@email.com', '+22507890123'),
('Fatou', 'Koné', 'fatou.kone@email.com', '+22507901234'),
('Ibrahim', 'Sanogo', 'ibrahim.sanogo@email.com', '+22508012345'),
('Aminata', 'Ouattara', 'aminata.ouattara@email.com', '+22508123456'),
('Seydou', 'Diabaté', 'seydou.diabate@email.com', '+22508234567'),
('Mariam', 'Dembélé', 'mariam.dembele@email.com', '+22508345678'),
('Moussa', 'Sissoko', 'moussa.sissoko@email.com', '+22508456789'),
('Fatoumata', 'Konaté', 'fatoumata.konate@email.com', '+22508567890'),
('Lamine', 'Cissé', 'lamine.cisse@email.com', '+22508678901'),
('Aïcha', 'Bakayoko', 'aicha.bakayoko@email.com', '+22508789012'),
('Youssouf', 'Fofana', 'youssouf.fofana@email.com', '+22508890123'),
('Hawa', 'Camara', 'hawa.camara@email.com', '+22508901234'),
('Aboubacar', 'Condé', 'aboubacar.conde@email.com', '+22509012345'),
('Djénéba', 'Sylla', 'djeneba.sylla@email.com', '+22509123456'),
('Souleymane', 'Bah', 'souleymane.bah@email.com', '+22509234567'),
('Kadiatou', 'Doumbia', 'kadiatou.doumbia@email.com', '+22509345678'),
('Bakary', 'Keita', 'bakary.keita@email.com', '+22509456789'),
('Nana', 'Yao', 'nana.yao@email.com', '+22509567890'),
('Awa', 'Sow', 'awa.sow@email.com', '+22509678901'),
('Adama', 'Diarra', 'adama.diarra@email.com', '+22509789012'),
('Salif', 'Traoré', 'salif.traore@email.com', '+22509890123'),
('Maimouna', 'Barry', 'maimouna.barry@email.com', '+22509901234'),
('Lancine', 'Doumbia', 'lancine.doumbia@email.com', '+22507012345');

-- Copy all data to partitioned table with country_code
INSERT INTO patients_partitioned (country_code, first_name, last_name, email, phone, created_at)
SELECT 'NG', first_name, last_name, email, phone, created_at FROM nigeria_patients;

INSERT INTO patients_partitioned (country_code, first_name, last_name, email, phone, created_at)
SELECT 'CI', first_name, last_name, email, phone, created_at FROM cotedivoire_patients;