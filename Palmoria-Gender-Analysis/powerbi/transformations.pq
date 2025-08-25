
let
    FilePath = "data/Dataset PALMORIA.xlsx",

    Source = Excel.Workbook(File.Contents(FilePath), true),
    Emp_Sheet = Source{[Item="Employee Dataset",Kind="Sheet"]}[Data],
    Emp_Promoted = Table.PromoteHeaders(Emp_Sheet, [PromoteAllScalars=true]),

    Emp_Types = Table.TransformColumnTypes(
        Emp_Promoted,
        {
            {"Name", type text},
            {"Gender", type text},
            {"Department", type text},
            {"Salary", type number},
            {"Location", type text},
            {"Rating", type text}
        }
    ),

    Emp_Trim = Table.TransformColumns(Emp_Types, {
        {"Name", Text.Trim, type text},
        {"Gender", Text.Trim, type text},
        {"Department", Text.Trim, type text},
        {"Location", Text.Trim, type text},
        {"Rating", Text.Trim, type text}
    }),

    Emp_Filtered = Table.SelectRows(Emp_Trim, each [Salary] <> null and [Department] <> null),

    Emp_GenderFixed = Table.ReplaceValue(
        Emp_Filtered, 
        each [Gender],
        each if [Gender] = null or [Gender] = "" then "Unknown" else [Gender],
        Replacer.ReplaceValue,
        {"Gender"}
    ),

    Emp_Indexed = Table.AddIndexColumn(Emp_GenderFixed, "EmployeeID", 1, 1, Int64.Type),

    Bonus_Sheet = Source{[Item="my Dataset",Kind="Sheet"]}[Data],
    Bonus_Promoted = Table.PromoteHeaders(Bonus_Sheet, [PromoteAllScalars=true]),
    Bonus_Types = Table.TransformColumnTypes(
        Bonus_Promoted,
        {
            {"Department", type text},
            {"Very Poor", type number},
            {"Poor", type number},
            {"Average", type number},
            {"Good", type number},
            {"Very Good", type number}
        }
    ),

    DimDepartment = Table.Distinct(Table.SelectColumns(Emp_Indexed, {"Department"})),
    DimRegion = Table.Distinct(Table.SelectColumns(Emp_Indexed, {"Location"})),
    DimRating = Table.Distinct(Table.SelectColumns(Emp_Indexed, {"Rating"})),

    Employee = Emp_Indexed,
    BonusRules = Bonus_Types,
    Out_Department = DimDepartment,
    Out_Region = DimRegion,
    Out_Rating = DimRating
in
    [
        Employee = Employee,
        BonusRules = BonusRules,
        DimDepartment = Out_Department,
        DimRegion = Out_Region,
        DimRating = Out_Rating
    ]
