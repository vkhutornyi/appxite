report 70155332 "ApX Create Reminders"
{
    // version NAVW111.00

    Caption = 'AppXite Create Reminders';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord();
            begin
                RecordNo := RecordNo + 1;
                CLEAR(MakeReminder);
                MakeReminder.Set(Customer, CustLedgEntry, ReminderHeaderReq, OverdueEntriesOnly, IncludeEntriesOnHold, CustLedgEntryLineFeeOn);
                IF NoOfRecords = 1 THEN BEGIN
                    MakeReminder.Code;
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
                    MARK := NOT MakeReminder.Code;
                END;
            end;

            trigger OnPostDataItem();
            begin
                Window.CLOSE;
                MARKEDONLY := TRUE;
                COMMIT;
                IF FIND('-') THEN
                    IF GuiAllowed() then
                        IF CONFIRM(Text003, TRUE) THEN
                            PAGE.RUNMODAL(0, Customer);
            end;

            trigger OnPreDataItem();
            var
                SalesSetup: Record "Sales & Receivables Setup";
            begin
                IF ReminderHeaderReq."Document Date" = 0D THEN
                    ERROR(Text000, ReminderHeaderReq.FIELDCAPTION("Document Date"));
                FILTERGROUP := 2;
                SETFILTER("Reminder Terms Code", '<>%1', '');
                FILTERGROUP := 0;
                NoOfRecords := COUNT;
                SalesSetup.GET;
                SalesSetup.TESTFIELD("Reminder Nos.");
                IF NoOfRecords = 1 THEN
                    Window.OPEN(Text001)
                ELSE BEGIN
                    Window.OPEN(Text002);
                    OldTime := TIME;
                END;
                ReminderHeaderReq."Use Header Level" := UseHeaderLevel;
            end;
        }
        dataitem(CustLedgEntry2; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING("Customer No.");
            RequestFilterFields = "Document Type";

            trigger OnPreDataItem();
            begin
                CurrReport.BREAK;
            end;
        }
        dataitem(CustLedgEntryLineFeeOn; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING("Entry No.")
                                ORDER(Ascending);
            RequestFilterFields = "Document Type";
            RequestFilterHeading = 'Apply Fee per Line On';

            trigger OnPreDataItem();
            begin
                CurrReport.BREAK;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field("Posting Date"; ReminderHeaderReq."Posting Date")
                    {
                        ApplicationArea = Advanced;
                        Caption = 'Posting Date';
                        ToolTip = 'Specifies the date that will appear as the posting date on the header of the reminder that is created by the batch job.';
                    }
                    field(DocumentDate; ReminderHeaderReq."Document Date")
                    {
                        ApplicationArea = Advanced;
                        Caption = 'Document Date';
                        ToolTip = 'Specifies the date that will appear as the document date on the header of the reminder that is created by the batch job. This date is used for any interest calculations and to determine the due date of the reminder.';
                    }
                    field(OverdueEntriesOnly; OverdueEntriesOnly)
                    {
                        ApplicationArea = Advanced;
                        Caption = 'Only Entries with Overdue Amounts';
                        MultiLine = true;
                        ToolTip = 'Specifies if the batch job will only insert open entries that are overdue, meaning they have a due date earlier than the document date on the reminder header.';
                    }
                    field(IncludeEntriesOnHold; IncludeEntriesOnHold)
                    {
                        ApplicationArea = Advanced;
                        Caption = 'Include Entries On Hold';
                        ToolTip = 'Specifies if you want to create reminders for entries that are on hold.';
                    }
                    field(UseHeaderLevel; UseHeaderLevel)
                    {
                        ApplicationArea = Advanced;
                        Caption = 'Use Header Level';
                        ToolTip = 'Specifies if the batch job will apply the condition of the reminder level to all the reminder lines.';
                    }
                }
            }
        }
        trigger OnOpenPage();
        begin
            IF ReminderHeaderReq."Document Date" = 0D THEN BEGIN
                ReminderHeaderReq."Document Date" := WORKDATE;
                ReminderHeaderReq."Posting Date" := WORKDATE;
            END;
        end;
    }

    trigger OnInitReport();
    begin
        OverdueEntriesOnly := TRUE;
    end;

    trigger OnPreReport();
    begin
        CustLedgEntry.COPY(CustLedgEntry2);
        IF CustLedgEntryLineFeeOnFilters.GETFILTERS <> '' THEN
            CustLedgEntryLineFeeOn.COPYFILTERS(CustLedgEntryLineFeeOnFilters);
    end;

    var
        Text000: Label '%1 must be specified.';
        Text001: Label 'Making reminders...';
        Text002: Label 'Making reminders @1@@@@@@@@@@@@@';
        Text003: Label 'It was not possible to create reminders for some of the selected customers.\Do you want to see these customers?';
        CustLedgEntry: Record "Cust. Ledger Entry";
        ReminderHeaderReq: Record "Reminder Header";
        CustLedgEntryLineFeeOnFilters: Record "Cust. Ledger Entry";
        MakeReminder: Codeunit "ApX Reminder-Make";
        Window: Dialog;
        NoOfRecords: Integer;
        RecordNo: Integer;
        NewProgress: Integer;
        OldProgress: Integer;
        NewTime: Time;
        OldTime: Time;
        OverdueEntriesOnly: Boolean;
        UseHeaderLevel: Boolean;
        IncludeEntriesOnHold: Boolean;

    procedure InitializeRequest(DocumentDate: Date; PostingDate: Date; OverdueEntries: Boolean; NewUseHeaderLevel: Boolean; IncludeEntries: Boolean);
    begin
        ReminderHeaderReq."Document Date" := DocumentDate;
        ReminderHeaderReq."Posting Date" := PostingDate;
        OverdueEntriesOnly := OverdueEntries;
        UseHeaderLevel := NewUseHeaderLevel;
        IncludeEntriesOnHold := IncludeEntries;
    end;

    procedure SetApplyLineFeeOnFilters(var CustLedgEntryLineFeeOn2: Record "Cust. Ledger Entry");
    begin
        CustLedgEntryLineFeeOnFilters.COPYFILTERS(CustLedgEntryLineFeeOn2);
    end;
}

