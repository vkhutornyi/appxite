pageextension 70155328 "ApX Pag25 CustLedgEntries Ext"  extends "Customer Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("ApX Status";ApX_Status )
            {
                Editable = false;
                ApplicationArea = All;
            }
            field("ApX ReThink ID";ApX_ReThinkID)
            {
                Editable = false;
                ApplicationArea = All;
            }
             field("ApX Last Modified - ReThink";ApX_LastModifiedReThink)
            {
                Editable = false;
                ApplicationArea = All;
            }
        }
    }

    trigger OnAfterGetRecord();
    var 
        ReThinkCustLedgerEntry : Record "ApX ReThink Cust. Ledger Entry";
    begin
        ApX_Status := ApX_Status::" ";
        ApX_ReThinkID := '00000000-0000-0000-0000-000000000000';
        ApX_LastModifiedReThink := 0DT;
        ReThinkCustLedgerEntry.Reset;
        ReThinkCustLedgerEntry.SetRange("Entry No.", "Entry No.");
        If ReThinkCustLedgerEntry.FindFirst then begin
            ApX_Status := ReThinkCustLedgerEntry.Status;
            ApX_ReThinkID := ReThinkCustLedgerEntry."ReThink ID";
            ApX_LastModifiedReThink := ReThinkCustLedgerEntry."Last Modified - ReThink";
        end;
    end;
    var 
        ApX_Status : Option " ",Overdue,"Partially Paid",Paid;
        ApX_ReThinkID : Guid;
        ApX_LastModifiedReThink : DateTime;

}