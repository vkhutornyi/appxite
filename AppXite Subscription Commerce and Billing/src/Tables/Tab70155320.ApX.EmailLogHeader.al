table 70155328 "ApX Email Log Header"
{
    fields
    {
        field(70155324; "No."; Integer)
        {
            Caption = 'No.';
            DataClassification = SystemMetadata;
        }
        field(70155325; "Doc Type"; Option)
        {
            OptionMembers = "Sales Inv","Sales Cr",Reminder,"Fin Charge";
            Caption = 'Doc Type';
            DataClassification = SystemMetadata;
        }
        field(70155326; "Process Start Date Time"; DateTime)
        {
            Caption = 'Process Start Date Time';
            DataClassification = SystemMetadata;
        }
        field(70155327; "Process End Date Time"; DateTime)
        {
            Caption = 'Process End Date Time';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(No; "No.")
        {
            Clustered = true;
        }
        key(DocType; "Doc Type") { }
    }
}