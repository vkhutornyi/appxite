table 70155334 "ApX RESTWebServiceArguments"
{
    Caption = 'REST Web Service Arguments';

    fields
    {
        field(70155324; PrimaryKey; Integer)
        {
            DataClassification = SystemMetadata;
        }
        field(70155325; RestMethod; Option)
        {
            OptionMembers = get,post,delete,patch,put;
            DataClassification = SystemMetadata;
        }
        field(70155326; URL; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(70155327; Accept; Text[30])
        {
            DataClassification = SystemMetadata;
        }
        field(70155328; ETag; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(70155329; SASkey; Text[250])
        {
            DataClassification = SystemMetadata;
        }
        field(70155330; Blob; Blob)
        {
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; PrimaryKey)
        {
            Clustered = true;
        }
    }

    var
        RequestContent: HttpContent;
        RequestContentSet: Boolean;
        ResponseHeaders: HttpHeaders;

    procedure SetRequestContent(var value: HttpContent)
    begin
        RequestContent := value;
        RequestContentSet := true;
    end;

    procedure ClearRequestContent()
    begin
        RequestContent.Clear();
        RequestContentSet := false;
    end;

    procedure HasRequestContent(): Boolean
    begin
        exit(RequestContentSet);
    end;

    procedure GetRequestContent(var value: HttpContent)
    begin
        value := RequestContent;
    end;

    procedure SetResponseContent(var value: HttpContent)
    var
        InStr: InStream;
        OutStr: OutStream;
    begin
        Blob.CreateInStream(InStr);
        value.ReadAs(InStr);

        Blob.CreateOutStream(OutStr);
        CopyStream(OutStr, InStr);
    end;

    procedure HasResponseContent(): Boolean
    begin
        exit(Blob.HasValue);
    end;

    procedure GetResponseContent(var value: HttpContent)
    var
        InStr: InStream;
    begin
        Blob.CreateInStream(InStr);
        value.Clear();
        value.WriteFrom(InStr);
    end;

    procedure GetResponseContentAsText() ReturnValue: text
    var
        InStr: InStream;
        Line: text;
    begin
        if not HasResponseContent then
            exit;

        Blob.CreateInStream(InStr);
        InStr.ReadText(ReturnValue);

        while not InStr.EOS do begin
            InStr.ReadText(Line);
            ReturnValue += Line;
        end;
    end;

    procedure SetResponseHeaders(var value: HttpHeaders)
    begin
        ResponseHeaders := value;
    end;

    procedure GetResponseHeaders(var value: HttpHeaders)
    begin
        value := ResponseHeaders;
    end;
}