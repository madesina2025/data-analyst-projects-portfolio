
# Model Diagram & Relationships (Palmoria Gender Analysis)

**Fact**
- Employee(EmployeeID, Name, Gender, Department, Salary, Location, Rating, Gender_Clean, SalaryRangeKey, Is_Compliant_MinWage, BonusRate)

**Dimensions & Lookups**
- DimDepartment(Department)
- DimRegion(Region)
- DimRating(Rating[, RatingScore optional])
- SalaryRanges(Salary Range, MinSalary, MaxSalary, SortOrder)
- BonusRules(Department, Very Poor, Poor, Average, Good, Very Good)

**Relationships (single direction):**
- Employee[Department] → BonusRules[Department] (Many-to-One)
- Employee[Department] → DimDepartment[Department]
- Employee[Location]  → DimRegion[Region]
- Employee[Rating]    → DimRating[Rating]
- Employee[SalaryRangeKey] → SalaryRanges[SortOrder]
