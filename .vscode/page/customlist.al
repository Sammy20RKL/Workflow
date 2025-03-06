page 50123 "Workflow List"
{
    PageType = List;
    ApplicationArea = All;
    Caption = 'Workflow List';
    UsageCategory = Lists;
    SourceTable = "Custom Worlkflow";
    CardPageId = "Workflow Card";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';

                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';

                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';

                }

            }
        }
    }


}