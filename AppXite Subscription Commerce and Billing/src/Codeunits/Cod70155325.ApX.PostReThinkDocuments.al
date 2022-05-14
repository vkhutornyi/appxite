codeunit 70155325 "ApX Post ReThink Documents"
{
    trigger OnRun();
    begin
        PostSalesDocuments();
        UpdateOverdueStatus();
        IF GuiAllowed() then
            Message(PostingDoneMsg);
    end;

    local procedure PostSalesDocuments();
    var
        BillingHeader: Record "ApX ReThink Billing Header";
        BillingHeaderCp: Record "ApX ReThink Billing Header";
        Customer: Record Customer;
        ReCustLedgEntry: Record "ApX ReThink Cust. Ledger Entry";
        SalesCreHeader: Record "Sales Cr.Memo Header";
        SalesHeader: Record "Sales Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesRecSetup: Record "Sales & Receivables Setup";
        Defresult: Boolean;
        EmailSent: Boolean;
        EntryNo: Integer;
        BillingLine: Record "ApX ReThink Billing Line";
    begin
        EmailSent := false;
        SalesRecSetup.Get;
        SalesHeader.SetRange("ApX ReThink Document", true);
        if SalesHeader.FindSet(true) then
            repeat begin
                Defresult := UpdateDeferral(SalesHeader."Document Type", SalesHeader."No.");
                if Defresult then begin
                    //•	Post the documents in a try..catch function so that any potential error does not result in stopping the process.
                    BillingHeaderCp.Reset;
                    BillingHeaderCp.SetRange("NAV Doc No", SalesHeader."No.");
                    BillingHeaderCp.SetRange(Status, BillingHeader.Status::"Doc Created");
                    if BillingHeaderCp.FindFirst then begin
                        Codeunit.Run(Codeunit::"Sales-Post", SalesHeader);

                        if BillingHeader.Get(BillingHeaderCp.invoicesId, BillingHeaderCp.invoicesNumber) then begin
                            if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then begin
                                SalesInvHeader.Reset;
                                SalesInvHeader.SetRange("Pre-Assigned No.", SalesHeader."No.");
                                if SalesInvHeader.FindFirst then begin
                                    BillingHeader.Validate("NAV Doc No", SalesInvHeader."No.");
                                    EntryNo := SalesInvHeader."Cust. Ledger Entry No.";
                                end;
                            end else begin
                                if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then begin
                                    SalesCreHeader.Reset;
                                    SalesCreHeader.SetRange("Pre-Assigned No.", SalesHeader."No.");
                                    if SalesCreHeader.FindFirst then begin
                                        BillingHeader.Validate("NAV Doc No", SalesCreHeader."No.");
                                        EntryNo := SalesCreHeader."Cust. Ledger Entry No."
                                    end;
                                end;
                            end;
                            BillingHeader.Validate(Status, BillingHeader.Status::"Doc Posted");
                            BillingHeader.Modify(true);
                            BillingLine.Reset();
                            BillingLine.SetRange("NAV Doc No", BillingHeader."NAV Doc No");
                            if BillingLine.FindSet(true) then
                                repeat
                                    BillingLine.Validate(Status, BillingLine.Status::"Doc Posted");
                                    BillingLine.Modify(true);
                                until BillingLine.Next = 0;
                            Customer.Reset;
                            Customer.SetCurrentKey("No.");
                            ReCustLedgEntry.Reset;
                            if Customer.Get(SalesHeader."Sell-to Customer No.") and ReCustLedgEntry.Get(EntryNo) then begin
                                ReCustLedgEntry.Validate("ReThink ID", Customer."ApX ReThink ID");
                                ReCustLedgEntry.Validate("Last Modified - ReThink", CurrentDateTime);
                                ReCustLedgEntry.Modify(true);
                            end;
                        end;
                    end;
                end else
                    if not (Defresult) and not (EmailSent) then begin
                        // SendEmail(SalesRecSetup."ApX Sales Doc Internal Email",
                        //           AppXiteTxt,
                        //           UnpostedSalesDocTxt + SalesHeader."No.",
                        //           FromCompTxt + CompanyName() + ReviewMsg);
                        EmailSent := true;
                    end;
            end until SalesHeader.Next = 0;

    end;

    local procedure UpdateOverdueStatus();
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        ReCustLedgerEntry: Record "ApX ReThink Cust. Ledger Entry";
    begin
        CustLedgerEntry.SetCurrentKey("Entry No.");
        if ReCustLedgerEntry.FindSet(true) then begin
            repeat begin
                if CustLedgerEntry.Get(ReCustLedgerEntry."Entry No.") then begin
                    CustLedgerEntry.CalcFields("Remaining Amount");
                    if (CustLedgerEntry."Remaining Amount" > 0) and (Today > CustLedgerEntry."Due Date") then begin
                        ReCustLedgerEntry.Validate(Status, ReCustLedgerEntry.Status::Overdue);
                        ReCustLedgerEntry.Validate("Check For Overdue", false);
                        ReCustLedgerEntry.Modify(true);
                    end;
                end;
            end until ReCustLedgerEntry.Next = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', false, false)]
    local procedure OnBeforePostSalesDoc_80_(var SalesHeader: Record "Sales Header")
    var
        SalesRecSetup: Record "Sales & Receivables Setup";
    begin
        if not UpdateDeferral(SalesHeader."Document Type", SalesHeader."No.") then begin
            SalesRecSetup.Get;
            // SendEmail(SalesRecSetup."ApX Sales Doc Internal Email",
            //           AppXiteTxt,
            //           UnpostedSalesDocTxt + SalesHeader."No.",
            //           FromCompTxt + CompanyName() + ReviewMsg);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    procedure OnAfterPostSalesDoc_80_(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20])
    var
        BillingHeader: Record "ApX ReThink Billing Header";
        BillingHeaderCp: Record "ApX ReThink Billing Header";
        Customer: Record Customer;
        ReCustLedgEntry: Record "ApX ReThink Cust. Ledger Entry";
        SalesCreHeader: Record "Sales Cr.Memo Header";
        SalesInvHeader: Record "Sales Invoice Header";
        EntryNo: Integer;
        BillingLine: Record "ApX ReThink Billing Line";
    begin
        BillingHeaderCp.Reset;
        BillingHeaderCp.SetRange("NAV Doc No", SalesHeader."No.");
        BillingHeaderCp.SetRange(Status, BillingHeader.Status::"Doc Created");
        if BillingHeaderCp.FindFirst then begin
            if BillingHeader.Get(BillingHeaderCp.invoicesId, BillingHeaderCp.invoicesNumber) then begin
                if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then begin
                    SalesInvHeader.Reset;
                    SalesInvHeader.SetRange("Pre-Assigned No.", SalesHeader."No.");
                    if SalesInvHeader.FindFirst then begin
                        BillingHeader.Validate("NAV Doc No", SalesInvHeader."No.");
                        EntryNo := SalesInvHeader."Cust. Ledger Entry No.";
                    end;

                end else begin
                    if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then begin
                        SalesCreHeader.Reset;
                        SalesCreHeader.SetRange("Pre-Assigned No.", SalesHeader."No.");
                        if SalesCreHeader.FindFirst then begin
                            BillingHeader.Validate("NAV Doc No", SalesCreHeader."No.");
                            EntryNo := SalesCreHeader."Cust. Ledger Entry No.";
                        end;
                    end;
                end;
                BillingHeader.Validate(Status, BillingHeader.Status::"Doc Posted");
                BillingHeader.Modify(true);
                BillingLine.Reset();
                BillingLine.SetRange("NAV Doc No", BillingHeader."NAV Doc No");
                if BillingLine.FindSet(true) then
                    repeat
                        BillingLine.Validate(Status, BillingLine.Status::"Doc Posted");
                        BillingLine.Modify(true);
                    until BillingLine.Next = 0;
                Customer.Reset;
                Customer.SetCurrentKey("No.");
                ReCustLedgEntry.Reset;
                if Customer.Get(SalesHeader."Sell-to Customer No.") and ReCustLedgEntry.Get(EntryNo) then begin
                    ReCustLedgEntry.Validate("ReThink ID", Customer."ApX ReThink ID");
                    ReCustLedgEntry.Validate("Last Modified - ReThink", CurrentDateTime);
                    ReCustLedgEntry.Modify(true);
                end;
            end;
        end;
    end;

    local procedure UpdateDeferral(docType: Enum "Sales Document Type"/*Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order"*/; salesHeadNo: Code[20]) result: Boolean
    var
        ReThinkBillingHeader: Record "ApX ReThink Billing Header";
        ReThinkBillingLine: Record "ApX ReThink Billing Line";
        ReThinkDeferralTemplate: Record "ApX ReThink Deferral Template";
        SalesLine: Record "Sales Line";
        TermDays: Integer;
        DaysDiff: Integer;
        Branch: Integer;
        LineNo: Integer;
        Months: Integer;
        Precission: Integer;
    begin
        result := false;
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", docType);
        SalesLine.SetRange("Document No.", salesHeadNo);
        if SalesLine.FindSet(true) then
            repeat
                LineNo := SalesLine."Line No.";
                ReThinkBillingLine.Reset;
                ReThinkBillingLine.SetRange(rowId, SalesLine."ApX Billing Line Row Id");
                if ReThinkBillingLine.FindFirst() then begin
                    DaysDiff := DT2Date(ReThinkBillingLine."charge end date") - DT2Date(ReThinkBillingLine."charge start date");
                    //Evaluate(DaysDiff, Format(DT2Date(ReThinkBillingLine."charge end date") - DT2Date(ReThinkBillingLine."charge start date")));
                    if (DaysDiff > 0) then begin
                        ReThinkBillingHeader.Reset;
                        if ReThinkBillingHeader.Get(ReThinkBillingLine.invoicesId, ReThinkBillingLine.invoicesNumber) then begin
                            TermDays := DT2Date(ReThinkBillingLine."charge end date") - DT2Date(ReThinkBillingHeader.invoicesDate);
                            //Evaluate(TermDays, FORMAt(DT2Date(ReThinkBillingLine."charge end date") - DT2Date(ReThinkBillingHeader.invoicesDate)));
                            if (DaysDiff > 31) and (TermDays > 31) then Begin
                                if ReThinkDeferralTemplate.FindSet() then
                                    repeat
                                        Months := Round(ReThinkDeferralTemplate."Day To" / 30, 1);
                                        Precission := Round(SalesLine."Line Amount" / Months, 1);
                                        if Precission <> 0 then begin
                                            if (Date2DMY(DT2Date(ReThinkBillingLine."charge start date"), 2) = Date2DMY(DT2Date(ReThinkBillingHeader.invoicesDate), 2)) or
                                                (CALCDATE('<-CM>', DT2Date(ReThinkBillingHeader.invoicesDate)) - DT2Date(ReThinkBillingLine."charge start date") <= 7) then begin
                                                if (DaysDiff >= ReThinkDeferralTemplate."Day From") and (DaysDiff <= ReThinkDeferralTemplate."Day To") then begin
                                                    SalesLine.Validate("Deferral Code", ReThinkDeferralTemplate."Deferral Template Code");
                                                    SalesLine.Modify(true);
                                                    result := true;
                                                end;
                                            end else begin
                                                if (TermDays >= ReThinkDeferralTemplate."Day From") and (TermDays <= ReThinkDeferralTemplate."Day To") then begin
                                                    SalesLine.Validate("Deferral Code", ReThinkDeferralTemplate."Deferral Template Code");
                                                    SalesLine.Modify(true);
                                                    result := true;
                                                end;
                                            end;
                                        end;
                                    until ReThinkDeferralTemplate.Next = 0;
                            end else
                                if (DaysDiff <= 31) OR (TermDays < 0) then
                                    result := true
                                else
                                    result := false;
                        end else
                            result := false;
                    end else
                        result := false;
                end else
                    result := false;
            until SalesLine.Next = 0;
    end;

    // local procedure SendEmail(SendToEmail: Text[250]; FromName: Text[100]; SubjectText: Text[250]; BodyText: Text[500]);
    // var
    //     TempEmailItem: Record "Email Item" temporary;
    // begin
    //     with TempEmailItem do begin
    //         if SendToEmail <> '' then begin
    //             Validate("Send to", SendToEmail);
    //             Validate("From Name", FromName);
    //             Validate(Subject, SubjectText);
    //             VALIDATE("Plaintext Formatted", true);
    //             SetBodyText(BodyText);
    //             Send(true);
    //         end else
    //             Error(NoEmailErr);
    //     end;
    // end;

    var
        ReviewMsg: Label '" - There are some sales documents which have not been posted because the system could not find any matching deferral templates for them.  Please review them and assigned a deferral template, if applicable.';
        NoEmailErr: Label 'Email Address Not found in Sales & Receivables Setup';
        UnpostedSalesDocTxt: Label 'Unposted Sales Documents';
        AppXiteTxt: Label 'AppXite';
        PostingDoneMsg: Label 'Posting Done.';
        FromCompTxt: Label 'From Company: "';
}
