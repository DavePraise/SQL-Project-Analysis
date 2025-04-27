# SQL-Project-Analysis

## Project Objective
In this project, I was tasked with analyzing the employee data of a fictional company to gain insights into various aspects of its workforce. The datasets I worked with contained information aboout employees, their departments, salaries, titles, and managerial position. Using queries and data manipulation techniques, I extracted relevant information from the dataset to present meaningful insights capable of supporting decision-making processes within the organization.

In total, I worked on 30 questions for my analysis and also to get famimliar with standard and andvanced level SQL techniques. I have organized these SQL queries by different types of operations. Each query is designed to answer a specific business or technical problem. Feel free to explore the queries and how they can be applied to real-world scenarios

## Table of Contents:
1. Importing datasets into SQL
2. Aggregations
3. Joins
4. Subqueries
5. Date and Time Functions
6. Miscellaneous

### Importing datasets into SQL
The first step when working with datasets from external sources (e.g. csv files) is to import them into SQL. For this project, I was initially given one Excel file titled "Company Dataset" that included several worksheets containing relevant data needed for my analysis. Here is my step-by-step approach to importing the data I needed into SQL:
1. I made separate csv files for each of the worksheets
2. I created a table for each of the worksheets using SQL code
3. Lasty, I imported the data for each worksheet (or csv file) into their respective tables

``` Code
-- Step 1: Import tables from Excel

CREATE TYPE gender_enum AS ENUM ('M', 'F')

CREATE TABLE employees (emp_no int PRIMARY KEY,
			birth_date date,
			first_name varchar (14),
			last_name varchar (16),
			gender gender_enum,
			hire_date date)
```
## Challenges Faced

## Tools
