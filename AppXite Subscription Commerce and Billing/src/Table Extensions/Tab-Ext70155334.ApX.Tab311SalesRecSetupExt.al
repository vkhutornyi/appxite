tableextension 70155334 "ApX Tab311 SalesRecSetup Ext" extends "Sales & Receivables Setup"
{
    fields
    {
        field(70155324; "ApX Max Inv Lines to Display"; Integer)
        {
            Caption = 'Max Inv Lines to Display';
            DataClassification = SystemMetadata;
        }
        field(70155325; "ApX Sales Doc Internal Email"; Text[80])
        {
            Caption = 'Sales Doc Internal Email';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(70155326; "ApX Reseller Liability Account"; Code[20])
        {
            TableRelation = "G/L Account"."No." WHERE("Direct Posting" = const(true));
            Caption = 'Reseller Liability Account';
            DataClassification = CustomerContent;
        }
    }

}