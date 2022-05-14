table 70155333 "ApX ReThink Deferral Template"
{
    fields
    {
        field(70155324; "Day From"; Integer)
        {
            Caption = 'Day From';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "Day To" := "Day From";
                Validate("Day To");
            end;
        }
        field(70155325; "Day To"; Integer)
        {
            Caption = 'Day To';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Reset;
                SetRange("Day To", Rec."Day To");
                if (FindFirst()) and (Rec."Day To" <> xRec."Day To") then
                    Error(Text001);

                if ("Day From" > "Day To") then
                    Error(Text002);

            end;
        }
        field(70155326; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(70155327; "Deferral Template Code"; Code[10])
        {
            TableRelation = "Deferral Template"."Deferral Code";
            Caption = 'Deferral Template Code';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Day From"; "Day From")
        {
            Clustered = true;
            Enabled = true;
        }
    }

    trigger OnInsert()
    begin
        "Day To" := "Day From";
        Validate("Day To");
    end;

    trigger OnRename()
    begin
        if ("Day From" > "Day To") then
            Error(Text002);
    end;

    var
        Text001: Label 'Day To alredy entered.';
        Text002: Label 'Day From cannot be greater than Day To.';
}