# Author: Shiyang Yu
# Date: 2018/12/21

CREATE TABLE administrative_staff ( 
employee_id CHAR(20) NOT NULL, 
title CHAR(20) 
); 
ALTER TABLE administrative_staff ADD CONSTRAINT administrative_staff_pk PRIMARY KEY ( employee_id ); 
CREATE TABLE diagnoses ( 
visiting_visitid CHAR(15) NOT NULL, 
medical_code_list_medical_code CHAR(15) NOT NULL 
); 
ALTER TABLE diagnoses ADD CONSTRAINT diagnoses_pk PRIMARY KEY 
( medical_code_list_medical_code, 
visiting_visitid ); 
CREATE TABLE drug_list ( 
drugid CHAR(30) NOT NULL, 
description CHAR(50), 
stock_on_hand INTEGER, 
cost_per_unit CHAR(10) 
); 
ALTER TABLE drug_list ADD CONSTRAINT drug_list_pk PRIMARY KEY ( drugid ); 
CREATE TABLE medical_code_list ( 
medical_code CHAR(15) NOT NULL, 
description CHAR(50) 
); 
ALTER TABLE medical_code_list ADD CONSTRAINT medical_code_list_pk PRIMARY KEY ( medical_code ); 
CREATE TABLE nurse ( 
employee_id CHAR(20) NOT NULL, 
certification CHAR(20) 
); 
ALTER TABLE nurse ADD CONSTRAINT nurse_pk PRIMARY KEY ( employee_id ); 
CREATE TABLE patient ( 
patient_id CHAR(20) NOT NULL, 
name CHAR(30), 
address CHAR(200), 
dob DATE, 
tel CHAR(15) 
); 
ALTER TABLE patient ADD CONSTRAINT patient_pk PRIMARY KEY ( patient_id ); 
CREATE TABLE physician ( 
employee_id CHAR(20) NOT NULL, 
certification CHAR(20), 
other_certifications CHAR(20), 
speciality CHAR(30) 
); 
ALTER TABLE physician ADD CONSTRAINT physician_pk PRIMARY KEY ( employee_id ); 
CREATE TABLE prescription ( 
number_of_days NUMBER(38), 
times_pers_day NUMBER(38), 
visiting_visitid CHAR(15) NOT NULL, 
drug_list_drugid CHAR(30) NOT NULL 
); 
ALTER TABLE prescription ADD CONSTRAINT prescription_pk PRIMARY KEY ( drug_list_drugid, 
visiting_visitid ); 
CREATE TABLE staff ( 
employee_id CHAR(20) NOT NULL, 
name CHAR(30), 
date_hired DATE, 
type CHAR(20) 
); 
ALTER TABLE staff 
ADD CONSTRAINT fkarc_1_lov CHECK ( type IN ( 
'Technologist', 
'Nurse', 
'Administrative_Staff', 
'Physician' 
) ); 
ALTER TABLE staff ADD CONSTRAINT fkarc_1_nn CHECK ( type IS NOT NULL ); 
ALTER TABLE staff ADD CONSTRAINT staff_pk PRIMARY KEY ( employee_id ); 
CREATE TABLE technologist ( 
employee_id CHAR(20) NOT NULL, 
certification CHAR(20), 
title CHAR(20) 
); 
ALTER TABLE technologist ADD CONSTRAINT technologist_pk PRIMARY KEY ( employee_id ); 
CREATE TABLE tests ( 
test_code CHAR(3) NOT NULL, 
type CHAR(25) 
); 
ALTER TABLE tests ADD CONSTRAINT tests_pk PRIMARY KEY ( test_code ); 
CREATE TABLE used_tests ( 
result CHAR(100), 
description CHAR(100), 
technologist_employee_id CHAR(20) NOT NULL, 
tests_test_code CHAR(3) NOT NULL, 
visiting_visitid CHAR(15) NOT NULL 
); 
ALTER TABLE used_tests ADD CONSTRAINT used_tests_pk PRIMARY KEY ( tests_test_code, 
visiting_visitid ); 
CREATE TABLE visiting ( 
visitid CHAR(15) NOT NULL, 
"Date" DATE, 
temperature VARCHAR2(15), 
weight VARCHAR2(15), 
blood_pressure CHAR(10), 
notes CHAR(200), 
other_instructions CHAR(250), 
nurse_employee_id CHAR(20) NOT NULL, 
physician_employee_id CHAR(20), 
patient_patient_id CHAR(20) NOT NULL 
); 
ALTER TABLE visiting ADD CONSTRAINT visiting_pk PRIMARY KEY ( visitid ); 
ALTER TABLE administrative_staff 
ADD CONSTRAINT administrative_staff_staff_fk FOREIGN KEY ( employee_id ) 
REFERENCES staff ( employee_id ); 
ALTER TABLE diagnoses 
ADD CONSTRAINT diagnoses_medical_code_list_fk FOREIGN KEY ( medical_code_list_medical_code ) 
REFERENCES medical_code_list ( medical_code ); 
ALTER TABLE diagnoses 
ADD CONSTRAINT diagnoses_visiting_fk FOREIGN KEY ( visiting_visitid ) 
REFERENCES visiting ( visitid ); 
ALTER TABLE nurse 
ADD CONSTRAINT nurse_staff_fk FOREIGN KEY ( employee_id ) 
REFERENCES staff ( employee_id ); 
ALTER TABLE physician 
ADD CONSTRAINT physician_staff_fk FOREIGN KEY ( employee_id ) 
REFERENCES staff ( employee_id ); 
ALTER TABLE prescription 
ADD CONSTRAINT prescription_drug_list_fk FOREIGN KEY ( drug_list_drugid ) 
REFERENCES drug_list ( drugid ); 
ALTER TABLE prescription 
ADD CONSTRAINT prescription_visiting_fk FOREIGN KEY ( visiting_visitid ) 
REFERENCES visiting ( visitid ); 
ALTER TABLE technologist 
ADD CONSTRAINT technologist_staff_fk FOREIGN KEY ( employee_id ) 
REFERENCES staff ( employee_id ); 
ALTER TABLE used_tests 
ADD CONSTRAINT used_tests_technologist_fk FOREIGN KEY ( technologist_employee_id ) 
REFERENCES technologist ( employee_id ); 
ALTER TABLE used_tests 
ADD CONSTRAINT used_tests_tests_fk FOREIGN KEY ( tests_test_code ) 
REFERENCES tests ( test_code ); 
ALTER TABLE used_tests 
ADD CONSTRAINT used_tests_visiting_fk FOREIGN KEY ( visiting_visitid ) 
REFERENCES visiting ( visitid ); 
ALTER TABLE visiting 
ADD CONSTRAINT visiting_nurse_fk FOREIGN KEY ( nurse_employee_id ) 
REFERENCES nurse ( employee_id ); 
ALTER TABLE visiting 
ADD CONSTRAINT visiting_patient_fk FOREIGN KEY ( patient_patient_id ) 
REFERENCES patient ( patient_id ); 
ALTER TABLE visiting 
ADD CONSTRAINT visiting_physician_fk FOREIGN KEY ( physician_employee_id ) 
REFERENCES physician ( employee_id ); 
CREATE OR REPLACE TRIGGER arc_fkarc_1_technologist BEFORE 
INSERT OR UPDATE OF employee_id ON technologist 
FOR EACH ROW 
DECLARE 
d CHAR(20); 
BEGIN 
SELECT 
a.type 
INTO 
d 
FROM 
staff a 
WHERE 
a.employee_id =:new.employee_id; 
IF 
( d IS NULL OR d <> 'Technologist' ) 
THEN 
raise_application_error(-20223,'FK Technologist_STAFF_FK in Table Technologist violates Arc constraint on Table STAFF - discriminator column Type doesn''t have value ''Technologist''' 
); 
END IF; 
EXCEPTION 
WHEN no_data_found THEN 
NULL; 
WHEN OTHERS THEN 
RAISE; 
END; 
/ 
CREATE OR REPLACE TRIGGER arc_fkarc_1_nurse BEFORE 
INSERT OR UPDATE OF employee_id ON nurse 
FOR EACH ROW 
DECLARE 
d CHAR(20); 
BEGIN 
SELECT 
a.type 
INTO 
d 
FROM 
staff a 
WHERE 
a.employee_id =:new.employee_id; 
IF 
( d IS NULL OR d <> 'Nurse' ) 
THEN 
raise_application_error(-20223,'FK Nurse_STAFF_FK in Table Nurse violates Arc constraint on Table STAFF - discriminator column Type doesn''t have value ''Nurse''' 
); 
END IF; 
EXCEPTION 
WHEN no_data_found THEN 
NULL; 
WHEN OTHERS THEN 
RAISE; 
END; 
/ 
CREATE OR REPLACE TRIGGER arc_fkarc_administrative_staff BEFORE 
INSERT OR UPDATE OF employee_id ON administrative_staff 
FOR EACH ROW 
DECLARE 
d CHAR(20); 
BEGIN 
SELECT 
a.type 
INTO 
d 
FROM 
staff a 
WHERE 
a.employee_id =:new.employee_id; 
IF 
( d IS NULL OR d <> 'Administrative_Staff' ) 
THEN 
raise_application_error(-20223,'FK Administrative_Staff_STAFF_FK in Table Administrative_Staff violates Arc constraint on Table STAFF - discriminator column Type doesn''t have value ''Administrative_Staff''' 
); 
END IF; 
EXCEPTION 
WHEN no_data_found THEN 
NULL; 
WHEN OTHERS THEN 
RAISE; 
END; 
/ 
CREATE OR REPLACE TRIGGER arc_fkarc_1_physician BEFORE 
INSERT OR UPDATE OF employee_id ON physician 
FOR EACH ROW 
DECLARE 
d CHAR(20); 
BEGIN 
SELECT 
a.type 
INTO 
d 
FROM 
staff a 
WHERE 
a.employee_id =:new.employee_id; 
IF 
( d IS NULL OR d <> 'Physician' ) 
THEN 
raise_application_error(-20223,'FK Physician_STAFF_FK in Table Physician violates Arc constraint on Table STAFF - discriminator column Type doesn''t have value ''Physician''' 
); 
END IF; 
EXCEPTION 
WHEN no_data_found THEN 
NULL; 
WHEN OTHERS THEN 
RAISE; 
END; 
