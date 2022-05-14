page 70155328 "ApX WS Billing Lines"
{
    PageType = Card;
    SourceTable = "ApX ReThink Billing Line";
    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(rowId; Rec.rowId)
                {
                    applicationArea = All;
                }
                field(invoicesId; Rec.invoicesId)
                {
                    applicationArea = All;
                }
                field(invoicesNumber; Rec.invoicesNumber)
                {
                    applicationArea = All;
                }
                field(subscriptionId; Rec.subscriptionId)
                {
                    applicationArea = All;
                }
                field(subscriptionName; Rec.subscriptionName)
                {
                    applicationArea = All;
                }
                field(subscriptionStartDate; Rec.subscriptionStartDate)
                {
                    applicationArea = All;
                }
                field(subscriptionEndDate; Rec.subscriptionEndDate)
                {
                    applicationArea = All;
                }
                field("vendor Subscription Id"; Rec."vendor Subscription Id txt")
                {
                    applicationArea = All;
                }
                field("charge start date"; Rec."charge start date")
                {
                    applicationArea = All;
                }
                field("charge end date"; Rec."charge end date")
                {
                    applicationArea = All;
                }
                field(offerId; Rec.offerId)
                {
                    applicationArea = All;
                }
                field(offerName; Rec.offerName)
                {
                    applicationArea = All;
                }
                field(ShortOfferName; Rec.ShortOfferName)
                {
                    applicationArea = All;
                }
                field("vendor Offer Id"; Rec."vendor Offer Id")
                {
                    applicationArea = All;
                }
                field(invoiceDataContractType; Rec.invoiceDataContractType)
                {
                    applicationArea = All;
                }
                field(invoiceChargeTypes; Rec.invoiceChargeTypes)
                {
                    applicationArea = All;
                }
                field(quantity; Rec.quantity)
                {
                    applicationArea = All;
                }
                field(unitPrice; Rec.unitPrice)
                {
                    applicationArea = All;
                }
                field(totalPrice; Rec.totalPrice)
                {
                    applicationArea = All;
                }
                field(resellerPrice; Rec.resellerPrice)
                {
                    applicationArea = All;
                }
                field(retailPrice; Rec.retailPrice)
                {
                    applicationArea = All;
                }
                field("retail Price Source"; Rec."retail Price Source")
                {
                    applicationArea = All;
                }
                field("retail Price Markup"; Rec."retail Price Markup")
                {
                    applicationArea = All;
                }
                field("customer Markup"; Rec."customer Markup")
                {
                    applicationArea = All;
                }
                field("price Markup Start Date"; Rec."price Markup Start Date")
                {
                    applicationArea = All;
                }
                field(vendorOrgId; Rec.vendorOrgId)
                {
                    applicationArea = All;
                }
                field(vendorOrg; Rec.vendorOrg)
                {
                    applicationArea = All;
                }
                field(resellerOrgId; Rec.resellerOrgId)
                {
                    applicationArea = All;
                }
                field(resellerOrg; Rec.resellerOrg)
                {
                    applicationArea = All;
                }
                field(customerOrgId; Rec.customerOrgId)
                {
                    applicationArea = All;
                }
                field(customerOrg; Rec.customerOrg)
                {
                    applicationArea = All;
                }
                field(endCustomerOrgStatus; Rec.endCustomerOrgStatus)
                {
                    applicationArea = All;
                }
            }
        }
    }
}