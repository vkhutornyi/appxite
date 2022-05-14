table 70155324 "ApX ReThink Billing Header"
{

    fields
    {
        field(70155324; invoicesId; GUID)
        {
            Caption = 'invoicesId';
            DataClassification = SystemMetadata;
        }
        field(70155325; invoicesNumber; Integer)
        {
            Caption = 'invoicesNumber';
            DataClassification = SystemMetadata;
        }
        field(70155326; invoiceProviderId; GUID)
        {
            Caption = 'invoiceProviderId';
            DataClassification = EndUserPseudonymousIdentifiers;
        }
        field(70155327; invoiceProvider; Text[250])
        {
            Caption = 'invoiceProvider';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(70155328; invoiceReceiverId; GUID)
        {
            Caption = 'invoiceReceiverId';
            DataClassification = EndUserPseudonymousIdentifiers;
        }
        field(70155329; invoiceReceiver; Text[250])
        {
            Caption = 'invoiceReceiver';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(70155330; "receiver country"; Text[250])
        {
            Caption = 'receiver country';
            DataClassification = CustomerContent;
        }
        field(70155331; "receiver VAT number"; Text[64])
        {
            Caption = 'receiver VAT number';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(70155332; "billing address"; Text[250])
        {
            Caption = 'billing address';
            DataClassification = CustomerContent;
        }
        field(70155333; "account manager"; Text[250])
        {
            Caption = 'account manager';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(70155334; "account manager email"; Text[64])
        {
            Caption = 'account manager email';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(70155335; "comments"; Text[250])
        {
            Caption = 'comments';
            DataClassification = CustomerContent;
        }
        field(70155336; invoicesDate; Datetime)
        {
            Caption = 'invoicesDate';
            DataClassification = CustomerContent;
        }
        field(70155337; invoiceCurrency; Text[250])
        {
            Caption = 'invoiceCurrency';
            DataClassification = CustomerContent;
        }
        field(70155338; totalPriceCheckSum; Decimal)
        {
            Caption = 'totalPriceCheckSum';
            DataClassification = CustomerContent;
        }
        field(70155339; rateToEuro; Decimal)
        {
            Caption = 'rateToEuro';
            DataClassification = SystemMetadata;
        }
        field(70155340; Status; Option)
        {
            OptionMembers = New,"Doc Created","Doc Posted",Error;
            Caption = 'Status';
            DataClassification = SystemMetadata;
        }
        field(70155341; "NAV Doc No"; Text[20])
        {
            Caption = 'NAV Doc No';
            DataClassification = SystemMetadata;
        }
        field(70155342; "Status Time Stamp"; DateTime)
        {
            Caption = 'Status Time Stamp';
            DataClassification = SystemMetadata;
        }
        field(70155343; "billing period start"; Datetime)
        {
            Caption = 'Billing Period Start';
            DataClassification = SystemMetadata;
        }
        field(70155344; "billing period end"; Datetime)
        {
            Caption = 'Billing Period End';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(invoicesId_invoicesNumber; invoicesId, invoicesNumber)
        {
            Clustered = true;
            Enabled = true;
        }
    }
}