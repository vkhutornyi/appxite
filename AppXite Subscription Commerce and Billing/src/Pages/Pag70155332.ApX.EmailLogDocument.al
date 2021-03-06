page 70155332 "ApX Email Log Document"
{
    Caption = 'Email Log Document';
    PageType = Document;
    SourceTable = "ApX Email Log Header";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group("Email Log")
            {
                field("No."; Rec."No.")
                {
                    Caption = 'No.';
                    ApplicationArea = All;
                }
                field("Doc Type"; Rec."Doc Type")
                {
                    Caption = 'Doc Type';
                    ApplicationArea = All;
                }
                field("Process Start Date Time"; Rec."Process Start Date Time")
                {
                    Caption = 'Process Start Date Time';
                    ApplicationArea = All;
                }
                field("Process End Date Time"; Rec."Process End Date Time")
                {
                    Caption = 'Process End Date Time';
                    ApplicationArea = All;
                }
            }
            part("Email Log Lines"; "ApX Email Log Lines")
            {
                SubPageLink = "Email Log Header No." = field("No.");
                ApplicationArea = All;
            }
        }
    }
}