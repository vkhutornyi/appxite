pageextension 70155327 "ApX Pag76 ResourceCard Ext" extends "Resource Card"
{
    layout
    {
        addafter("Last Date Modified")
        {
            field("ApX Last Modified - ReThink"; "ApX Last Modified - ReThink")
            {
                Caption = 'Last Modified - ReThink';
                Editable = false;
                ApplicationArea = All;
            }
        }
        addafter("ApX Last Modified - ReThink")
        {
            field("ApX ReThink ID"; "ApX ReThink ID")
            {
                Caption = 'ReThink ID';
                Editable = false;
                ApplicationArea = All;
            }
        }
        addlast(General)
        {
            field("ApX On-Boarding Required"; "ApX On-Boarding Required")
            {
                Caption = 'On-Boarding Required';
                ApplicationArea = All;
            }
        }
        addafter("ApX ReThink ID")
        {
            field("ApX Name From ReThink"; "ApX Name From ReThink")
            {
                Caption = 'Name From ReThink';
                Editable = false;
                ApplicationArea = All;
            }
        }
        addafter(Name)
        {
            field("ApX Name 2"; "Name 2")
            {
                Caption = 'Name 2';
                ApplicationArea = All;
            }
        }
        addafter(Type)
        {
            field("ApX Type"; Type)
            {
                ApplicationArea = All;
                Caption = 'Type';
                ToolTip = 'Specifies whether the resource is a software or a machine.';
            }
        }
        modify(Type)
        {
            Visible = false;
        }
    }


}