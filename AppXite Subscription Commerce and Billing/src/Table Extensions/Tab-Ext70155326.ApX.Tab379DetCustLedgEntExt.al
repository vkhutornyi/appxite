tableextension 70155326 "ApX Tab379 DetCustLedgEnt Ext" extends "Detailed Cust. Ledg. Entry"
{
    trigger OnAfterInsert();
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Customer: Record Customer;
        ReCustLedgEntry: Record "ApX Rethink Cust. Ledger Entry";
    begin
        if Customer.Get("Customer No.") then begin
            Customer.CalcFields(Balance);
            if Customer.Balance <> Customer."ApX Custom Balance" then begin
                Customer.Validate("ApX Synch To ReThink", true);
                Customer.Validate("ApX Last Modified - ReThink", CurrentDateTime);
                Customer.Validate("ApX Custom Balance", Customer.Balance);
                Customer.Modify(true);
            end;

            if CustLedgerEntry.Get("Cust. Ledger Entry No.") and ReCustLedgEntry.Get("Cust. Ledger Entry No.") then begin
                ReCustLedgEntry.Validate("Last Modified - ReThink", CurrentDateTime);
                CustLedgerEntry.CalcFields("Remaining Amount");
                if Amount <> 0 then begin
                    if CustLedgerEntry."Remaining Amount" <> 0 then begin
                        if CustLedgerEntry."Remaining Amount" = Amount then
                            ReCustLedgEntry.Validate(Status, ReCustLedgEntry.Status::" ")
                        else
                            if ReCustLedgEntry.Status <> ReCustLedgEntry.Status::Overdue then
                                ReCustLedgEntry.Validate(Status, ReCustLedgEntry.Status::"Partially Paid");
                    end else begin
                        ReCustLedgEntry.Validate(Status, ReCustLedgEntry.Status::Paid);
                        ReCustLedgEntry.Validate("Check For Overdue", false);
                    end;
                end;
                ReCustLedgEntry.Modify(true);
            end;
        end;
    end;
}