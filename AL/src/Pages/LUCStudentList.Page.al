page 50115 "LUC Student List"
{
    Caption = 'LUC Students';
    PageType = List;
    SourceTable = "LUC Student";
    CardPageId = "LUC Student Card";
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Students)
            {
                field("Student No."; Rec."Student No.")
                {
                }
                field("First Name"; Rec."First Name")
                {
                }
                field("Last Name"; Rec."Last Name")
                {
                }
                field("Programme Code"; Rec."Programme Code")
                {
                }
                field(Intake; Rec.Intake)
                {
                }
                field("Study Mode"; Rec."Study Mode")
                {
                }
                field("Email Address"; Rec."Email Address")
                {
                }
                field(Status; Rec.Status)
                {
                }
            }
        }
    }

    views
    {
        view(PendingVerification)
        {
            Caption = 'Pending Verification';
            Filters = where(Status = const(PendingVerification));
        }
    }
}

