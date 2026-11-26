page 50103 "LUC Student API"
{
    PageType = API;
    Caption = 'student';
    APIPublisher = 'luc';
    APIGroup = 'registration';
    APIVersion = 'v1.0';
    EntityName = 'student';
    EntitySetName = 'students';
    SourceTable = "LUC Student";
    ODataKeyFields = SystemId;
    DelayedInsert = true;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(Students)
            {
                field(id; Rec.SystemId) { Editable = false; }
                field(studentNumber; Rec."Student No.") { Editable = false; }
                field(firstName; Rec."First Name") { }
                field(middleName; Rec."Middle Name") { }
                field(lastName; Rec."Last Name") { }
                field(dateOfBirth; Rec."Date of Birth") { }
                field(gender; Rec.Gender) { }
                field(nationalityCode; Rec."Nationality Code") { }
                field(idDocumentType; Rec."ID Document Type") { }
                field(idNumber; Rec."ID Number") { }
                field(emailAddress; Rec."Email Address") { }
                field(phoneNumber; Rec."Phone No.") { }
                field(postalAddress; Rec."Postal Address") { }
                field(programmeCode; Rec."Programme Code") { }
                field(programmeName; Rec."Programme Name") { Editable = false; }
                field(department; Rec.Department) { Editable = false; }
                field(faculty; Rec.Faculty) { Editable = false; }
                field(intake; Rec.Intake) { }
                field(admissionAcademicYear; Rec."Admission Academic Year") { }
                field(studyMode; Rec."Study Mode") { }
                field(yearOfStudy; Rec."Year of Study") { Editable = false; }
                field(admissionDate; Rec."Admission Date") { Editable = false; }
                field(admissionReference; Rec."Admission Reference") { }
                field(status; Rec.Status) { Editable = false; }
                field(portalSubmissionId; Rec."Portal Submission ID") { }
                field(submittedOn; Rec."Submitted On") { }
                field(lastModifiedDateTime; Rec.SystemModifiedAt) { Editable = false; }
            }
        }
    }
}
