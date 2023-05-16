DATABASE SYSADMIN;

DROP DATABASE IF EXISTS people;
CREATE DATABASE people WITH log;

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

LOAD FROM "people.unl" INSERT INTO people(party_id, last_name, first_name,
    gender, birth_date, dr_lic_num, dr_lic_state, ssn, address_1, address_2,
    city, state_code, zip_code, bus_phone, home_phone, email_address, otn,
    party_code);

DATABASE people;
