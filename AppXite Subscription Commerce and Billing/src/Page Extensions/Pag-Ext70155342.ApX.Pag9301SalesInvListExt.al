pageextension 70155342 "ApX Sales Invoice List Ext" extends "Sales Invoice List"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("ApX Your Reference"; "Your Reference")
            {
                ApplicationArea = All;
            }
        }
    }
}
