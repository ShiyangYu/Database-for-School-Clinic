# List patient id and name of each patient and number of visits the patient has made

Select Patient_ID, Name, count(VisitID) AS Visit_Num
From patient p, visiting v
Where p.Patient_ID = v.PATIENT_PATIENT_ID
Group by p.PATIENT_ID, p.Name;

# List the drug that has been prescribed most often.

SELECT * 
FROM
(SELECT DRUG_LIST_DRUGID, COUNT(VISITING_VISITID) AS NUM
FROM PRESCRIPTION
GROUP BY DRUG_LIST_DRUGID
ORDER BY NUM DESC)
WHERE ROWNUM = 1;

# Identify the number of visits handled by each nurse.

SELECT NURSE_EMPLOYEE_ID, COUNT(NURSE_EMPLOYEE_ID) AS NUM_VISIT
FROM VISITING
GROUP BY NURSE_EMPLOYEE_ID;

#Identify all the physicians that a patient has seen. If the patient has only been seen by a nurse and not by any physician, corresponding columns in the resulting table should contain blank.

SELECT PHYSICIAN_EMPLOYEE_ID, PATIENT_PATIENT_ID
FROM VISITING
Order by PATIENT_PATIENT_ID





