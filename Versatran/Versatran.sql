select * from m1b_Versatran_Student_Export
where studentnumber = '10559'
Order By StudentNumber ASC

select * from m1b_Versatran_Contact_Export
where studentnumber = '10559'
Order By StudentNumber ASC,PersonContact_Primary DESC

/*

SELECT
	RecordID,
	FirstName,
	LastName,
	City,
	Country
FROM EAVTable
PIVOT(MAX(Value) FOR Element IN (FirstName, LastName, City, Country)) AS t

SELECT 
  ROW_NUMBER() OVER(ORDER BY name ASC) AS Row#,
  name, recovery_model_desc
FROM sys.databases 
WHERE database_id < 5
10559
10809
9990
*/

IF OBJECT_ID('tempdb..#Versatran') IS NOT NULL DROP TABLE #Versatran

Create table #Versatran
(
	StudentID			VARCHAR(12),
	LastName			VARCHAR(25),
	FirstName			VARCHAR(20),
	MiddleName			VARCHAR(20),
	Grade				VARCHAR(6),
	SchoolCode			VARCHAR(20),
	HomeHouseNumber		VARCHAR(8),
	HomeStreet			VARCHAR(50),
	HomeAptNumber		VARCHAR(20),
	HomeCity			VARCHAR(25),
	HomeState			CHAR(2),
	HomeZipCode			VARCHAR(10),
	DateOfBirth			VARCHAR(20),
	HomePhoneNumber		VARCHAR(25),
	Gender				VARCHAR(6),
	EmergencyPhone1		VARCHAR(25),
	EmergencyPhone2		VARCHAR(25),
	EmergencyPhone3		VARCHAR(25),
	EmergencyContact1	VARCHAR(25),
	EmergencyContact2	VARCHAR(25),
	EmergencyContact3	VARCHAR(25)
)

INSERT INTO #Versatran 
(
	StudentID, 
	LastName, 
	FirstName, 
	MiddleName, 
	Grade, 
	SchoolCode, 
	HomeHouseNumber, 
	HomeStreet, 
	HomeAptNumber, 
	HomeCity, 
	HomeState, 
	HomeZipCode, 
	DateOfBirth,
	HomePhoneNumber, 
	Gender
)
select 
se.StudentNumber, 
se.LastName, 
se.FirstName, 
se.MiddleName, 
se.Grade, 
se.SchoolBuidlingCode, 
se.PersonAddress_StreetNumber, 
se.PersonAddress_StreetName, 
se.PersonAddress_UnitNumber,
se.PersonAddress_City, 
se.PersonAddress_State,
se.PersonAddress_Zip, 
se.DateofBirth,
se.PersonAddress_PhoneNumber,
se.Gender
from m1b_Versatran_Student_Export se
Order By StudentNumber ASC



select * from #Versatran




update #Versatran
set EmergencyContact1 = a.ContactName,
EmergencyPhone1 = a.Contact_CellPhoneNumber
 from #Versatran vt
CROSS APPLY
( select ROW_NUMBER() OVER (Order By StudentNumber ASC,PersonContact_Primary DESC) as Row#, StudentNumber, ContactName, Contact_CellPhoneNumber from m1b_Versatran_Contact_Export ce
	WHERE ce.StudentNumber = vt.StudentID 
) a where a.Row# = 1

update #Versatran
set EmergencyContact2 = a.ContactName,
EmergencyPhone2 = a.Contact_CellPhoneNumber
from #Versatran vt
CROSS APPLY
( select ROW_NUMBER() OVER (Order By StudentNumber ASC,PersonContact_Primary DESC) as Row#, StudentNumber, ContactName, Contact_CellPhoneNumber from m1b_Versatran_Contact_Export ce
	WHERE ce.StudentNumber = vt.StudentID 
	) a where a.Row# = 2

update #Versatran
set EmergencyContact3 = a.ContactName,
EmergencyPhone3 = a.Contact_CellPhoneNumber
from #Versatran vt
CROSS APPLY
( select ROW_NUMBER() OVER (Order By StudentNumber ASC,PersonContact_Primary DESC) as Row#, StudentNumber, ContactName, Contact_CellPhoneNumber from m1b_Versatran_Contact_Export ce
	WHERE ce.StudentNumber = vt.StudentID 
	) a where a.Row# = 3

select * from #Versatran

/*
SELECT * FROM Department D 
CROSS APPLY 
   ( 
   SELECT * FROM Employee E 
   WHERE E.DepartmentID = D.DepartmentID 
   ) A 

   
;with ce as
(
select ROW_NUMBER() OVER (Order By StudentNumber ASC,PersonContact_Primary DESC) as Row#, StudentNumber, ContactName, Contact_CellPhoneNumber from m1b_Versatran_Contact_Export
) 
*/