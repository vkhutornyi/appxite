report 70155331 "ApX Remove Email Log History"
{

    ProcessingOnly = true;
    dataset
    {
        dataitem(EmailLogHeader; "ApX Email Log Header")
        {
            DataItemTableView = sorting("No.");
            trigger OnPreDataItem();
            begin
                EmailLogHeader.SetFilter("Process End Date Time", '<%1&<>%2', CreateDateTime(DateUpTo, Time()), 0DT);
                Num := Count;
                if Not EmailLogHeader.FindFirst() then
                    Error(Text001);
            end;

            trigger OnAfterGetRecord();
            var
                EmailLogHead: Record "ApX Email Log Header";
                EmailLogLine: Record "ApX Email Log Line";
            begin
                EmailLogLine.Reset;
                EmailLogLine.SetRange(EmailLogLine."Email Log Header No.", EmailLogHeader."No.");
                if EmailLogLine.FindFirst then
                    EmailLogLine.DeleteAll;
                EmailLogHead.Reset;
                EmailLogHead.SetRange(EmailLogHead."No.", EmailLogHeader."No.");
                if EmailLogHead.FindFirst then
                    EmailLogHead.Delete;
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
                    field("Date Up To"; "DateUpTo")
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    trigger OnInitReport()
    var
        myInt: Integer;
    begin
        if not Confirm(Text002, true) then
            Error(Text003)
        else
            DateUpTo := Today;
    end;

    trigger OnPreReport()
    var

    begin
        if (DateUpTo <> 0D) and (DateUpTo > CalcDate('-<3M>', Today())) then
            Error(Text004);
    end;

    trigger OnPostReport();
    var

    begin
        Message(Text005, Num);

    end;

    var
        Num: Integer;
        DateUpTo: Date;
        Text001: Label 'Data Not Found';
        Text002: Label 'Do you want to delete Email Log History?';
        Text003: Label 'No Action performed';
        Text004: Label 'Date should be Less than three months from today';
        Text005: Label '%1 Line(s) Deleted';
}