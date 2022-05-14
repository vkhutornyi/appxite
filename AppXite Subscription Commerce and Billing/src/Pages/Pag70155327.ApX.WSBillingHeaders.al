page 70155327 "ApX WS Billing Headers"
{
    PageType = Card;
    SourceTable = "ApX ReThink Billing Header";
    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(invoicesId; Rec.invoicesId)
                {
                    applicationArea = All;
                }
                field(invoicesNumber; Rec.invoicesNumber)
                {
                    applicationArea = All;
                }
                field(invoiceProviderId; Rec.invoiceProviderId)
                {
                    applicationArea = All;
                }
                field(invoiceProvider; Rec.invoiceProvider)
                {
                    applicationArea = All;
                }
                field(invoiceReceiverId; Rec.invoiceReceiverId)
                {
                    applicationArea = All;
                }
                field(invoiceReceiver; Rec.invoiceReceiver)
                {
                    applicationArea = All;
                }
                field("receiver country"; Rec."receiver country")
                {
                    applicationArea = All;
                }
                field("receiver VAT number"; Rec."receiver VAT number")
                {
                    applicationArea = All;
                }
                field("billing address"; Rec."billing address")
                {
                    applicationArea = All;
                }
                field("account manager"; Rec."account manager")
                {
                    applicationArea = All;
                }
                field("account manager email"; Rec."account manager email")
                {
                    applicationArea = All;
                }
                field(comments; Rec.comments)
                {
                    applicationArea = All;
                }
                field(invoicesDate; Rec.invoicesDate)
                {
                    applicationArea = All;
                }
                field(invoiceCurrency; Rec.invoiceCurrency)
                {
                    applicationArea = All;
                }
                field(totalPriceCheckSum; Rec.totalPriceCheckSum)
                {
                    applicationArea = All;
                }
                field(rateToEuro; Rec.rateToEuro)
                {
                    applicationArea = All;
                }
                field("billing period start"; Rec."billing period start")
                {
                    applicationArea = All;
                }
                field("billing period end"; Rec."billing period end")
                {
                    applicationArea = All;
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        Rec.Validate("Status Time Stamp", CurrentDateTime);
    end;
}