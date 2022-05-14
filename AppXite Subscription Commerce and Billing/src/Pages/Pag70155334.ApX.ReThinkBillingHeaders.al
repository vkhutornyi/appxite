page 70155334 "ApX ReThink Billing Headers"
{
    Caption = 'ReThink Billing Headers';
    PageType = List;
    SourceTable = "ApX ReThink Billing Header";
    InsertAllowed = false;
    ModifyAllowed = true;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(invoicesId; invoicesId)
                {
                    applicationArea = All;
                    Editable = false;
                }
                field(invoicesNumber; invoicesNumber)
                {
                    applicationArea = All;
                    Editable = false;
                }
                field(invoiceProviderId; invoiceProviderId)
                {
                    applicationArea = All;
                    Editable = false;
                }
                field(invoiceProvider; invoiceProvider)
                {
                    applicationArea = All;
                    Editable = false;
                }
                field(invoiceReceiverId; invoiceReceiverId)
                {
                    applicationArea = All;
                    Editable = false;
                }
                field(invoiceReceiver; invoiceReceiver)
                {
                    applicationArea = All;
                    Editable = false;
                }
                field("receiver country"; "receiver country")
                {
                    applicationArea = All;
                    Editable = false;
                }
                field("receiver VAT number"; "receiver VAT number")
                {
                    applicationArea = All;
                    Editable = false;
                }
                field("billing address"; "billing address")
                {
                    applicationArea = All;
                    Editable = false;
                }
                field("account manager"; "account manager")
                {
                    applicationArea = All;
                    Editable = false;
                }
                field("account manager email"; "account manager email")
                {
                    applicationArea = All;
                    Editable = false;
                }
                field("comments"; comments)
                {
                    applicationArea = All;
                    Editable = false;
                }
                field(invoicesDate; invoicesDate)
                {
                    applicationArea = All;
                    Editable = true;
                }
                field(invoiceCurrency; invoiceCurrency)
                {
                    applicationArea = All;
                    Editable = false;
                }
                field(totalPriceCheckSum; totalPriceCheckSum)
                {
                    applicationArea = All;
                    Editable = false;
                }
                field(rateToEuro; rateToEuro)
                {
                    applicationArea = All;
                    Editable = false;
                }
                field(Status; Status)
                {
                    applicationArea = All;
                    Editable = false;
                }
                field("NAV Doc No"; "NAV Doc No")
                {
                    applicationArea = All;
                    Editable = false;
                    trigger OnDrillDown();
                    var
                        SalesHeader: Record "Sales Header";
                        SalesInvHeader: Record "Sales Invoice Header";
                        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                    begin
                        if "Nav Doc No" = '' then
                            exit;
                        case Status of
                            Status::"Doc Created":
                                begin
                                    SalesHeader.SetRange("No.", "NAV Doc No");
                                    if totalPriceCheckSum > 0 then begin
                                        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
                                        page.RunModal(page::"Sales Invoice", SalesHeader);
                                    end else begin
                                        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Credit Memo");
                                        page.RunModal(page::"Sales Credit Memo", SalesHeader);
                                    end;
                                end;
                            Status::"Doc Posted":
                                begin
                                    if totalPriceCheckSum > 0 then begin
                                        SalesInvHeader.SetRange("No.", "NAV Doc No");
                                        page.RunModal(page::"Posted Sales Invoice", SalesInvHeader);
                                    end else begin
                                        SalesCrMemoHeader.SetRange("No.", "NAV Doc No");
                                        page.RunModal(page::"Posted Sales Credit Memo", SalesCrMemoHeader);
                                    end;
                                end;
                        end;
                    end;
                }
                field("Status Time Stamp"; "Status Time Stamp")
                {
                    applicationArea = All;
                    Editable = false;
                }
                field("billing period start"; "billing period start")
                {
                    applicationArea = All;
                    Editable = false;
                }
                field("billing period end"; "billing period end")
                {
                    applicationArea = All;
                    Editable = false;
                }
            }

        }
        area(factboxes)
        {
        }

    }

    actions
    {
        area(processing)
        {
            action("ReThink Billing Lines")
            {
                Caption = 'ReThink Billing Lines';
                Image = Table;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction();
                var
                    ReThinkBillingLinePage: page "ApX ReThink Billing Line";
                    ReThinkBillingLineRec: Record "ApX ReThink Billing Line";
                begin
                    ReThinkBillingLineRec.SetRange(invoicesId, invoicesId);
                    ReThinkBillingLineRec.SetRange(invoicesNumber, invoicesNumber);
                    ReThinkBillingLinePage.SetTableView(ReThinkBillingLineRec);
                    ReThinkBillingLinePage.Run;
                end;
            }
            action("ReThink Document")
            {
                Caption = 'ReThink Document';
                Image = Table;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction();
                var
                    RethinkDoc: page "ApX ReThink Document";
                begin
                    RethinkDoc.SetRecord(Rec);
                    RethinkDoc.Run;
                end;
            }
            action("Errors")
            {
                Caption = 'ReThink Errors';
                RunObject = page "ApX ReThink Errors";
                Image = Table;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

            }
            action("Process Documents")
            {
                Caption = 'Process Documents';
                RunObject = codeunit "ApX ReThink Data Processing";
                Image = CreateDocuments;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

            }
            action("post documents")
            {
                Caption = 'Post Documents';
                RunObject = codeunit "ApX Post ReThink Documents";
                Image = PostDocument;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
            }
            action(GetBillingData)
            {
                Caption = 'Get Billing Data from ReThink';
                Image = TransmitElectronicDoc;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                Visible = false;
                trigger OnAction()
                begin
                    WebRequest.ProcessBillingDataRequest();
                end;
            }
        }
        area(Reporting)
        {
            action("App Xite Functions")
            {
                RunObject = codeunit "ApX Common Functions";
                Image = Process;
                ApplicationArea = All;
            }

            action("Clear Billing History")
            {
                RunObject = report "ApX Clear Billing History";
                Image = Report;
                Promoted = false;
                ApplicationArea = All;
            }
            action("ReThink Data Errors")
            {
                RunObject = report "ApX ReThink Data Errors";
                Image = Report;
                Promoted = false;
                ApplicationArea = All;
            }
        }
    }
    var
        WebRequest: Codeunit "ApX RESTWebService";
}