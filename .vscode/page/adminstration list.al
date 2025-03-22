page 50138 "Administration list"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Administration;
    CardPageId = "Administration Card";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the name';
                }
                field(Age; Rec.Age)
                {
                    ToolTip = 'Specifies the age';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the status';
                }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }
}