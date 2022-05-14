page 70155336 "ApX ReThink Document"
{
    Caption = 'ReThink Document';
    PageType = Document;
    SourceTable = "ApX ReThink Billing Header";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group("Rethink Document Header")
            {
                field(invoicesId; invoicesId)
                {
                    ApplicationArea = All;
                }
                field(invoicesNumber; invoicesNumber)
                {
                    ApplicationArea = All;
                }
                field(invoiceProviderId; invoiceProviderId)
                {
                    ApplicationArea = All;
                }
                field(invoiceProvider; invoiceProvider)
                {
                    ApplicationArea = All;
                }
                field(invoiceReceiverId; invoiceReceiverId)
                {
                    ApplicationArea = All;
                }
                field(invoiceReceiver; invoiceReceiver)
                {
                    ApplicationArea = All;
                }
                field("receiver country"; "receiver country")
                {
                    ApplicationArea = All;
                }
                field("receiver VAT number"; "receiver VAT number")
                {
                    ApplicationArea = All;
                }
                field("billing address"; "billing address")
                {
                    ApplicationArea = All;
                }
                field("account manager"; "account manager")
                {
                    ApplicationArea = All;
                }
                field("account manager email"; "account manager email")
                {
                    ApplicationArea = All;
                }
                field("comments"; comments)
                {
                    ApplicationArea = All;
                }
                field(invoicesDate; invoicesDate)
                {
                    ApplicationArea = All;
                }
                field("billing period start"; "billing period start")
                {
                    ApplicationArea = All;
                }
                field("billing period end"; "billing period end")
                {
                    ApplicationArea = All;
                }
                field(invoiceCurrency; invoiceCurrency)
                {
                    ApplicationArea = All;
                }
                field(totalPriceCheckSum; totalPriceCheckSum)
                {
                    ApplicationArea = All;
                }
                field(rateToEuro; rateToEuro)
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("NAV Doc No"; "NAV Doc No")
                {
                    ApplicationArea = All;
                }
                field("Status Time Stamp"; "Status Time Stamp")
                {
                    ApplicationArea = All;
                }
            }
            part("ReThink Billing Lines"; "ApX ReThink Billing Lines")
            {
                SubPageLink = invoicesId = field(invoicesId), invoicesNumber = field(invoicesNumber);
                ApplicationArea = All;
            }

        }
    }
}