codeunit 70155329 "ApX Upgrade Management"

{
    Subtype = Upgrade;

    trigger OnRun()
    begin
    end;

    trigger OnCheckPreconditionsPerCompany()
    begin
    end;


    trigger OnCheckPreconditionsPerDatabase()
    begin
    end;

    trigger OnUpgradePerCompany()
    var
        archivedVersion: Text;
    begin
        // archivedVersion := NAVAPP.GetArchiveVersion();
        // if archivedVersion = '1.0.0.1' then begin
        //     NAVAPP.RESTOREARCHIVEDATA(DATABASE::"ApX ReThink Billing Header");
        //     NAVAPP.RESTOREARCHIVEDATA(DATABASE::"ApX ReThink Billing Line");
        // end;
    end;

    trigger OnUpgradePerDatabase()
    begin
    end;

    trigger OnValidateUpgradePerCompany()
    begin
    end;

    trigger OnValidateUpgradePerDatabase()
    begin
    end;
}
