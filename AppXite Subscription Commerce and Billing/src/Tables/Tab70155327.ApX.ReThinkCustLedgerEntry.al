table 70155327 "ApX ReThink Cust. Ledger Entry"
{

    fields
    {
        field(70155324; "Entry No."; integer)
        {
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
        }
        field(70155325; Status; Option)
        {
            OptionMembers = " ",Overdue,"Partially Paid",Paid,Sent;
            Caption = 'Status';
            DataClassification = SystemMetadata;
        }
        field(70155326; "ReThink ID"; GUID)
        {
            Caption = 'ReThink ID';
            DataClassification = SystemMetadata;
        }
        field(70155327; "Last Modified - ReThink"; DateTime)
        {
            Caption = 'Last Modified - ReThink';
            DataClassification = SystemMetadata;
        }
        field(70155328; "Check For Overdue"; Boolean)
        {
            Caption = 'Check For Overdue';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key("Entry No."; "Entry No.")
        {
            Clustered = true;
        }
    }
}