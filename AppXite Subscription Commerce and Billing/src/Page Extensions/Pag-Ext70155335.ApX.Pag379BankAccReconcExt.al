pageextension 70155335 "ApX Pag379 BankAccReconc Ext" extends "Bank Acc. Reconciliation"
{
    actions
    {
        addafter(SuggestLines)
        {
            action("ApX TransferToGenJnl")
            {
                Caption='Transfer to General Journal AppXite';
                ToolTip='Transfer the lines from the current window to the General Journal.';
                ApplicationArea=Basic,Suite;
                Image=TransferToGeneralJournal;
                Promoted=true;
                PromotedCategory=Process;
                Ellipsis=true; 
                trigger OnAction()
                var
                    TransferToGJnlAppXite: Report "ApX Transfer Bank Rec. to GJ";
                begin
                    TransferToGJnlAppXite.SetBankAccRecon(Rec);
                    TransferToGJnlAppXite.RUN;
                end;              
            }
        }
    }
    

}