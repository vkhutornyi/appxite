table 70155329 "ApX Email Log Line"
{

    fields
    {
        field(70155324; "No."; Integer)
        {
            Caption = 'No.';
            DataClassification = SystemMetadata;
        }
        field(70155325; "Email Log Header No."; Integer)
        {
            TableRelation = "ApX Email Log Header"."No.";
            Caption = 'Email Log Header No.';
            DataClassification = SystemMetadata;
        }
        field(70155326; "Doc Type"; Option)
        {
            OptionMembers = "Sales Inv","Sales Cr",Reminder,"Fin Charge";
            Caption = 'Doc Type';
            DataClassification = SystemMetadata;
        }
        field(70155327; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = SystemMetadata;
        }
        field(70155328; "Email Sent"; Boolean)
        {
            Caption = 'Email Sent';
            DataClassification = SystemMetadata;
        }
        field(70155329; "Customer Name"; text[250])
        {
            Caption = 'Customer Name';
            DataClassification = EndUserIdentifiableInformation;
        }
    }

    keys
    {
        key(No_EmailLogHeaderNo; "No.", "Email Log Header No.")
        {
            Clustered = true;
        }
        key(DocType_DocumentNo; "Doc Type", "Document No.") { }
    }
}