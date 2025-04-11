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
            group(admin)
            {
                action(Send)
                {
                    ApplicationArea = Basic;
                    Caption = 'Send';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    Enabled = NOT OpenApprovalEntriesExist;
                    trigger OnAction()
                    var
                        MyPublisher: Codeunit MyPublishers;
                        RecRef: RecordRef;
                    begin
                        if MyPublisher.CheckInvoiceApprovalsWorkflowEnabled(RecRef) then
                            MyPublisher.OnSendWorkflowForApproval(RecRef);
                    end;
                }
                action(Cancel)
                {
                    ApplicationArea = All;
                    Caption = 'Cancel';
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    Enabled = NOT OpenCancelApprovalEntriesExist;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        MyPublisher: Codeunit MyPublishers;
                        RecRef: RecordRef;
                    begin
                        MyPublisher.OnCancelWorkflowForApproval(RecRef);

                    end;
                }

            }
        }
    }
    var
        OpenApprovalEntriesExistCurrUser, OpenApprovalEntriesExist, OpenCancelApprovalEntriesExist,
       HasApprovalsEntries : Boolean;

        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
}