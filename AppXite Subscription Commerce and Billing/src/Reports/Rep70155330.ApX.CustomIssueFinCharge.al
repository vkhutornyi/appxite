report 70155330 "ApX Custom Issue Fin. Charge"
{
    Caption = 'Custom Issue Fin. Charge';
    ProcessingOnly = true;
    UseRequestPage = false;
    dataset
    {
        dataitem("Finance Charge Memo Header"; "Finance Charge Memo Header")
        {
            DataItemTableView = sorting("No.")
                    WHERE("ApX Ready To Issue" = FILTER(true));

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
                CLEAR(FinChrgMemoIssue);
                FinChrgMemoIssue.Set("Finance Charge Memo Header", ReplacePostingDate, PostingDateReq);
                IF NoOfRecords = 1 THEN BEGIN
                    FinChrgMemoIssue.RUN;
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
                    MARK := NOT FinChrgMemoIssue.RUN;
                END;

                IF (PrintDoc <> PrintDoc::" ") AND NOT MARK THEN BEGIN
                    FinChrgMemoIssue.GetIssuedFinChrgMemo(IssuedFinChrgMemoHeader);
                    TempIssuedFinChrgMemoHeader := IssuedFinChrgMemoHeader;
                    TempIssuedFinChrgMemoHeader.INSERT;
                END;

            end;

            trigger OnPostDataItem()
            begin
                Window.CLOSE;
                COMMIT;
                IF PrintDoc <> PrintDoc::" " THEN
                    IF TempIssuedFinChrgMemoHeader.FINDSET THEN
                        REPEAT
                            IssuedFinChrgMemoHeader := TempIssuedFinChrgMemoHeader;
                            IssuedFinChrgMemoHeader.SETRECFILTER;
                            IssuedFinChrgMemoHeader.PrintRecords(FALSE, PrintDoc = PrintDoc::Email, HideDialog);
                        UNTIL TempIssuedFinChrgMemoHeader.NEXT = 0;
                MARKEDONLY := TRUE;
                IF FIND('-') THEN
                    IF GuiAllowed() then
                        IF CONFIRM(Text003, TRUE) THEN
                            PAGE.RUNMODAL(0, "Finance Charge Memo Header");
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
        Text001: Label 'Issuing finance charge memo...';
        Text002: Label 'Issuing finance charge memos @1@@@@@@@@@@@@@';
        Text003: Label 'It was not possible to issue some of the selected finance charge memos.\Do you want to see these finance charge memos?';
        IssuedFinChrgMemoHeader: Record 304;
        TempIssuedFinChrgMemoHeader: Record 304 temporary;
        FinChrgMemoIssue: Codeunit 395;
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
}