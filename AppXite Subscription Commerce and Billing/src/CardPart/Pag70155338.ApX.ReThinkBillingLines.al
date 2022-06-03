page 70155338 "ApX ReThink Billing Lines"
{
    Caption = 'ReThink Billing Lines';
    PageType = CardPart;
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
                field(rowId; Rec.rowId)
                {
                    ApplicationArea = All;
                }
                field(invoicesId; Rec.invoicesId)
                {
                    ApplicationArea = All;
                }
                field(invoicesNumber; Rec.invoicesNumber)
                {
                    ApplicationArea = All;
                }
                field(subscriptionId; Rec.subscriptionId)
                {
                    ApplicationArea = All;
                }
                field(subscriptionName; Rec.subscriptionName)
                {
                    ApplicationArea = All;
                }
                field(subscriptionStartDate; Rec.subscriptionStartDate)
                {
                    ApplicationArea = All;
                }
                field(subscriptionEndDate; Rec.subscriptionEndDate)
                {
                    ApplicationArea = All;
                }
                field("vendor Subscription Id"; Rec."vendor Subscription Id txt")
                {
                    ApplicationArea = All;
                }
                field("charge start date"; Rec."charge start date")
                {
                    ApplicationArea = All;
                }
                field("charge end date"; Rec."charge end date")
                {
                    ApplicationArea = All;
                }
                field(offerId; Rec.offerId)
                {
                    ApplicationArea = All;
                }
                field(offerName; Rec.offerName)
                {
                    ApplicationArea = All;
                }
                field(ShortOfferName; Rec.ShortOfferName)
                {
                    ApplicationArea = All;
                }
                field("vendor Offer Id"; Rec."vendor Offer Id")
                {
                    ApplicationArea = All;
                }
                field(invoiceDataContractType; Rec.invoiceDataContractType)
                {
                    ApplicationArea = All;
                }
                field(invoiceChargeTypes; Rec.invoiceChargeTypes)
                {
                    ApplicationArea = All;
                }
                field(quantity; Rec.quantity)
                {
                    ApplicationArea = All;
                }
                field(unitPrice; Rec.unitPrice)
                {
                    ApplicationArea = All;
                }
                field(totalPrice; Rec.totalPrice)
                {
                    ApplicationArea = All;
                }
                field(resellerPrice; Rec.resellerPrice)
                {
                    ApplicationArea = All;
                }
                field(retailPrice; Rec.retailPrice)
                {
                    ApplicationArea = All;
                }
                field("retail Price Source"; Rec."retail Price Source")
                {
                    ApplicationArea = All;
                }
                field("retail Price Markup"; Rec."retail Price Markup")
                {
                    ApplicationArea = All;
                }
                field("customer Markup"; Rec."customer Markup")
                {
                    ApplicationArea = All;
                }
                field("price Markup Start Date"; Rec."price Markup Start Date")
                {
                    ApplicationArea = All;

                }
                //field(invoicesDate; invoicesDate) { }
                field(vendorOrgId; Rec.vendorOrgId)
                {
                    ApplicationArea = All;
                }
                field(vendorOrg; Rec.vendorOrg)
                {
                    ApplicationArea = All;
                }
                field(resellerOrgId; Rec.resellerOrgId)
                {
                    ApplicationArea = All;
                }
                field(resellerOrg; Rec.resellerOrg)
                {
                    ApplicationArea = All;
                }
                field(customerOrgId; Rec.customerOrgId)
                {
                    ApplicationArea = All;
                }
                field(customerOrg; Rec.customerOrg)
                {
                    ApplicationArea = All;
                }
                field(endCustomerOrgStatus; Rec.endCustomerOrgStatus)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Status Time Stamp"; Rec."Status Time Stamp")
                {
                    ApplicationArea = All;
                }
                field(ProductName; Rec.ProductName)
                {
                    ApplicationArea = All;
                }
                field("NAV Doc No"; Rec."NAV Doc No")
                {
                    ApplicationArea = All;
                }
                field("NAV Doc Line No"; Rec."NAV Doc Line No")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}