table 50105 "LUC Programme"
{
    Caption = 'LUC Programme';
    DataClassification = CustomerContent;
    LookupPageId = "LUC Programme List";
    DrillDownPageId = "LUC Programme List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(3; Department; Text[100])
        {
            Caption = 'Department';
            DataClassification = CustomerContent;
        }
        field(4; Faculty; Text[100])
        {
            Caption = 'Faculty / School';
            DataClassification = CustomerContent;
        }
        field(5; "Open for Registration"; Boolean)
        {
            Caption = 'Open for Registration';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
