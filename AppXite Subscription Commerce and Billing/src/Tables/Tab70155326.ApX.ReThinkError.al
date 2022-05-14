table 70155326 "ApX ReThink Error"
{

    fields
    {
        field(70155324; invoicesNumber; Integer)
        {
            Caption = 'invoicesNumber';
            DataClassification = SystemMetadata;
        }
        field(70155325; rowId; GUID)
        {
            Caption = 'rowId';
            DataClassification = SystemMetadata;
        }
        field(70155326; "Data Type"; Option)
        {
            OptionMembers = Header,Line;
            Caption = 'Data Type';
            DataClassification = SystemMetadata;
        }
        field(70155327; "Error Type"; Option)
        {
            OptionMembers = Customer,Resource,Balance,"NULL Value",Invoice;
            Caption = 'Error Type';
            DataClassification = SystemMetadata;
        }
        field(70155328; Comment; Text[80])
        {
            Caption = 'Comment';
            DataClassification = SystemMetadata;
        }
        field(70155329; "Time Created"; Datetime)
        {
            Caption = 'Time Created';
            DataClassification = SystemMetadata;
        }
        field(70155330; Resolved; Boolean)
        {
            Caption = 'Resolved';
            DataClassification = SystemMetadata;
        }
        field(70155331; invoicesId; GUID)
        {
            Caption = 'invoicesId';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(invoicesNumber_rowId; invoicesNumber, rowId)
        {
            Clustered = true;
            Enabled = true;
        }
    }
}