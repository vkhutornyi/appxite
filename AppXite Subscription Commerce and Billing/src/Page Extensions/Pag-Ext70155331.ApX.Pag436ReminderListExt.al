pageextension 70155331 "ApX Pag436 ReminderList Ext" extends "Reminder List"
{
    actions
    {
        addafter("F&unctions")
        {
            action("ApX CreateReminderBeforeDueDate")
            {
                Caption='AppXite Create Reminders';
                ToolTip='AppXite Create reminders for one or more customers with overdue payments.';
                ApplicationArea=Basic,Suite;
                Image=CreateReminders;
                Promoted=true;
                PromotedCategory=Process;
                Ellipsis=true;
                RunObject=report "ApX Create Reminders";
            }
            action("ApX SuggestReminderLinesBeforeDueDate")
            {
                Caption='AppXite Suggest Reminder Lines';
                ToolTip='AppXite Create reminder lines in existing reminders for any overdue payments based on information in the Reminder window.';
                ApplicationArea=Basic,Suite;
                Image=SuggestReminderLines;
                Promoted=true;
                PromotedCategory=Process;
                Ellipsis=true;
                RunObject=report "ApX Create Reminders";
            }
        }
    }
}