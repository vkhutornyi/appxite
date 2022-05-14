pageextension 70155343 "ApX Sales Credit Memo Ext" extends "Sales Credit Memo"
{
    layout
    {
        addafter("Due Date")
        {
            field("ApX Billing Period Start"; "ApX Billing Period Start")
            {
                ApplicationArea = All;
            }
            field("ApX Billing Period End"; "ApX Billing Period End")
            {
                ApplicationArea = All;
            }
        }
    }
}