codeunit 70155327 "ApX Reminder-Make"
{
    // version NAVW111.00
    trigger OnRun();
    begin
    end;

    var
        Currency: Record Currency temporary;
        Cust: Record Customer;
        CustLedgEntry: Record "Cust. Ledger Entry";
        CustLedgEntry2: Record "Cust. Ledger Entry";
        ReminderTerms: Record "Reminder Terms";
        ReminderHeaderReq: Record "Reminder Header";
        ReminderHeader: Record "Reminder Header";
        ReminderLine: Record "Reminder Line";
        ReminderEntry: Record "Reminder/Fin. Charge Entry";
        Text0000: Label 'Open Entries Not Due';
        CustLedgEntryOnHoldTEMP: Record "Cust. Ledger Entry" temporary;
        CustLedgEntryLineFeeFilters: Record "Cust. Ledger Entry";
        AmountsNotDueLineInserted: Boolean;
        OverdueEntriesOnly: Boolean;
        HeaderExists: Boolean;
        IncludeEntriesOnHold: Boolean;
        Text0001: Label 'Open Entries On Hold';

    //[Scope('Internal')]
    procedure "Code"() RetVal: Boolean;
    begin
        WITH ReminderHeader DO
            IF "No." <> '' THEN BEGIN
                HeaderExists := TRUE;
                TESTFIELD("Customer No.");
                Cust.GET("Customer No.");
                TESTFIELD("Document Date");
                TESTFIELD("Reminder Terms Code");
                ReminderHeaderReq := ReminderHeader;
                ReminderLine.SETRANGE("Reminder No.", "No.");
                ReminderLine.DELETEALL;
            END;

        Cust.TESTFIELD("Reminder Terms Code");
        IF ReminderHeader."Reminder Terms Code" <> '' THEN
            ReminderTerms.GET(ReminderHeader."Reminder Terms Code")
        ELSE
            ReminderTerms.GET(Cust."Reminder Terms Code");
        IF HeaderExists THEN
            MakeReminder(ReminderHeader."Currency Code")
        ELSE BEGIN
            Currency.DELETEALL;
            CustLedgEntry2.COPYFILTERS(CustLedgEntry);
            CustLedgEntry.SETCURRENTKEY("Customer No.", Open, Positive);
            CustLedgEntry.SETRANGE("Customer No.", Cust."No.");
            CustLedgEntry.SETRANGE(Open, TRUE);
            CustLedgEntry.SETRANGE(Positive, TRUE);
            IF CustLedgEntry.FINDSET THEN
                REPEAT
                    IF CustLedgEntry."On Hold" = '' THEN BEGIN
                        Currency.Code := CustLedgEntry."Currency Code";
                        IF Currency.INSERT THEN;
                    END;
                UNTIL CustLedgEntry.NEXT = 0;
            CustLedgEntry.COPYFILTERS(CustLedgEntry2);
            RetVal := TRUE;
            IF Currency.FINDSET THEN
                REPEAT
                    IF NOT MakeReminder(Currency.Code) THEN
                        RetVal := FALSE;
                UNTIL Currency.NEXT = 0;
        END;
    end;

    //[Scope('Personalization')]
    procedure Set(Cust2: Record Customer; var CustLedgEntry2: Record "Cust. Ledger Entry"; ReminderHeaderReq2: Record "Reminder Header"; OverdueEntriesOnly2: Boolean; IncludeEntriesOnHold2: Boolean; var CustLedgEntryLinefeeOn: Record "Cust. Ledger Entry");
    begin
        Cust := Cust2;
        CustLedgEntry.COPY(CustLedgEntry2);
        ReminderHeaderReq := ReminderHeaderReq2;
        OverdueEntriesOnly := OverdueEntriesOnly2;
        IncludeEntriesOnHold := IncludeEntriesOnHold2;
        CustLedgEntryLineFeeFilters.COPYFILTERS(CustLedgEntryLinefeeOn);
    end;

    //[Scope('Personalization')]
    procedure SuggestLines(ReminderHeader2: Record "Reminder Header"; var CustLedgEntry2: Record "Cust. Ledger Entry"; OverdueEntriesOnly2: Boolean; IncludeEntriesOnHold2: Boolean; var CustLedgEntryLinefeeOn: Record "Cust. Ledger Entry");
    begin
        ReminderHeader := ReminderHeader2;
        CustLedgEntry.COPY(CustLedgEntry2);
        OverdueEntriesOnly := OverdueEntriesOnly2;
        IncludeEntriesOnHold := IncludeEntriesOnHold2;
        CustLedgEntryLineFeeFilters.COPYFILTERS(CustLedgEntryLinefeeOn);
    end;

    local procedure MakeReminder(CurrencyCode: Code[10]): Boolean;
    var
        ReminderLevel: Record "Reminder Level";
        MakeDoc: Boolean;
        StartLineInserted: Boolean;
        NextLineNo: Integer;
        LineLevel: Integer;
        MaxLineLevel: Integer;
        MaxReminderLevel: Integer;
        CustAmount: Decimal;
        ReminderDueDate: Date;
        OpenEntriesNotDueTranslated: Text[100];
        OpenEntriesOnHoldTranslated: Text[100];
    begin
        WITH Cust DO BEGIN
            FilterCustLedgEntryReminderLevel(CustLedgEntry, ReminderLevel, CurrencyCode);
            IF NOT ReminderLevel.FINDLAST THEN
                EXIT(FALSE);
            CustLedgEntryOnHoldTEMP.DELETEALL;

            // Find and MARK Reminder Candidates
            REPEAT
                FilterCustLedgEntries(ReminderLevel);
                IF CustLedgEntry.FINDSET THEN
                    REPEAT
                        IF CustLedgEntry."On Hold" = '' THEN BEGIN
                            SetReminderLine(LineLevel, ReminderDueDate);
                            IF (CalcDate(ReminderLevel."ApX Reminder Days", CALCDATE(ReminderLevel."Grace Period", ReminderDueDate)) <= ReminderHeaderReq."Document Date") AND
                               ((LineLevel <= ReminderTerms."Max. No. of Reminders") OR (ReminderTerms."Max. No. of Reminders" = 0))
                            THEN BEGIN
                                CustLedgEntry.MARK(TRUE);
                                ReminderLevel.MARK(TRUE);
                                IF (ReminderLevel."No." > MaxReminderLevel) AND
                                   (CustLedgEntry."Document Type" <> CustLedgEntry."Document Type"::"Credit Memo")
                                THEN
                                    MaxReminderLevel := ReminderLevel."No.";
                                IF MaxLineLevel < LineLevel THEN
                                    MaxLineLevel := LineLevel;
                                CustLedgEntry.CALCFIELDS("Remaining Amount");
                                CustAmount := CustAmount + CustLedgEntry."Remaining Amount";
                                IF CustLedgEntry.Positive AND
                                   (CalcDate(ReminderLevel."ApX Reminder Days", CALCDATE(ReminderLevel."Grace Period", ReminderDueDate)) <= ReminderHeaderReq."Document Date")
                                THEN
                                    MakeDoc := TRUE;
                            END ELSE
                                IF (CalcDate(ReminderLevel."ApX Reminder Days", CALCDATE(ReminderLevel."Grace Period", ReminderDueDate)) >= ReminderHeaderReq."Document Date") AND
                                   (NOT OverdueEntriesOnly OR
                                    (CustLedgEntry."Document Type" IN [CustLedgEntry."Document Type"::Payment, CustLedgEntry."Document Type"::Refund]))
                                THEN BEGIN
                                    CustLedgEntry.MARK(TRUE);
                                    ReminderLevel.MARK(TRUE);
                                END;
                        END ELSE // The customer ledger entry is on hold
                            IF IncludeEntriesOnHold THEN BEGIN
                                CustLedgEntryOnHoldTEMP := CustLedgEntry;
                                CustLedgEntryOnHoldTEMP.INSERT;
                            END;
                    UNTIL CustLedgEntry.NEXT = 0;
            UNTIL ReminderLevel.NEXT(-1) = 0;

            ReminderLevel.SETRANGE("Reminder Terms Code", ReminderTerms.Code);
            ReminderLevel.SETRANGE("No.", 1, MaxLineLevel);
            IF NOT ReminderLevel.FINDLAST THEN
                ReminderLevel.INIT;
            IF MakeDoc AND (CustAmount > 0) AND (CustAmountLCY(CurrencyCode, CustAmount) >= ReminderTerms."Minimum Amount (LCY)") THEN BEGIN
                IF Blocked = Blocked::All THEN
                    EXIT(FALSE);
                ReminderLine.LOCKTABLE;
                ReminderHeader.LOCKTABLE;
                IF NOT HeaderExists THEN BEGIN
                    ReminderHeader.SETCURRENTKEY("Customer No.", "Currency Code");
                    ReminderHeader.SETRANGE("Customer No.", "No.");
                    ReminderHeader.SETRANGE("Currency Code", CurrencyCode);
                    IF ReminderHeader.FINDFIRST THEN
                        EXIT(FALSE);
                    ReminderHeader.INIT;
                    ReminderHeader."No." := '';
                    ReminderHeader."Posting Date" := ReminderHeaderReq."Posting Date";
                    ReminderHeader.INSERT(TRUE);
                    ReminderHeader.VALIDATE("Customer No.", "No.");
                    ReminderHeader.VALIDATE("Currency Code", CurrencyCode);
                    ReminderHeader."Document Date" := ReminderHeaderReq."Document Date";
                    ReminderHeader."Use Header Level" := ReminderHeaderReq."Use Header Level";
                END;
                ReminderHeader."Reminder Level" := ReminderLevel."No.";
                ReminderHeader.MODIFY;
                NextLineNo := 0;
                ReminderLevel.MARKEDONLY(TRUE);
                CustLedgEntry.MARKEDONLY(TRUE);
                ReminderLevel.FINDLAST;

                REPEAT
                    StartLineInserted := FALSE;
                    FilterCustLedgEntries(ReminderLevel);
                    AmountsNotDueLineInserted := FALSE;
                    IF CustLedgEntry.FINDSET THEN BEGIN
                        REPEAT
                            SetReminderLine(LineLevel, ReminderDueDate);
                            IF CalcDate(ReminderLevel."ApX Reminder Days", ReminderDueDate) <= ReminderHeaderReq."Document Date" THEN BEGIN
                                IF (NextLineNo > 0) AND NOT StartLineInserted THEN BEGIN
                                    ReminderLine.INIT;
                                    NextLineNo := NextLineNo + 10000;
                                    ReminderLine."Reminder No." := ReminderHeader."No.";
                                    ReminderLine."Line No." := NextLineNo;
                                    ReminderLine."Line Type" := ReminderLine."Line Type"::"Reminder Line";
                                    ReminderLine.INSERT;
                                END;
                                NextLineNo := NextLineNo + 10000;
                                ReminderLine.INIT;
                                ReminderLine."Reminder No." := ReminderHeader."No.";
                                ReminderLine."Line No." := NextLineNo;
                                ReminderLine.Type := ReminderLine.Type::"Customer Ledger Entry";
                                ReminderLine.VALIDATE("Entry No.", CustLedgEntry."Entry No.");
                                SetReminderLevel(ReminderHeader, ReminderLevel."No.");
                                ReminderLine.INSERT;
                                StartLineInserted := TRUE;

                                AddLineFeeForCustLedgEntry(CustLedgEntry, ReminderLevel, NextLineNo);
                            END;
                        UNTIL CustLedgEntry.NEXT = 0;
                    END
                UNTIL ReminderLevel.NEXT(-1) = 0;
                ReminderHeader."Reminder Level" := MaxReminderLevel;
                ReminderHeader.VALIDATE("Reminder Level");
                ReminderHeader.InsertLines;
                ReminderLine.SETRANGE("Reminder No.", ReminderHeader."No.");
                ReminderLine.FINDLAST;
                NextLineNo := ReminderLine."Line No.";
                GetOpenEntriesNotDueOnHoldTranslated("Language Code", OpenEntriesNotDueTranslated, OpenEntriesOnHoldTranslated);
                CustLedgEntry.SETRANGE("Last Issued Reminder Level");
                IF CustLedgEntry.FINDSET THEN
                    REPEAT
                        IF (NOT OverdueEntriesOnly) OR
                           (CustLedgEntry."Document Type" IN [CustLedgEntry."Document Type"::Payment, CustLedgEntry."Document Type"::Refund])
                        THEN BEGIN
                            SetReminderLine(LineLevel, ReminderDueDate);
                            IF (CalcDate(ReminderLevel."ApX Reminder Days", CALCDATE(ReminderLevel."Grace Period", ReminderDueDate)) >= ReminderHeaderReq."Document Date") AND
                               (LineLevel = 1)
                            THEN BEGIN
                                IF NOT AmountsNotDueLineInserted THEN BEGIN
                                    ReminderLine.INIT;
                                    NextLineNo := NextLineNo + 10000;
                                    ReminderLine."Reminder No." := ReminderHeader."No.";
                                    ReminderLine."Line No." := NextLineNo;
                                    ReminderLine."Line Type" := ReminderLine."Line Type"::"Not Due";
                                    ReminderLine.INSERT;
                                    NextLineNo := NextLineNo + 10000;
                                    ReminderLine.INIT;
                                    ReminderLine."Reminder No." := ReminderHeader."No.";
                                    ReminderLine."Line No." := NextLineNo;
                                    ReminderLine.Description := OpenEntriesNotDueTranslated;
                                    ReminderLine."Line Type" := ReminderLine."Line Type"::"Not Due";
                                    ReminderLine.INSERT;
                                    AmountsNotDueLineInserted := TRUE;
                                END;
                                NextLineNo := NextLineNo + 10000;
                                ReminderLine.INIT;
                                ReminderLine."Reminder No." := ReminderHeader."No.";
                                ReminderLine."Line No." := NextLineNo;
                                ReminderLine.Type := ReminderLine.Type::"Customer Ledger Entry";
                                ReminderLine.VALIDATE("Entry No.", CustLedgEntry."Entry No.");
                                ReminderLine."No. of Reminders" := 0;
                                ReminderLine."Line Type" := ReminderLine."Line Type"::"Not Due";
                                ReminderLine.INSERT;
                                RemoveNotDueLinesInSectionReminderLine(ReminderLine);
                            END;
                        END;
                    UNTIL CustLedgEntry.NEXT = 0;

                IF IncludeEntriesOnHold THEN
                    IF CustLedgEntryOnHoldTEMP.FINDSET THEN BEGIN
                        ReminderLine.SETRANGE("Reminder No.", ReminderHeader."No.");
                        ReminderLine.FINDLAST;
                        NextLineNo := ReminderLine."Line No.";
                        ReminderLine.INIT;
                        NextLineNo := NextLineNo + 10000;
                        ReminderLine."Reminder No." := ReminderHeader."No.";
                        ReminderLine."Line No." := NextLineNo;
                        ReminderLine."Line Type" := ReminderLine."Line Type"::"On Hold";
                        ReminderLine.INSERT;
                        NextLineNo := NextLineNo + 10000;
                        ReminderLine.INIT;
                        ReminderLine."Reminder No." := ReminderHeader."No.";
                        ReminderLine."Line No." := NextLineNo;
                        ReminderLine.Description := OpenEntriesOnHoldTranslated;
                        ReminderLine."Line Type" := ReminderLine."Line Type"::"On Hold";
                        ReminderLine.INSERT;
                        REPEAT
                            NextLineNo := NextLineNo + 10000;
                            ReminderLine.INIT;
                            ReminderLine."Reminder No." := ReminderHeader."No.";
                            ReminderLine."Line No." := NextLineNo;
                            ReminderLine.Type := ReminderLine.Type::"Customer Ledger Entry";
                            ReminderLine.VALIDATE("Entry No.", CustLedgEntryOnHoldTEMP."Entry No.");
                            ReminderLine."No. of Reminders" := 0;
                            ReminderLine."Line Type" := ReminderLine."Line Type"::"On Hold";
                            ReminderLine.INSERT;
                        UNTIL CustLedgEntryOnHoldTEMP.NEXT = 0;
                    END;
                ReminderHeader.MODIFY;
            END;
        END;

        RemoveLinesOfNegativeReminder(ReminderHeader);

        ReminderLevel.RESET;
        CustLedgEntry.RESET;
        EXIT(TRUE);
    end;

    local procedure CustAmountLCY(CurrencyCode: Code[10]; Amount: Decimal): Decimal;
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        IF CurrencyCode <> '' THEN
            EXIT(
              CurrExchRate.ExchangeAmtFCYToLCY(
                ReminderHeaderReq."Posting Date", CurrencyCode, Amount,
                CurrExchRate.ExchangeRate(ReminderHeaderReq."Posting Date", CurrencyCode)));
        EXIT(Amount);
    end;

    local procedure FilterCustLedgEntries(var ReminderLevel2: Record "Reminder Level");
    var
        ReminderLevel3: Record "Reminder Level";
        LastLevel: Boolean;
    begin
        ReminderLevel3 := ReminderLevel2;
        ReminderLevel3.COPYFILTERS(ReminderLevel2);
        IF ReminderLevel3.NEXT = 0 THEN
            LastLevel := TRUE
        ELSE
            LastLevel := FALSE;
        IF ReminderTerms."Max. No. of Reminders" > 0 THEN
            IF ReminderLevel2."No." <= ReminderTerms."Max. No. of Reminders" THEN
                IF LastLevel THEN
                    CustLedgEntry.SETRANGE("Last Issued Reminder Level", ReminderLevel2."No." - 1, ReminderTerms."Max. No. of Reminders" - 1)
                ELSE
                    CustLedgEntry.SETRANGE("Last Issued Reminder Level", ReminderLevel2."No." - 1)
            ELSE
                CustLedgEntry.SETRANGE("Last Issued Reminder Level", -1)
        ELSE
            IF LastLevel THEN
                CustLedgEntry.SETFILTER("Last Issued Reminder Level", '%1..', ReminderLevel2."No." - 1)
            ELSE
                CustLedgEntry.SETRANGE("Last Issued Reminder Level", ReminderLevel2."No." - 1);
    end;

    local procedure FilterCustLedgEntryReminderLevel(var CustLedgEntry: Record "Cust. Ledger Entry"; var ReminderLevel: Record "Reminder Level"; CurrencyCode: Code[10]);
    begin
        WITH Cust DO BEGIN
            CustLedgEntry.SETCURRENTKEY("Customer No.", Open, Positive, "Due Date", "Currency Code");
            CustLedgEntry.SETRANGE(Open, TRUE);
            CustLedgEntry.SETRANGE("Customer No.", "No.");
            CustLedgEntry.SETRANGE("Due Date");
            CustLedgEntry.SETRANGE("Last Issued Reminder Level");
            CustLedgEntry.SETRANGE("Currency Code", CurrencyCode);
            ReminderLevel.SETRANGE("Reminder Terms Code", ReminderTerms.Code);
        END;
    end;

    local procedure SetReminderLine(var LineLevel2: Integer; var ReminderDueDate2: Date);
    begin
        IF CustLedgEntry."Last Issued Reminder Level" > 0 THEN BEGIN
            ReminderEntry.SETCURRENTKEY("Customer Entry No.", Type);
            ReminderEntry.SETRANGE("Customer Entry No.", CustLedgEntry."Entry No.");
            ReminderEntry.SETRANGE(Type, ReminderEntry.Type::Reminder);
            ReminderEntry.SETRANGE("Reminder Level", CustLedgEntry."Last Issued Reminder Level");
            IF ReminderEntry.FINDLAST THEN BEGIN
                ReminderDueDate2 := ReminderEntry."Due Date";
                LineLevel2 := ReminderEntry."Reminder Level" + 1;
                EXIT;
            END
        END;
        ReminderDueDate2 := CustLedgEntry."Due Date";
        LineLevel2 := 1;
    end;

    //[Scope('Internal')]
    procedure AddLineFeeForCustLedgEntry(var CustLedgEntry: Record "Cust. Ledger Entry"; var ReminderLevel: Record "Reminder Level"; NextLineNo: Integer);
    var
        TempCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        IssuedReminderLine: Record "Issued Reminder Line";
        CustPostingGr: Record "Customer Posting Group";
        LineFeeAmount: Decimal;
    begin
        TempCustLedgEntry := CustLedgEntry;
        TempCustLedgEntry.INSERT;
        TempCustLedgEntry.RESET;
        TempCustLedgEntry.COPYFILTERS(CustLedgEntryLineFeeFilters);
        IF NOT TempCustLedgEntry.FINDFIRST THEN
            EXIT;

        CustLedgEntry.CALCFIELDS("Remaining Amount");
        LineFeeAmount := ReminderLevel.GetAdditionalFee(CustLedgEntry."Remaining Amount",
            ReminderHeader."Currency Code", TRUE, ReminderHeader."Posting Date");
        IF LineFeeAmount = 0 THEN
            EXIT;

        IssuedReminderLine.SETRANGE(Type, IssuedReminderLine.Type::"Line Fee");
        IssuedReminderLine.SETRANGE("Applies-To Document Type", CustLedgEntry."Document Type");
        IssuedReminderLine.SETRANGE("Applies-To Document No.", CustLedgEntry."Document No.");
        IssuedReminderLine.SETRANGE("No. of Reminders", ReminderLevel."No.");
        IF NOT IssuedReminderLine.ISEMPTY THEN
            EXIT;

        CustPostingGr.GET(ReminderHeader."Customer Posting Group");

        NextLineNo := NextLineNo + 100;
        ReminderLine.INIT;
        ReminderLine.VALIDATE("Reminder No.", ReminderHeader."No.");
        ReminderLine.VALIDATE("Line No.", NextLineNo);
        ReminderLine.VALIDATE(Type, ReminderLine.Type::"Line Fee");
        ReminderLine.VALIDATE("No.", CustPostingGr.GetAddFeePerLineAccount);
        ReminderLine.VALIDATE("No. of Reminders", ReminderLevel."No.");
        ReminderLine.VALIDATE("Applies-to Document Type", CustLedgEntry."Document Type");
        ReminderLine.VALIDATE("Applies-to Document No.", CustLedgEntry."Document No.");
        ReminderLine.VALIDATE("Due Date", CALCDATE(ReminderLevel."Due Date Calculation", ReminderHeader."Document Date"));
        ReminderLine.INSERT(TRUE);
    end;

    local procedure SetReminderLevel(ReminderHeader: Record "Reminder Header"; LineLevel: Integer);
    begin
        IF ReminderHeader."Use Header Level" THEN
            ReminderLine."No. of Reminders" := ReminderHeader."Reminder Level"
        ELSE
            ReminderLine."No. of Reminders" := LineLevel;
    end;

    local procedure RemoveLinesOfNegativeReminder(var ReminderHeader: Record "Reminder Header");
    var
        ReminderTotal: Decimal;
    begin
        ReminderHeader.CALCFIELDS(
          "Remaining Amount", "Interest Amount", "Additional Fee", "VAT Amount");

        ReminderTotal := ReminderHeader."Remaining Amount" + ReminderHeader."Interest Amount" +
          ReminderHeader."Additional Fee" + ReminderHeader."VAT Amount";

        IF ReminderTotal < 0 THEN
            ReminderHeader.DELETE(TRUE);
    end;

    local procedure GetOpenEntriesNotDueOnHoldTranslated(CustomerLanguageCode: Code[10]; var OpenEntriesNotDueTranslated: Text[100]; var OpenEntriesOnHoldTranslated: Text[100]);
    var
        Language: Codeunit Language;
        CurrentLanguageCode: Integer;
    begin
        IF CustomerLanguageCode <> '' THEN BEGIN
            CurrentLanguageCode := GLOBALLANGUAGE;
            GLOBALLANGUAGE(Language.GetLanguageID(CustomerLanguageCode));
            OpenEntriesNotDueTranslated := Text0000;
            OpenEntriesOnHoldTranslated := Text0001;
            GLOBALLANGUAGE(CurrentLanguageCode);
        END ELSE BEGIN
            OpenEntriesNotDueTranslated := Text0000;
            OpenEntriesOnHoldTranslated := Text0001;
        END;
    end;

    local procedure RemoveNotDueLinesInSectionReminderLine(ReminderLine: Record "Reminder Line");
    var
        ReminderLineToDelete: Record "Reminder Line";
    begin
        WITH ReminderLineToDelete DO BEGIN
            SETRANGE("Reminder No.", ReminderLine."Reminder No.");
            SETRANGE(Type, ReminderLine.Type);
            SETRANGE("Entry No.", ReminderLine."Entry No.");
            SETRANGE("Document Type", ReminderLine."Document Type");
            SETRANGE("Document No.", ReminderLine."Document No.");
            SETFILTER("Line Type", '<>%1', ReminderLine."Line Type");
            IF FINDFIRST THEN
                DELETE(TRUE);
        END;
    end;
}