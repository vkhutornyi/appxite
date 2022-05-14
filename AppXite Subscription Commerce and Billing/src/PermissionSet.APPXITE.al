permissionset 70155324 APXITE
{
    Assignable = true;
    Caption = 'AppXite Permissions', MaxLength = 30;
    Permissions =
        tabledata "ApX Email Log Header" = RMID,
        tabledata "ApX ReThink Billing Header" = RMID,
        tabledata "ApX ReThink Billing Line" = RMID,
        tabledata "ApX ReThink Error" = RMID,
        tabledata "ApX ReThink Cust. Ledger Entry" = RMID,
        tabledata "ApX Email Log Line" = RMID,
        tabledata "ApX Sales Doc PDF File" = RMID,
        tabledata "ApX ReThink Deferral Template" = RMID,
        tabledata "ApX RESTWebServiceArguments" = RMID;
}
