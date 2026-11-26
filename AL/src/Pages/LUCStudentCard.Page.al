page 50116 "LUC Student Card"
{
    Caption = 'LUC Student';
    PageType = Card;
    SourceTable = "LUC Student";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Student No."; Rec."Student No.")
                {
                }
                field("First Name"; Rec."First Name")
                {
                    ShowMandatory = true;
                }
                field("Middle Name"; Rec."Middle Name")
                {
                }
                field("Last Name"; Rec."Last Name")
                {
                    ShowMandatory = true;
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                    ShowMandatory = true;
                }
                field(Gender; Rec.Gender)
                {
                }
                field("Nationality Code"; Rec."Nationality Code")
                {
                }
                field("ID Document Type"; Rec."ID Document Type")
                {
                    ShowMandatory = true;
                }
                field("ID Number"; Rec."ID Number")
                {
                    ShowMandatory = true;
                }
            }
            group(Contact)
            {
                Caption = 'Contact';

                field("Email Address"; Rec."Email Address")
                {
                }
                field("Phone No."; Rec."Phone No.")
                {
                }
                field("Postal Address"; Rec."Postal Address")
                {
                }
            }
            group(Academic)
            {
                Caption = 'Academic';

                field("Programme Code"; Rec."Programme Code")
                {
                    ShowMandatory = true;
                }
                field("Programme Name"; Rec."Programme Name")
                {
                }
                field(Department; Rec.Department)
                {
                }
                field(Faculty; Rec.Faculty)
                {
                }
                field(Intake; Rec.Intake)
                {
                    ShowMandatory = true;
                }
                field("Admission Academic Year"; Rec."Admission Academic Year")
                {
                }
                field("Study Mode"; Rec."Study Mode")
                {
                    ShowMandatory = true;
                }
                field("Year of Study"; Rec."Year of Study")
                {
                }
                field("Admission Date"; Rec."Admission Date")
                {
                }
                field("Admission Reference"; Rec."Admission Reference")
                {
                }
            }
            group(Verification)
            {
                Caption = 'Verification';

                field(Status; Rec.Status)
                {
                    Editable = false;
                }
            }
            group(Portal)
            {
                Caption = 'Portal';

                field("Portal Submission ID"; Rec."Portal Submission ID")
                {
                    Editable = false;
                }
                field("Submitted On"; Rec."Submitted On")
                {
                    Editable = false;
                }
                field(CreatedAt; Rec.SystemCreatedAt)
                {
                    Caption = 'Record Created';
                    Editable = false;
                }
                field(ModifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'Last Modified';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Activate)
            {
                Caption = 'Verify and Activate';
                ApplicationArea = All;
                Enabled = Rec.Status = Rec.Status::PendingVerification;

                trigger OnAction()
                begin
                    if not Confirm(ConfirmActivateQst, false, Rec."Student No.") then
                        exit;
                    Rec.Validate(Status, Rec.Status::Active);
                    Rec.Modify(true);
                end;
            }
            action(Reject)
            {
                Caption = 'Reject';
                ApplicationArea = All;
                Enabled = Rec.Status = Rec.Status::PendingVerification;

                trigger OnAction()
                begin
                    if not Confirm(ConfirmRejectQst, false, Rec."Student No.") then
                        exit;
                    Rec.Validate(Status, Rec.Status::Rejected);
                    Rec.Modify(true);
                end;
            }
        }
        area(Promoted)
        {
            actionref(Activate_Promoted; Activate)
            {
            }
            actionref(Reject_Promoted; Reject)
            {
            }
        }
    }

    var
        ConfirmActivateQst: Label 'Verify and activate student %1?';
        ConfirmRejectQst: Label 'Reject the registration for student %1?';
}

