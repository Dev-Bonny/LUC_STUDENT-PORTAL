enum 50107 "LUC Student Status"
{
    Extensible = true;
    Caption = 'Student Status';

    value(0; PendingVerification)
    {
        Caption = 'Pending Verification';
    }
    value(1; Active)
    {
        Caption = 'Active';
    }
    value(2; Rejected)
    {
        Caption = 'Rejected';
    }
}
