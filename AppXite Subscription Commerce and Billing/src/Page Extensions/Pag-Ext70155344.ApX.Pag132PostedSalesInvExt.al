pageextension 70155344 "ApX Posted Sales Invoice Ext" extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Due Date")
        {
            field("ApX Billing Period Start"; "ApX Billing Period Start")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("ApX Billing Period End"; "ApX Billing Period End")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}