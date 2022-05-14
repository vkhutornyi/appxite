codeunit 70155331 "ApX JSONMethods"
{
    procedure GetJsonValueAsText(var JSonObject: JsonObject; Property: Text) Value: text
    var
        JsonValue: JsonValue;
    begin
        Value := '';
        if not GetJsonValue(JSonObject, Property, JsonValue) then
            exit;
        if not JsonValue.IsNull then
            Value := JsonValue.AsText;
    end;

    procedure GetJsonValueAsDate(var JSonObject: JsonObject; Property: Text) Value: Date
    var
        JsonValue: JsonValue;
    begin
        Value := 0D;
        if not GetJsonValue(JSonObject, Property, JsonValue) then
            exit;
        if not JsonValue.IsNull then
            Value := JsonValue.AsDate();
    end;

    procedure GetJsonValueAsDateTime(var JSonObject: JsonObject; Property: Text) Value: DateTime
    var
        JsonValue: JsonValue;
    begin
        Value := 0DT;
        if not GetJsonValue(JSonObject, Property, JsonValue) then
            exit;
        if not JsonValue.IsNull then
            Value := JsonValue.AsDateTime();
    end;

    procedure GetJsonValueAsDecimal(var JSonObject: JsonObject; Property: Text) Value: Decimal
    var
        JsonValue: JsonValue;
    begin
        Value := 0.0;
        if not GetJsonValue(JSonObject, Property, JsonValue) then
            exit;
        if not JsonValue.IsNull then
            Value := JsonValue.AsDecimal();
    end;

    procedure GetJsonValueAsInteger(var JSonObject: JsonObject; Property: Text) Value: Integer
    var
        JsonValue: JsonValue;
    begin
        Value := 0;
        if not GetJsonValue(JSonObject, Property, JsonValue) then
            exit;
        if not JsonValue.IsNull then
            Value := JsonValue.AsInteger();
    end;

    procedure GetJsonValue(var JSonObject: JsonObject; Property: Text; var JsonValue: JsonValue): Boolean
    var
        JsonToken: JsonToken;
    begin
        if not JSonObject.Get(Property, JsonToken) then
            exit;
        JsonValue := JsonToken.AsValue();
        exit(true);
    end;
}