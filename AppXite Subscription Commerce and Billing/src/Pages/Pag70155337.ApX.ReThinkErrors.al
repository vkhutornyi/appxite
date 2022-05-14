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
                field(invoicesId;invoicesId){
                    ApplicationArea = All;
                }
                field("Invoice Number"; invoicesNumber) { 
                    ApplicationArea = All;
                }
                field("Row Id"; rowId) {
                    ApplicationArea = All;
                 }
                field("Data Type"; "Data Type") { 
                    ApplicationArea = All;
                }
                field("Error Type"; "Error Type") {
                    ApplicationArea = All;
                 }
                field(Comment; Comment) {
                    ApplicationArea = All;
                }
                field("Time Created"; "Time Created") {
                    ApplicationArea = All;
                 }
                field(Resolved; Resolved) { 
                    ApplicationArea = All;
                }
            }
        }       
    }
}