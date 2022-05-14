report 70155328 "ApX Custom Issue Reminders"
{
    Caption = 'Custom Issue Reminders';
    ProcessingOnly = true;
    UseRequestPage = false;
    dataset
    {
        dataitem("Reminder Header"; "Reminder Header")
        {
            DataItemTableView = sorting("No.");

            trigger OnPreDataItem()
            var

            begin
                IF ReplacePostingDate AND (PostingDateReq = 0D) THEN
                    ERROR(Text000);
                NoOfRecords := COUNT;
                IF NoOfRecords = 1 THEN
                    Window.OPEN(Text001)
                ELSE BEGIN
                    Window.OPEN(Text002);
                    OldTime := TIME;
                END;
            end;

            trigger OnAfterGetRecord()
            var
                myInt: Integer;
            begin
                RecordNo := RecordNo + 1;
                CLEAR(ReminderIssue);
                ReminderIssue.Set("Reminder Header", ReplacePostingDate, PostingDateReq);
                IF NoOfRecords = 1 THEN BEGIN
                    ReminderIssue.RUN;
                    MARK := FALSE;
                END ELSE BEGIN
                    NewTime := TIME;
                    IF (NewTime - OldTime > 100) OR (NewTime < OldTime) THEN BEGIN
                        NewProgress := ROUND(RecordNo / NoOfRecords * 100, 1);
                        IF NewProgress <> OldProgress THEN BEGIN
                            Window.UPDATE(1, NewProgress * 100);
                            OldProgress := NewProgress;
                        END;
                        OldTime := TIME;
                    END;
                    COMMIT;
                    MARK := NOT ReminderIssue.RUN;
                END;

                IF PrintDoc <> PrintDoc::" " THEN BEGIN
                    ReminderIssue.GetIssuedReminder(IssuedReminderHeader);
                    TempIssuedReminderHeader := IssuedReminderHeader;
                    TempIssuedReminderHeader.INSERT;
                END;

            end;

            trigger OnPostDataItem()
            var
                IssuedReminderHeaderPrint: Record "Issued Reminder Header";
            begin
                Window.CLOSE;
                COMMIT;
                IF PrintDoc <> PrintDoc::" " THEN
                    IF TempIssuedReminderHeader.FINDSET THEN
                        REPEAT
                            IssuedReminderHeaderPrint := TempIssuedReminderHeader;
                            IssuedReminderHeaderPrint.SETRECFILTER;
                            IssuedReminderHeaderPrint.PrintRecords(FALSE, PrintDoc = PrintDoc::Email, HideDialog);
                        UNTIL TempIssuedReminderHeader.NEXT = 0;
                MARKEDONLY := TRUE;
                IF FIND('-') THEN
                    IF GuiAllowed() then
                        IF CONFIRM(Text003, TRUE) THEN
                            PAGE.RUNMODAL(0, "Reminder Header");
            end;
        }
    }

    procedure SetpostingDate(postingDate: Date)
    begin
        PrintDoc := PrintDoc::" ";
        ReplacePostingDate := true;
        PostingDateReq := postingDate;
    end;

    var
        Text000: Label 'Enter the posting date.';
        Text001: Label 'Issuing reminder...';
        Text002: Label 'Issuing reminders @1@@@@@@@@@@@@@';
        Text003: Label 'It was not possible to issue some of the selected reminders.\Do you want to see these reminders?';
        IssuedReminderHeader: Record "Issued Reminder Header";
        TempIssuedReminderHeader: Record "Issued Reminder Header" temporary;
        ReminderIssue: Codeunit "Reminder-Issue";
        Window: Dialog;
        NoOfRecords: Integer;
        RecordNo: Integer;
        NewProgress: Integer;
        OldProgress: Integer;
        NewTime: Time;
        OldTime: Time;
        PostingDateReq: Date;
        ReplacePostingDate: Boolean;
        PrintDoc: Option " ",Print,Email;
        HideDialog: Boolean;
        IsOfficeAddin: Boolean;
}