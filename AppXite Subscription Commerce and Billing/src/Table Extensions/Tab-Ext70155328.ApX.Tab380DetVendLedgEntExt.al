tableextension 70155328 "ApX Tab380 DetVendLedgEnt Ext" extends "Detailed Vendor Ledg. Entry"
{
    trigger OnAfterInsert();
    var
        Vendor: Record Vendor;
    begin
        if Vendor.Get("Vendor No.") then begin
            Vendor.CalcFields(Balance);
            if Vendor.Balance <> Vendor."ApX Custom Balance" then begin
                Vendor.Validate("ApX Synch To ReThink", true);
                Vendor.Validate("ApX Last Modified - ReThink", CurrentDateTime);
                Vendor.Validate("ApX Custom Balance", Vendor.Balance);
                Vendor.Modify(true);
            end;
        end;
    end;
}