codeunit 70155330 "ApX RESTWebService"
{
    procedure CallRESTWebService(var Parameters: Record "ApX RESTWebServiceArguments"): Boolean
    var
        Client: HttpClient;
        AuthHeaderValue: HttpHeaders;
        Headers: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        Content: HttpContent;
    begin
        RequestMessage.Method := Format(Parameters.RestMethod);
        RequestMessage.SetRequestUri(Parameters.URL);

        RequestMessage.GetHeaders(Headers);

        if Parameters.Accept <> '' then
            Headers.Add('Accept', Parameters.Accept);

        if Parameters.ETag <> '' then
            Headers.Add('If-Match', Parameters.ETag);

        if Parameters.SASkey <> '' then
            Headers.Add('saskey', Parameters.SASkey);

        if Parameters.HasRequestContent then begin
            Parameters.GetRequestContent(Content);
            RequestMessage.Content := Content;
        end;

        Client.Send(RequestMessage, ResponseMessage);

        Headers := ResponseMessage.Headers;
        Parameters.SetResponseHeaders(Headers);

        Content := ResponseMessage.Content;
        Parameters.SetResponseContent(Content);

        exit(ResponseMessage.IsSuccessStatusCode);
    end;

    procedure ProcessRosourcesRequest()
    var
        Arguments: Record "ApX RESTWebServiceArguments" temporary;
        JSONMethod: Codeunit "ApX JSONMethods";
        JSONObject: JsonObject;
        JSONArray: JsonArray;
        JSONToken: JsonToken;
        Resource: Record Resource;
        CompanyInfo: Record "Company Information";
        RethinkID: Guid;
        NameFromRethink: Text[250];
        i: Integer;
        Sucess: Boolean;
    begin
        Sucess := true;
        CompanyInfo.Get;
        Arguments.URL := CompanyInfo."ApX Base URI" + 'data?workflowId=offers.wrkf&refreshDateFrom=2019-10-28T00:00:00Z&refreshDateTill=2019-12-10 05:40:14';
        Arguments.RestMethod := Arguments.RestMethod::get;
        Arguments.Accept := 'application/json';
        Arguments.SASkey := CompanyInfo."ApX API Token";
        Resource.SetCurrentKey("ApX ReThink ID");
        if CallRESTWebService(Arguments) then begin
            JSONArray.ReadFrom(Arguments.GetResponseContentAsText);
            for i := 0 to JSONArray.Count - 1 do begin
                JSONArray.Get(i, JSONToken);
                JSONObject := JSONToken.AsObject();
                RethinkID := JSONMethod.GetJsonValueAsText(JSONObject, 'id');
                NameFromRethink := JSONMethod.GetJsonValueAsText(JSONObject, 'name');
                Resource.SetRange("ApX ReThink ID", RethinkID);
                if not Resource.FindFirst() then begin
                    Resource.Init();
                    Resource."No." := '';
                    Resource."ApX ReThink ID" := RethinkID;
                    Resource.Validate("ApX On-Boarding Required", true);
                    Resource.Insert(true);
                end;
                Resource."ApX Name From ReThink" := NameFromRethink;
                Resource.Validate(Name, CopyStr(NameFromRethink, 1, 100));
                Resource.Validate("Name 2", CopyStr(NameFromRethink, 101, 50));
                Resource.Validate("ApX Last Modified - ReThink", CurrentDateTime());
                Resource.Modify(true);
            end;
        end else
            Sucess := false;
    end;

    procedure ProcessVendorsRequest()
    var
        Arguments: Record "ApX RESTWebServiceArguments" temporary;
        JSONMethod: Codeunit "ApX JSONMethods";
        JSONObject: JsonObject;
        JSONArray: JsonArray;
        JSONToken: JsonToken;
        Vendor: Record Vendor;
        CompanyInfo: Record "Company Information";
        RethinkID: Guid;
        VendorIds: List of [Text];
        NameFromRethink: Text[250];
        i: Integer;
        j: Integer;
        Sucess: Boolean;
    begin
        Sucess := true;
        CompanyInfo.Get;
        if not CompanyInfo."ApX Is AppXite Company" then exit;
        Arguments.URL := CompanyInfo."ApX Base URI" + 'data/organization-info?workflowId=vendors.wrkf&createDateFrom=2019-07-01 04:30:48&createDateTill=2019-12-11 01:49:12';
        Arguments.RestMethod := Arguments.RestMethod::get;
        Arguments.Accept := 'application/json';
        Arguments.SASkey := CompanyInfo."ApX API Token";
        Vendor.SetCurrentKey("ApX ReThink ID");
        if CallRESTWebService(Arguments) then begin
            JSONArray.ReadFrom(Arguments.GetResponseContentAsText);
            for i := 0 to JSONArray.Count - 1 do begin
                JSONArray.Get(i, JSONToken);
                JSONObject := JSONToken.AsObject();
                VendorIds.Add(JSONMethod.GetJsonValueAsText(JSONObject, 'profileVendorId'));
            end;
        end else
            Sucess := false;
        Arguments.URL := CompanyInfo."ApX Base URI" + 'data/organization-info?workflowId=vendors.wrkf&modifyDateFrom=2019-07-01 04:30:48&modifyDateTill=2019-12-11 01:49:12';
        if CallRESTWebService(Arguments) then begin
            JSONArray.ReadFrom(Arguments.GetResponseContentAsText);
            for i := 0 to JSONArray.Count - 1 do begin
                JSONArray.Get(i, JSONToken);
                JSONObject := JSONToken.AsObject();
                VendorIds.Add(JSONMethod.GetJsonValueAsText(JSONObject, 'profileVendorId'));
            end;
        end else
            Sucess := false;
        for j := 1 to VendorIds.Count do begin
            Arguments.URL := CompanyInfo."ApX Base URI" + 'data/organization-info/organizations/' + VendorIds.Get(j) + '?workflowId=organizations.wrkf';
            if CallRESTWebService(Arguments) then begin
                JSONArray.ReadFrom(Arguments.GetResponseContentAsText);
                for i := 0 to JSONArray.Count - 1 do begin
                    JSONArray.Get(i, JSONToken);
                    JSONObject := JSONToken.AsObject();
                    RethinkID := JSONMethod.GetJsonValueAsText(JSONObject, 'id');
                    NameFromRethink := JSONMethod.GetJsonValueAsText(JSONObject, 'fullName');
                    Vendor.SetRange("ApX ReThink ID", RethinkID);
                    if not Vendor.FindFirst() then begin
                        Vendor.Init();
                        Vendor."No." := '';
                        Vendor."ApX ReThink ID" := RethinkID;
                        Vendor.Validate("ApX On-Boarding Required", true);
                        Vendor.Validate("ApX From ReThink", true);
                        Vendor.Insert(true);
                    end;
                    Vendor."ApX Name From ReThink" := NameFromRethink;
                    Vendor.Validate("ApX Last Modified - ReThink", CurrentDateTime());
                    Vendor.Validate(Name, CopyStr(NameFromRethink, 1, 100));
                    Vendor.Validate("Name 2", CopyStr(NameFromRethink, 101, 50));
                    Vendor.Validate("ApX Last Modified - ReThink", CurrentDateTime());
                    Vendor.Validate(Address, JSONMethod.GetJsonValueAsText(JSONObject, 'addressLine1'));
                    Vendor.Validate("Address 2", JSONMethod.GetJsonValueAsText(JSONObject, 'addressLine2'));
                    Vendor.Validate(City, JSONMethod.GetJsonValueAsText(JSONObject, 'city'));
                    Vendor.Validate(Contact, JSONMethod.GetJsonValueAsText(JSONObject, 'accountManager'));
                    Vendor.Validate("Country/Region Code", JSONMethod.GetJsonValueAsText(JSONObject, 'billingCountryCode'));
                    Vendor.Validate("Currency Code", JSONMethod.GetJsonValueAsText(JSONObject, 'currencyCode'));
                    Vendor.Validate("E-Mail", JSONMethod.GetJsonValueAsText(JSONObject, 'invoicingEmail'));
                    Vendor.Validate("Phone No.", JSONMethod.GetJsonValueAsText(JSONObject, 'accountManagerPhone'));
                    Vendor.Validate("Post Code", JSONMethod.GetJsonValueAsText(JSONObject, 'postalCode'));
                    Vendor.Validate("VAT Registration No.", CopyStr(JSONMethod.GetJsonValueAsText(JSONObject, 'vatNumber'), 1, 20));
                    Vendor.Modify(true);
                end;
            end else
                Sucess := false;
        end;
    end;

    procedure ProcessCustomersRequest()
    var
        Arguments: Record "ApX RESTWebServiceArguments" temporary;
        JSONMethod: Codeunit "ApX JSONMethods";
        JSONObject: JsonObject;
        JSONArray: JsonArray;
        JSONToken: JsonToken;
        Customer: Record Customer;
        CompanyInfo: Record "Company Information";
        RethinkID: Guid;
        CustomerIds: List of [Text];
        NameFromRethink: Text[250];
        i: Integer;
        j: Integer;
        Sucess: Boolean;
        id: Text[40];
    begin
        Sucess := true;
        CompanyInfo.Get;
        Arguments.URL := CompanyInfo."ApX Base URI" + 'data/organization-info/resellers/' + CompanyInfo."ApX ReThink Company ID" + '?workflowId=organizations.wrkf&createDateFrom=2019-08-17 05:50:54.0000000&createDateTill=2019-12-13 06:50:13.0155026';
        Arguments.RestMethod := Arguments.RestMethod::get;
        Arguments.Accept := 'application/json';
        Arguments.SASkey := CompanyInfo."ApX API Token";
        Customer.SetCurrentKey("ApX ReThink ID");
        if CallRESTWebService(Arguments) then begin
            JSONArray.ReadFrom(Arguments.GetResponseContentAsText);
            for i := 0 to JSONArray.Count - 1 do begin
                JSONArray.Get(i, JSONToken);
                JSONObject := JSONToken.AsObject();
                id := JSONMethod.GetJsonValueAsText(JSONObject, 'id');
                if not CustomerIds.Contains(id) then CustomerIds.Add(id);
            end;
        end else
            Sucess := false;
        Arguments.URL := CompanyInfo."ApX Base URI" + 'data/organization-info/resellers/' + CompanyInfo."ApX ReThink Company ID" + '?workflowId=organizations.wrkf&modifyDateFrom=2019-08-17 05:50:54.0000000&modifyDateTill=2019-12-13 06:50:13.0155026';
        if CallRESTWebService(Arguments) then begin
            JSONArray.ReadFrom(Arguments.GetResponseContentAsText);
            for i := 0 to JSONArray.Count - 1 do begin
                JSONArray.Get(i, JSONToken);
                JSONObject := JSONToken.AsObject();
                id := JSONMethod.GetJsonValueAsText(JSONObject, 'id');
                if not CustomerIds.Contains(id) then CustomerIds.Add(id);
            end;
        end else
            Sucess := false;
        if CompanyInfo."ApX Is AppXite Company" then begin
            Arguments.URL := CompanyInfo."ApX Base URI" + 'data/organization-info?workflowId=profileResellers.wrkf&createDateFrom=2019-08-17 05:50:54.0000000&createDateTill=2019-12-13 06:50:13.0155026';
            if CallRESTWebService(Arguments) then begin
                JSONArray.ReadFrom(Arguments.GetResponseContentAsText);
                for i := 0 to JSONArray.Count - 1 do begin
                    JSONArray.Get(i, JSONToken);
                    JSONObject := JSONToken.AsObject();
                    id := JSONMethod.GetJsonValueAsText(JSONObject, 'id');
                    if not CustomerIds.Contains(id) then CustomerIds.Add(id);
                end;
            end else
                Sucess := false;
            Arguments.URL := CompanyInfo."ApX Base URI" + 'data/organization-info?workflowId=profileResellers.wrkf&modifyDateFrom=2019-08-17 05:50:54.0000000&modifyDateTill=2019-12-13 06:50:13.0155026';
            if CallRESTWebService(Arguments) then begin
                JSONArray.ReadFrom(Arguments.GetResponseContentAsText);
                for i := 0 to JSONArray.Count - 1 do begin
                    JSONArray.Get(i, JSONToken);
                    JSONObject := JSONToken.AsObject();
                    id := JSONMethod.GetJsonValueAsText(JSONObject, 'id');
                    if not CustomerIds.Contains(id) then CustomerIds.Add(id);
                end;
            end else
                Sucess := false;
        end;
        for j := 1 to CustomerIds.Count do begin
            Arguments.URL := CompanyInfo."ApX Base URI" + 'data/organization-info/organizations/' + CustomerIds.Get(j) + '?workflowId=organizations.wrkf';
            if CallRESTWebService(Arguments) then begin
                JSONArray.ReadFrom(Arguments.GetResponseContentAsText);
                for i := 0 to JSONArray.Count - 1 do begin
                    JSONArray.Get(i, JSONToken);
                    JSONObject := JSONToken.AsObject();
                    RethinkID := JSONMethod.GetJsonValueAsText(JSONObject, 'id');
                    NameFromRethink := JSONMethod.GetJsonValueAsText(JSONObject, 'fullName');
                    Customer.SetRange("ApX ReThink ID", RethinkID);
                    if not Customer.FindFirst() then begin
                        Customer.Init();
                        Customer."No." := '';
                        Customer."ApX ReThink ID" := RethinkID;
                        Customer.Validate("ApX On-Boarding Required", true);
                        Customer.Validate("ApX From ReThink", true);
                        Customer.Insert(true);
                    end;
                    Customer."ApX Name From ReThink" := NameFromRethink;
                    Customer.Validate("ApX Last Modified - ReThink", CurrentDateTime());
                    Customer.Validate(Name, CopyStr(NameFromRethink, 1, 100));
                    Customer.Validate("Name 2", CopyStr(NameFromRethink, 101, 50));
                    Customer.Validate("ApX Last Modified - ReThink", CurrentDateTime());
                    Customer.Validate(Address, JSONMethod.GetJsonValueAsText(JSONObject, 'addressLine1'));
                    Customer.Validate("Address 2", JSONMethod.GetJsonValueAsText(JSONObject, 'addressLine2'));
                    Customer.Validate(City, JSONMethod.GetJsonValueAsText(JSONObject, 'city'));
                    Customer.Validate(Contact, JSONMethod.GetJsonValueAsText(JSONObject, 'accountManager'));
                    Customer.Validate("Country/Region Code", JSONMethod.GetJsonValueAsText(JSONObject, 'billingCountryCode'));
                    Customer.Validate(County, CopyStr(JSONMethod.GetJsonValueAsText(JSONObject, 'state'), 1, 30));
                    Customer.Validate("Currency Code", JSONMethod.GetJsonValueAsText(JSONObject, 'currencyCode'));
                    Customer.Validate("E-Mail", JSONMethod.GetJsonValueAsText(JSONObject, 'invoicingEmail'));
                    Customer.Validate("Phone No.", JSONMethod.GetJsonValueAsText(JSONObject, 'accountManagerPhone'));
                    Customer.Validate("Post Code", JSONMethod.GetJsonValueAsText(JSONObject, 'postalCode'));
                    Customer.Validate("ApX Registration No.", CopyStr(JSONMethod.GetJsonValueAsText(JSONObject, 'registrationNumber'), 1, 20));
                    Customer.Validate("VAT Registration No.", CopyStr(JSONMethod.GetJsonValueAsText(JSONObject, 'vatNumber'), 1, 20));
                    Customer.Modify(true);
                end;
            end else
                Sucess := false;
        end;
    end;

    procedure ProcessBillingDataRequest()
    var
        Arguments: Record "ApX RESTWebServiceArguments" temporary;
        JSONMethod: Codeunit "ApX JSONMethods";
        JSONObject: JsonObject;
        //JSONObjectL: JsonObject;
        JSONArrayH: JsonArray;
        JSONArrayL: JsonArray;
        JSONToken: JsonToken;
        BillingHeader: Record "ApX ReThink Billing Header";
        BillingLine: Record "ApX ReThink Billing Line";
        CompanyInfo: Record "Company Information";
        RethinkID: Guid;
        InvoiceId: Text[40];
        RowId: Text[40];
        CompanyId: Text[40];
        NameFromRethink: Text[250];
        i: Integer;
        j: Integer;
    begin
        CompanyInfo.Get;
        Arguments.URL := CompanyInfo."ApX Base URI" + 'invoices/invoice-headers?workflowId=invoicing-rawdata.wrkf&refreshDateFrom=2019-12-11 00:00:00&refreshDateTill=2019-12-12 00:00:00';
        Arguments.RestMethod := Arguments.RestMethod::get;
        Arguments.Accept := 'application/json';
        Arguments.SASkey := CompanyInfo."ApX API Token";
        BillingHeader.SetCurrentKey(invoicesId);
        if CallRESTWebService(Arguments) then begin
            JSONArrayH.ReadFrom(Arguments.GetResponseContentAsText);
            for i := 0 to JSONArrayH.Count - 1 do begin
                JSONArrayH.Get(i, JSONToken);
                JSONObject := JSONToken.AsObject();
                CompanyId := JSONMethod.GetJsonValueAsText(JSONObject, 'invoiceProviderId');
                if CompanyInfo."ApX ReThink Company ID" = CompanyId then begin
                    InvoiceId := JSONMethod.GetJsonValueAsText(JSONObject, 'invoicesId');
                    Arguments.URL := CompanyInfo."ApX Base URI" + 'invoices/' + InvoiceId + '/invoice-rows?workflowId=invoicing-rawdata.wrkf&dateFrom=2019-12-01T00:00:00Z&dateTill=2019-12-12 00:00:00';
                    BillingHeader.SetRange(invoicesId, InvoiceId);
                    if not BillingHeader.FindFirst() then begin
                        BillingHeader.Init();
                        BillingHeader.invoicesId := InvoiceId;
                        BillingHeader.invoiceProviderId := CompanyId;
                        BillingHeader.invoicesNumber := JSONMethod.GetJsonValueAsInteger(JSONObject, 'invoicesNumber');
                        BillingHeader.invoiceProvider := JSONMethod.GetJsonValueAsText(JSONObject, 'invoiceProvider');
                        BillingHeader.invoiceReceiverId := JSONMethod.GetJsonValueAsText(JSONObject, 'invoiceReceiverId');
                        BillingHeader.invoiceReceiver := JSONMethod.GetJsonValueAsText(JSONObject, 'invoiceReceiver');
                        BillingHeader."receiver country" := JSONMethod.GetJsonValueAsText(JSONObject, 'receiver country');
                        BillingHeader."receiver VAT number" := JSONMethod.GetJsonValueAsText(JSONObject, 'receiver VAT number');
                        BillingHeader."billing address" := JSONMethod.GetJsonValueAsText(JSONObject, 'billing address');
                        BillingHeader."account manager" := JSONMethod.GetJsonValueAsText(JSONObject, 'account manager');
                        BillingHeader."account manager email" := JSONMethod.GetJsonValueAsText(JSONObject, 'account manager email');
                        BillingHeader.comments := JSONMethod.GetJsonValueAsText(JSONObject, 'comments');
                        BillingHeader.invoicesDate := JSONMethod.GetJsonValueAsDateTime(JSONObject, 'invoicesDate');
                        BillingHeader.invoiceCurrency := JSONMethod.GetJsonValueAsText(JSONObject, 'invoiceCurrency');
                        BillingHeader.totalPriceCheckSum := JSONMethod.GetJsonValueAsDecimal(JSONObject, 'totalPriceCheckSum');
                        BillingHeader.rateToEuro := JSONMethod.GetJsonValueAsDecimal(JSONObject, 'rateToEuro');
                        BillingHeader."billing period start" := CreateDateTime(JSONMethod.GetJsonValueAsDate(JSONObject, 'billingPeriodFromDate'), 0T);
                        BillingHeader."billing period end" := CreateDateTime(JSONMethod.GetJsonValueAsDate(JSONObject, 'billingPeriodTillDate'), 0T);
                        BillingHeader.Status := BillingHeader.Status::New;
                        BillingHeader."Status Time Stamp" := CurrentDateTime();
                        BillingHeader.Insert(true);
                    end;
                    if CallRESTWebService(Arguments) then begin
                        JSONArrayL.ReadFrom(Arguments.GetResponseContentAsText);
                        for j := 0 to JSONArrayL.Count - 1 do begin
                            JSONArrayL.Get(j, JSONToken);
                            JSONObject := JSONToken.AsObject();
                            RowId := JSONMethod.GetJsonValueAsText(JSONObject, 'rowId');
                            BillingLine.SetRange(invoicesId, InvoiceId);
                            BillingLine.SetRange(RowId, RowId);
                            if not BillingLine.FindFirst() then begin
                                BillingLine.Init();
                                BillingLine.invoicesId := InvoiceId;
                                BillingLine.rowId := RowId;
                                BillingLine.invoicesNumber := JSONMethod.GetJsonValueAsInteger(JSONObject, 'invoicesNumber');
                                BillingLine.subscriptionId := JSONMethod.GetJsonValueAsText(JSONObject, 'subscriptionId');
                                BillingLine.subscriptionName := JSONMethod.GetJsonValueAsText(JSONObject, 'subscriptionName');
                                BillingLine.subscriptionStartDate := JSONMethod.GetJsonValueAsDateTime(JSONObject, 'subscriptionStartDate');
                                BillingLine.subscriptionEndDate := JSONMethod.GetJsonValueAsDateTime(JSONObject, 'subscriptionEndDate');
                                BillingLine."vendor Subscription Id txt" := JSONMethod.GetJsonValueAsText(JSONObject, 'vendor Subscription Id');
                                BillingLine."charge start date" := JSONMethod.GetJsonValueAsDateTime(JSONObject, 'charge start date');
                                BillingLine."charge end date" := JSONMethod.GetJsonValueAsDateTime(JSONObject, 'charge end date');
                                BillingLine.offerId := JSONMethod.GetJsonValueAsText(JSONObject, 'offerId');
                                BillingLine.offerName := JSONMethod.GetJsonValueAsText(JSONObject, 'offerName');
                                BillingLine.ShortOfferName := JSONMethod.GetJsonValueAsText(JSONObject, 'offerShortName');
                                BillingLine."vendor Offer Id" := JSONMethod.GetJsonValueAsText(JSONObject, 'vendor Offer Id');
                                BillingLine.ProductName := JSONMethod.GetJsonValueAsText(JSONObject, 'productsName');
                                BillingLine.invoiceDataContractType := JSONMethod.GetJsonValueAsText(JSONObject, 'invoiceDataContractType');
                                BillingLine.invoiceChargeTypes := JSONMethod.GetJsonValueAsText(JSONObject, 'invoiceChargeTypes');
                                BillingLine.quantity := JSONMethod.GetJsonValueAsDecimal(JSONObject, 'quantity');
                                BillingLine.unitPrice := JSONMethod.GetJsonValueAsDecimal(JSONObject, 'unitPrice');
                                BillingLine.totalPrice := JSONMethod.GetJsonValueAsDecimal(JSONObject, 'totalPrice');
                                BillingLine.resellerPrice := JSONMethod.GetJsonValueAsDecimal(JSONObject, 'resellerPrice');
                                BillingLine.retailPrice := JSONMethod.GetJsonValueAsDecimal(JSONObject, 'retailPrice');
                                BillingLine."retail Price Source" := JSONMethod.GetJsonValueAsText(JSONObject, 'retail Price Source');
                                BillingLine."retail Price Markup" := JSONMethod.GetJsonValueAsDecimal(JSONObject, 'retail Price Markup');
                                BillingLine."customer Markup" := JSONMethod.GetJsonValueAsDecimal(JSONObject, 'customer Markup');
                                BillingLine."price Markup Start Date" := JSONMethod.GetJsonValueAsDateTime(JSONObject, 'price Markup Start Date');
                                BillingLine.vendorOrgId := JSONMethod.GetJsonValueAsText(JSONObject, 'vendorOrgId');
                                BillingLine.vendorOrg := JSONMethod.GetJsonValueAsText(JSONObject, 'vendorOrg');
                                BillingLine.resellerOrgId := JSONMethod.GetJsonValueAsText(JSONObject, 'resellerOrgId');
                                BillingLine.resellerOrg := JSONMethod.GetJsonValueAsText(JSONObject, 'resellerOrg');
                                BillingLine.customerOrgId := JSONMethod.GetJsonValueAsText(JSONObject, 'customerOrgId');
                                BillingLine.customerOrg := JSONMethod.GetJsonValueAsText(JSONObject, 'customerOrg');
                                BillingLine.Insert(true);
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
}