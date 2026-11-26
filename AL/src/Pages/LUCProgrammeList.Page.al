page 50114 "LUC Programme List"
{
    Caption = 'LUC Programmes';
    PageType = List;
    SourceTable = "LUC Programme";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Programmes)
            {
                field("Code"; Rec."Code")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field(Department; Rec.Department)
                {
                }
                field(Faculty; Rec.Faculty)
                {
                }
                field("Open for Registration"; Rec."Open for Registration")
                {
                }
            }
        }
    }
}
