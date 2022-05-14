report 70155333 "ApX Suggest Reminder Lines"
{
    // version NAVW111.00

    Caption = 'AppXite Suggest Reminder Lines';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Reminder Header"; "Reminder Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Reminder';

            trigger OnAfterGetRecord();
            begin
                RecordNo := RecordNo + 1;
                CLEAR(MakeReminder);
                MakeReminder.SuggestLines("Reminder Header", CustLedgEntry, OverdueEntriesOnly, IncludeEntriesOnHold, CustLedgEntryLineFeeOn);
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
                    MARK := NOT MakeReminder.RUN;
                END;
            end;

            trigger OnPostDataItem();
            begin
                COMMIT;
                Window.CLOSE;
                MARKEDONLY := TRUE;
                IF FIND('-') THEN
                    IF CONFIRM(Text002, TRUE) THEN
                        PAGE.RUNMODAL(0, "Reminder Header");
            end;

            trigger OnPreDataItem();
            begin
                NoOfRecords := COUNT;
                IF NoOfRecords = 1 THEN
                    Window.OPEN(Text000)
                ELSE BEGIN
                    Window.OPEN(Text001);
                    OldTime := TIME;
                END;
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
                        ToolTip = 'Specifies if the batch job will also insert overdue open entries that are on hold.';
                    }
                }
            }
        }
    }

    trigger OnPreReport();
    begin
        CustLedgEntry.COPY(CustLedgEntry2)
    end;

    var
        Text000: Label 'Suggesting lines...';
        Text001: Label 'Suggesting lines @1@@@@@@@@@@@@@';
        Text002: Label 'It was not possible to process some of the selected reminders.\Do you want to see these reminders?';
        CustLedgEntry: Record "Cust. Ledger Entry";
        MakeReminder: Codeunit "ApX Reminder-Make";
        Window: Dialog;
        NoOfRecords: Integer;
        RecordNo: Integer;
        NewProgress: Integer;
        OldProgress: Integer;
        NewTime: Time;
        OldTime: Time;
        OverdueEntriesOnly: Boolean;
        IncludeEntriesOnHold: Boolean;
}

