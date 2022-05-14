pageextension 70155324 "ApX Pag22 CustList Ext" extends "Customer List"
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
        modify("Power BI Report FactBox")
        {
            Visible = false;
        }
        modify(SalesHistSelltoFactBox)
        {
            Visible = false;
        }
        addafter(Contact)
        {
            field("ApX Global Dimension 1 Code"; "Global Dimension 1 Code")
            {
                ApplicationArea = All;
            }
            field("ApX Global Dimension 2 Code"; "Global Dimension 2 Code")
            {
                ApplicationArea = All;
            }
            field("ApX Payment Terms Code"; "Payment Terms Code")
            {
                ApplicationArea = All;
            }
            field("ApX Fin. Charge Terms Code"; "Fin. Charge Terms Code")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter(PaymentRegistration)
        {
            action("ApX GetCustomers")
            {
                Caption = 'Get Customers from ReThink';
                Image = TransmitElectronicDoc;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                Visible = false;
                trigger OnAction()
                begin
                    WebRequest.ProcessCustomersRequest();
                end;
            }
        }
    }
    var
        WebRequest: Codeunit "ApX RESTWebService";
}
