report 70155326 "ApX Clear Billing History"
{
    ProcessingOnly = true;
    dataset
    {

        dataitem(RethinkBillingHeader; "ApX ReThink Billing Header")
        {
            RequestFilterFields = invoicesDate;
            trigger OnPreDataItem();
            var
                invoicesDateFrom: Text[17];
                invoicesDateTo: Text[17];
                DateFrom: Date;
                DateTo: Date;

            begin
                if (RethinkBillingHeader.GetFilter(invoicesDate)) <> '' then begin
                    invoicesDateFrom := CopyStr(RethinkBillingHeader.GetFilter(invoicesDate), 1, 8);
                    invoicesDateTo := CopyStr(RethinkBillingHeader.GetFilter(invoicesDate), 20, 8);
                    Evaluate(DateFrom, invoicesDateFrom);
                    Evaluate(DateTo, invoicesDateTo);
                end;

                RethinkBillingHeader.SetRange(RethinkBillingHeader.Status, Status::"Doc Posted");

                if (RethinkBillingHeader.GetFilter(invoicesDate)) <> '' then
                    RethinkBillingHeader.SetFilter(RethinkBillingHeader.invoicesDate, '<%1&>=%2&<=%3', CreateDateTime(CalcDate('-<1Y>', Today()), Time()), CreateDateTime(DateFrom, 000001T), CreateDateTime(DateTo, 235959T))
                else
                    RethinkBillingHeader.SetFilter(RethinkBillingHeader.invoicesDate, '<%1', CreateDateTime(CalcDate('-<1Y>', Today()), Time()));
                Num := Count;
                if Not RethinkBillingHeader.FindFirst() then
                    Error(Text001);

            end;

            trigger OnAfterGetRecord();
            var
                RethinkBillLine: Record "ApX ReThink Billing Line";
                RethinkBillHeader: Record "ApX ReThink Billing Header";
            begin
                RethinkBillLine.Reset;
                RethinkBillLine.SetRange(invoicesId, RethinkBillingHeader.invoicesId);
                RethinkBillLine.SetRange(invoicesNumber, RethinkBillingHeader.invoicesNumber);
                RethinkBillLine.SetRange(RethinkBillLine.Status, Status::"Doc Posted");
                if RethinkBillLine.FindFirst then
                    RethinkBillLine.DeleteAll;
                RethinkBillHeader.Reset;
                RethinkBillHeader.SetRange(RethinkBillHeader.invoicesId, RethinkBillingHeader.invoicesId);
                RethinkBillHeader.SetRange(RethinkBillHeader.invoicesNumber, RethinkBillingHeader.invoicesNumber);
                RethinkBillHeader.SetRange(RethinkBillHeader.Status, Status::"Doc Posted");
                if RethinkBillHeader.FindFirst then
                    RethinkBillHeader.Delete;
            end;
        }

    }
    trigger OnPreReport()
    begin
        if not Confirm(Text002, true) then
            Error(Text003);
    end;

    trigger OnPostReport();
    begin
        Message(Text004, Num);
    end;

    var
        Num: Integer;
        Text001: Label 'Data less than 2 years old cannot be deleted.';
        Text002: Label 'Are you sure you want delete data?';
        Text003: Label 'No Action performed.';
        Text004: Label '%1 Line(s) Deleted.';
}