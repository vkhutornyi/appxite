page 70155325 "ApX WS Vendor"
{
    PageType = Card;
    SourceTable = Vendor;
    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Name 2"; "Name 2")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Address; Address)
                {
                    ApplicationArea = All;
                }
                field("Address 2"; "Address 2")
                {
                    ApplicationArea = All;
                }
                field(City; City)
                {
                    ApplicationArea = All;
                }
                field(Contact; Contact)
                {
                    ApplicationArea = All;
                }
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Language Code"; "Language Code")
                {
                    ApplicationArea = All;
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field(Balance; Balance)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Balance Due"; "Balance Due")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("VAT Registration No."; "VAT Registration No.")
                {
                    ApplicationArea = All;
                }
                field("Post Code"; "Post Code")
                {
                    ApplicationArea = All;
                }
                field(County; County)
                {
                    ApplicationArea = All;
                }
                field("E-Mail"; "E-Mail")
                {
                    ApplicationArea = All;
                }
                field("Synch To ReThink"; "ApX Synch To ReThink")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Last Modified - ReThink"; "ApX Last Modified - ReThink")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("ReThink ID"; "ApX ReThink ID")
                {
                    ApplicationArea = All;
                }
                field("Name From ReThink"; "ApX Name From ReThink")
                {
                    ApplicationArea = All;
                    trigger OnValidate();
                    begin
                        Validate(Name, CopyStr("ApX Name From ReThink", 1, 100));
                        Validate("Name 2", CopyStr("ApX Name From ReThink", 101, 50));
                        Modify(true);
                    end;
                }
            }
        }
    }

    var
        FieldEditable: boolean;

    trigger OnOpenPage();

    begin
        SetRange("ApX From ReThink", true);
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        Validate("ApX On-Boarding Required", true);
        Validate("ApX From ReThink", true);
        Validate("ApX Last Modified - ReThink", CurrentDateTime());
        Validate("ApX Name From ReThink");
    end;

    trigger OnModifyRecord(): Boolean;
    begin
        Validate("ApX Last Modified - ReThink", CurrentDateTime());
        if "ApX Name From ReThink" <> xRec."ApX Name From ReThink" then
            Validate("ApX Name From ReThink");
    end;
}