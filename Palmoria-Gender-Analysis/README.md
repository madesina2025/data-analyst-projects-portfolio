# Palmoria Gender Analysis (Power BI)

🚀 **A complete Power BI project implementing ETL (Power Query), Data Modeling (Star Schema), and DAX measures to analyze gender distribution, salary structures, pay gaps, bonuses, and compliance with minimum wage for Palmoria Group.**

---

## 📌 Project Overview

The **Palmoria Group**, a large manufacturing company, faced criticism for gender inequality and pay gaps across its divisions.  
This project uses Power BI to deliver insights into:

- Gender distribution across regions and departments
- Employee ratings analysis by gender
- Salary structures and identification of gender pay gaps
- Compliance with ₦100,000 minimum wage regulation
- Bonus allocation rules by department & performance
- Total payout (salary + bonus) across the organization

**Key Deliverables**
- 8 interactive dashboard pages
- Clean **ETL pipeline** in Power Query
- Reusable **DAX measures**
- A structured **star schema** model

---

## 🗂️ Data Model

**Fact Table**
- `Employee`: Name, Gender, Department, Salary, Location, Rating  

**Lookup & Dimensions**
- `BonusRules` (from Excel)  
- `DimDepartment`, `DimRegion`, `DimRating` (created via Power Query)  
- `SalaryRanges` (created via DAX DATATABLE)  

**Relationships**
- Employee[Department] → BonusRules[Department]  
- Employee[Department] → DimDepartment[Department]  
- Employee[Location] → DimRegion[Region]  
- Employee[Rating] → DimRating[Rating]  
- Employee[SalaryRangeKey] → SalaryRanges[SortOrder]  

📖 See [powerbi/model-diagram.md](../powerbi/model-diagram.md) for full details.

---

## ⚙️ Power Query (ETL)

1. Remove rows with missing Salary or Department  
2. Replace blank Gender with `"Unknown"`  
3. Add EmployeeID (index)  
4. Create Dim tables (`Department`, `Region`, `Rating`)  
5. Load `BonusRules` sheet with bonus percentages  

Full M script: [powerbi/transformations.pq](../powerbi/transformations.pq)

---

## 📊 DAX Measures

Core measures used in the report:

```DAX
Headcount := DISTINCTCOUNT ( Employee[Name] )
Total Salary := SUM ( Employee[Salary] )
Average Salary := AVERAGE ( Employee[Salary] )

Min-Wage Compliance % :=
DIVIDE ( SUM ( Employee[Is_Compliant_MinWage] ), [Headcount] )

% Below Min Wage := 1 - [Min-Wage Compliance %]

Salary % by Gender :=
DIVIDE ( [Total Salary], CALCULATE ( [Total Salary], ALL ( Employee[Gender_Clean] ) ) )

Bonus Amount := SUMX ( Employee, Employee[Salary] * Employee[BonusRate] )
Total Payout := [Total Salary] + [Bonus Amount]
Average Bonus := DIVIDE ( [Bonus Amount], [Headcount] )

Gender Pay Gap (Avg) :=
VAR avgMale =
    CALCULATE ( [Average Salary], KEEPFILTERS ( Employee[Gender_Clean] = "Male" ) )
VAR avgFemale =
    CALCULATE ( [Average Salary], KEEPFILTERS ( Employee[Gender_Clean] = "Female" ) )
RETURN avgMale - avgFemale
