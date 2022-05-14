pageextension 70155340 "ApX Pag459 SalesRecSetup Ext" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(General)
        {
            field("ApX Max Inv Lines to Display"; "ApX Max Inv Lines to Display")
            {
                ApplicationArea = All;
            }
            field("ApX Reseller Liability Account"; "ApX Reseller Liability Account")
            {
                ApplicationArea = All;
            }
        }

        addafter("Dynamics 365 Sales")
        {
            group("ApX Email")
            {
                field("ApX Sales Doc Internal Email"; "ApX Sales Doc Internal Email")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        addlast("Navigation")
        {
            Action("ApX ReThink Deferral Templates")
            {
                Caption = 'ReThink Deferral Templates';
                RunObject = page "ApX ReThink Deferral Templates";
                Image = Template;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
            }
            Action("ApX ReThink Billing Headers")
            {
                Caption = 'ReThink Billing Headers';
                RunObject = page "ApX ReThink Billing Headers";
                Image = Table;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
            }
            Action("ApX Email Logs")
            {
                Caption = 'Email Logs';
                RunObject = page "ApX Email Log Headers";
                Image = Log;
                Promoted = false;
                ApplicationArea = All;
            }
            action("ApX Delete Email Log History")
            {
                Caption = 'Delete Email Log History';
                RunObject = report "ApX Remove Email Log History";
                Image = Report;
                Promoted = false;
                ApplicationArea = All;

            }
            action("ApX Customer Report Selections")
            {
                Caption = 'Customer Report Selections';
                RunObject = page "Customer Report Selections";
                Image = ListPage;
                Promoted = false;
                ApplicationArea = All;
            }
            action("ApX Process Posted Documents")
            {
                Caption = 'Process Posted Documents';
                RunObject = codeunit "ApX Email Sales Documents";
                Image = ListPage;
                Promoted = false;
                ApplicationArea = All;
            }
            action("ApX On-Boarding Status")
            {
                Caption = 'On-Boarding Status';
                RunObject = report "ApX On-Boarding Status Report";
                Image = Report;
                Promoted = false;
                ApplicationArea = All;
            }
        }
    }
}