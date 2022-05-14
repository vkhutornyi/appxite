page 70155331 "ApX Email Log Lines"
{
    Caption = 'Email Log Line';
    PageType = CardPart;
    SourceTable = "ApX Email Log Line";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Email Log Header No."; "Email Log Header No.")
                {
                    ApplicationArea = All;
                }
                field("Doc Type"; "Doc Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                }
                field("Email Sent"; "Email Sent")
                {
                    ApplicationArea = All;
                }
            }

        }
    }
}