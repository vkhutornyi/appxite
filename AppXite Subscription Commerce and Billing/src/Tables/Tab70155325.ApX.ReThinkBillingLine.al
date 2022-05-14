table 70155325 "ApX ReThink Billing Line"
{

    fields
    {
        field(70155324; rowId; Guid)
        {
            Caption = 'rowId';
            DataClassification = SystemMetadata;
        }
        field(70155325; invoicesId; GUID)
        {
            Caption = 'invoicesId';
            DataClassification = SystemMetadata;
        }
        field(70155326; invoicesNumber; Integer)
        {
            Caption = 'invoicesNumber';
            DataClassification = SystemMetadata;
        }
        field(70155327; subscriptionId; GUID)
        {
            Caption = 'subscriptionId';
            DataClassification = CustomerContent;
        }
        field(70155328; subscriptionName; Text[250])
        {
            Caption = 'subscriptionName';
            DataClassification = CustomerContent;
        }
        field(70155329; subscriptionStartDate; Datetime)
        {
            Caption = 'subscriptionStartDate';
            DataClassification = CustomerContent;
        }
        field(70155330; subscriptionEndDate; Datetime)
        {
            Caption = 'subscriptionEndDate';
            DataClassification = CustomerContent;
        }
        field(70155331; "vendor Subscription Id"; GUID)
        {
            Caption = 'vendor Subscription Id';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Changed data Type';
        }
        field(70155361; "vendor Subscription Id txt"; Text[128])
        {
            Caption = 'vendor Subscription Id';
            DataClassification = CustomerContent;
        }
        field(70155332; "charge start date"; Datetime)
        {
            Caption = 'charge start date';
            DataClassification = CustomerContent;
        }
        field(70155333; "charge end date"; Datetime)
        {
            Caption = 'charge end date';
            DataClassification = CustomerContent;
        }
        field(70155334; offerId; GUID)
        {
            Caption = 'offerId';
            DataClassification = CustomerContent;
        }
        field(70155335; offerName; Text[250])
        {
            Caption = 'offerName';
            DataClassification = CustomerContent;
        }
        field(70155336; "vendor Offer Id"; Text[250])
        {
            Caption = 'vendor Offer Id';
            DataClassification = CustomerContent;
        }
        field(70155337; invoiceDataContractType; Text[32])
        {
            Caption = 'invoiceDataContractType';
            DataClassification = CustomerContent;
        }
        field(70155338; invoiceChargeTypes; Text[250])
        {
            Caption = 'invoiceChargeTypes';
            DataClassification = CustomerContent;
        }
        field(70155339; quantity; Decimal)
        {
            Caption = 'quantity';
            DataClassification = CustomerContent;
        }
        field(70155340; unitPrice; Decimal)
        {
            Caption = 'unitPrice';
            DataClassification = CustomerContent;
        }
        field(70155341; totalPrice; Decimal)
        {
            Caption = 'totalPrice';
            DataClassification = CustomerContent;
        }
        field(70155342; resellerPrice; Decimal)
        {
            Caption = 'resellerPrice';
            DataClassification = CustomerContent;
        }
        field(70155343; retailPrice; Decimal)
        {
            Caption = 'retailPrice';
            DataClassification = CustomerContent;
        }
        field(70155344; "retail Price Source"; Text[250])
        {
            Caption = 'retail Price Source';
            DataClassification = CustomerContent;
        }
        field(70155345; "retail Price Markup"; Decimal)
        {
            Caption = 'retail Price Markup';
            DataClassification = CustomerContent;
        }
        field(70155346; "customer Markup"; Decimal)
        {
            Caption = 'customer Markup';
            DataClassification = CustomerContent;
        }
        field(70155347; "price Markup Start Date"; DateTime)
        {
            Caption = 'price Markup Start Date';
            DataClassification = CustomerContent;
        }
        field(70155348; Status; Option)
        {
            OptionMembers = New,"Doc Created","Doc Posted",Error;
            Caption = 'Status';
            DataClassification = SystemMetadata;
        }
        field(70155349; "Status Time Stamp"; DateTime)
        {
            Caption = 'Status Time Stamp';
            DataClassification = SystemMetadata;
        }
        field(70155350; vendorOrgId; GUID)
        {
            Caption = 'vendorOrgId';
            DataClassification = EndUserPseudonymousIdentifiers;
        }
        field(70155351; vendorOrg; Text[250])
        {
            Caption = 'vendorOrg';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(70155352; resellerOrgId; GUID)
        {
            Caption = 'resellerOrgId';
            DataClassification = EndUserPseudonymousIdentifiers;
        }
        field(70155353; resellerOrg; Text[250])
        {
            Caption = 'resellerOrg';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(70155354; customerOrgId; GUID)
        {
            Caption = 'customerOrgId';
            DataClassification = EndUserPseudonymousIdentifiers;
        }
        field(70155355; customerOrg; Text[250])
        {
            Caption = 'customerOrg';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(70155356; endCustomerOrgStatus; Text[250])
        {
            Caption = 'endCustomerOrgStatus';
            DataClassification = CustomerContent;
        }
        field(70155357; ShortOfferName; Text[250])
        {
            Caption = 'ShortOfferName';
            DataClassification = CustomerContent;
        }
        field(70155358; ProductName; Text[250])
        {
            Caption = 'ProductName';
            DataClassification = CustomerContent;
        }
        field(70155359; "NAV Doc No"; Text[20])
        {
            Caption = 'NAV Doc No';
            DataClassification = SystemMetadata;
        }
        field(70155360; "NAV Doc Line No"; Integer)
        {
            Caption = 'NAV Doc Line No';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(invoicesId_rowId; invoicesId, rowId)
        {
            Clustered = true;
            Enabled = true;
        }
    }
}