pageextension 50124 "purchase&payable" extends "Purchases & Payables Setup"
{
    layout
    {

        addafter("Posted Invoice Nos.")
        {
            field("Workflow Header No."; Rec."Workflow Header No.")
            {
                ApplicationArea = All;
            }
        }

    }


}