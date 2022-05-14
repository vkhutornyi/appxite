report 70155341 "ApX Posted Sales Invoice"
{
    // version NAVNA11.00

    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Rep70155341.ApX.PostedSalesInvoice.rdlc';
    Caption = 'Posted Sales Invoice';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "ApX ReThink Document ID", "Sell-to Customer No.", "Bill-to Customer No.", "Ship-to Code", "No. Printed";
            RequestFilterHeading = 'Sales Invoice';
            CalcFields = Amount, "Amount Including VAT";
            column(No_SalesHeader; "No.")
            {
            }
            dataitem("Sales Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");

                DataItemTableView = SORTING("Document No.", "Line No.");


                trigger OnAfterGetRecord();
                begin
                    ReThinkBillingLine2.SETRANGE(ReThinkBillingLine2."NAV Doc Line No", "Sales Line"."Line No.");
                    IF ReThinkBillingLine2.FINDFIRST THEN BEGIN
                        IF (ReThinkBillingLine2.customerOrg = Cust."ApX Name From ReThink") OR (ReThinkBillingLine2.resellerOrg = '') then
                            ReThinkBillingLine2.customerOrg := '';
                        TempReThinkBillingLine3.TRANSFERFIELDS(ReThinkBillingLine2);
                        TempReThinkBillingLine3.INSERT;

                        TempReThinkBillingLine.SETRANGE(customerOrg, ReThinkBillingLine2.customerOrg);

                        IF TempReThinkBillingLine.ISEMPTY THEN BEGIN
                            TempReThinkBillingLine.invoicesId := ReThinkBillingLine2.invoicesId;
                            TempReThinkBillingLine.rowId := CREATEGUID;
                            TempReThinkBillingLine.customerOrg := ReThinkBillingLine2.customerOrg;

                            ReThinkBillingLine.RESET;
                            ReThinkBillingLine.SETRANGE(ReThinkBillingLine."NAV Doc No", ReThinkBillingLine2."NAV Doc No");
                            ReThinkBillingLine.SETRANGE(ReThinkBillingLine.customerOrg, ReThinkBillingLine2.customerOrg);
                            ReThinkBillingLine.CALCSUMS(ReThinkBillingLine.totalPrice);
                            TempReThinkBillingLine.totalPrice := ReThinkBillingLine.totalPrice;

                            IF TempReThinkBillingLine.INSERT THEN;

                        END;

                        TempReThinkBillingLine2.SETRANGE(customerOrg, ReThinkBillingLine2.customerOrg);
                        TempReThinkBillingLine2.SETRANGE(ProductName, ReThinkBillingLine2.ProductName);

                        IF TempReThinkBillingLine2.ISEMPTY THEN BEGIN
                            TempReThinkBillingLine2.invoicesId := ReThinkBillingLine2.invoicesId;
                            TempReThinkBillingLine2.rowId := CREATEGUID;
                            TempReThinkBillingLine2.customerOrg := ReThinkBillingLine2.customerOrg;
                            TempReThinkBillingLine2.ProductName := ReThinkBillingLine2.ProductName;

                            ReThinkBillingLine.RESET;
                            ReThinkBillingLine.SETRANGE(ReThinkBillingLine."NAV Doc No", ReThinkBillingLine2."NAV Doc No");
                            ReThinkBillingLine.SETRANGE(ReThinkBillingLine.customerOrg, ReThinkBillingLine2.customerOrg);
                            ReThinkBillingLine.SETRANGE(ProductName, ReThinkBillingLine2.ProductName);
                            ReThinkBillingLine.CALCSUMS(ReThinkBillingLine.totalPrice);
                            TempReThinkBillingLine2.totalPrice := ReThinkBillingLine.totalPrice;

                            IF TempReThinkBillingLine2.INSERT THEN;
                        END;
                    END;

                end;

                trigger OnPreDataItem();
                begin
                    ReThinkBillingLine.SETCURRENTKEY(ReThinkBillingLine.customerOrg, ProductName, ReThinkBillingLine.subscriptionName, ReThinkBillingLine.subscriptionStartDate);
                    ReThinkBillingLine2.SETRANGE("NAV Doc No", "Sales Invoice Header"."No.");
                    TempReThinkBillingLine.RESET;
                    TempReThinkBillingLine.DELETEALL;
                    TempReThinkBillingLine2.RESET;
                    TempReThinkBillingLine2.DELETEALL;
                    TempReThinkBillingLine3.RESET;
                    TempReThinkBillingLine3.DELETEALL;
                end;
            }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = CONST(1));
                    column(SubtotalCaption; SubtotalCaptionLbl)
                    {
                    }
                    column(Product_and_ConsumptionCaptionLbl; Product_and_ConsumptionCaptionLbl)
                    {
                    }
                    column(ChargeTypeCaptionLbl; ChargeTypeCaptionLbl)
                    {
                    }
                    column(StartDateCaptionLbl; StartDateCaptionLbl)
                    {
                    }
                    column(EndDateCaptionLbl; EndDateCaptionLbl)
                    {
                    }
                    column(QtyCaptionLbl; QtyCaptionLbl)
                    {
                    }
                    column(UnitPriceCaptionLbl; UnitPriceCaptionLbl)
                    {
                    }
                    column(TotalPriceCaptionLbl; TotalPriceCaptionLbl)
                    {
                    }
                    column(VATCaptionLbl; VATText)
                    {
                    }
                    column(Please_makesure_to_specify_this_invoice; strsubstno(Please_makesure_to_specify_this_invoice, CompanyInformation."ApX Specify Invoice Text"))
                    {
                    }
                    column(EURaccountNoCaptionLbl; STRSUBSTNO(EURaccountNoCaptionLbl, CompanyInformation."Bank Account No."))
                    {
                    }
                    column(SWIFTCodeCaptionLbl; STRSUBSTNO(SWIFTCodeCaptionLbl, CompanyInformation."SWIFT Code"))
                    {
                    }
                    column(For_copies_of_invoices_and_credit_notes; STRSUBSTNO(For_copies_of_invoices_and_credit_notes, CompanyInformation."ApX Contact Dept Text", CompanyInformation."E-Mail"))
                    {
                    }
                    column(Please_transfer_the_amount; STRSUBSTNO(Please_transfer_the_amount, CompanyInformation."ApX Transfer Amount To Text", StrSubstNo(CompanyInformation."ApX Address String Template", CompanyInformation."Bank Name", BankCountryRegion.Name, CompanyInformation."ApX Bank County", CompanyInformation."ApX Bank Post Code", CompanyInformation."ApX Bank City", CompanyInformation."ApX Bank Address", CompanyInformation."ApX Bank Address 2")))
                    {
                    }
                    column(Reversecharge2CaptionLbl; Reversecharge2CaptionLbl)
                    {
                    }
                    column(Reversecharge1CaptionLbl; Reversecharge1CaptionLbl)
                    {
                    }
                    column(DocumentDateCaptionLbl; DocumentDateCaptionLbl)
                    {
                    }
                    column(SalesHeader_DocumentDate; FORMAT("Sales Invoice Header"."Document Date"))
                    {
                    }
                    column(SalesHeader_DueDate; "Sales Invoice Header"."Due Date")
                    {
                    }
                    column(Registration_number; DELSTR(CompanyInformation."VAT Registration No.", 1, 2))
                    {
                    }
                    column(DocumentNoCaptionLbl; DocumentNoCaptionLbl)
                    {
                    }
                    column(RegistrationnumberCaptionLbl; RegistrationnumberCaptionLbl)
                    {
                    }
                    column(CustomerNoCaptionLbl; CustomerNoCaptionLbl)
                    {
                    }
                    column(Cust_No; Cust."ApX Registration No.")
                    {
                    }
                    column(Cust_ReThinkID; Cust."ApX ReThink ID")
                    {
                    }
                    column(Cust_Name_From_ReThink; Cust."ApX Name From ReThink")
                    {
                    }
                    column(Currency_Code_SalesInvHeader; CurrencyCode)
                    {
                    }
                    column(Amount_SalesInvHeader; "Sales Invoice Header".Amount)
                    {
                    }
                    column(AmountIncludingVAT_SalesInvHeader; "Sales Invoice Header"."Amount Including VAT")
                    {
                    }
                    column(InvoiceDiscountAmount_SalesInvHeader; "Sales Invoice Header"."Invoice Discount Amount")
                    {
                    }
                    column(YourReference_SalesInvHeader; "Sales Invoice Header"."Your Reference")
                    {
                    }
                    column(VAT_Registration_No_SalesInvHeader; Cust."VAT Registration No.")
                    {
                    }
                    column(Cust_Contact; Cust.Contact)
                    {
                    }
                    column(BillingPeriod; BillingPeriod)
                    {
                    }
                    column(BillingPeriodCaptionLbl; BillingPeriodCaptionLbl)
                    {
                    }
                    column(TotalDueCaptionLbl; TotalDueCaptionLbl)
                    {
                    }
                    column(YourAppXiteBillCaptionLbl; STRSUBSTNO(YourAppXiteBillCaptionLbl, CompanyInformation."ApX Short Name"))
                    {
                    }
                    column(CustomerERPCaptionLbl; CustomerERPCaptionLbl)
                    {
                    }
                    column(CustomerNameCaptionLbl; CustomerNameCaptionLbl)
                    {
                    }
                    column(CustomerRegNoCaptionLbl; CustomerRegNoCaptionLbl)
                    {
                    }
                    column(BillingAddressCaptionLbl; BillingAddressCaptionLbl)
                    {
                    }
                    column(ContactNameCaptionLbl; ContactNameCaptionLbl)
                    {
                    }
                    column(YourReferenceCaptionLbl; YourReferenceCaptionLbl)
                    {
                    }
                    column(CompanyInfo2Picture; CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInfoPicture; CompanyInfo3.Picture)
                    {
                    }
                    column(CompanyAddress1; CompanyAddress[1])
                    {
                    }
                    column(CompanyAddress2; CompanyAddress[2])
                    {
                    }
                    column(CompanyAddress3; CompanyAddress[3])
                    {
                    }
                    column(CompanyAddress4; '')
                    {
                    }
                    column(CompanyAddress5; '')
                    {
                    }
                    column(CompanyAddress6; '')
                    {
                    }
                    column(BillToAddress1; BillToAddress[1])
                    {
                    }
                    column(BillToAddress2; BillToAddress[2])
                    {
                    }
                    column(BillToAddress3; BillToAddress[3])
                    {
                    }
                    column(BillToAddress4; BillToAddress[4])
                    {
                    }
                    column(BillToAddress5; BillToAddress[5])
                    {
                    }
                    column(BillToAddress6; BillToAddress[6])
                    {
                    }
                    column(BillToAddress7; BillToAddress[7])
                    {
                    }
                    column(CopyTxt; CopyTxt)
                    {
                    }
                    column(BilltoCustNo_SalesHeader; "Sales Invoice Header"."Bill-to Customer No.")
                    {
                    }
                    column(ExtDocNo_SalesHeader; "Sales Invoice Header"."External Document No.")
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(OrderDate_SalesHeader; "Sales Invoice Header"."Order Date")
                    {
                    }
                    column(CompanyAddress7; CompanyAddress[7])
                    {
                    }
                    column(CompanyAddress8; CompanyAddress[8])
                    {
                    }
                    column(BillToAddress8; BillToAddress[8])
                    {
                    }
                    column(ShipToAddress8; ShipToAddress[8])
                    {
                    }
                    column(ShipmentMethodDesc; ShipmentMethod.Description)
                    {
                    }
                    column(PaymentTermsDesc; PaymentTerms.Description)
                    {
                    }
                    column(TaxRegLabel; VATnumberCaptionLbl)
                    {
                    }
                    column(TaxRegNo; CompanyInformation."VAT Registration No.")
                    {
                    }
                    column(CopyNo; CopyNo)
                    {
                    }
                    column(CustTaxIdentificationType; VATnumberCaptionLbl)
                    {
                    }
                    column(ShipDateCaption; ShipDateCaptionLbl)
                    {
                    }
                    column(CustomerIDCaption; CustomerIDCaptionLbl)
                    {
                    }
                    column(PONumberCaption; PONumberCaptionLbl)
                    {
                    }
                    column(SalesPersonCaption; SalesPersonCaptionLbl)
                    {
                    }
                    column(TermsCaption; TermsCaptionLbl)
                    {
                    }
                    column(PODateCaption; PODateCaptionLbl)
                    {
                    }
                    column(TaxIdentTypeCaption; TaxIdentTypeCaptionLbl)
                    {
                    }
                    column(NetAmountCaptionLb; NetAmountCaptionLb)
                    {
                    }
                    column(VATAmountCaptionLb; VATAmountCaptionLb)
                    {
                    }
                    column(TotalamountCaptionLb; TotalamountCaptionLb)
                    {
                    }
                    column(VATLineCaptionLbl; VATLineCaptionLbl)
                    {
                    }
                    column(BillingHistoryYAxis; BillingHistoryYAxisLb)
                    {
                    }
                    column(BillHistoryCaption; StrSubstNo(BillHistoryCaptionLb, CurrencyCode))
                    {
                    }
                    dataitem(CustStat; Integer)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = FILTER(1 .. 4));
                        column(CustDateFilterTxt; CustDateFilterTxt)
                        {
                        }
                        column(CustSalesInvLCY; CustSalesInvLCY)
                        {
                        }

                        trigger OnAfterGetRecord();
                        begin
                            CustDateFilterTxt := FORMAT(CustDate[Number], 0, '<Month Text,3><Year>');
                            CustSalesInvLCY := CustSalesLCY[Number];
                        end;
                    }
                    dataitem(EndCustomer; Integer)
                    {
                        DataItemTableView = SORTING(Number);
                        column(EndCustomerName; TempReThinkBillingLine.customerOrg)
                        {
                        }
                        column(EndCustomer_totalPrice; TempReThinkBillingLine.totalPrice)
                        {
                        }
                        column(EndCustomer_VATNumber; VATPercentage * TempReThinkBillingLine.totalPrice / 100)
                        {
                        }
                        dataitem(Product; Integer)
                        {
                            DataItemTableView = SORTING(Number);
                            column(ProductName; TempReThinkBillingLine2.ProductName)
                            {
                            }
                            column(Product_totalPrice; TempReThinkBillingLine2.totalPrice)
                            {
                            }
                            column(Product_VATNumber; VATPercentage * TempReThinkBillingLine2.totalPrice / 100)
                            {
                            }
                            dataitem(Subscription; Integer)
                            {
                                DataItemTableView = SORTING(Number);
                                column(ShortOfferName; TempReThinkBillingLine3.ShortOfferName)
                                {
                                }
                                column(subscriptionName; TempReThinkBillingLine3.subscriptionName)
                                {
                                }
                                column(StartDate; TempReThinkBillingLine3."charge start date")
                                {
                                }
                                column(EndDate; TempReThinkBillingLine3."charge end date")
                                {
                                }
                                column(ChargeTypes; TempReThinkBillingLine3.invoiceChargeTypes)
                                {
                                }
                                column(Quantity; TempReThinkBillingLine3.quantity)
                                {
                                }
                                column(UnitPrice; TempReThinkBillingLine3.unitPrice)
                                {
                                }
                                column(TotalPrice; TempReThinkBillingLine3.totalPrice)
                                {
                                }
                                column(VATNumber; VATPercentage * TempReThinkBillingLine3.totalPrice / 100)
                                {
                                }
                                column(Number; Number)
                                {
                                }

                                trigger OnAfterGetRecord();
                                begin
                                    IF Number = 1 THEN
                                        TempReThinkBillingLine3.FINDSET
                                    ELSE BEGIN
                                        TempReThinkBillingLine3.NEXT;
                                    END;
                                    IF ShortOfferNameVar <> TempReThinkBillingLine3.ShortOfferName THEN BEGIN
                                        ShortOfferNameVar := TempReThinkBillingLine3.ShortOfferName;
                                        TempReThinkBillingLine3.subscriptionName := ShortOfferNameVar;
                                    END ELSE
                                        TempReThinkBillingLine3.subscriptionName := '';
                                end;

                                trigger OnPreDataItem();
                                begin

                                    TempReThinkBillingLine3.RESET;
                                    TempReThinkBillingLine3.SETCURRENTKEY(TempReThinkBillingLine3.customerOrg, TempReThinkBillingLine3.ProductName, TempReThinkBillingLine3.ShortOfferName);
                                    TempReThinkBillingLine3.SETRANGE(TempReThinkBillingLine3.customerOrg, TempReThinkBillingLine2.customerOrg);
                                    TempReThinkBillingLine3.SETRANGE(TempReThinkBillingLine3.ProductName, TempReThinkBillingLine2.ProductName);
                                    SETRANGE(Number, 1, TempReThinkBillingLine3.COUNT);

                                    CLEAR(ShortOfferNameVar);
                                end;
                            }

                            trigger OnAfterGetRecord();
                            begin
                                IF Number = 1 THEN
                                    TempReThinkBillingLine2.FINDSET
                                ELSE BEGIN
                                    TempReThinkBillingLine2.NEXT;
                                END;
                            end;

                            trigger OnPreDataItem();
                            begin
                                TempReThinkBillingLine2.RESET;
                                TempReThinkBillingLine2.SETRANGE(TempReThinkBillingLine2.customerOrg, TempReThinkBillingLine.customerOrg);
                                SETRANGE(Number, 1, TempReThinkBillingLine2.COUNT);
                            end;
                        }

                        trigger OnAfterGetRecord();
                        begin
                            OnLineNumber := OnLineNumber + 1;

                            IF OnLineNumber = 1 THEN
                                TempReThinkBillingLine.FIND('-')
                            ELSE
                                TempReThinkBillingLine.NEXT;
                        end;

                        trigger OnPreDataItem();
                        begin
                            TempReThinkBillingLine.RESET;
                            NumberOfLines := TempReThinkBillingLine.COUNT;
                            SETRANGE(Number, 1, NumberOfLines);
                            OnLineNumber := 0;
                        end;
                    }
                    dataitem(TotalEndCustomer; Integer)
                    {
                        DataItemTableView = SORTING(Number);
                        column(Number_TotalEndCustomer; Number)
                        {
                        }
                        column(TotalEndCustomerName; STRSUBSTNO(TotalPriceCaptionLb, TempReThinkBillingLine.customerOrg))
                        {
                        }
                        column(TotalEndCustomer_totalPrice; TempReThinkBillingLine.totalPrice)
                        {
                        }
                        column(TotalEndCustomer_VATNumber; VATNumber)
                        {
                        }

                        trigger OnAfterGetRecord();
                        begin
                            IF Number = 1 THEN
                                TempReThinkBillingLine.FINDSET
                            ELSE BEGIN
                                TempReThinkBillingLine.NEXT;
                            END;
                            VATNumber := VATPercentage * TempReThinkBillingLine.totalPrice / 100;
                        end;

                        trigger OnPreDataItem();
                        begin
                            TempReThinkBillingLine.RESET;
                            SETRANGE(Number, 1, TempReThinkBillingLine.COUNT);
                        end;
                    }
                }

                trigger OnAfterGetRecord();
                begin

                    IF CopyNo = NoLoops THEN BEGIN
                        //IF NOT CurrReport.PREVIEW THEN
                        //  SalesPrinted.RUN("Sales Invoice Header");
                        CurrReport.BREAK;
                    END;
                    CopyNo := CopyNo + 1;
                    IF CopyNo = 1 THEN // Original
                        CLEAR(CopyTxt)
                    ELSE
                        CopyTxt := CopyLbl;
                end;

                trigger OnPreDataItem();
                begin
                    NoLoops := 1 + ABS(NoCopies);
                    IF NoLoops <= 0 THEN
                        NoLoops := 1;
                    CopyNo := 0;
                end;
            }

            trigger OnAfterGetRecord();
            var
                tempdata: Array[3] of Text;
                CustLedgerEntry: Record "Cust. Ledger Entry";
            begin
                IF PrintCompany THEN
                    IF RespCenter.GET("Responsibility Center") THEN BEGIN
                        FormatAddress.RespCenter(CompanyAddress, RespCenter);
                        CompanyInformation."Phone No." := RespCenter."Phone No.";
                        CompanyInformation."Fax No." := RespCenter."Fax No.";
                    END;

                if "Language Code" = '' then
                    CurrReport.LANGUAGE := Language.GetLanguageID('ENG')
                else
                    CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                Clear(Cust);
                IF Cust.GET("Sell-to Customer No.") THEN;

                FOR i := 1 TO 4 DO BEGIN
                    IF i = 1 THEN
                        CustDate[i] := CALCDATE('<CD-4M>', "Sales Invoice Header"."Posting Date")
                    ELSE
                        CustDate[i] := CALCDATE('<CD+1M>', CustDate[i - 1]);
                    DateFilterCalc.CreateAccountingPeriodFilter(CustDateFilter[i], CustDateName[i], CustDate[i], 0);
                    CustSalesLCY[i] := 0;
                    CustLedgerEntry.Reset;
                    CustLedgerEntry.SetCurrentKey("Customer No.", "Posting Date");
                    CustLedgerEntry.SetRange("Customer No.", Cust."No.");
                    CustLedgerEntry.SetFilter("Posting Date", CustDateFilter[i]);
                    if CustLedgerEntry.FindSet then
                        repeat
                            CustLedgerEntry.CalcFields(Amount);
                            CustSalesLCY[i] += CustLedgerEntry.Amount;
                        until CustLedgerEntry.Next = 0;
                END;

                //trick to omit not needed info
                tempdata[1] := "Sales Invoice Header"."Sell-to Customer Name";
                tempdata[2] := "Sales Invoice Header"."Sell-to Customer Name 2";
                tempdata[3] := "Sales Invoice Header"."Sell-to Contact";
                "Sales Invoice Header"."Sell-to Customer Name" := '';
                "Sales Invoice Header"."Sell-to Customer Name 2" := '';
                "Sales Invoice Header"."Sell-to Contact" := '';

                FormatAddress.SalesInvSellTo(BillToAddress, "Sales Invoice Header");
                //restore data
                "Sales Invoice Header"."Sell-to Customer Name" := tempdata[1];
                "Sales Invoice Header"."Sell-to Customer Name 2" := tempdata[2];
                "Sales Invoice Header"."Sell-to Contact" := tempdata[3];

                FormatAddress.SalesInvShipTo(ShipToAddress, ShipToAddress, "Sales Invoice Header");
                IF "Payment Terms Code" = '' THEN
                    CLEAR(PaymentTerms)
                ELSE
                    PaymentTerms.GET("Payment Terms Code");
                BillingPeriod := Format("ApX Billing Period Start") + '-' + Format("ApX Billing Period End");
                IF "Currency Code" <> '' THEN
                    CurrencyCode := "Currency Code"
                ELSE
                    CurrencyCode := GeneralLedgerSetup."LCY Code";
                CLEAR(VATPercentage);
                IF "Amount Including VAT" - Amount <> 0 THEN BEGIN
                    VATPercentage := (("Amount Including VAT" - Amount) / Amount) * 100;
                    VATText := STRSUBSTNO(VATCaptionLbl, Round(VATPercentage, 1));
                END else
                    VATText := STRSUBSTNO(VATCaptionLbl, 0) + '*';
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
                    field(NoCopies; NoCopies)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Number of Copies';
                        ToolTip = 'Specifies the number of copies of each document (in addition to the original) that you want to print.';
                    }
                    field(PrintCompanyAddress; PrintCompany)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Company Address';
                        ToolTip = 'Specifies if your company address is printed at the top of the sheet, because you do not use pre-printed paper. Leave this check box blank to omit your company''s address.';
                        Visible = false;
                    }
                    field(ArchiveDocument; ArchiveDocument)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Archive Document';
                        Enabled = ArchiveDocumentEnable;
                        ToolTip = 'Specifies if the document is archived after you preview or print it.';
                        Visible = false;

                        trigger OnValidate();
                        begin
                            IF NOT ArchiveDocument THEN
                                LogInteraction := FALSE;
                        end;
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies if you want to record the related interactions with the involved contact person in the Interaction Log Entry table.';
                        Visible = false;

                        trigger OnValidate();
                        begin
                            IF LogInteraction THEN
                                ArchiveDocument := ArchiveDocumentEnable;
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit();
        begin
            LogInteractionEnable := TRUE;
            ArchiveDocumentEnable := TRUE;
        end;

        trigger OnOpenPage();
        begin
            ArchiveDocument := ArchiveManagement.SalesDocArchiveGranule;
            LogInteraction := SegManagement.FindInteractTmplCode(3) <> '';

            ArchiveDocumentEnable := ArchiveDocument;
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        PrintCompany := TRUE;
    end;

    trigger OnPreReport();
    begin
        CompanyInformation.GET;
        IF BankCountryRegion.Get(CompanyInformation."ApX Bank Country/Region Code") then;
        SalesSetup.GET;
        GeneralLedgerSetup.GET;
        CompanyInfo3.GET;
        CompanyInfo3.CALCFIELDS(Picture);
        IF CountryRegion.GET(CompanyInformation."Country/Region Code") THEN
            CompanyInformation."Address 2" := CompanyInformation.City + ', ' + COPYSTR(CountryRegion.Name, 1, 30) + ', ' + CompanyInformation."Post Code";
        IF PrintCompany THEN
            FormatAddress.Company(CompanyAddress, CompanyInformation)
        ELSE
            CLEAR(CompanyAddress);
    end;

    var
        TaxLiable: Decimal;
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPrinted: Codeunit "Sales-Printed";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInformation: Record "Company Information";
        BankCountryRegion: Record "Country/Region";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        RespCenter: Record "Responsibility Center";
        Language: Codeunit "Language";
        Cust: Record "Customer";
        CountryRegion: Record "Country/Region";
        VATPercentage: Decimal;
        VATText: Text[50];
        FormatAddress: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit "SegManagement";
        ArchiveManagement: Codeunit "ArchiveManagement";
        SalesTaxCalc: Codeunit "Sales Tax Calculate";
        CompanyAddress: array[8] of Text[50];
        BillToAddress: array[8] of Text[50];
        ShipToAddress: array[8] of Text[50];
        CopyTxt: Text;
        SalespersonText: Text[50];
        CurrencyCode: Code[10];
        GeneralLedgerSetup: Record "General Ledger Setup";
        PrintCompany: Boolean;
        NoCopies: Integer;
        NoLoops: Integer;
        CopyNo: Integer;
        NumberOfLines: Integer;
        OnLineNumber: Integer;
        HighestLineNo: Integer;
        TaxAmount: Decimal;
        ArchiveDocument: Boolean;
        LogInteraction: Boolean;
        TaxRegNo: Text;
        TaxRegLabel: Text;
        TotalTaxLabel: Text;
        PrevPrintOrder: Integer;
        PrevTaxPercent: Decimal;
        UseDate: Date;
        UseExternalTaxEngine: Boolean;
        [InDataSet]
        ArchiveDocumentEnable: Boolean;
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        AsmInfoExistsForLine: Boolean;
        CopyLbl: Label 'COPY';
        SubtotalCaptionLbl: Label 'Subtotal';
        ShipDateCaptionLbl: Label 'Ship Date';
        CustomerIDCaptionLbl: Label 'Customer ID';
        PONumberCaptionLbl: Label 'P.O. Number';
        SalesPersonCaptionLbl: Label 'SalesPerson';
        TermsCaptionLbl: Label 'Terms of Payment:';
        PODateCaptionLbl: Label 'P.O. Date';
        TaxIdentTypeCaptionLbl: Label 'Tax Ident. Type';
        InvoiceDiscountCaptionLbl: Label 'Invoice Discount:';
        TotalCaptionLbl: Label 'Total:';
        CustDateFilter: array[4] of Text[30];
        CustDateName: array[4] of Text[30];
        CustDate: array[4] of Date;
        CustSalesLCY: array[4] of Decimal;
        i: Integer;
        CustSalesInvLCY: Decimal;
        DateFilterCalc: Codeunit "DateFilter-Calc";
        CustomerNameCaptionLbl: Label 'Customer Name:';
        CustomerRegNoCaptionLbl: Label 'Customer VAT No:';
        BillingAddressCaptionLbl: Label 'Billing Address:';
        ContactNameCaptionLbl: Label 'Contact Name:';
        YourReferenceCaptionLbl: Label 'Your Reference:';
        CustomerERPCaptionLbl: Label 'Customer ERP ID:';
        YourAppXiteBillCaptionLbl: Label 'Your %1 Bill No:';
        TotalDueCaptionLbl: Label 'Total Due';
        BillingPeriodCaptionLbl: Label 'Billing Period:';
        CustDateFilterTxt: Text[30];
        BillingPeriod: Text[30];
        CustomerNoCaptionLbl: Label 'Customer Reg. No:';
        DocumentNoCaptionLbl: Label 'Invoice No:';
        RegistrationnumberCaptionLbl: Label 'Registration number: ';
        VATnumberCaptionLbl: Label 'VAT number: ';
        DocumentDateCaptionLbl: Label 'Invoice Date:';
        Reversecharge2CaptionLbl: Label '*Reverse charge, EU directive "111"';
        Reversecharge1CaptionLbl: Label '* reverse charge (Article 44 of the EU VAT Directive (2006/112/EC))';
        Please_transfer_the_amount: Label '%1 %2';
        SWIFTCodeCaptionLbl: Label 'SWIFT code %1';
        EURaccountNoCaptionLbl: Label 'Account No./IBAN %1';
        Please_makesure_to_specify_this_invoice: Label '%1';
        For_copies_of_invoices_and_credit_notes: Label '%1 %2';
        ReThinkBillingLine: Record "ApX ReThink Billing Line";
        ReThinkBillingLine2: Record "ApX ReThink Billing Line";
        TempReThinkBillingLine: Record "ApX ReThink Billing Line" temporary;
        TempReThinkBillingLine2: Record "ApX ReThink Billing Line" temporary;
        TempReThinkBillingLine3: Record "ApX ReThink Billing Line" temporary;
        VATNumber: Decimal;
        Product_and_ConsumptionCaptionLbl: Label 'Product and Consumption Details';
        ChargeTypeCaptionLbl: Label 'Charge Type';
        StartDateCaptionLbl: Label 'Start date';
        EndDateCaptionLbl: Label 'End date';
        QtyCaptionLbl: Label 'Qty';
        UnitPriceCaptionLbl: Label 'Unit Price';
        TotalPriceCaptionLbl: Label 'Total Price';
        VATCaptionLbl: Label 'VAT %1 %';
        VATLineCaptionLbl: Label 'VAT *';
        ShortOfferNameVar: Text;
        TotalPriceCaptionLb: Label 'Total %1';
        NetAmountCaptionLb: Label 'Net Amount';
        VATAmountCaptionLb: Label 'VAT Amount';
        TotalamountCaptionLb: Label 'Total Amount';
        BillingHistoryYAxisLb: Label '#,0;(#,0)';
        BillHistoryCaptionLb: Label 'Bill History (%1)';
}

