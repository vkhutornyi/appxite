page 70155329 "ApX WS NAV Transactions"
{
    PageType = Card;
    SourceTable = "ApX Rethink Cust. Ledger Entry";
    Editable = false;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Entry No."; "Entry No.")
                {
                    applicationArea = All;
                }
                field("Customer No."; CustomerNo)
                {
                    applicationArea = All;
                }
                field("Document Type"; DocumentType)
                {
                    applicationArea = All;
                }
                field("Document No."; DocumentNo)
                {
                    applicationArea = All;
                }
                field(Description; Description)
                {
                    applicationArea = All;
                }
                field("Currency Code"; CurrencyCode)
                {
                    applicationArea = All;
                }
                field(Amount; Amount)
                {
                    applicationArea = All;
                }
                field("Remaining Amount"; RemainingAmount)
                {
                    applicationArea = All;
                }
                field("Due Date"; DueDate)
                {
                    applicationArea = All;
                }
                field("Document Date"; DocumentDate)
                {
                    applicationArea = All;
                }
                field("External Document No."; ExternalDocumentNo)
                {
                    applicationArea = All;
                }
                field(Status; Status)
                {
                    applicationArea = All;
                }
                field("ReThink ID"; "ReThink ID")
                {
                    applicationArea = All;
                }
                field("Last Modified - ReThink"; "Last Modified - ReThink")
                {
                    applicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        CustomerNo := '';
        DocumentType := CustLedgerEntry."Document Type"::" ";
        DocumentNo := '';
        DocumentDate := 0D;
        Description := '';
        CurrencyCode := '';
        Amount := 0;
        RemainingAmount := 0;
        DueDate := 0D;
        ExternalDocumentNo := '';
        CustLedgerEntry.Reset;
        CustLedgerEntry.SetCurrentKey("Entry No.");
        If CustLedgerEntry.Get("Entry No.") then begin
            CustLedgerEntry.CalcFields("Remaining Amount");
            CustomerNo := CustLedgerEntry."Customer No.";
            DocumentType := CustLedgerEntry."Document Type";
            DocumentNo := CustLedgerEntry."Document No.";
            DocumentDate := CustLedgerEntry."Document Date";
            Description := CustLedgerEntry.Description;
            CurrencyCode := CustLedgerEntry."Currency Code";
            Amount := CustLedgerEntry.Amount;
            RemainingAmount := CustLedgerEntry."Remaining Amount";
            DueDate := CustLedgerEntry."Due Date";
            ExternalDocumentNo := CustLedgerEntry."External Document No.";
        end;
    end;

    var
        CustomerNo: Code[20];
        DocumentType: Enum "Gen. Journal Document Type";
        //Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        DocumentNo: Code[20];
        Description: Text[50];
        CurrencyCode: Code[10];
        Amount: Decimal;
        RemainingAmount: Decimal;
        DueDate: Date;
        DocumentDate: Date;
        ExternalDocumentNo: Code[35];
}