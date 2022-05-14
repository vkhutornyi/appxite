pageextension 70155334 "ApX Pag1 CompInfo Ext" extends "Company Information"
{
    layout
    {
        addafter(Name)
        {
            field("ApX Short Name"; "ApX Short Name")
            {
                Caption = 'Short Name';
                ApplicationArea = All;
            }
        }
        addafter(BankAccountPostingGroup)
        {
            group("ApX Bank Details")
            {
                Caption = 'Bank Details (Bank Name is %1)';
                field("ApX Bank Country/Region Code"; "ApX Bank Country/Region Code")
                {
                    Caption = 'Bank Country/Region Code (%2)';
                    ApplicationArea = All;
                }
                field("ApX Bank County"; "ApX Bank County")
                {
                    Caption = 'Bank County (%3)';
                    ApplicationArea = All;
                }
                field("ApX Bank Post Code"; "ApX Bank Post Code")
                {
                    Caption = 'Bank Post Code (%4)';
                    ApplicationArea = All;
                }
                field("ApX Bank City"; "ApX Bank City")
                {
                    Caption = 'Bank City (%5)';
                    ApplicationArea = All;
                }
                field("ApX Bank Address"; "ApX Bank Address")
                {
                    Caption = 'Bank Address (%6)';
                    ApplicationArea = All;
                }
                field("ApX Bank Address 2"; "ApX Bank Address 2")
                {
                    Caption = 'Bank Address 2 (%7)';
                    ApplicationArea = All;
                }
            }
            group("ApX Document Texts")
            {
                Caption = 'Document Texts';
                field("ApX Address String Template"; "ApX Address String Template")
                {
                    Caption = 'Address String Template';
                    ToolTip = 'Specify address components as %x, where x is number of field to use. Example: %1 in %6, %5, %4, %2 will give you "Bank Name in Addess, City, Post Code, Country"';
                    ApplicationArea = All;
                }
                field("ApX Transfer Amount To Text"; "ApX Transfer Amount To Text")
                {
                    Caption = 'Transfer Amount To Text';
                    ApplicationArea = All;
                }
                field("ApX Specify Invoice Text"; "ApX Specify Invoice Text")
                {
                    Caption = 'Specify Invoice Text';
                    ApplicationArea = All;
                }
                field("ApX Contact Dept Text"; "ApX Contact Dept Text")
                {
                    Caption = 'Contact Department Text';
                    ApplicationArea = All;
                }
            }
        }
        addafter(Communication)
        {
            group("ApX ReThink Integration Settings")
            {
                Caption = 'ReThink Integration Settings';
                Visible = false;
                field("ApX ReThink Company ID"; "ApX ReThink Company ID")
                {
                    Caption = 'ReThink Company ID';
                    ToolTip = 'Specify ReThink CompanyId GUID';
                    ApplicationArea = All;
                }
                field("ApX Is AppXite Company"; "ApX Is AppXite Company")
                {
                    Caption = 'Is AppXite Company?';
                    ToolTip = 'Set "No" if company is WhiteLable ReThink Company';
                    ApplicationArea = All;
                }
                field("ApX Base URI"; "ApX Base URI")
                {
                    Caption = 'Base URI';
                    ToolTip = 'Specify Base URI of ReThink endpoint API';
                    ApplicationArea = All;
                }
                field("ApX API Token"; "ApX API Token")
                {
                    Caption = 'Access Token';
                    ToolTip = 'Specify Access Token to ReThink API';
                    ApplicationArea = All;
                }
            }
        }
    }
}
