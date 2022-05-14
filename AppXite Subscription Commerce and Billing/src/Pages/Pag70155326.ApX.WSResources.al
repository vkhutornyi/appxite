page 70155326 "ApX WS Resources"
{
    PageType = Card;
    SourceTable = Resource;
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
                    applicationArea = All;
                }
                field(Blocked; Blocked)
                {
                    applicationArea = All;
                }
                field("Last Modified - ReThink"; "ApX Last Modified - ReThink")
                {
                    Editable = false;
                    applicationArea = All;
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
                        Validate(Name, CopyStr("ApX Name From ReThink", 1, 100));
                        Validate("Name 2", CopyStr("ApX Name From ReThink", 101, 50));
                        Modify(true);
                    end;
                }

            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        Validate("ApX On-Boarding Required", true);
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