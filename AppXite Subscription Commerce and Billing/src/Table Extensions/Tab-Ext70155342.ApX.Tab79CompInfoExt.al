tableextension 70155342 "ApX Tab79 CompInfo Ext" extends "Company Information"
{
    fields
    {
        field(70155324; "ApX Short Name"; Text[30])
        {
            Caption = 'Short Name';
            DataClassification = CustomerContent;
        }
        field(70155325; "ApX Bank Address"; Text[50])
        {
            Caption = 'Bank Address';
            DataClassification = CustomerContent;
        }
        field(70155326; "ApX Bank Address 2"; Text[50])
        {
            Caption = 'Bank Address 2';
            DataClassification = CustomerContent;
        }
        field(70155327; "ApX Bank Country/Region Code"; Code[10])
        {
            Caption = 'Bank Country/Region Code';
            TableRelation = "Country/Region";
            DataClassification = CustomerContent;
        }
        field(70155328; "ApX Bank County"; Text[30])
        {
            Caption = 'Bank County';
            DataClassification = CustomerContent;
        }
        field(70155329; "ApX Bank Post Code"; Code[20])
        {
            Caption = 'Bank Post Code';
            DataClassification = CustomerContent;
            trigger OnValidate();
            var
                PostCode: Record "Post Code";
            begin
                PostCode.ValidatePostCode("ApX Bank City", "ApX Bank Post Code", "ApX Bank County", "ApX Bank Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(70155330; "ApX Bank City"; Text[30])
        {
            Caption = 'Bank City';
            TableRelation = IF ("ApX Bank Country/Region Code" = CONST()) "Post Code".City ELSE
            IF ("ApX Bank Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("ApX Bank Country/Region Code"));
            DataClassification = CustomerContent;
            trigger OnValidate();
            var
                PostCode: Record "Post Code";
            begin
                PostCode.ValidateCity("ApX Bank City", "ApX Bank Post Code", "ApX Bank County", "ApX Bank Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(70155331; "ApX Transfer Amount To Text"; Text[250])
        {
            Caption = 'Transfer Amount Text';
            DataClassification = CustomerContent;
        }
        field(70155332; "ApX Specify Invoice Text"; Text[250])
        {
            Caption = 'Specify Invoice Text';
            DataClassification = CustomerContent;
        }
        field(70155333; "ApX Contact Dept Text"; Text[250])
        {
            Caption = 'Contact Department Text';
            DataClassification = CustomerContent;
        }
        field(70155334; "ApX Address String Template"; Text[50])
        {
            Caption = 'Address String Template';
            DataClassification = CustomerContent;
        }
        field(70155335; "ApX Base URI"; Text[100])
        {
            Caption = 'Base URI';
            DataClassification = CustomerContent;
        }
        field(70155336; "ApX API Token"; Text[100])
        {
            Caption = 'API Token';
            DataClassification = CustomerContent;
        }
        field(70155337; "ApX ReThink Company ID"; Text[50])
        {
            Caption = 'ReThink Company ID';
            DataClassification = CustomerContent;
        }
        field(70155338; "ApX Is AppXite Company"; Boolean)
        {
            Caption = 'Is AppXite Company';
            DataClassification = CustomerContent;
        }
    }
}

