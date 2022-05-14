report 70155344 "ApX Transfer Bank Rec. to GJ"
{

    Caption = 'Transfer Bank Rec. to Gen. Jnl.';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Bank Acc. Reconciliation"; "Bank Acc. Reconciliation")
        {
            DataItemTableView = SORTING("Bank Account No.", "Statement No.")
                                WHERE("Statement Type" = CONST("Bank Reconciliation"));
            dataitem("Bank Acc. Reconciliation Line"; "Bank Acc. Reconciliation Line")
            {
                DataItemLink = "Bank Account No." = FIELD("Bank Account No."),
                               "Statement No." = FIELD("Statement No.");
                DataItemTableView = SORTING("Bank Account No.", "Statement No.", "Statement Line No.");

                trigger OnAfterGetRecord();
                var
                    SourceCodeSetup: Record "Source Code Setup";
                begin
                    IF (Difference = 0) OR (Type > Type::"Bank Account Ledger Entry") THEN
                        CurrReport.SKIP;

                    GenJnlLine.INIT;
                    GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                    GenJnlLine.VALIDATE("Posting Date", "Transaction Date");
                    SourceCodeSetup.GET;
                    GenJnlLine."Source Code" := SourceCodeSetup."Trans. Bank Rec. to Gen. Jnl.";
                    IF "Document No." <> '' THEN
                        GenJnlLine."Document No." := "Document No."
                    ELSE
                        IF GenJnlBatch."No. Series" <> '' THEN
                            GenJnlLine."Document No." := NoSeriesMgt.GetNextNo(
                                GenJnlBatch."No. Series", "Transaction Date", FALSE);

                    GenJnlLine."Posting No. Series" := GenJnlBatch."Posting No. Series";

                    IF (GenJnlBatch."Bal. Account No." <> '') AND
                       ((GenJnlBatch."Bal. Account Type" <> GenJnlBatch."Bal. Account Type"::"Bank Account") OR
                        (GenJnlBatch."Bal. Account No." <> "Bank Acc. Reconciliation"."Bank Account No."))
                    THEN BEGIN
                        GenJnlLine.VALIDATE("Bal. Account Type", GenJnlBatch."Bal. Account Type");
                        GenJnlLine.VALIDATE("Bal. Account No.", GenJnlBatch."Bal. Account No.");
                        GenJnlLine.VALIDATE(Amount, Difference);
                    END ELSE BEGIN
                        GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Account Type"::"Bank Account");
                        GenJnlLine.VALIDATE("Bal. Account No.", "Bank Acc. Reconciliation"."Bank Account No.");
                        GenJnlLine.VALIDATE(Amount, -Difference);
                    END;

                    GenJnlLine.Description := Description;
                    SetAccount(Description);

                    GenJnlLine.INSERT;
                end;

                trigger OnPreDataItem();
                begin
                    GenJnlTemplate.GET(GenJnlLine."Journal Template Name");
                    GenJnlBatch.GET(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
                    GenJnlLine.SETRANGE("Journal Template Name", GenJnlBatch."Journal Template Name");
                    IF GenJnlBatch.Name <> '' THEN
                        GenJnlLine.SETRANGE("Journal Batch Name", GenJnlBatch.Name)
                    ELSE
                        GenJnlLine.SETRANGE("Journal Batch Name", '');

                    GenJnlLine.LOCKTABLE;
                    IF GenJnlLine.FINDLAST THEN;
                end;
            }

            trigger OnPreDataItem();
            begin
                SETRANGE("Statement Type", BankAccRecon."Statement Type");
                SETRANGE("Bank Account No.", BankAccRecon."Bank Account No.");
                SETRANGE("Statement No.", BankAccRecon."Statement No.");
                IF SalesReceivablesSetup.GET THEN;
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
                    field("Gen. Journal Template"; GenJnlLine."Journal Template Name")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Gen. Journal Template';
                        NotBlank = true;
                        TableRelation = "Gen. Journal Template";
                        ToolTip = 'Specifies the general journal template that the entries are placed in.';
                    }
                    field("Gen. Journal Batch"; GenJnlLine."Journal Batch Name")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Gen. Journal Batch';
                        Lookup = true;
                        NotBlank = true;
                        ToolTip = 'Specifies the general journal batch that the entries are placed in.';
                        trigger OnLookup(var Text: Text): Boolean;
                        begin
                            GenJnlLine.TESTFIELD("Journal Template Name");
                            GenJnlTemplate.GET(GenJnlLine."Journal Template Name");
                            GenJnlBatch.FILTERGROUP(2);
                            GenJnlBatch.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
                            GenJnlBatch.FILTERGROUP(0);
                            GenJnlBatch.Name := GenJnlLine."Journal Batch Name";
                            IF GenJnlBatch.FIND('=><') THEN;
                            IF PAGE.RUNMODAL(0, GenJnlBatch) = ACTION::LookupOK THEN BEGIN
                                Text := GenJnlBatch.Name;
                                EXIT(TRUE);
                            END;
                        end;

                        trigger OnValidate();
                        begin
                            GenJnlLine.TESTFIELD("Journal Template Name");
                            GenJnlBatch.GET(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
                        end;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport();
    begin
        GenJnlManagement.TemplateSelectionFromBatch(GenJnlBatch);
    end;

    var
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        BankAccRecon: Record "Bank Acc. Reconciliation";
        GenJnlManagement: Codeunit "GenJnlManagement";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit "NoSeriesManagement";

    procedure SetBankAccRecon(var UseBankAccRecon: Record "Bank Acc. Reconciliation");
    begin
        BankAccRecon := UseBankAccRecon;
    end;

    procedure InitializeRequest(GenJnlTemplateName: Code[10]; GenJnlBatchName: Code[10]);
    begin
        GenJnlLine."Journal Template Name" := GenJnlTemplateName;
        GenJnlLine."Journal Batch Name" := GenJnlBatchName;
    end;

    local procedure SetAccount(var DocumentNoFilter: Text);
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Number: Integer;
        Amount: Decimal;
    begin
        DocumentNoFilter := ReplaceString(DocumentNoFilter, ';', '|');
        DocumentNoFilter := ReplaceString(DocumentNoFilter, ',', '|');
        DocumentNoFilter := ReplaceString(DocumentNoFilter, ' ', '|');

        WHILE STRPOS(DocumentNoFilter, '||') <> 0 DO
            DocumentNoFilter := ReplaceString(DocumentNoFilter, '||', '|');
        WHILE COPYSTR(DocumentNoFilter, STRLEN(DocumentNoFilter), 1) = '|' DO
            DocumentNoFilter := COPYSTR(DocumentNoFilter, 1, STRLEN(DocumentNoFilter) - 1);
        Amount := 0;
        CustLedgerEntry.SETCURRENTKEY(Open, "Document No.");
        CustLedgerEntry.SETRANGE(Open, TRUE);
        CustLedgerEntry.SETFILTER("Document No.", STRSUBSTNO(DocumentNoFilter));

        Number := CustLedgerEntry.COUNT;
        IF CustLedgerEntry.FINDSET(TRUE) THEN BEGIN
            REPEAT
                CustLedgerEntry.CALCFIELDS(Amount);
                Amount += CustLedgerEntry.Amount;
            UNTIL CustLedgerEntry.NEXT = 0;

            CustLedgerEntry.FINDFIRST;
            IF Amount = "Bank Acc. Reconciliation Line"."Statement Amount" THEN BEGIN
                IF Number = 1 THEN BEGIN
                    CustLedgerEntry."Applies-to ID" := GenJnlLine."Document No.";
                    CustLedgerEntry."Amount to Apply" := Amount;
                    CustLedgerEntry.MODIFY;
                    GenJnlLine."Applies-to Doc. No." := CustLedgerEntry."Document No.";
                    GenJnlLine."Applies-to Doc. Type" := CustLedgerEntry."Document Type";
                END ELSE
                    REPEAT
                        CustLedgerEntry.CALCFIELDS(Amount);
                        CustLedgerEntry."Applies-to ID" := GenJnlLine."Document No.";
                        CustLedgerEntry."Amount to Apply" := CustLedgerEntry.Amount;
                        CustLedgerEntry.MODIFY;
                    UNTIL CustLedgerEntry.NEXT = 0;
            END;
            GenJnlLine."Applies-to ID" := GenJnlLine."Document No.";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
            GenJnlLine."Account No." := CustLedgerEntry."Customer No.";
            GenJnlLine."External Document No." := FORMAT(Amount);
        END ELSE BEGIN
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := SalesReceivablesSetup."ApX Reseller Liability Account";
        END;
    end;

    local procedure ReplaceString(var String: Text[50]; FindWhat: Text[50]; ReplaceWith: Text[50]) NewString: Text[50];
    begin
        WHILE STRPOS(String, FindWhat) > 0 DO
            String := DELSTR(String, STRPOS(String, FindWhat)) + ReplaceWith + COPYSTR(String, STRPOS(String, FindWhat) + STRLEN(FindWhat));
        NewString := String;
    end;
}

