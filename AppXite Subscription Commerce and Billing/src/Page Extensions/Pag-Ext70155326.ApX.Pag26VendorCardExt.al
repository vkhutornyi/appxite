pageextension 70155326 "ApX Pag26 VendorCard Ext" extends "Vendor Card"
{
    layout
    {
        modify(Name)
        {
            Enabled = FieldEditable;
        }
        modify(Address)
        {
            Enabled = FieldEditable;
        }
        modify("Address 2")
        {
            Enabled = FieldEditable;
        }
        modify(City)
        {
            Enabled = FieldEditable;
        }
        modify(Control16)
        {
            Enabled = FieldEditable;
        }
        modify("Phone No.")
        {
            Enabled = FieldEditable;
        }
        modify("Currency Code")
        {
            Enabled = FieldEditable;
        }
        modify("Language Code")
        {
            Enabled = FieldEditable;
        }
        modify("Country/Region Code")
        {
            Enabled = FieldEditable;
        }
        modify("VAT Registration No.")
        {
            Enabled = FieldEditable;
        }
        modify("Post Code")
        {
            Enabled = FieldEditable;
        }
        modify("E-Mail")
        {
            Enabled = FieldEditable;
        }
        addafter("Last Date Modified")
        {
            field("ApX Last Modified - ReThink"; "ApX Last Modified - ReThink")
            {
                Caption = 'Last Modified - ReThink';
                Editable = false;
                ApplicationArea = All;
            }
            field("ApX ReThink ID"; "ApX ReThink ID")
            {
                Caption = 'ReThink ID';
                Editable = FieldEditable;
                ApplicationArea = All;
            }
            field("ApX From ReThink"; "ApX From ReThink")
            {
                Caption = 'From ReThink';
                Editable = false;
                ApplicationArea = All;
            }
            
        }
        addlast(General)
        {
            field("ApX On-Boarding Required"; "ApX On-Boarding Required")
            {
                Caption = 'On-Boarding Required';
                ApplicationArea = All;
            }
            field("ApX Modify Locked Fields"; "ApX Modify Locked Fields")
            {
                Caption = 'Modify Locked Fields';
                ApplicationArea = All;
                trigger OnValidate();
                var
                    UserSetup: Record "User Setup";
                begin
                    if "ApX From ReThink" then begin
                        if "ApX Modify Locked Fields" then begin
                            if UserSetup.Get(USERID) then
                                FieldEditable := UserSetup."ApX Modify ReThink Vendors";
                            if not UserSetup."ApX Modify ReThink Vendors" then
                                Error(Text001);
                        end else
                            if not "ApX Modify Locked Fields" then
                                FieldEditable := false;
                    end else
                        FieldEditable := true;
                end;
            }
        }
        addafter("Name")
        {
            field("ApX Name 2";"Name 2")
            {
                Caption = 'Name 2';
                Enabled = FieldEditable;
                ApplicationArea = All;
            }
            field("ApX Name From ReThink"; "ApX Name From ReThink")
            {
                Caption = 'Name From ReThink';
                Editable = false;
                ApplicationArea = All;
            }
        }
    }

    var
        FieldEditable: Boolean;
        Text001: Label 'You are not allowed to change ReThink related fields.';

    trigger OnOpenPage();
    begin
        if not "ApX From ReThink" then
            FieldEditable := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        FieldEditable := true;
    end;

    trigger OnAfterGetRecord()
    var
        UserSetup: Record "User Setup";
    begin
        if "ApX From ReThink" then begin
            if "ApX Modify Locked Fields" then begin
                if UserSetup.Get(USERID) then
                    FieldEditable := UserSetup."ApX Modify ReThink Vendors";
                if not UserSetup."ApX Modify ReThink Vendors" then
                    error(Text001);
            end else
                if not "ApX Modify Locked Fields" then
                    FieldEditable := false;
        end else
            FieldEditable := true;
    end;

    trigger OnAfterGetCurrRecord();
    var
        UserSetup: Record "User Setup";
    begin
        "ApX Modify Locked Fields" := false;
        Modify;
        if "ApX From ReThink" then begin
            if "ApX Modify Locked Fields" then begin
                if UserSetup.Get(USERID) then
                    FieldEditable := UserSetup."ApX Modify ReThink Vendors";
                if not UserSetup."ApX Modify ReThink Vendors" then
                    error(Text001);
            end else
                if not "ApX Modify Locked Fields" then
                    FieldEditable := false;
        end else
            FieldEditable := true;
    end;

    trigger OnClosePage();
    begin
        "ApX Modify Locked Fields" := false;
        Modify;
    end;
}