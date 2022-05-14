tableextension 70155327 "ApX Tab23 Vendor Ext" extends "Vendor"
{
    fields
    {
        Modify(Name)
        {
            trigger OnAfterValidate();
            begin
                if (rec.Name <> xRec.Name) then
                    UpdateRethinkFields();
            end;
        }
        Modify("Name 2")
        {
            trigger OnAfterValidate();
            begin
                if (rec."Name 2" <> xRec."Name 2") then
                    UpdateRethinkFields();
            end;
        }
        Modify(Address)
        {
            trigger OnAfterValidate();
            begin
                if (rec.Address <> xRec.Address) then
                    UpdateRethinkFields();
            end;
        }
        Modify("Address 2")
        {
            trigger OnAfterValidate();
            begin
                if (rec."Address 2" <> xRec."Address 2") then
                    UpdateRethinkFields();
            end;
        }
        Modify(City)
        {
            trigger OnAfterValidate();
            begin
                if (rec.City <> xRec.City) then
                    UpdateRethinkFields();
            end;
        }
        Modify(Contact)
        {
            trigger OnAfterValidate();
            begin
                if (rec.Contact <> xRec.Contact) then
                    UpdateRethinkFields();
            end;
        }
        Modify("Phone No.")
        {
            trigger OnAfterValidate();
            begin
                if (rec."Phone No." <> xRec."Phone No.") then
                    UpdateRethinkFields();
            end;
        }
        Modify("Currency Code")
        {
            trigger OnAfterValidate();
            begin
                if (rec."Currency Code" <> xRec."Currency Code") then
                    UpdateRethinkFields();
            end;
        }
        Modify("Language Code")
        {
            trigger OnAfterValidate();
            begin
                if (rec."Language Code" <> xRec."Language Code") then
                    UpdateRethinkFields();
            end;
        }
        Modify("Country/Region Code")
        {
            trigger OnAfterValidate();
            begin
                if (rec."Country/Region Code" <> xRec."Country/Region Code") then
                    UpdateRethinkFields();
            end;
        }
        Modify("VAT Registration No.")
        {
            trigger OnAfterValidate();
            begin
                if (rec."VAT Registration No." <> xRec."VAT Registration No.") then
                    UpdateRethinkFields();
            end;
        }
        Modify("Post Code")
        {
            trigger OnAfterValidate();
            begin
                if (rec."Post Code" <> xRec."Post Code") then
                    UpdateRethinkFields();
            end;
        }
        Modify(County)
        {
            trigger OnAfterValidate();
            begin
                if (rec.County <> xRec.County) then
                    UpdateRethinkFields();
            end;
        }
        Modify("E-Mail")
        {
            trigger OnAfterValidate();
            begin
                if (rec."E-Mail" <> xRec."E-Mail") then
                    UpdateRethinkFields();
            end;
        }
        field(70155324; "ApX Synch To ReThink"; Boolean)
        {
            Caption = 'Synch To ReThink';
            DataClassification = SystemMetadata;
        }
        field(70155325; "ApX Last Modified - ReThink"; DateTime)
        {
            Caption = 'Last Modified - ReThink';
            DataClassification = SystemMetadata;
        }
        field(70155326; "ApX On-Boarding Required"; Boolean)
        {
            Caption = 'On-Boarding Required';
            DataClassification = CustomerContent;
        }
        field(70155327; "ApX Modify Locked Fields"; Boolean)
        {
            Caption = 'Modify Locked Fields';
            DataClassification = SystemMetadata;
        }
        field(70155328; "ApX From ReThink"; Boolean)
        {
            Caption = 'From ReThink';
            DataClassification = SystemMetadata;
        }
        field(70155329; "ApX ReThink ID"; Guid)
        {
            Caption = 'ReThink ID';
            DataClassification = SystemMetadata;
        }
        field(70155330; "ApX Name From ReThink"; Text[250])
        {
            Caption = 'Name From ReThink';
            DataClassification = EndUserPseudonymousIdentifiers;
        }
        field(70155331; "ApX Custom Balance"; Decimal)
        {
            Caption = 'Custom Balance';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key("ApX Last Modified - ReThink"; "ApX Last Modified - ReThink") { Enabled = true; }
        key("ApX ReThink ID"; "ApX ReThink ID") { Enabled = true; }
    }

    local procedure UpdateRethinkFields()
    begin
        if "ApX From ReThink" then begin
            Validate("ApX Synch To ReThink", true);
            Validate("ApX Last Modified - ReThink", CurrentDateTime);
            Modify;
        end;
    end;
}