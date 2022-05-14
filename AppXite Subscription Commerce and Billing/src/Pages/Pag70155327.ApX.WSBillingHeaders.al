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
                field(invoicesId; invoicesId)
                {
                    applicationArea = All;
                }
                field(invoicesNumber; invoicesNumber)
                {
                    applicationArea = All;
                }
                field(invoiceProviderId; invoiceProviderId)
                {
                    applicationArea = All;
                }
                field(invoiceProvider; invoiceProvider)
                {
                    applicationArea = All;
                }
                field(invoiceReceiverId; invoiceReceiverId)
                {
                    applicationArea = All;
                }
                field(invoiceReceiver; invoiceReceiver)
                {
                    applicationArea = All;
                }
                field("receiver country"; "receiver country")
                {
                    applicationArea = All;
                }
                field("receiver VAT number"; "receiver VAT number")
                {
                    applicationArea = All;
                }
                field("billing address"; "billing address")
                {
                    applicationArea = All;
                }
                field("account manager"; "account manager")
                {
                    applicationArea = All;
                }
                field("account manager email"; "account manager email")
                {
                    applicationArea = All;
                }
                field(comments; comments)
                {
                    applicationArea = All;
                }
                field(invoicesDate; invoicesDate)
                {
                    applicationArea = All;
                }
                field(invoiceCurrency; invoiceCurrency)
                {
                    applicationArea = All;
                }
                field(totalPriceCheckSum; totalPriceCheckSum)
                {
                    applicationArea = All;
                }
                field(rateToEuro; rateToEuro)
                {
                    applicationArea = All;
                }
                field("billing period start"; "billing period start")
                {
                    applicationArea = All;
                }
                field("billing period end"; "billing period end")
                {
                    applicationArea = All;
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        Validate("Status Time Stamp", CurrentDateTime);
    end;
}