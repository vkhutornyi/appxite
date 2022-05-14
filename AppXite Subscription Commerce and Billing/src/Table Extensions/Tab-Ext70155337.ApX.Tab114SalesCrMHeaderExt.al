tableextension 70155337 "ApX Tab114 SalesCrMHeader Ext" extends "Sales Cr.Memo Header"
{
    fields
    {
        field(70155324; "ApX ReThink Document"; Boolean)
        {
            Caption = 'ReThink Document';
            DataClassification = SystemMetadata;
        }
        field(70155325; "ApX ReThink Customer ID"; GUID)
        {
            Caption = 'ReThink Customer ID';
            DataClassification = EndUserPseudonymousIdentifiers;
        }
        field(70155326; "ApX ReThink Document ID"; Guid)
        {
            Caption = 'ReThink Document ID';
            DataClassification = CustomerContent;
        }
        field(70155327; "ApX Billing Period Start"; Date)
        {
            Caption = 'Billing Period Start';
            DataClassification = CustomerContent;
        }
        field(70155328; "ApX Billing Period End"; Date)
        {
            Caption = 'Billing Period End';
            DataClassification = CustomerContent;
        }
    }
}