page 70155339 "ApX ReThink Deferral Templates"
{
    Caption = 'ReThink Deferral Templates';
    PageType = List;
    SourceTable = "ApX ReThink Deferral Template";
    
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Day From"; "Day From") {
                    ApplicationArea = All;
                 }
                field("Day To"; "Day To") { 
                    ApplicationArea = All;
                }
                field(Description; Description) {
                    ApplicationArea = All;
                 }
                field("Deferral Template Code"; "Deferral Template Code") {
                    ApplicationArea = All;
                 }
            }
        }        
    }   
}