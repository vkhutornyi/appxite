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
                field("Day From"; Rec."Day From")
                {
                    ApplicationArea = All;
                }
                field("Day To"; Rec."Day To")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Deferral Template Code"; Rec."Deferral Template Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}