tableextension 70155331 "ApX Tab21 CustLedgEntry Ext" extends "Cust. Ledger Entry"
{
    trigger OnAfterInsert();
    var
        ReThinkCustLedgEntry: Record "ApX ReThink Cust. Ledger Entry";
    begin
        ReThinkCustLedgEntry.Init;
        ReThinkCustLedgEntry.Validate("Entry No.", "Entry No.");
        if "Document Type" = "Document Type"::Payment then begin
            ReThinkCustLedgEntry.Validate(Status, ReThinkCustLedgEntry.Status::" ");
            ReThinkCustLedgEntry.Validate("Last Modified - ReThink", CurrentDateTime);
        end;
        ReThinkCustLedgEntry.Validate("Check For Overdue", true);
        ReThinkCustLedgEntry.Insert(true);
    end;
}