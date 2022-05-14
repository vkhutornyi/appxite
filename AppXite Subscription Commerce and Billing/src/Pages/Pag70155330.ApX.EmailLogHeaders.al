page 70155330 "ApX Email Log Headers"
{
    Caption = 'Email Log Headers';
    PageType = List;
    SourceTable = "ApX Email Log Header";
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
                    Caption = 'No.';
                    ApplicationArea = All;
                }
                field("Doc Type"; "Doc Type")
                {
                    Caption = 'Doc Type';
                    ApplicationArea = All;
                }
                field("Process Start Date Time"; "Process Start Date Time")
                {
                    Caption = 'Process Start Date Time';
                    ApplicationArea = All;
                }
                field("Process End Date Time"; "Process End Date Time")
                {
                    Caption = 'Process End Date Time';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("View Document")
            {
                Caption = 'View Document';
                Image = Table;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction();
                var
                    EmailDoc: page "ApX Email Log Document";

                begin
                    EmailDoc.SetRecord(Rec);
                    EmailDoc.Run;
                end;
            }
        }
    }
}