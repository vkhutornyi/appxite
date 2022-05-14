codeunit 70155328 "ApX Common Functions"
{
    trigger OnRun()
    begin
        AppXiteCreateRemindersReport(Today());
        IssueRemindersReport(Today());
        IssueFinanceChargeMemosReport(Today());
        If GuiAllowed() then
            Message(ProcessCompletedMsg)
    end;

    procedure AppXiteCreateRemindersReport(reportDate: Date)
    var
        AppXiteCreateReminders: Report "ApX Create Reminders";
        Customer: Record Customer;
    begin
        Customer.Reset();
        AppXiteCreateReminders.SetTableView(Customer);
        AppXiteCreateReminders.InitializeRequest(reportDate, reportDate, FALSE, FALSE, FALSE);
        AppXiteCreateReminders.USEREQUESTPAGE(FALSE);
        AppXiteCreateReminders.RUN;
    end;

    procedure IssueRemindersReport(reportDate: Date)
    var
        IssueReminders: Report "ApX Custom Issue Reminders";
        ReminderHeader: Record "Reminder Header";
    begin
        ReminderHeader.Reset();
        IssueReminders.SetTableView(ReminderHeader);
        IssueReminders.SetpostingDate(reportDate);
        IssueReminders.USEREQUESTPAGE(FALSE);
        IssueReminders.RUN;
    end;

    procedure CreateFinanceChargeMemosReport(reportDate: Date)
    var
        CustomCreateFinanceChargeMemos: Report "Create Finance Charge Memos";
        Customer: Record Customer;
    begin
        Customer.Reset();
        CustomCreateFinanceChargeMemos.SetTableView(Customer);
        CustomCreateFinanceChargeMemos.InitializeRequest(reportDate, reportDate);
        CustomCreateFinanceChargeMemos.USEREQUESTPAGE(FALSE);
        CustomCreateFinanceChargeMemos.RUN;
    end;

    procedure IssueFinanceChargeMemosReport(reportDate: Date)
    var
        CustomIssueFinanceChargeMemos: Report "ApX Custom Issue Fin. Charge";
        FinanceChargeMemoHeader: Record "Finance Charge Memo Header";
    begin
        FinanceChargeMemoHeader.Reset();
        FinanceChargeMemoHeader.SetRange("ApX Ready To Issue", true);
        if FinanceChargeMemoHeader.FindFirst() then begin
            CustomIssueFinanceChargeMemos.SetTableView(FinanceChargeMemoHeader);
            CustomIssueFinanceChargeMemos.SetpostingDate(reportDate);
            CustomIssueFinanceChargeMemos.USEREQUESTPAGE(FALSE);
            CustomIssueFinanceChargeMemos.RUN;
        end;
    end;

    procedure ResetBillingHeader(var BillingHeader: Record "ApX ReThink Billing Header"; ShowWarning: Boolean)
    var
        SalesHeader: Record "Sales Header";
        ContinueProcess: Boolean;
    begin
        IF BillingHeader.Status = BillingHeader.Status::"Doc Created" then begin
            if ShowWarning then
                if GuiAllowed then
                    if NOT Confirm(ResetBillingHeaderCreatedQst) then
                        exit;
            SalesHeader.SetRange("ApX ReThink Document ID", BillingHeader.invoicesId);
            SalesHeader.DeleteAll(true);
            ContinueProcess := true;
        end;
        IF BillingHeader.Status = BillingHeader.Status::"Doc Posted" then begin
            if ShowWarning then
                if GuiAllowed then
                    if NOT Confirm(ResetBillingHeaderCreatedQst) then
                        exit;
            ContinueProcess := true;
        end;
        if ContinueProcess then begin
            BillingHeader.Status := BillingHeader.Status::New;
            BillingHeader."Status Time Stamp" := CreateDateTime(0D, 0T);
            BillingHeader."NAV Doc No" := '';
            BillingHeader.Modify(true);
        end;
    end;

    var
        ProcessCompletedMsg: Label 'Process Completed';
        ResetBillingHeaderCreatedQst: Label 'You are about to reset Status of Billing Header to New. This action will delete related document.\Do you want to continue?';
        ResetBillingHeaderPostedQst: Label 'You are about to reset Status of Billing Header to New. You need to post corrective document to related existing document.\Do you want to continue?';
}