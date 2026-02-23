# Intercambios-Sin-Fronteras-Database-System

## Project Overview

**Intercambios Sin Fronteras** is a relational database system designed to manage international student exchange programs.
The system models students, universities, applications, exchanges, languages, and geographic information, while enforcing real-world business rules through SQL logic.

This project emphasizes **data integrity**, **business logic implementation**, and **advanced SQL querying**, making it suitable both for academic evaluation and professional portfolio use.

---

## Database Design

The database follows a normalized relational design and includes:

* **Geographic hierarchy** (states, municipalities, neighborhoods, addresses)
* **Students** (local and exchange)
* **Universities** (national and international)
* **Applications and exchanges**
* **Languages and multilingual students**

Primary and foreign keys are strictly enforced to guarantee **referential integrity**.

---

## Business Logic Implementation

### Function

**`is_student_eligible(id_alumno)`**
Determines whether a student is eligible for an exchange program based on GPA requirements.

* Returns `TRUE` if GPA ≥ 8.0
* Returns `FALSE` otherwise

---

### Stored Procedure

**`create_exchange_request(id_alumno, status)`**
Creates a new exchange application for an existing student.

* Automatically assigns the current date
* Enforces foreign key constraints

---

### Trigger

**`trg_validate_exchange_gpa`**
Prevents the creation of an exchange if the student's GPA is below the required threshold.

* Triggered **before INSERT** on the `intercambio` table
* Raises a custom SQL error when the rule is violated

---

## Advanced Queries

The project includes **10 advanced SQL queries** covering:

* Aggregations and grouping
* Multi-table joins
* Subqueries
* Filtering based on academic and program criteria
* Analytical insights for decision-making

These queries are located in `business_logic_and_analytics.sql`.

---

## Execution & Reproducibility

To run the project from scratch:

```sql
SOURCE 01_schema.sql;
SOURCE 02_inserts.sql;
SOURCE analytics_and_business_logic.sql;
```

The full execution output is documented in:

```text
execution/execution_log.txt
```

This log demonstrates:

* Successful database creation
* Correct data insertion
* Execution of functions, procedures, triggers
* Expected constraint and validation behavior

---

## Project Scope

This project demonstrates skills in:

* Relational database modeling
* SQL schema design
* Advanced querying
* Business rule enforcement using SQL
* Database validation and testing
* Professional documentation

---

## Author

**Ismael Ruiz Carbajal**

---

## Notes

This project was developed as part of an academic database systems course and has been structured to meet **professional repository standards**, making it suitable for public sharing and portfolio inclusion.
