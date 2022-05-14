tableextension 70155332 "ApX Tab156 Resource Ext" extends Resource
{
    fields
    {
        field(70155324; "ApX Last Modified - ReThink"; DateTime)
        {
            Caption = 'Last Modified - ReThink';
            DataClassification = SystemMetadata;
        }
        field(70155325; "ApX On-Boarding Required"; Boolean)
        {
            Caption = 'On-Boarding Required';
            DataClassification = CustomerContent;
        }
        field(70155326; "ApX ReThink ID"; Guid)
        {
            Caption = 'ReThink ID';
            DataClassification = SystemMetadata;
        }
        field(70155327; "ApX Name From ReThink"; Text[250])
        {
            Caption = 'Name From ReThink';
            DataClassification = CustomerContent;
        }

        // Modify(Type)
        // {
        //     //OptionCaption = 'Software,Machine';
        //     OptionCaptionML = ENU = 'Software,Machine';
        // }
    }
    keys
    {
        key("ApX ReThink ID"; "ApX ReThink ID") { Enabled = true; }
    }
}