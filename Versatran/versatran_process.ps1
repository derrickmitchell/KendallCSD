$exportfile = 'versatran_export.csv'
Remove-Item -Path "versatran_export.csv"

$students = Import-Csv .\Versatran_student.csv
$contacts = Import-Csv .\versatran_contact.csv


$versatran_codes = @{
'450607040002' = '2';
'450607040003' ='3';
'269100000000' ='11';
'269200000000' ='12';
'261801808866' ='13';
'262001997047' ='14';
'261901997789' ='15';
'450704040001' ='16';
'800000061350' ='17';
'261701167030' ='18';
'800000058648'='22';
'450607040666'='666';
'450607040888'='888';
'261101325771'='5771';
'260501166192'='6192';
'261600167041'='7041';
'180300137112'='7112';
'260401857742'='7742';
'450101880048'='40118';
'450101640001'='40123';
'260803166171'='66171';

}

 
$versatran = @()
foreach ($student in $students)
{
	if ($versatran_codes.Get_Item($student.StudentEnrollment_ProviderCode))
	{
		$studentContacts = $contacts -match $student.StudentNumber
		if ($studentContacts[0].Contact_CellPhoneNumber){$contact1Number =$studentContacts[0].Contact_CellPhoneNumber} else {$contact1Number =$studentContacts[0].Contact_WorkPhoneNumber} 
		if ($studentContacts[1].Contact_CellPhoneNumber){$contact2Number =$studentContacts[1].Contact_CellPhoneNumber} else {$contact2Number =$studentContacts[1].Contact_WorkPhoneNumber} 
		if ($studentContacts[2].Contact_CellPhoneNumber){$contact3Number =$studentContacts[2].Contact_CellPhoneNumber} else {$contact3Number =$studentContacts[2].Contact_WorkPhoneNumber} 
		$properties =[ordered]@{
		'studentNumber'=$student.StudentNumber;
		'LastName'=$student.LastName;
		'FirstName'=$student.FirstName;
		'MiddleName'=$student.MiddleName;
		'Grade' = $student.Grade;
		'SchoolCode' = $versatran_codes.Get_Item($student.StudentEnrollment_ProviderCode);
		'HomeHouseNumber' = $student.PersonAddress_StreetNumber;
		'HomeStreet' = $student.PersonAddress_StreetName;
		'HomeApartmentNumber' = $student.PersonAddress_UnitNumber;
		'City' = $student.PersonAddress_City;
		'State' = $student.PersonAddress_State;
		'ZipCode' = $student.PersonAddress_Zip;
		'BirthDate' = $student.DateofBirth;
		'HomePhoneNumber' = $student.PersonAddress_PhoneNumber;
		'Gender' = $student.Gender;
		'EmergencyPhone1' = $contact1Number;
		'EmergencyContact1' = $studentContacts[0].ContactName;
		'EmergencyPhone2' = $contact2Number;
		'EmergencyContact2' = $studentContacts[1].ContactName;
		'EmergencyPhone3' = $contact3Number;
		'EmergencyContact3' = $studentContacts[2].ContactName
		}
		$object = New-Object –TypeName PSObject –Prop $properties
		$versatran += $object
	}
}


$exportfile = 'versatran_export.csv'
$versatran | Select-Object | ConvertTo-Csv -NoTypeInformation | Select-Object -Skip 1 | Out-File -FilePath $exportfile
(Get-Content $exportfile) | % {$_ -replace '"', ""} | out-file -FilePath $exportfile -Force -Encoding ascii

