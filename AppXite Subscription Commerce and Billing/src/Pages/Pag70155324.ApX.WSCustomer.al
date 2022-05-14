page 70155324 "ApX WS Customer"
{
    PageType = Card;
    SourceTable = Customer;
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
                    applicationArea = All;
                    Editable = false;
                }
                field(Name; Name)
                {
                    applicationArea = All;
                    Editable = false;
                }
                field("Name 2"; "Name 2")
                {
                    applicationArea = All;
                    Editable = false;
                }
                field(Address; Address)
                {
                    applicationArea = All;
                }
                field("Address 2"; "Address 2")
                {
                    applicationArea = All;
                }
                field(City; City)
                {
                    applicationArea = All;
                }
                field(Contact; Contact)
                {
                    applicationArea = All;
                }
                field("Phone No."; "Phone No.")
                {
                    applicationArea = All;
                }
                field("Credit Limit (LCY)"; "Credit Limit (LCY)")
                {
                    applicationArea = All;
                    Editable = false;
                }
                field("Currency Code"; "Currency Code")
                {
                    applicationArea = All;
                }
                field("Language Code"; "Language Code")
                {
                    applicationArea = All;
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                    applicationArea = All;
                }
                field(Balance; Balance)
                {
                    applicationArea = All;
                    Editable = false;
                }
                field("Balance Due"; "Balance Due")
                {
                    applicationArea = All;
                    Editable = false;
                }
                field("VAT Registration No."; "VAT Registration No.")
                {
                    applicationArea = All;
                }
                field("Post Code"; "Post Code")
                {
                    applicationArea = All;
                }
                field(County; County)
                {
                    applicationArea = All;
                }
                field("E-Mail"; "E-Mail")
                {
                    applicationArea = All;
                }
                field("Synch To ReThink"; "ApX Synch To ReThink")
                {
                    applicationArea = All;
                    Editable = false;
                }
                field("Last Modified - ReThink"; "ApX Last Modified - ReThink")
                {
                    applicationArea = All;
                    Editable = false;
                }
                field("ReThink ID"; "ApX ReThink ID")
                {
                    applicationArea = All;
                }
                field("Name From ReThink"; "ApX Name From ReThink")
                {
                    applicationArea = All;
                    trigger OnValidate();
                    begin
                        Validate(Name, CopyStr("ApX Name From ReThink", 1, 50));
                        Validate("Name 2", CopyStr("ApX Name From ReThink", 51, 50));
                        Modify(true);
                    end;
                }
                field("Registration No."; "ApX Registration No.")
                {
                    applicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage();
    var
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