
page 50139 "Administration card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Administration;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Age; Rec.Age)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Admin)
            {
                Caption = 'Admin';
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
            group(Approval)
            {
                Caption = 'Approval';
                Image = Approvals;
                action(Approve)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Approve';
                    Image = Approve;
                    ToolTip = 'Approve the requested changes';
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = OpenApprovalEntriesExistCurrUser;
                    trigger OnAction()
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Image = Reject;
                    ToolTip = 'Reject the approval request';
                    Visible = OpenApprovalEntriesExistCurrUser;
                    Promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Delegate';
                    Image = Delegate;
                    ToolTip = 'Delegate the approval to a substitute approver';
                    Enabled = OpenApprovalEntriesExistCurrUser;
                    Promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comment';
                    Image = Comment;
                    ToolTip = 'View or add comment in the record';
                    Enabled = OpenApprovalEntriesExistCurrUser;
                    Promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec.RecordId);
                    end;
                }
                action(Approvals)
                {
                    ApplicationArea = All;
                    Caption = 'Approvals';
                    Image = Approvals;
                    ToolTip = 'Open approvals entry exist in the record';
                    Enabled = HasApprovalsEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    begin
                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                    end;
                }
            }

        }
    }
    trigger OnAfterGetRecord()
    begin
        OpenApprovalEntriesExistCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        OpenCancelApprovalEntriesExist := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);
        HasApprovalsEntries := ApprovalsMgmt.HasApprovalEntries(Rec.RecordId);
    end;


    var
        OpenApprovalEntriesExistCurrUser, OpenApprovalEntriesExist, OpenCancelApprovalEntriesExist,
       HasApprovalsEntries : Boolean;

        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
}