table 50100 "LUC Student"
{
    Caption = 'LUC Student';
    DataClassification = CustomerContent;
    LookupPageId = "LUC Student List";
    DrillDownPageId = "LUC Student List";

    fields
    {
        // ---------- Identity (1-9) ----------
        field(1; "Student No."; Code[20])
        {
            Caption = 'Student No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(2; "First Name"; Text[50])
        {
            Caption = 'First Name';
            DataClassification = EndUserIdentifiableInformation;

            trigger OnValidate()
            begin
                "First Name" := DelChr("First Name", '<>', ' ');
            end;
        }
        field(3; "Middle Name"; Text[50])
        {
            Caption = 'Middle Name';
            DataClassification = EndUserIdentifiableInformation;

            trigger OnValidate()
            begin
                "Middle Name" := DelChr("Middle Name", '<>', ' ');
            end;
        }
        field(4; "Last Name"; Text[50])
        {
            Caption = 'Last Name';
            DataClassification = EndUserIdentifiableInformation;

            trigger OnValidate()
            begin
                "Last Name" := DelChr("Last Name", '<>', ' ');
            end;
        }
        field(5; "Date of Birth"; Date)
        {
            Caption = 'Date of Birth';
            DataClassification = EndUserIdentifiableInformation;

            trigger OnValidate()
            var
                EarliestDate: Date;
                LatestDate: Date;
            begin
                if "Date of Birth" = 0D then
                    exit;
                EarliestDate := CalcDate('<-80Y>', Today());
                LatestDate := CalcDate('<-16Y>', Today());
                if ("Date of Birth" < EarliestDate) or ("Date of Birth" > LatestDate) then
                    Error(DateOfBirthRangeErr, EarliestDate, LatestDate);
            end;
        }
        field(6; Gender; Enum "LUC Gender")
        {
            Caption = 'Gender';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(7; "Nationality Code"; Code[10])
        {
            Caption = 'Nationality';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = "Country/Region";
        }
        field(8; "ID Document Type"; Enum "LUC ID Document Type")
        {
            Caption = 'ID Document Type';
            DataClassification = EndUserIdentifiableInformation;

            trigger OnValidate()
            begin
                CheckDuplicateIdentity();
            end;
        }
        field(9; "ID Number"; Code[30])
        {
            Caption = 'ID / Passport No.';
            DataClassification = EndUserIdentifiableInformation;

            trigger OnValidate()
            begin
                "ID Number" := DelChr("ID Number", '<>', ' ');
                CheckDuplicateIdentity();
            end;
        }

        // ---------- Contact (10-19) ----------
        field(10; "Email Address"; Text[80])
        {
            Caption = 'Email Address';
            DataClassification = EndUserIdentifiableInformation;
            ExtendedDatatype = EMail;

            trigger OnValidate()
            begin
                "Email Address" := DelChr("Email Address", '<>', ' ');
                if "Email Address" = '' then
                    exit;
                if (StrPos("Email Address", '@') < 2) or (StrPos("Email Address", ' ') > 0) or (StrPos("Email Address", '.') = 0) then
                    Error(InvalidEmailErr);
            end;
        }
        field(11; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            DataClassification = EndUserIdentifiableInformation;
            ExtendedDatatype = PhoneNo;
        }
        field(12; "Postal Address"; Text[100])
        {
            Caption = 'Postal Address';
            DataClassification = EndUserIdentifiableInformation;
        }

        // ---------- Academic (20-29) ----------
        field(20; "Programme Code"; Code[20])
        {
            Caption = 'Programme';
            DataClassification = CustomerContent;
            TableRelation = "LUC Programme";
        }
        field(21; "Programme Name"; Text[100])
        {
            Caption = 'Programme Name';
            FieldClass = FlowField;
            CalcFormula = lookup("LUC Programme".Name where(Code = field("Programme Code")));
            Editable = false;
        }
        field(22; Department; Text[100])
        {
            Caption = 'Department';
            FieldClass = FlowField;
            CalcFormula = lookup("LUC Programme".Department where(Code = field("Programme Code")));
            Editable = false;
        }
        field(23; Faculty; Text[100])
        {
            Caption = 'Faculty / School';
            FieldClass = FlowField;
            CalcFormula = lookup("LUC Programme".Faculty where(Code = field("Programme Code")));
            Editable = false;
        }
        field(24; Intake; Enum "LUC Intake")
        {
            Caption = 'Intake';
            DataClassification = CustomerContent;
        }
        field(25; "Admission Academic Year"; Code[9])
        {
            Caption = 'Admission Academic Year';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CheckAcademicYear();
            end;
        }
        field(26; "Study Mode"; Enum "LUC Study Mode")
        {
            Caption = 'Study Mode';
            DataClassification = CustomerContent;
        }
        field(27; "Year of Study"; Integer)
        {
            Caption = 'Year of Study';
            DataClassification = CustomerContent;
            InitValue = 1;
            MinValue = 1;
            MaxValue = 8;
        }
        field(28; "Admission Date"; Date)
        {
            Caption = 'Admission Date';
            DataClassification = CustomerContent;
        }
        field(29; "Admission Reference"; Code[30])
        {
            Caption = 'Admission Reference';
            DataClassification = CustomerContent;
        }

        // ---------- Status and system (30-39) ----------
        field(30; Status; Enum "LUC Student Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if Status = Status::Active then begin
                    TestField("First Name");
                    TestField("Last Name");
                    TestField("Date of Birth");
                    TestField("ID Document Type");
                    TestField("ID Number");
                    TestField("Programme Code");
                    TestField(Intake);
                    TestField("Study Mode");
                    if "Admission Date" = 0D then
                        "Admission Date" := Today();
                end;
            end;
        }
        field(31; "Portal Submission ID"; Guid)
        {
            Caption = 'Portal Submission ID';
            DataClassification = SystemMetadata;

            trigger OnValidate()
            begin
                CheckDuplicateSubmission();
            end;
        }
        field(32; "Submitted On"; DateTime)
        {
            Caption = 'Submitted On';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Student No.")
        {
            Clustered = true;
        }
        key(IdentityDocument; "ID Document Type", "ID Number")
        {
        }
        key(PortalSubmission; "Portal Submission ID")
        {
        }
        key(Name; "Last Name", "First Name")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Student No.", "First Name", "Last Name", "Programme Code")
        {
        }
    }

    trigger OnInsert()
    begin
        CheckDuplicateIdentity();
        CheckDuplicateSubmission();
        AssignStudentNo();
    end;

    trigger OnDelete()
    begin
        if Status = Status::Active then
            Error(CannotDeleteActiveErr);
    end;

    local procedure AssignStudentNo()
    var
        StudentSetup: Record "LUC Student Setup";
        NoSeries: Codeunit "No. Series";
    begin
        if "Student No." <> '' then
            exit;

        if not StudentSetup.Get() then
            Error(SetupMissingErr);
        StudentSetup.TestField("Student Nos.");
        "Student No." := NoSeries.GetNextNo(StudentSetup."Student Nos.", WorkDate());
    end;

    local procedure CheckDuplicateIdentity()
    var
        OtherStudent: Record "LUC Student";
    begin
        if ("ID Number" = '') or ("ID Document Type" = "ID Document Type"::NotSet) then
            exit;

        OtherStudent.SetRange("ID Document Type", "ID Document Type");
        OtherStudent.SetRange("ID Number", "ID Number");
        OtherStudent.SetFilter("Student No.", '<>%1', "Student No.");
        if not OtherStudent.IsEmpty() then
            Error(DuplicateIdentityErr);
    end;

    local procedure CheckDuplicateSubmission()
    var
        OtherStudent: Record "LUC Student";
    begin
        if IsNullGuid("Portal Submission ID") then
            exit;

        OtherStudent.SetRange("Portal Submission ID", "Portal Submission ID");
        OtherStudent.SetFilter("Student No.", '<>%1', "Student No.");
        if not OtherStudent.IsEmpty() then
            Error(DuplicateSubmissionErr);
    end;

    local procedure CheckAcademicYear()
    var
        StartYear: Integer;
        EndYear: Integer;
    begin
        if "Admission Academic Year" = '' then
            exit;

        if (StrLen("Admission Academic Year") <> 9) or
           (CopyStr("Admission Academic Year", 5, 1) <> '/') or
           not Evaluate(StartYear, CopyStr("Admission Academic Year", 1, 4)) or
           not Evaluate(EndYear, CopyStr("Admission Academic Year", 6, 4)) or
           (EndYear <> StartYear + 1)
        then
            Error(InvalidAcademicYearErr);
    end;

    var
        DateOfBirthRangeErr: Label 'Date of birth must be between %1 and %2.';
        InvalidEmailErr: Label 'The email address is not valid.';
        DuplicateIdentityErr: Label 'A student record with this identity document already exists.';
        DuplicateSubmissionErr: Label 'A student record for this portal submission already exists.';
        InvalidAcademicYearErr: Label 'The academic year must look like 2026/2027.';
        SetupMissingErr: Label 'LUC Student Setup has not been configured. Open the LUC Student Setup page and choose a number series.';
        CannotDeleteActiveErr: Label 'An active student cannot be deleted.';
}

