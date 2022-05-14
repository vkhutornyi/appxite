codeunit 70155326 "ApX Email Sales Documents"
{
    var
        ProgressWindow: Dialog;
        InvoiceReportID: Integer;
        CrMemoReportID: Integer;
        ReminderReportID: Integer;
        FinMemoReportID: Integer;
        InvoiceLayoutCode: Code[20];
        CrMemoLayoutCode: Code[20];
        ReminderLayoutCode: Code[20];
        FinMemoLayoutCode: Code[20];
        TextProcessCompleted: Label 'Process Completed';

    trigger OnRun();
    begin
        InvoiceReportID := 1306;
        InvoiceLayoutCode := '1306-000002';
        CrMemoReportID := 1307;
        CrMemoLayoutCode := '1307-000001';
        ReminderReportID := 117;
        ReminderLayoutCode := '117-000001';
        FinMemoReportID := 118;
        FinMemoLayoutCode := '118-000001';
        ProcessPostedInvoice();
        ProcessPostedCreditMemo();
        ProcessIssuedReminders();
        ProcessIssuedFinanceChargeMemos();
        ProcessNotSentEmails();
        Message(TextProcessCompleted);
    end;

    procedure ProcessPostedInvoice();
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvHeaderFilter: Record "Sales Invoice Header";
        CustomReportSelection: Record "Custom Report Selection";
        EmailLogLine: Record "ApX Email Log Line";
        ReportLayoutSelection: Record "Report Layout Selection";
        ReportSelections: Record "Report Selections";
        HeaderNo: Integer;
        LineNo: Integer;
        ReportID: Integer;
        Text000: Label 'Processing Invoice #1\ out of #2\';
        Text001: Label 'Invoice Number #3#######';
        RecordIndex: Integer;

    begin
        // SalesInvoiceHeader.SetRange("Sell-to Customer No.", '003462');
        SalesInvoiceHeader.SetRange("Posting Date", CalcDate('<-6D>', Today), Today);
        SalesInvoiceHeader.SetFilter("Sell-to Customer No.", '<>%1', '');
        if SalesInvoiceHeader.FindFirst() then begin
            repeat begin
                EmailLogLine.SetRange("Doc Type", EmailLogLine."Doc Type"::"Sales Inv");
                EmailLogLine.SetRange("Document No.", SalesInvoiceHeader."No.");
                If Not EmailLogLine.FindFirst then begin
                    if HeaderNo = 0 then begin
                        ProgressWindow.Open(Text000 + Text001);
                        RecordIndex := 1;
                        ProgressWindow.Update(1, RecordIndex);
                        ProgressWindow.Update(2, SalesInvoiceHeader.Count());

                        ReportID := InvoiceReportID;
                        ReportSelections.SetRange(Usage, ReportSelections.Usage::"S.Invoice");
                        if ReportSelections.FindFirst then
                            ReportID := ReportSelections."Report ID";

                        ReportLayoutSelection.SetTempLayoutSelected(InvoiceLayoutCode);
                        SalesInvHeaderFilter.SetRange("No.", SalesInvoiceHeader."No.");
                        SalesInvHeaderFilter.FindFirst();
                        ReportLayoutSelection.SetTempLayoutSelected('');
                        HeaderNo := AddEmailLogHeader(EmailLogLine."Doc Type"::"Sales Inv");
                    end;
                    ProgressWindow.Update(1, RecordIndex);
                    ProgressWindow.Update(3, SalesInvoiceHeader."No.");
                    RecordIndex += 1;
                    LineNo := AddEmailLogLine(HeaderNo, SalesInvoiceHeader."No.", EmailLogLine."Doc Type"::"Sales Inv", SalesInvoiceHeader."Sell-to Customer Name");

                    CustomReportSelection.Reset();
                    CustomReportSelection.SetRange("Source Type", 18);
                    CustomReportSelection.SetRange("Source No.", SalesInvoiceHeader."Sell-to Customer No.");
                    if CustomReportSelection.FindFirst then begin
                        ReportLayoutSelection.SetTempLayoutSelected(CustomReportSelection."Custom Report Layout Code");
                        ReportID := CustomReportSelection."Report ID";
                    end else begin
                        ReportSelections.Reset();
                        ReportSelections.SetRange(Usage, ReportSelections.Usage::"S.Invoice");
                        if ReportSelections.FindFirst then begin
                            ReportLayoutSelection.SetTempLayoutSelected(ReportSelections."Custom Report Layout Code"); //Ask AH if use email or custom layout code
                            ReportID := ReportSelections."Report ID";
                        end;
                    end;

                    ReportLayoutSelection.SetTempLayoutSelected('');

                end;
            end until SalesInvoiceHeader.Next = 0;
            if HeaderNo <> 0 then begin
                UpdateProcessEndInEmailLogHeader(HeaderNo);
                ProgressWindow.Close();
            end;
        end;
    end;

    local procedure ProcessPostedCreditMemo();
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoHeaderFilter: Record "Sales Cr.Memo Header";
        CustomReportSelection: Record "Custom Report Selection";
        EmailLogLine: Record "ApX Email Log Line";
        ReportLayoutSelection: Record "Report Layout Selection";
        ReportSelections: Record "Report Selections";
        HeaderNo: Integer;
        LineNo: Integer;
        ReportID: Integer;
        Text000: Label 'Processing Cr.Memo #1\ out of #2\';
        Text001: Label 'Cr.Memo Number #3#######';
        RecordIndex: Integer;
    begin
        SalesCrMemoHeader.SetRange("Posting Date", CalcDate('<-6D>', Today), Today);
        SalesCrMemoHeader.SetFilter("Sell-to Customer No.", '<>%1', '');
        if SalesCrMemoHeader.FindFirst then begin
            repeat begin
                EmailLogLine.SetRange("Doc Type", EmailLogLine."Doc Type"::"Sales Cr");
                EmailLogLine.SetRange("Document No.", SalesCrMemoHeader."No.");
                If Not EmailLogLine.FindFirst then begin
                    if HeaderNo = 0 then begin
                        ProgressWindow.Open(Text000 + Text001);
                        RecordIndex := 1;
                        ProgressWindow.Update(1, RecordIndex);
                        ProgressWindow.Update(2, SalesCrMemoHeader.Count());

                        ReportID := CrMemoReportID;
                        ReportSelections.SetRange(Usage, ReportSelections.Usage::"S.Cr.Memo");
                        if ReportSelections.FindFirst then
                            ReportID := ReportSelections."Report ID";

                        ReportLayoutSelection.SetTempLayoutSelected(CrMemoLayoutCode);
                        SalesCrMemoHeaderFilter.SetRange("No.", SalesCrMemoHeader."No.");
                        SalesCrMemoHeaderFilter.FindFirst();
                        ReportLayoutSelection.SetTempLayoutSelected('');
                        HeaderNo := AddEmailLogHeader(EmailLogLine."Doc Type"::"Sales Cr");
                    end;
                    ProgressWindow.Update(1, RecordIndex);
                    ProgressWindow.Update(3, SalesCrMemoHeader."No.");
                    RecordIndex += 1;
                    LineNo := AddEmailLogLine(HeaderNo, SalesCrMemoHeader."No.", EmailLogLine."Doc Type"::"Sales Cr", SalesCrMemoHeader."Sell-to Customer Name");
                    CustomReportSelection.Reset();
                    CustomReportSelection.SetRange("Source Type", 18);
                    CustomReportSelection.SetRange("Source No.", SalesCrMemoHeader."Sell-to Customer No.");
                    if CustomReportSelection.FindFirst then begin
                        ReportLayoutSelection.SetTempLayoutSelected(CustomReportSelection."Custom Report Layout Code");
                        ReportID := CustomReportSelection."Report ID";
                    end else begin
                        ReportSelections.Reset();
                        ReportSelections.SetRange(Usage, ReportSelections.Usage::"S.Cr.Memo");
                        if ReportSelections.FindFirst then begin
                            ReportLayoutSelection.SetTempLayoutSelected(ReportSelections."Custom Report Layout Code"); //Ask AH if use email or custom layout code
                            ReportID := ReportSelections."Report ID";
                        end;
                    end;
                    ReportLayoutSelection.SetTempLayoutSelected('');

                end;
            end until SalesCrMemoHeader.Next = 0;
            if HeaderNo <> 0 then begin
                UpdateProcessEndInEmailLogHeader(HeaderNo);
                ProgressWindow.Close();
            end;
        end;
    end;

    local procedure ProcessIssuedReminders();
    var
        IssuedReminderHeader: Record "Issued Reminder Header";
        IssuedReminderHeaderFilter: Record "Issued Reminder Header";
        EmailLogLine: Record "ApX Email Log Line";
        CustomReportSelection: Record "Custom Report Selection";
        ReportSelections: Record "Report Selections";
        ReportLayoutSelection: Record "Report Layout Selection";
        HeaderNo: Integer;
        LineNo: Integer;
        EmailSent: Boolean;
        ReportID: Integer;
        SendEmailTo: Text[200];
        Text000: Label 'Processing Reminder #1\ out of #2\';
        Text001: Label 'Reminder Number #3#######';
        RecordIndex: Integer;
    begin
        IssuedReminderHeader.SetRange("Posting Date", CalcDate('<-6D>', Today), Today);
        IssuedReminderHeader.SetFilter("Customer No.", '<>%1', '');
        if IssuedReminderHeader.FindFirst then begin
            repeat begin
                EmailLogLine.SetRange("Doc Type", EmailLogLine."Doc Type"::Reminder);
                EmailLogLine.SetRange("Document No.", IssuedReminderHeader."No.");
                If Not EmailLogLine.FindFirst then begin
                    if HeaderNo = 0 then begin
                        ProgressWindow.Open(Text000 + Text001);
                        RecordIndex := 1;
                        ProgressWindow.Update(1, RecordIndex);
                        ProgressWindow.Update(2, IssuedReminderHeader.Count());

                        ReportID := ReminderReportID;
                        ReportSelections.SetRange(Usage, ReportSelections.Usage::Reminder);
                        if ReportSelections.FindFirst() then
                            ReportID := ReportSelections."Report ID";
                        ReportLayoutSelection.SetTempLayoutSelected(ReminderLayoutCode);
                        IssuedReminderHeaderFilter.SetRange("No.", IssuedReminderHeader."No.");
                        IssuedReminderHeaderFilter.FindFirst();
                        ReportLayoutSelection.SetTempLayoutSelected('');
                        HeaderNo := AddEmailLogHeader(EmailLogLine."Doc Type"::Reminder);
                    end;
                    ProgressWindow.Update(1, RecordIndex);
                    ProgressWindow.Update(3, IssuedReminderHeader."No.");
                    RecordIndex += 1;
                    LineNo := AddEmailLogLine(HeaderNo, IssuedReminderHeader."No.", EmailLogLine."Doc Type"::Reminder, IssuedReminderHeader.Name);

                    CustomReportSelection.Reset();
                    CustomReportSelection.SetRange("Source Type", 18);
                    CustomReportSelection.SetRange("Source No.", IssuedReminderHeader."Customer No.");
                    if CustomReportSelection.FindFirst then
                        SendEmailTo := CustomReportSelection."Send To Email";
                end;
            end until IssuedReminderHeader.Next = 0;
            if HeaderNo <> 0 then begin
                UpdateProcessEndInEmailLogHeader(HeaderNo);
                ProgressWindow.Close();
            end;
        end;
    end;

    local procedure ProcessIssuedFinanceChargeMemos();
    var
        IssuedFinChargeMemoHeader: Record "Issued Fin. Charge Memo Header";
        IssuedFinChargeMemoHeaderFilter: Record "Issued Fin. Charge Memo Header";
        EmailLogLine: Record "ApX Email Log Line";
        CustomReportSelection: Record "Custom Report Selection";
        ReportSelections: Record "Report Selections";
        ReportLayoutSelection: Record "Report Layout Selection";
        HeaderNo: Integer;
        LineNo: Integer;
        EmailSent: Boolean;
        ReportID: Integer;
        SendEmailTo: Text[200];
        Text000: Label 'Processing Finance Memo #1\ out of #2\';
        Text001: Label 'Finance Memo Number #3#######';
        RecordIndex: Integer;
    begin
        IssuedFinChargeMemoHeader.SetRange("Posting Date", CalcDate('<-6D>', Today), Today);
        IssuedFinChargeMemoHeader.SetFilter("Customer No.", '<>%1', '');
        if IssuedFinChargeMemoHeader.FindFirst then begin
            repeat begin
                EmailLogLine.SetRange("Doc Type", EmailLogLine."Doc Type"::"Fin Charge");
                EmailLogLine.SetRange("Document No.", IssuedFinChargeMemoHeader."No.");
                If Not EmailLogLine.FindFirst then begin
                    if HeaderNo = 0 then begin
                        ProgressWindow.Open(Text000 + Text001);
                        RecordIndex := 1;
                        ProgressWindow.Update(1, RecordIndex);
                        ProgressWindow.Update(2, IssuedFinChargeMemoHeader.Count());


                        ReportID := FinMemoReportID;
                        ReportSelections.SetRange(Usage, ReportSelections.Usage::"Fin.Charge");
                        if ReportSelections.FindFirst then
                            ReportID := ReportSelections."Report ID";

                        ReportLayoutSelection.SetTempLayoutSelected(FinMemoLayoutCode);

                        IssuedFinChargeMemoHeaderFilter.SetRange("No.", IssuedFinChargeMemoHeader."No.");
                        IssuedFinChargeMemoHeaderFilter.FindFirst();
                        ReportLayoutSelection.SetTempLayoutSelected('');
                        HeaderNo := AddEmailLogHeader(EmailLogLine."Doc Type"::"Fin Charge");
                    end;
                    ProgressWindow.Update(1, RecordIndex);
                    ProgressWindow.Update(3, IssuedFinChargeMemoHeader."No.");
                    RecordIndex += 1;
                    LineNo := AddEmailLogLine(HeaderNo, IssuedFinChargeMemoHeader."No.", EmailLogLine."Doc Type"::"Fin Charge", IssuedFinChargeMemoHeader.Name);

                    CustomReportSelection.Reset();
                    CustomReportSelection.SetRange("Source Type", 18);
                    CustomReportSelection.SetRange("Source No.", IssuedFinChargeMemoHeader."Customer No.");
                    if CustomReportSelection.FindFirst then
                        SendEmailTo := CustomReportSelection."Send To Email";

                end;
            end until IssuedFinChargeMemoHeader.Next = 0;
            if HeaderNo <> 0 then begin
                UpdateProcessEndInEmailLogHeader(HeaderNo);
                ProgressWindow.Close();
            end;
        end;
    end;

    local procedure ProcessNotSentEmails()
    var
        EmailLogLine: Record "ApX Email Log Line";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        IssuedReminderHeader: Record "Issued Reminder Header";
        IssuedFinChargeMemoHeader: Record "Issued Fin. Charge Memo Header";
        CustomReportSelection: Record "Custom Report Selection";
        ReportLayoutSelection: Record "Report Layout Selection";
        ReportSelections: Record "Report Selections";
        Customer: Record Customer;
        CustomerNo: Code[20];
        ReportID: Integer;
        EmailSent: Boolean;
        Text000: Label 'Processing unsent emails for #4\ #1\ out of #2\';
        Text001: Label 'Document Number #3#######';
        RecordIndex: Integer;
        SendToEmail: List of [Text];
        PostingDate: Date;
        DocTypeText: Text[30];
    begin
        EmailLogLine.SetRange("Email Sent", false);
        If EmailLogLine.FindFirst() then begin
            ProgressWindow.Open(Text000 + Text001);
            RecordIndex := 1;
            ProgressWindow.Update(1, RecordIndex);
            ProgressWindow.Update(2, EmailLogLine.Count());
            ProgressWindow.Update(4, EmailLogLine."Doc Type");

            if EmailLogLine."Doc Type" = EmailLogLine."Doc Type"::"Sales Inv" then begin
                ReportID := InvoiceReportID;
                ReportSelections.SetRange(Usage, ReportSelections.Usage::"S.Invoice");
                ReportLayoutSelection.SetTempLayoutSelected(InvoiceLayoutCode);
                SalesInvoiceHeader.SetRange("No.", EmailLogLine."Document No.");
                SalesInvoiceHeader.FindFirst();
                if ReportSelections.FindFirst then
                    ReportID := ReportSelections."Report ID";

                DocTypeText := 'Sales Invoice ';
            end else
                if EmailLogLine."Doc Type" = EmailLogLine."Doc Type"::"Sales Cr" then begin
                    ReportID := CrMemoReportID;
                    ReportSelections.SetRange(Usage, ReportSelections.Usage::"S.Cr.Memo");
                    ReportLayoutSelection.SetTempLayoutSelected(CrMemoLayoutCode);
                    SalesCrMemoHeader.SetRange("No.", EmailLogLine."Document No.");
                    SalesCrMemoHeader.FindFirst();
                    if ReportSelections.FindFirst then
                        ReportID := ReportSelections."Report ID";
                    DocTypeText := 'Sales Credit Memo ';
                end else
                    if EmailLogLine."Doc Type" = EmailLogLine."Doc Type"::Reminder then begin
                        ReportID := ReminderReportID;
                        ReportSelections.SetRange(Usage, ReportSelections.Usage::Reminder);
                        ReportLayoutSelection.SetTempLayoutSelected(ReminderLayoutCode);
                        IssuedReminderHeader.SetRange("No.", EmailLogLine."Document No.");
                        IssuedReminderHeader.FindFirst();
                        if ReportSelections.FindFirst then
                            ReportID := ReportSelections."Report ID";

                        DocTypeText := 'Issued Reminder ';
                    end else
                        if EmailLogLine."Doc Type" = EmailLogLine."Doc Type"::"Fin Charge" then begin
                            ReportID := FinMemoReportID;
                            ReportSelections.SetRange(Usage, ReportSelections.Usage::"Fin.Charge");
                            ReportLayoutSelection.SetTempLayoutSelected(FinMemoLayoutCode);
                            IssuedFinChargeMemoHeader.SetRange("No.", EmailLogLine."Document No.");
                            IssuedFinChargeMemoHeader.FindFirst();
                            if ReportSelections.FindFirst then
                                ReportID := ReportSelections."Report ID";

                            DocTypeText := 'Issued Finance Charge Memo ';
                        end;
            ReportLayoutSelection.SetTempLayoutSelected('');

            repeat begin
                Clear(SendToEmail);
                ProgressWindow.Update(1, RecordIndex);
                ProgressWindow.Update(3, EmailLogLine."Document No.");
                RecordIndex += 1;

                CustomReportSelection.Reset();
                CustomReportSelection.SetRange("Source Type", 18);


                if EmailLogLine."Doc Type" = EmailLogLine."Doc Type"::"Sales Inv" then begin
                    SalesInvoiceHeader.SetRange("No.", EmailLogLine."Document No.");
                    SalesInvoiceHeader.FindFirst();
                    CustomerNo := SalesInvoiceHeader."Sell-to Customer No.";
                    PostingDate := SalesInvoiceHeader."Posting Date";

                    CustomReportSelection.SetRange("Source No.", CustomerNo);
                    if CustomReportSelection.FindFirst then begin
                        ReportLayoutSelection.SetTempLayoutSelected(CustomReportSelection."Custom Report Layout Code");
                        ReportID := CustomReportSelection."Report ID";
                        SendToEmail.Add(CustomReportSelection."Send To Email");
                    end else begin
                        ReportSelections.Reset();
                        ReportSelections.SetRange(Usage, ReportSelections.Usage::"S.Invoice");
                        if ReportSelections.FindFirst then begin
                            ReportLayoutSelection.SetTempLayoutSelected(ReportSelections."Custom Report Layout Code"); //Ask AH if use email or custom layout code
                            ReportID := ReportSelections."Report ID";
                        end;
                    end;



                end else
                    if EmailLogLine."Doc Type" = EmailLogLine."Doc Type"::"Sales Cr" then begin
                        SalesCrMemoHeader.SetRange("No.", EmailLogLine."Document No.");
                        SalesCrMemoHeader.FindFirst();
                        CustomerNo := SalesCrMemoHeader."Sell-to Customer No.";
                        PostingDate := SalesCrMemoHeader."Posting Date";
                        CustomReportSelection.SetRange("Source No.", CustomerNo);
                        if CustomReportSelection.FindFirst then begin
                            ReportLayoutSelection.SetTempLayoutSelected(CustomReportSelection."Custom Report Layout Code");
                            ReportID := CustomReportSelection."Report ID";
                            SendToEmail.Add(CustomReportSelection."Send To Email");
                        end else begin
                            ReportSelections.Reset();
                            ReportSelections.SetRange(Usage, ReportSelections.Usage::"S.Cr.Memo");
                            if ReportSelections.FindFirst then begin
                                ReportLayoutSelection.SetTempLayoutSelected(ReportSelections."Custom Report Layout Code"); //Ask AH if use email or custom layout code
                                ReportID := ReportSelections."Report ID";
                            end;
                        end;


                    end else
                        if EmailLogLine."Doc Type" = EmailLogLine."Doc Type"::Reminder then begin
                            IssuedReminderHeader.SetRange("No.", EmailLogLine."Document No.");
                            IssuedReminderHeader.FindFirst();
                            CustomerNo := IssuedReminderHeader."Customer No.";
                            PostingDate := IssuedReminderHeader."Posting Date";
                            CustomReportSelection.SetRange("Source No.", CustomerNo);
                            ReportID := ReminderReportID;
                            CustomReportSelection.Reset();
                            CustomReportSelection.SetRange("Source Type", 18);
                            CustomReportSelection.SetRange("Source No.", IssuedReminderHeader."Customer No.");
                            if CustomReportSelection.FindFirst then
                                SendToEmail.Add(CustomReportSelection."Send To Email");

                        end else
                            if EmailLogLine."Doc Type" = EmailLogLine."Doc Type"::"Fin Charge" then begin
                                IssuedFinChargeMemoHeader.SetRange("No.", EmailLogLine."Document No.");
                                IssuedFinChargeMemoHeader.FindFirst();
                                CustomerNo := IssuedFinChargeMemoHeader."Customer No.";
                                PostingDate := IssuedFinChargeMemoHeader."Posting Date";
                                CustomReportSelection.SetRange("Source No.", CustomerNo);
                                ReportID := FinMemoReportID;
                                CustomReportSelection.Reset();
                                CustomReportSelection.SetRange("Source Type", 18);
                                CustomReportSelection.SetRange("Source No.", IssuedFinChargeMemoHeader."Customer No.");
                                if CustomReportSelection.FindFirst then
                                    SendToEmail.Add(CustomReportSelection."Send To Email");


                            end;
                ReportLayoutSelection.SetTempLayoutSelected('');

                IF SendToEmail.Count = 0 then
                    IF Customer.Get(CustomerNo) then
                        SendToEmail.Add(Customer."E-Mail");

                PrepareAndSendEmail(ReportID, EmailLogLine, SendToEmail, PostingDate, DocTypeText);

            end until EmailLogLine.Next() = 0;
            ProgressWindow.Close();
        end;
    end;

    local procedure AfterEmailSentUpdateData(HeaderNo: Integer; LineNo: Integer; RecordNo: Code[20]; PostingDate: Date; TempAttachment: Record Attachment)
    begin
        UpdateEmailSentInEmailLogLine(LineNo, HeaderNo);

        UpdateStatusRethinkCustLedgEntry(RecordNo, PostingDate);

        AddSalesDocPDFFile(RecordNo, TempAttachment);
    end;

    local procedure AddEmailLogHeader(DocType: Option "Sales Inv","Sales Cr",Reminder,"Fin Charge"): Integer;
    var
        EmailLogHeader: Record "ApX Email Log Header";
        No: Integer;
    begin
        No := 10;
        if EmailLogHeader.FindLast then
            No += EmailLogHeader."No.";

        EmailLogHeader.Reset;
        EmailLogHeader.Init;
        EmailLogHeader.Validate("No.", No);
        EmailLogHeader.Validate("Doc Type", DocType);
        EmailLogHeader.Validate("Process Start Date Time", CurrentDateTime);
        EmailLogHeader.Insert(true);
        exit(No);
    end;

    local procedure AddEmailLogLine(EmailLogHeaderNo: Integer; DocumentNo: Code[20]; DocType: Option "Sales Inv","Sales Cr",Reminder,"Fin Charge"; CustomerName: Text[250]): Integer;
    var
        EmailLogLine: Record "ApX Email Log Line";
        No: Integer;
    begin
        No := 10;
        If EmailLogLine.FindLast then
            No += EmailLogLine."No.";

        EmailLogLine.Reset;
        EmailLogLine.Init;
        EmailLogLine.Validate("No.", No);
        EmailLogLine.Validate("Email Log Header No.", EmailLogHeaderNo);
        EmailLogLine.Validate("Document No.", DocumentNo);
        EmailLogLine.Validate("Doc Type", DocType);
        EmailLogLine.Validate("Email Sent", false);
        EmailLogLine.Validate("Customer Name", CustomerName);
        EmailLogLine.Insert(true);
        exit(No);
    end;

    local procedure SendEmail(SendToEmail: List of [Text]; HtmlBody: Text[250];
    SubjectIn: Text[250]; AttachmentName: Text[250]; EmailInSteam: InStream): Boolean;
    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        ToRecipients, ToRecipient : Text;
    begin
        foreach ToRecipient in SendToEmail do begin
            ToRecipients += StrSubstNo('%1;', ToRecipient);
        end;
        EmailMessage.Create(ToRecipients, SubjectIn, HtmlBody);
        EmailMessage.AddAttachment(AttachmentName, 'application/pdf', EmailInSteam);
        exit(Email.Send(EmailMessage));
    end;

    local procedure UpdateStatusRethinkCustLedgEntry(HeaderNo: Text[20]; PostingDate: Date);
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        ReThinkCustLedgerEntry: Record "ApX ReThink Cust. Ledger Entry";
    begin
        CustLedgerEntry.SetRange("Document No.", HeaderNo);
        CustLedgerEntry.SetRange("Posting Date", PostingDate);
        if CustLedgerEntry.FindFirst then
            if ReThinkCustLedgerEntry.Get(CustLedgerEntry."Entry No.") then begin
                ReThinkCustLedgerEntry.Validate(Status, ReThinkCustLedgerEntry.Status::Sent);
                ReThinkCustLedgerEntry.Validate("Last Modified - ReThink", CurrentDateTime);
                ReThinkCustLedgerEntry.Modify(true);
            end;
    end;

    local procedure AddSalesDocPDFFile(HeaderNo: Text[20]; TempAttachment: Record Attachment);
    var
        SalesDocPDFFile: Record "ApX Sales Doc PDF File";
        ReThinkBillingHeader: Record "ApX ReThink Billing Header";
    begin
        ReThinkBillingHeader.SetRange("NAV Doc No", HeaderNo);
        if ReThinkBillingHeader.FindFirst then begin
            SalesDocPDFFile.Init;
            SalesDocPDFFile."Document PDF" := TempAttachment."Email Message Url";
            SalesDocPDFFile.Validate(invoicesId, ReThinkBillingHeader.invoicesId);
            SalesDocPDFFile.Validate(invoicesNumber, ReThinkBillingHeader.invoicesNumber);
            SalesDocPDFFile.Validate(invoiceProviderId, ReThinkBillingHeader.invoiceProviderId);
            SalesDocPDFFile.Validate(invoiceReceiverId, ReThinkBillingHeader.invoiceReceiverId);
            SalesDocPDFFile.Validate("NAV Document No.", ReThinkBillingHeader."NAV Doc No");
            SalesDocPDFFile.Insert(true);
        end;
    end;

    local procedure UpdateProcessEndInEmailLogHeader(HeaderNo: Integer);
    var
        EmailLogHeader: Record "ApX Email Log Header";
    begin
        if EmailLogHeader.Get(HeaderNo) then begin
            EmailLogHeader.Validate("Process End Date Time", CurrentDateTime);
            EmailLogHeader.Modify(true);
        end;
    end;

    local procedure UpdateEmailSentInEmailLogLine(LineNo: Integer; HeaderNo: Integer);
    var
        EmailLogLine: Record "ApX Email Log Line";
    begin
        if EmailLogLine.Get(LineNo, HeaderNo) then begin
            EmailLogLine.Validate("Email Sent", true);
            EmailLogLine.Modify(true);
        end;
    end;

    local procedure NotRestricted(Email: Text[80]): Boolean;
    var
        EmailDomain: array[2] of Text[50];
        str: Text[50];
    begin
        EmailDomain[1] := '@CIELLOS.COM';
        EmailDomain[2] := '@APPXITE.COM';
        if Email <> '' then
            str := COPYSTR(Email, StrPos(Email, '@'));
        if (UPPERCASE(str) = EmailDomain[1]) OR (UPPERCASE(str) = EmailDomain[2]) THEN
            exit(true)
        else
            exit(false);
    end;

    Local procedure PrepareAndSendEmail(ReportId: Integer; EmailLogLine: Record "ApX Email Log Line"; SendToEmail: List of [Text]; PostingDate: Date; DocTypeText: Text[30]);
    var
        DataItemName: Text;
        FieldId: Integer;
        EmailInStream: InStream;
        EmailOutStream: OutStream;
        HtmlBodyText: Text;
        XmlParametr: Text;
        XmlParametrTemplate: Label '<?xml version="1.0" standalone="yes"?><ReportParameters id="%1"><Options><Field name="NoCopies">0</Field></Options><DataItems><DataItem name="%2">VERSION(1) SORTING(Field%4) WHERE(Field%4=1(%3))</DataItem></DataItems></ReportParameters>';
        HtmlBodyTemplate: Label '<html><body><p>Hello&nbsp;%1,</p><p>Attached is the %2 %3.</p><p>Regards,</p><p>AppXite</p></body></html>';
        TempAttachment: Record Attachment temporary;
    begin

        Case EmailLogLine."Doc Type" of
            EmailLogLine."Doc Type"::"Sales Inv":
                begin
                    DataItemName := 'Sales Invoice Header';
                    FieldId := 3;
                end;
            EmailLogLine."Doc Type"::"Sales Cr":
                begin
                    DataItemName := 'Sales Cr.Memo Header';
                    FieldId := 3;
                end;
            EmailLogLine."Doc Type"::"Fin Charge":
                begin
                    DataItemName := 'Issued Fin. Charge Memo Header';
                    FieldId := 1;
                end;
            EmailLogLine."Doc Type"::Reminder:
                begin
                    DataItemName := 'Issued Reminder Header';
                    FieldId := 1;
                end;
        end;
        XmlParametr := STRSUBSTNO(XmlParametrTemplate, ReportID, DataItemName, EmailLogLine."Document No.", FieldId);
        HtmlBodyText := StrSubstNo(HtmlBodyTemplate, EmailLogLine."Customer Name", EmailLogLine."Doc Type", EmailLogLine."Document No.");

        TempAttachment."Email Message Url".CreateOutStream(EmailOutStream, TextEncoding::UTF8);
        TempAttachment."Email Message Url".CreateInStream(EmailInStream, TextEncoding::UTF8);

        Report.SaveAs(ReportID, XmlParametr, ReportFormat::Pdf, EmailOutStream);

        if SendEmail(SendToEmail, HtmlBodyText
           , DocTypeText + 'Number ' + EmailLogLine."Document No.", DocTypeText + EmailLogLine."Document No." + '.Pdf', EmailInStream)
            then
            AfterEmailSentUpdateData(EmailLogLine."Email Log Header No.", EmailLogLine."No.", EmailLogLine."Document No.", PostingDate, TempAttachment);
    end;
}