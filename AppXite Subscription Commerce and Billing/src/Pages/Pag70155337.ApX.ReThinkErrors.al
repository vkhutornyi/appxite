page 70155337 "ApX ReThink Errors"
{
    Caption = 'ReThink Errors';
    PageType = List;
    SourceTable = "ApX ReThink Error";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(invoicesId; Rec.invoicesId)
                {
                    ApplicationArea = All;
                }
                field("Invoice Number"; Rec.invoicesNumber)
                {
                    ApplicationArea = All;
                }
                field("Row Id"; Rec.rowId)
                {
                    ApplicationArea = All;
                }
                field("Data Type"; Rec."Data Type")
                {
                    ApplicationArea = All;
                }
                field("Error Type"; Rec."Error Type")
                {
                    ApplicationArea = All;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                }
                field("Time Created"; Rec."Time Created")
                {
                    ApplicationArea = All;
                }
                field(Resolved; Rec.Resolved)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}