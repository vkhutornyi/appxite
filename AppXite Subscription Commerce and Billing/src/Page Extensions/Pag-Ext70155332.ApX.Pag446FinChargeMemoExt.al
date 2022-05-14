pageextension 70155332 "ApX Pag446 FinChargeMemo Ext" extends "Finance Charge Memo"
{
    layout
    {
        addafter("Assigned User ID"){
            field("ApX Ready To Issue";"ApX Ready To Issue")
            {
                ApplicationArea = All,Basic,Suite,Advanced;
            }
        }
    }
        
}