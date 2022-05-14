page 70155335 "ApX ReThink Billing Line"
{
    Caption = 'ReThink Billing Line';
    PageType = List;
    SourceTable = "ApX ReThink Billing Line";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(rowId; rowId)
                {
                    ApplicationArea = All;
                }
                field(invoicesId; invoicesId)
                {
                    ApplicationArea = All;
                }
                field(invoicesNumber; invoicesNumber)
                {
                    ApplicationArea = All;
                }
                field(subscriptionId; subscriptionId)
                {
                    ApplicationArea = All;
                }
                field(subscriptionName; subscriptionName)
                {
                    ApplicationArea = All;
                }
                field(subscriptionStartDate; subscriptionStartDate)
                {
                    ApplicationArea = All;
                }
                field(subscriptionEndDate; subscriptionEndDate)
                {
                    ApplicationArea = All;
                }
                field("vendor Subscription Id"; "vendor Subscription Id txt")
                {
                    ApplicationArea = All;
                }
                field("charge start date"; "charge start date")
                {
                    ApplicationArea = All;
                }
                field("charge end date"; "charge end date")
                {
                    ApplicationArea = All;
                }
                field(offerId; offerId)
                {
                    ApplicationArea = All;
                }
                field(offerName; offerName)
                {
                    ApplicationArea = All;
                }
                field(ShortOfferName; ShortOfferName)
                {
                    ApplicationArea = All;
                }
                field("vendor Offer Id"; "vendor Offer Id")
                {
                    ApplicationArea = All;
                }
                field(invoiceDataContractType; invoiceDataContractType)
                {
                    ApplicationArea = All;
                }
                field(invoiceChargeTypes; invoiceChargeTypes)
                {
                    ApplicationArea = All;
                }
                field(quantity; quantity)
                {
                    ApplicationArea = All;
                }
                field(unitPrice; unitPrice)
                {
                    ApplicationArea = All;
                }
                field(totalPrice; totalPrice)
                {
                    ApplicationArea = All;
                }
                field(resellerPrice; resellerPrice)
                {
                    ApplicationArea = All;
                }
                field(retailPrice; retailPrice)
                {
                    ApplicationArea = All;
                }
                field("retail Price Source"; "retail Price Source")
                {
                    ApplicationArea = All;
                }
                field("retail Price Markup"; "retail Price Markup")
                {
                    ApplicationArea = All;
                }
                field("customer Markup"; "customer Markup")
                {
                    ApplicationArea = All;
                }
                field("price Markup Start Date"; "price Markup Start Date")
                {
                    ApplicationArea = All;
                }
                //field(invoicesDate; invoicesDate) { }
                field(vendorOrgId; vendorOrgId)
                {
                    ApplicationArea = All;
                }
                field(vendorOrg; vendorOrg)
                {
                    ApplicationArea = All;
                }
                field(resellerOrgId; resellerOrgId)
                {
                    ApplicationArea = All;
                }
                field(resellerOrg; resellerOrg)
                {
                    ApplicationArea = All;
                }
                field(customerOrgId; customerOrgId)
                {
                    ApplicationArea = All;
                }
                field(customerOrg; customerOrg)
                {
                    ApplicationArea = All;
                }
                field(endCustomerOrgStatus; endCustomerOrgStatus)
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("Status Time Stamp"; "Status Time Stamp")
                {
                    ApplicationArea = All;
                }
                field(ProductName; ProductName)
                {
                    ApplicationArea = All;
                }
                field("NAV Doc No"; "NAV Doc No")
                {
                    ApplicationArea = All;
                }
                field("NAV Doc Line No"; "NAV Doc Line No")
                {
                    ApplicationArea = All;
                }
            }
        }

    }


}