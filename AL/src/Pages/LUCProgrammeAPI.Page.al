page 50106 "LUC Programme API"
{
    PageType = API;
    Caption = 'programme';
    APIPublisher = 'luc';
    APIGroup = 'registration';
    APIVersion = 'v1.0';
    EntityName = 'programme';
    EntitySetName = 'programmes';
    SourceTable = "LUC Programme";
    ODataKeyFields = SystemId;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(Programmes)
            {
                field(id; Rec.SystemId) { }
                field(code; Rec."Code") { }
                field(name; Rec.Name) { }
                field(department; Rec.Department) { }
                field(faculty; Rec.Faculty) { }
                field(openForRegistration; Rec."Open for Registration") { }
            }
        }
    }
}
