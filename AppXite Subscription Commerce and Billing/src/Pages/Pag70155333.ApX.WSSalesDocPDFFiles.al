page 70155333 "ApX WS Sales Doc PDF Files"
{
    PageType = Card;
    SourceTable = "ApX Sales Doc PDF File";
    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = true;
    layout
    {
        area(content)
        {
            group(General)
            {
                field(invoicesNumber; invoicesNumber)
                {
                    applicationArea = All;
                }
                field(invoiceProviderId; invoiceProviderId)
                {
                    applicationArea = All;
                }
                field(invoiceReceiverId; invoiceReceiverId)
                {
                    applicationArea = All;
                }
                field("NAV Document No."; "NAV Document No.")
                {
                    applicationArea = All;
                }
                field("Document PDF"; "Document PDF")
                {
                    applicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        FileMgt: Codeunit "File Management";
        FileName: Text[50];
        PdfFile: File;
        folder: Text[80];
        NewStream: InStream;
        ToFile: Variant;
    begin

        CalcFields("Document PDF");
        if "Document PDF".HasValue() then begin
            if GuiAllowed() Then begin
                //"Document PDF".Export('MyFile');
                "Document PDF".CreateInStream(NewStream);
                ToFile := Format(invoicesId) + format(invoicesNumber) + '.Pdf';//InvoiceId??

                DOWNLOADFROMSTREAM(
                     NewStream,
                     'Save File to RoleTailored Client',
                     'C:\Users\Ali\Desktop\',
                     '"Pdf files (*.Pdf)|*.Pdf|All files (*.*)|*.*"',
                     ToFile);
            end;
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        CalcFields("Document PDF");
    end;
}
