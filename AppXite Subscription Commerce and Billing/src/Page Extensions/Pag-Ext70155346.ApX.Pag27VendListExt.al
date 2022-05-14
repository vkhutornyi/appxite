pageextension 70155346 "ApX Pag27 VendList Ext" extends "Vendor List"
{
    layout
    {
        addafter("Location Code")
        {
            field("ApX ReThink ID"; "ApX ReThink ID")
            {
                ApplicationArea = All;
            }
        }
        modify(VendorHistBuyFromFactBox)
        {
            Visible = false;
        }
        modify("Power BI Report FactBox")
        {
            Visible = false;
        }
    }
    actions
    {
        addlast(processing)
        {
            action("ApX GetVendors")
            {
                Caption = 'Get Vendors from ReThink';
                Image = TransmitElectronicDoc;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                Visible = false;
                trigger OnAction()
                begin
                    WebRequest.ProcessVendorsRequest();
                end;
            }
        }
    }
    var
        WebRequest: Codeunit "ApX RESTWebService";
}
