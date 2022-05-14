report 70155324 "ApX On-Boarding Status Report"
{
    Caption = 'On-Boarding Status Report';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Rep70155324.ApX.OnBoardingStatusReport.rdl'; // if Word use WordLayout property
    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number);
            column(No; No)
            {
            }
            column(Name; Name)
            {
            }
            column(NameFromReThink; NameFromReThink)
            {
            }
            column(lastModifiedbyReThink; lastModifiedbyReThink)
            {
            }
            column(ReThinkID; ReThinkID)
            {
            }


            trigger OnPreDataItem();
            begin
                if RecType = RecType::Customer then begin
                    Customer.SetRange("ApX On-Boarding Required", true);
                    IF not Customer.FindFirst then
                        Error(Text001);
                    Num := Customer.Count;

                end;
                if RecType = RecType::Vendor then begin
                    Vendor.SetRange("ApX On-Boarding Required", true);
                    IF not Vendor.FindFirst then
                        Error(Text001);
                    Num := Vendor.Count;
                end;
                if RecType = RecType::Resource then begin
                    Resource.SetRange("ApX On-Boarding Required", true);
                    IF not Resource.FindFirst then
                        Error(Text001);
                    Num := Resource.Count;
                end;
                SetRange(Number, 1, Num);
            end;

            trigger OnAfterGetRecord();
            begin
                Clear(No);
                Clear(Name);
                Clear(NameFromReThink);
                Clear(lastModifiedbyReThink);
                Clear(ReThinkID);

                if RecType = RecType::Customer then begin
                    Customer.RESET;
                    Customer.SetRange("ApX On-Boarding Required", true);
                    IF Customer.FINDFIRST THEN
                        i := 0;
                    REPEAT
                        No := Customer."No.";
                        Name := Customer.Name;
                        NameFromReThink := Customer."ApX Name From ReThink";
                        lastModifiedbyReThink := Customer."ApX Last Modified - ReThink";
                        ReThinkID := Customer."ApX ReThink ID";
                        i += 1;
                    UNTIL (Customer.NEXT = 0) OR (RecNum = i);
                end;
                if RecType = RecType::Vendor then begin
                    Vendor.RESET;
                    Vendor.SetRange("ApX On-Boarding Required", true);
                    IF Vendor.FINDFIRST THEN
                        i := 0;
                    REPEAT
                        No := Vendor."No.";
                        Name := Vendor.Name;
                        NameFromReThink := Vendor."ApX Name From ReThink";
                        lastModifiedbyReThink := Vendor."ApX Last Modified - ReThink";
                        ReThinkID := Vendor."ApX ReThink ID";
                        i += 1;
                    UNTIL (Vendor.NEXT = 0) OR (RecNum = i);
                end;
                if RecType = RecType::Resource then begin
                    Resource.RESET;
                    Resource.SetRange("ApX On-Boarding Required", true);
                    IF Resource.FINDFIRST THEN
                        i := 0;
                    REPEAT
                        No := Resource."No.";
                        Name := Resource.Name;
                        NameFromReThink := Resource."ApX Name From ReThink";
                        lastModifiedbyReThink := Resource."ApX Last Modified - ReThink";
                        ReThinkID := Resource."ApX ReThink ID";
                        i += 1;
                    UNTIL (Resource.NEXT = 0) OR (RecNum = i);
                end;
                RecNum += 1;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Filter)
                {
                    field("Record Type"; RecType)
                    {
                        ApplicationArea = All;

                    }
                }
            }
        }
    }

    var
        No: Code[20];
        Name: Text[50];
        NameFromReThink: Text[250];
        lastModifiedbyReThink: DateTime;
        ReThinkID: Guid;
        Customer: Record Customer;
        Vendor: Record Vendor;
        Resource: Record Resource;
        RecType: Option Customer,Vendor,Resource;
        Num: Integer;
        RecNum: Integer;
        i: Integer;
        Text001: Label 'No Record Found';
}