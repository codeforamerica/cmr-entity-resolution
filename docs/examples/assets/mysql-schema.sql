DROP TABLE IF EXISTS people;
CREATE TABLE people(
   party_id VARCHAR(255) NOT NULL,
   last_name VARCHAR(255) NULL,
   first_name VARCHAR(255) NULL,
   gender VARCHAR(255) NULL,
   birth_date VARCHAR(255) NULL,
   dr_lic_num VARCHAR(255) NULL,
   dr_lic_state VARCHAR(255) NULL,
   ssn VARCHAR(255) NULL,
   address_1 VARCHAR(255) NULL,
   address_2 VARCHAR(255) NULL,
   city VARCHAR(255) NULL,
   state_code VARCHAR(255) NULL,
   zip_code VARCHAR(255) NULL,
   bus_phone VARCHAR(255) NULL,
   home_phone VARCHAR(255) NULL,
   email_address VARCHAR(255) NULL,
   otn VARCHAR(255) NULL,
   party_code VARCHAR(255) NULL
);

LOAD DATA LOCAL INFILE "/docker-entrypoint-initdb.d/import.csv"
     INTO TABLE people
     FIELDS TERMINATED BY ','
     LINES TERMINATED BY '\n'
     IGNORE 1 ROWS;

CREATE TABLE entity_resolution(
  person_id VARCHAR(255) NOT NULL,
  database VARCHAR(255) NOT NULL,
  party_id VARCHAR(255) NOT NULL,
  match_score INTEGER NULL,
  potential_person_id VARCHAR(255) NULL,
  potential_match_score INTEGER NULL,
  PRIMARY KEY (person_id, party_id, database)
);
