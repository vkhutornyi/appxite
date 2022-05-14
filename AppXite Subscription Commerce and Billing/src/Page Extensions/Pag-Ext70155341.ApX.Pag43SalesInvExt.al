pageextension 70155341 "ApX Sales Invoice Extension" extends "Sales Invoice"
{
    layout
    {
        addfirst("Invoice Details")
        {
            field("ApX Your Reference74730"; "Your Reference")
            {
                Caption = 'Your Reference74730';
                ApplicationArea = All;
            }
        }
        addafter("Sell-to Contact")
        {
            field("ApX Document Type"; "Document Type")
            {
                Caption = 'Document Type';
                ApplicationArea = All;
            }
        }
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
            field("ApX Amount"; Amount)
            {
                Caption = 'Amount';
                ApplicationArea = All;
            }
            field("ApX Print Posted Documents"; "Print Posted Documents")
            {
                Caption = 'Print Posted Documents';
                ApplicationArea = All;
            }
            field("ApX VAT Country/Region Code"; "VAT Country/Region Code")
            {
                Caption = 'VAT Country/Region Code';
                ApplicationArea = All;
            }
            field("ApX VAT Bus. Posting Group46758"; "VAT Bus. Posting Group")
            {
                Caption = 'VAT Bus. Posting Group';
                ApplicationArea = All;
            }
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field("ApX Ship-to Name 2"; "Ship-to Name 2")
            {
                Caption = 'Ship-to Name 2';
                ApplicationArea = All;
            }
        }
    }
}
