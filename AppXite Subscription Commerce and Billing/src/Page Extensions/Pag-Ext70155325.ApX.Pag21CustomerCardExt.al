pageextension 70155325 "ApX Pag21 CustomerCard Ext" extends "Customer Card"
{
    layout
    {
        Modify(Name)
        {
            Enabled = FieldEditable;
        }
        Modify(Address)
        {
            Enabled = FieldEditable;
        }
        Modify("Address 2")
        {
            Enabled = FieldEditable;
        }
        Modify(City)
        {
            Enabled = FieldEditable;
        }
        Modify(ContactName)
        {
            Enabled = FieldEditable;
        }
        Modify("Phone No.")
        {
            Enabled = FieldEditable;
        }
        Modify("Currency Code")
        {
            Enabled = FieldEditable;
        }
        Modify("Language Code")
        {
            Enabled = FieldEditable;
        }
        Modify("Country/Region Code")
        {
            Enabled = FieldEditable;
        }
        Modify("VAT Registration No.")
        {
            Enabled = FieldEditable;
        }
        Modify("Post Code")
        {
            Enabled = FieldEditable;
        }
        
        Modify("E-Mail")
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
                Editable = false;
                ApplicationArea = All;
            }
            field("ApX Registration No."; "ApX Registration No."){
                Caption = 'Registration No.';
                Enabled = FieldEditable;
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
                    if Rec."ApX From ReThink" = true then begin
                        if Rec."ApX Modify Locked Fields" then begin
                            if UserSetup.Get(UserId) then
                                FieldEditable := UserSetup."ApX Modify ReThink Customers";
                            if not UserSetup."ApX Modify ReThink Customers" then
                                Error(Text001);
                        end else
                            if not Rec."ApX Modify Locked Fields" then
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
        
        addafter("Fin. Charge Terms Code")
        {
            field("ApX Reseller Fin. Charge Terms"; "ApX Reseller Fin. Charge Terms")
            {
                Caption = 'Reseller Fin. Charge Terms';
                ApplicationArea = All,Suite,Advanced;
                
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
    
    trigger OnModifyRecord() : Boolean;
    begin
        if "Credit Limit (LCY)" <> xRec."Credit Limit (LCY)" then
            Validate("ApX Last Modified - ReThink",CurrentDateTime);
    end;

    trigger OnAfterGetRecord()
    var
        UserSetup: Record "User Setup";
    begin
        if "ApX From ReThink" then begin
            if "ApX Modify Locked Fields" then begin
                if UserSetup.Get(UserId) then
                    FieldEditable := UserSetup."ApX Modify ReThink Customers";
                if not UserSetup."ApX Modify ReThink Customers" then
                    Error(Text001);
            end else
                if not "ApX Modify Locked Fields" then
                    FieldEditable := false;
        end else
            FieldEditable := true;
    end;
    
    trigger OnAfterGetCurrRecord()
    var
        UserSetup: Record "User Setup";
    begin
        "ApX Modify Locked Fields" := false;
        Modify;
        if "ApX From ReThink" then begin
            if "ApX Modify Locked Fields" then begin
                if UserSetup.Get(UserId) then
                    FieldEditable := UserSetup."ApX Modify ReThink Customers";
                if not UserSetup."ApX Modify ReThink Customers" then
                    Error(Text001);
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