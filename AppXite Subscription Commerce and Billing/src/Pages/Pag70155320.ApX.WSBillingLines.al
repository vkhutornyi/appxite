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
                field(rowId; rowId)
                {
                    applicationArea = All;
                }
                field(invoicesId; invoicesId)
                {
                    applicationArea = All;
                }
                field(invoicesNumber; invoicesNumber)
                {
                    applicationArea = All;
                }
                field(subscriptionId; subscriptionId)
                {
                    applicationArea = All;
                }
                field(subscriptionName; subscriptionName)
                {
                    applicationArea = All;
                }
                field(subscriptionStartDate; subscriptionStartDate)
                {
                    applicationArea = All;
                }
                field(subscriptionEndDate; subscriptionEndDate)
                {
                    applicationArea = All;
                }
                field("vendor Subscription Id"; "vendor Subscription Id txt")
                {
                    applicationArea = All;
                }
                field("charge start date"; "charge start date")
                {
                    applicationArea = All;
                }
                field("charge end date"; "charge end date")
                {
                    applicationArea = All;
                }
                field(offerId; offerId)
                {
                    applicationArea = All;
                }
                field(offerName; offerName)
                {
                    applicationArea = All;
                }
                field(ShortOfferName; ShortOfferName)
                {
                    applicationArea = All;
                }
                field("vendor Offer Id"; "vendor Offer Id")
                {
                    applicationArea = All;
                }
                field(invoiceDataContractType; invoiceDataContractType)
                {
                    applicationArea = All;
                }
                field(invoiceChargeTypes; invoiceChargeTypes)
                {
                    applicationArea = All;
                }
                field(quantity; quantity)
                {
                    applicationArea = All;
                }
                field(unitPrice; unitPrice)
                {
                    applicationArea = All;
                }
                field(totalPrice; totalPrice)
                {
                    applicationArea = All;
                }
                field(resellerPrice; resellerPrice)
                {
                    applicationArea = All;
                }
                field(retailPrice; retailPrice)
                {
                    applicationArea = All;
                }
                field("retail Price Source"; "retail Price Source")
                {
                    applicationArea = All;
                }
                field("retail Price Markup"; "retail Price Markup")
                {
                    applicationArea = All;
                }
                field("customer Markup"; "customer Markup")
                {
                    applicationArea = All;
                }
                field("price Markup Start Date"; "price Markup Start Date")
                {
                    applicationArea = All;
                }
                field(vendorOrgId; vendorOrgId)
                {
                    applicationArea = All;
                }
                field(vendorOrg; vendorOrg)
                {
                    applicationArea = All;
                }
                field(resellerOrgId; resellerOrgId)
                {
                    applicationArea = All;
                }
                field(resellerOrg; resellerOrg)
                {
                    applicationArea = All;
                }
                field(customerOrgId; customerOrgId)
                {
                    applicationArea = All;
                }
                field(customerOrg; customerOrg)
                {
                    applicationArea = All;
                }
                field(endCustomerOrgStatus; endCustomerOrgStatus)
                {
                    applicationArea = All;
                }
            }
        }
    }
}