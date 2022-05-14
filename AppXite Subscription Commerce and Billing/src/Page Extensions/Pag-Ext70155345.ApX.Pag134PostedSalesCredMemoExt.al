pageextension 70155345 "ApX Posted Sales Cr. Memo Ext" extends "Posted Sales Credit Memo"
{
    layout
    {
        addafter("Document Date")
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