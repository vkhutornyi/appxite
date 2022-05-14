pageextension 70155329 "ApX Pag77 ResourceList Ext" extends "Resource List"
{
    layout
    {
        addafter(Type)
        {
            field("ApX Type"; Type)
            {
                ApplicationArea = All;
                Caption = 'Type';
            }
            field("ApX ReThink ID"; "ApX ReThink ID")
            {
                ApplicationArea = All;
            }

        }
        modify(Type)
        {
            Visible = false;
        }
    }
    actions
    {
        addlast(processing)
        {
            action("ApX GetResources")
            {
                Caption = 'Get Resources from ReThink';
                Image = TransmitElectronicDoc;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                Visible = false;
                trigger OnAction()
                begin
                    WebRequest.ProcessRosourcesRequest();
                end;
            }
        }
    }
    var
        WebRequest: Codeunit "ApX RESTWebService";
}
