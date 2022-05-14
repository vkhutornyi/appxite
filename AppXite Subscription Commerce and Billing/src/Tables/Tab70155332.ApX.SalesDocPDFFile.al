table 70155332 "ApX Sales Doc PDF File"
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
        field(70155327; invoiceReceiverId; GUID)
        {
            Caption = 'invoiceReceiverId';
            DataClassification = EndUserPseudonymousIdentifiers;
        }
        field(70155328; "NAV Document No."; code[20])
        {
            Caption = 'NAV Document No.';
            DataClassification = SystemMetadata;
        }
        field(70155329; "Document PDF"; Blob)
        {
            Caption = 'Document PDF';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(invoicesId; invoicesId)
        {
            Clustered = true;
        }
    }
}