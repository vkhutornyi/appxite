report 70155325 "ApX ReThink Data Errors"
{
    Caption = 'ReThink Data Errors';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/Rep70155325.ApX.ReThinkDataErrors.rdl'; // if Word use WordLayout property    
    dataset
    {
        dataitem("ReThink Error"; "ApX ReThink Error")
        {
            RequestFilterFields = invoicesNumber, "Time Created";
            column(invoicesNumber; invoicesNumber)
            { }
            column(rowId; rowId)
            { }
            column(Data_Type; "Data Type")
            { }
            column(Error_Type; "Error Type")
            { }
            column(Comment; Comment)
            { }
            column(Time_Created; "Time Created")
            { }
            column(Resolved; Resolved)
            { }
        }

    }
}