table 50100 "LUC Student"
{
    Caption = 'LUC Student';
    DataClassification = CustomerContent;

    fields
    {
        // ---------- Identity (1-9) ----------
        field(1; "Student No."; Code[20])
        {
            Caption = 'Student No.';
            DataClassification = CustomerContent;
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
        key(Name; "Last Name", "First Name")
        {
        }
    }

    trigger OnInsert()
    begin
        CheckDuplicateIdentity();
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

    var
        DateOfBirthRangeErr: Label 'Date of birth must be between %1 and %2.';
        InvalidEmailErr: Label 'The email address is not valid.';
        DuplicateIdentityErr: Label 'A student record with this identity document already exists.';
}
