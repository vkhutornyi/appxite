pageextension 70155333 "ApX Pag119 UserSetup Ext" extends "User Setup"
{
    layout
    {
        addlast(Control1)
        {
            field("ApX Modify ReThink Customers";"ApX Modify ReThink Customers")
            {
                ApplicationArea = Basic,Suite;
            }
            field("ApX Modify ReThink Vendors";"ApX Modify ReThink Vendors")
            {
                ApplicationArea = Basic,Suite;
            }
        }
    }
}