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
                field(invoicesId; Rec.invoicesId)
                {
                    ApplicationArea = All;
                }
                field(invoicesNumber; Rec.invoicesNumber)
                {
                    ApplicationArea = All;
                }
                field(invoiceProviderId; Rec.invoiceProviderId)
                {
                    ApplicationArea = All;
                }
                field(invoiceProvider; Rec.invoiceProvider)
                {
                    ApplicationArea = All;
                }
                field(invoiceReceiverId; Rec.invoiceReceiverId)
                {
                    ApplicationArea = All;
                }
                field(invoiceReceiver; Rec.invoiceReceiver)
                {
                    ApplicationArea = All;
                }
                field("receiver country"; Rec."receiver country")
                {
                    ApplicationArea = All;
                }
                field("receiver VAT number"; Rec."receiver VAT number")
                {
                    ApplicationArea = All;
                }
                field("billing address"; Rec."billing address")
                {
                    ApplicationArea = All;
                }
                field("account manager"; Rec."account manager")
                {
                    ApplicationArea = All;
                }
                field("account manager email"; Rec."account manager email")
                {
                    ApplicationArea = All;
                }
                field("comments"; Rec.comments)
                {
                    ApplicationArea = All;
                }
                field(invoicesDate; Rec.invoicesDate)
                {
                    ApplicationArea = All;
                }
                field("billing period start"; Rec."billing period start")
                {
                    ApplicationArea = All;
                }
                field("billing period end"; Rec."billing period end")
                {
                    ApplicationArea = All;
                }
                field(invoiceCurrency; Rec.invoiceCurrency)
                {
                    ApplicationArea = All;
                }
                field(totalPriceCheckSum; Rec.totalPriceCheckSum)
                {
                    ApplicationArea = All;
                }
                field(rateToEuro; Rec.rateToEuro)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("NAV Doc No"; Rec."NAV Doc No")
                {
                    ApplicationArea = All;
                }
                field("Status Time Stamp"; Rec."Status Time Stamp")
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