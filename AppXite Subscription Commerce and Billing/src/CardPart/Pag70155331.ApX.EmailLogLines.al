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
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Email Log Header No."; Rec."Email Log Header No.")
                {
                    ApplicationArea = All;
                }
                field("Doc Type"; Rec."Doc Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Email Sent"; Rec."Email Sent")
                {
                    ApplicationArea = All;
                }
            }

        }
    }
}