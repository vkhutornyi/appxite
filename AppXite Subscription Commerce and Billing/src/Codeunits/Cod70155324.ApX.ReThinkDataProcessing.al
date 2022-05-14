codeunit 70155324 "ApX ReThink Data Processing"
{
    trigger OnRun();
    var
        BillingHeader: Record "ApX ReThink Billing Header";
        BillingLine: Record "ApX ReThink Billing Line";
    begin
        if GuiAllowed() then
            Message(ProcessingStartMsg);
        Validations();
        if GuiAllowed() then
            Message(ProcessingEndMsg);
    end;

    procedure Validations();
    var
        BillingHeader: Record "ApX ReThink Billing Header";
        BillingLine: Record "ApX ReThink Billing Line";
        Error: Record "ApX ReThink Error";
        Customer: Record Customer;
        Currency: Record Currency;
        Resource: Record Resource;
        hasError: Boolean;
        timeDiff: Time;
    begin
        EVALUATE(timeDiff, FORMAT(TIME - 5000));
        BillingHeader.SetFilter("Status Time Stamp", '<%1', CREATEDATETIME(TODAY, timeDiff));
        BillingHeader.SetFilter(Status, '%1|%2', BillingHeader.Status::New, BillingHeader.Status::Error);
        if BillingHeader.FindFirst then begin
            repeat begin
                hasError := false;
                if BillingHeader.invoicesNumber = 0 then
                    hasError := InsertReThinkError(BillingHeader.invoicesNumber, CreateGuid, Error."Data Type"::Header, Error."Error Type"::"NULL Value", 'invoiceNumber', BillingHeader.invoicesId)
                else
                    if IsNullGuid(BillingHeader.invoiceProviderId) then
                        hasError := InsertReThinkError(BillingHeader.invoicesNumber, CreateGuid, Error."Data Type"::Header, Error."Error Type"::"NULL Value", 'invoiceProviderId', BillingHeader.invoicesId)
                    else
                        if IsNullGuid(BillingHeader.invoiceReceiverId) then
                            hasError := InsertReThinkError(BillingHeader.invoicesNumber, CreateGuid, Error."Data Type"::Header, Error."Error Type"::"NULL Value", 'invoiceReceiverId', BillingHeader.invoicesId)
                        else
                            if BillingHeader.invoicesDate = 0DT then
                                hasError := InsertReThinkError(BillingHeader.invoicesNumber, CreateGuid, Error."Data Type"::Header, Error."Error Type"::"NULL Value", 'invocieDate', BillingHeader.invoicesId)
                            else
                                if BillingHeader.invoiceCurrency = '' then
                                    hasError := InsertReThinkError(BillingHeader.invoicesNumber, CreateGuid, Error."Data Type"::Header, Error."Error Type"::"NULL Value", 'invocieCurrency', BillingHeader.invoicesId)
                                else
                                    if BillingHeader.rateToEuro = 0 then
                                        hasError := InsertReThinkError(BillingHeader.invoicesNumber, CreateGuid, Error."Data Type"::Header, Error."Error Type"::"NULL Value", 'rateToEuro', BillingHeader.invoicesId)
                                    else
                                        if not InvoiceDateStatus(DT2Date(BillingHeader.invoicesDate)) then
                                            hasError := InsertReThinkError(BillingHeader.invoicesNumber, CreateGuid, Error."Data Type"::Header, Error."Error Type"::Invoice, 'invoicesDate', BillingHeader.invoicesId);

                Customer.Reset;
                Customer.SetRange("ApX ReThink ID", BillingHeader.invoiceReceiverId);
                if not Customer.FindFirst then
                    hasError := InsertReThinkError(BillingHeader.invoicesNumber, CreateGuid, Error."Data Type"::Header, Error."Error Type"::Customer, 'invoiceReceiverId : ' + Format(BillingHeader.invoiceReceiverId), BillingHeader.invoicesId);
                if CustomerOnBoardingStatus(BillingHeader.invoiceReceiverId) = false then
                    hasError := InsertReThinkError(BillingHeader.invoicesNumber, CreateGuid, Error."Data Type"::Header, Error."Error Type"::Customer, 'On-BoardingStatus : ' + Format(BillingHeader.invoiceReceiverId), BillingHeader.invoicesId);
                if not Currency.Get(BillingHeader.invoiceCurrency) then
                    hasError := InsertReThinkError(BillingHeader.invoicesNumber, CreateGuid, Error."Data Type"::Header, Error."Error Type"::Customer, 'invoiceCurrency : ' + Format(BillingHeader.invoiceCurrency), BillingHeader.invoicesId);

                BillingLine.Reset;
                BillingLine.SetRange(invoicesId, BillingHeader.invoicesId);
                BillingLine.SetRange(invoicesNumber, BillingHeader.invoicesNumber);
                if BillingLine.FindFirst then begin
                    BillingLine.CalcSums(totalPrice);
                    if BillingHeader.totalPriceCheckSum <> BillingLine.totalPrice then
                        hasError := InsertReThinkError(BillingHeader.invoicesNumber, CreateGuid, Error."Data Type"::Header, Error."Error Type"::Balance, 'totalPriceCheckSum', BillingHeader.invoicesId);
                    repeat begin
                        if BillingLine.invoicesNumber = 0 then
                            hasError := InsertReThinkError(BillingLine.invoicesNumber, BillingLine.rowId, Error."Data Type"::Line, Error."Error Type"::"NULL Value", 'invoicesNumber', BillingHeader.invoicesId)
                        else
                            if IsNullGuid(BillingLine.offerId) then
                                hasError := InsertReThinkError(BillingLine.invoicesNumber, BillingLine.rowId, Error."Data Type"::Line, Error."Error Type"::"NULL Value", 'offerId', BillingHeader.invoicesId)
                            else
                                if BillingLine.quantity = 0 then
                                    hasError := InsertReThinkError(BillingLine.invoicesNumber, BillingLine.rowId, Error."Data Type"::Line, Error."Error Type"::"NULL Value", 'quantity', BillingHeader.invoicesId)
                                else
                                    if BillingLine.unitPrice = 0 then
                                        hasError := InsertReThinkError(BillingLine.invoicesNumber, BillingLine.rowId, Error."Data Type"::Line, Error."Error Type"::"NULL Value", 'unitPrice', BillingHeader.invoicesId)
                                    else
                                        if BillingLine.totalPrice = 0 then
                                            hasError := InsertReThinkError(BillingLine.invoicesNumber, BillingLine.rowId, Error."Data Type"::Line, Error."Error Type"::"NULL Value", 'totalPrice', BillingHeader.invoicesId)
                                        else
                                            if IsNullGuid(BillingLine.customerOrgId) then
                                                hasError := InsertReThinkError(BillingLine.invoicesNumber, BillingLine.rowId, Error."Data Type"::Line, Error."Error Type"::"NULL Value", 'customerOrgId', BillingHeader.invoicesId);

                        Resource.Reset;
                        Resource.SetRange("ApX ReThink ID", BillingLine.offerId);
                        if not Resource.FindFirst then
                            hasError := InsertReThinkError(BillingLine.invoicesNumber, BillingLine.rowId, Error."Data Type"::Line, Error."Error Type"::Resource, 'offerId : ' + Format(BillingLine.offerId), BillingHeader.invoicesId)
                        else
                            if not ResourceOnBoardingStatus(BillingLine.offerId) then
                                hasError := InsertReThinkError(BillingLine.invoicesNumber, BillingLine.rowId, Error."Data Type"::Line, Error."Error Type"::Resource, 'On-BoardingStatus : ' + Format(BillingLine.offerId), BillingHeader.invoicesId)
                    end until BillingLine.Next = 0;
                end else
                    hasError := InsertReThinkError(BillingHeader.invoicesNumber, BillingHeader.invoicesId, Error."Data Type"::Header, Error."Error Type"::Balance, 'totalPriceCheckSum', BillingHeader.invoicesId);
                if not hasError then begin
                    Error.Reset;
                    Error.SetRange(invoicesId, BillingHeader.invoicesId);
                    Error.SetRange(invoicesNumber, BillingHeader.invoicesNumber);
                    Error.DeleteAll;

                    BillingHeader.Validate(Status, BillingHeader.Status::New);
                    BillingHeader.Modify(true);
                    if BillingLine.FindFirst then begin
                        repeat begin
                            BillingLine.Validate(Status, BillingLine.Status::New);
                            BillingLine.Modify(true);
                        end until BillingLine.Next = 0;
                    end;
                    CreateSalesDocument(BillingHeader.invoicesId, BillingHeader.invoicesNumber);
                end;
            end until BillingHeader.Next = 0;
        end;
    end;

    procedure CreateSalesDocument(invoiceId: Guid; invoiceNumber: Integer);
    var
        BillingHeader: Record "ApX ReThink Billing Header";
        BillingLine: Record "ApX ReThink Billing Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Customer: Record Customer;
        Resource: Record Resource;
        CurrencyExcRate: Record "Currency Exchange Rate";
        CurrencyFactor: Decimal;
        LineNo: Integer;
        SalesHeaderNo: Code[20];
        GLSetup: Record "General Ledger Setup";
        Sign: Decimal;
    begin
        BillingHeader.Reset();
        BillingHeader.SetRange(invoicesId, invoiceId);
        BillingHeader.SetRange(invoicesNumber, invoiceNumber);
        BillingHeader.SetRange(Status, BillingHeader.Status::New);
        if BillingHeader.FindFirst() then begin
            Clear(SalesHeaderNo);
            SalesHeader.Init;
            if BillingHeader.totalPriceCheckSum > 0 then
                SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Invoice)
            else
                SalesHeader.Validate("Document Type", SalesHeader."Document Type"::"Credit Memo");
            SalesHeader."Posting Date" := DT2Date(BillingHeader.invoicesDate);
            Customer.SetRange("ApX ReThink ID", BillingHeader.invoiceReceiverId);
            if Customer.FindFirst then begin
                SalesHeader.Validate("Sell-to Customer No.", Customer."No.");
                SalesHeader.Validate("ApX ReThink Customer ID", Customer."ApX ReThink ID");
            end;

            SalesHeader.Validate("External Document No.", Format(BillingHeader.invoicesNumber));
            SalesHeader.Validate("ApX ReThink Document", true);
            SalesHeader.Validate("ApX ReThink Document ID", BillingHeader.invoicesId);
            SalesHeader.Validate("Posting Date", DT2Date(BillingHeader.invoicesDate));
            SalesHeader.Validate("Document Date", DT2Date(BillingHeader.invoicesDate));
            SalesHeader.Validate("ApX Billing Period Start", DT2Date(BillingHeader."billing period start"));
            SalesHeader.Validate("ApX Billing Period End", DT2Date(BillingHeader."billing period end"));

            GLSetup.Get();
            IF (UPPERCASE(BillingHeader.invoiceCurrency) <> GLSetup."LCY Code") then begin
                SalesHeader."Currency Code" := BillingHeader.invoiceCurrency;
                SalesHeader."Currency Factor" := 1 / BillingHeader.rateToEuro;
            end else begin
                SalesHeader."Currency Code" := '';
                SalesHeader."Currency Factor" := 0.0;
            end;

            SalesHeader.Insert(true);
            SalesHeaderNo := SalesHeader."No.";
            SalesHeader.Validate("Document Date", TODAY);
            SalesHeader.Modify;

            BillingHeader.Validate(Status, BillingHeader.Status::"Doc Created");
            BillingHeader.Validate("NAV Doc No", SalesHeader."No.");
            BillingHeader.Validate("Status Time Stamp", CurrentDateTime);
            BillingHeader.Modify(true);

            BillingLine.SetRange(invoicesId, invoiceId);
            BillingLine.SetRange(invoicesNumber, invoiceNumber);
            if BillingLine.FindFirst then
                repeat begin
                    SalesLine.Init;
                    if BillingHeader.totalPriceCheckSum > 0 then
                        SalesLine.Validate("Document Type", SalesLine."Document Type"::Invoice)
                    else
                        SalesLine.Validate("Document Type", SalesLine."Document Type"::"Credit Memo");
                    SalesLine.Validate("Document No.", SalesHeaderNo);
                    SalesLine.Validate(Type, SalesLine.Type::Resource);
                    LineNo += 10000;
                    SalesLine.Validate("Line No.", LineNo);
                    Resource.Reset;
                    Resource.SetRange("ApX ReThink ID", BillingLine.offerId);
                    if Resource.FindFirst then
                        SalesLine.Validate("No.", Resource."No.");

                    SalesLine.Validate(Quantity, BillingLine.quantity);
                    Sign := 1;
                    IF SalesLine."Document Type" = SalesLine."Document Type"::"Credit Memo" then
                        Sign := -1;
                    SalesLine.Validate("Unit Price", BillingLine.unitPrice * Sign);
                    SalesLine.Validate("ApX Billing Line Row Id", BillingLine.rowId);

                    SalesLine.Insert(true);

                    BillingLine.Validate(Status, BillingLine.Status::"Doc Created");
                    BillingLine.Validate("NAV Doc No", SalesHeaderNo);
                    BillingLine.Validate("NAV Doc Line No", SalesLine."Line No.");
                    BillingLine.Validate("Status Time Stamp", CurrentDateTime);
                    BillingLine.Modify(true);
                end until BillingLine.Next = 0;
        End;
    end;

    local procedure InsertReThinkError(invoiceNumber: Integer; rowId: Guid; DataType: Option Header,Line; ErrorType: Option New,"Doc Created","Doc Posted",Error; Comment: Text[80]; headerinvoicesId: Guid): Boolean;
    var
        ReThinkError: Record "ApX ReThink Error";
        Header: Record "ApX ReThink Billing Header";
        Line: Record "ApX ReThink Billing Line";
    begin
        ReThinkError.Reset();
        ReThinkError.SetRange(invoicesNumber, invoiceNumber);
        ReThinkError.SetRange("Data Type", DataType);
        ReThinkError.SetRange("Error Type", ErrorType);
        ReThinkError.SetRange(Comment, Comment);
        if not ReThinkError.FindFirst() then begin
            ReThinkError.Init;
            ReThinkError.invoicesNumber := invoiceNumber;
            ReThinkError.rowId := rowId;//CreateGuid;
            ReThinkError."Data Type" := DataType;
            ReThinkError."Error Type" := ErrorType;
            ReThinkError.Comment := Comment;
            ReThinkError."Time Created" := CurrentDateTime;
            ReThinkError.Resolved := false;
            ReThinkError.invoicesId := headerinvoicesId;
            ReThinkError.Insert(true);

            if DataType = DataType::Header then begin
                if Header.Get(headerinvoicesId, invoiceNumber) then begin
                    Header.Status := Header.Status::Error;
                    Header.Modify(true);
                end;
            end else begin
                Header.Reset;
                Header.SetRange(invoicesId, headerinvoicesId);
                Header.SetRange(invoicesNumber, invoiceNumber);
                if Header.FindFirst then begin
                    Header.Status := Header.Status::Error;
                    Header.Modify(true);
                end;
            end;
            if DataType = DataType::Line then begin
                Line.Reset;
                Line.SetRange(invoicesId, headerinvoicesId);
                Line.SetRange(invoicesNumber, invoiceNumber);
                Line.SetRange(rowId, rowId);
                if Line.FindFirst then begin
                    Line.Validate(Status, Header.Status::Error);
                    line.Modify(true);
                end;
            end;
        end;
        exit(true);
    end;

    local procedure CustomerOnBoardingStatus(customerOrgId: Guid): Boolean
    var
        Customer: Record Customer;
        result: Boolean;
    begin
        Customer.Reset;
        Customer.SetRange("ApX ReThink ID", customerOrgId);
        if Customer.FindFirst then begin
            if Customer."ApX On-Boarding Required" then
                Exit(false)
            else
                if (Customer."Customer Posting Group" = '') OR (Customer."Gen. Bus. Posting Group" = '') OR (Customer."VAT Bus. Posting Group" = '') then begin
                    Customer."ApX On-Boarding Required" := true;
                    Customer.Modify(true);
                    Exit(false);
                end;
            if (Customer."ApX On-Boarding Required" = false) and (Customer."Customer Posting Group" <> '') and (Customer."Gen. Bus. Posting Group" <> '') and (Customer."VAT Bus. Posting Group" <> '') then
                Exit(true);

        end else
            Exit(false);
    end;

    local procedure ResourceOnBoardingStatus(offerId: Guid): Boolean
    var
        Resource: Record Resource;

    begin
        Resource.Reset;
        Resource.SetRange("ApX ReThink ID", offerId);
        if Resource.FindFirst then begin
            if Resource."ApX On-Boarding Required" then
                Exit(false)
            else
                if (Resource."Gen. Prod. Posting Group" = '') OR (Resource."VAT Prod. Posting Group" = '') OR (Resource."Base Unit of Measure" = '') then begin
                    Resource."ApX On-Boarding Required" := true;
                    Resource.Modify(true);
                    Exit(false);
                end;
            if (Resource."ApX On-Boarding Required" = false) and (Resource."Gen. Prod. Posting Group" <> '') and (Resource."VAT Prod. Posting Group" <> '') and (Resource."Base Unit of Measure" <> '') then
                Exit(true);

        end else
            Exit(false);
    end;

    local procedure InvoiceDateStatus(InvoiceDate: Date): Boolean
    var
        tDate: Record Date;
        cDate: Date;
    begin
        cDate := Today();
        if Date2DMY(cDate, 2) = Date2DMY(InvoiceDate, 2) then
            exit(true)
        else
            if Date2DMY(cDate, 2) - Date2DMY(InvoiceDate, 2) = 1 then begin
                with tDate do begin
                    SetCurrentKey("Period Type", "Period Start");
                    SetRange("Period Type", "Period Type"::Date);
                    SetRange("Period Start", CalcDate('-CM'), cDate);
                    SetRange("Period No.", 1, 5);
                    exit(Count() < 3);
                end;
            end
            else
                exit(false)
    end;

    Var
        ProcessingStartMsg: Label 'ReThink Data Processing : Start';
        ProcessingEndMsg: Label 'ReThink Data Processing : End';

}
