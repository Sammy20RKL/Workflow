codeunit 50122 MyPublishers
{
    procedure CheckInvoiceApprovalsWorkflowEnabled(var RecRef: RecordRef): Boolean
    begin
        if not WorkflowManagement.CanExecuteWorkflow(RecRef, GetWorkflowCode(RunWorkflowOnSendForApprovalCode, RecRef)) then
            Error(NoWorkflowEnabledErr);

        exit(true);
    end;

    procedure GetWorkflowCode(WorkflowCode: Code[128]; RecRef: RecordRef): Code[128]
    begin
        exit(DelChr(StrSubstNo(WorkflowCode, RecRef.Name), '=', ''));
    end;

    [IntegrationEvent(false, false)]
    procedure OnAddressLineChange(line: Text[150])
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendWorkflowForApproval(var RecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelWorkflowForApproval(var RecRef: RecordRef)
    begin
    end;
    //add event to library
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", OnAddWorkflowEventsToLibrary, '', false, false)]
    local procedure OnAddWorkflowEventsToLibrary()

    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        RecRef: RecordRef;
    begin
        RecRef.Open(Database::Administration);
        WorkflowEventHandling.AddEventToLibrary(GetWorkflowCode(RunWorkflowOnSendForApprovalCode, RecRef), Database::Administration,
GetWorkflowEventDesc(WorkflowSendForApprovalEventDescTxt, RecRef), 0, false);
        WorkflowEventHandling.AddEventToLibrary(GetWorkflowCode(RunWorkflowOnCancelForApprovalCode, RecRef), DATABASE::Administration,
          GetWorkflowEventDesc(WorkflowCancelForApprovalEventDescTxt, RecRef), 0, false);

    end;

    procedure GetWorkflowEventDesc(WorkflowCodeEventDesc: Text; RecRef: RecordRef): Text
    begin
        exit(StrSubstNo(WorkflowCodeEventDesc, RecRef.Name));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::MyPublishers, 'OnSendWorkflowForApproval', '', false, false)]
    local procedure RunWorkflowOnSendWorkflowForApproval(var RecRef: RecordRef)
    begin
        WorkflowManagement.HandleEvent(GetWorkflowCode(RunWorkflowOnSendForApprovalCode, RecRef), RecRef);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::MyPublishers, 'OnCancelWorkflowForApproval', '', false, false)]
    local procedure RunWorkflowOnCancelWorkflowForApproval(var RecRef: RecordRef)
    begin
        WorkflowManagement.HandleEvent(GetWorkflowCode(RunWorkflowOnCancelForApprovalCode, RecRef), RecRef);
    end;

    //handle the document
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", OnOpenDocument, '', false, false)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        Adminstration: Record Administration;
    begin
        case RecRef.Number of
            Database::Administration:
                begin
                    RecRef.SetTable(Adminstration);
                    Adminstration.Validate(Status, Adminstration.Status::open);
                    Adminstration.Modify(true);
                    Handled := true;
                end;
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnSetStatusToPendingApproval, '', false, false)]
    local procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        Adminstration: Record Administration;
    begin
        case RecRef.Number of
            Database::Administration:
                begin
                    RecRef.SetTable(Adminstration);
                    Adminstration.Validate(Status, Adminstration.Status::pending);
                    Adminstration.Modify(true);
                    Variant := Adminstration;
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnPopulateApprovalEntryArgument, '', false, false)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        Adminstration: Record Administration;
    begin
        case RecRef.Number of
            Database::Administration:
                begin
                    RecRef.SetTable(Adminstration);

                    ApprovalEntryArgument."Document No." := Adminstration.Name;
                end;
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", OnReleaseDocument, '', false, false)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        Admin: Record Administration;
    begin
        case RecRef.Number of
            Database::Administration:
                begin
                    RecRef.SetTable(Admin);
                    Admin.Validate(Status, Admin.Status::approved);
                    Admin.Modify(true);
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnRejectApprovalRequest, '', false, false)]
    local procedure OnRejectApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        Admin: Record Administration;
    begin
        case ApprovalEntry."Table ID" of
            Database::Administration:
                begin
                    if Admin.Get(ApprovalEntry."Document No.") then begin
                        Admin.Validate(Status, Admin.Status::rejected);
                        Admin.Modify(true);
                    end;
                end;
        end;
    end;


    var
        WorkflowManagement: Codeunit "Workflow Management";
        s: Codeunit "Workflow Event Handling";
        f: Codeunit "Approvals Mgmt.";

        RunWorkflowOnSendForApprovalCode: Label 'RunWorkflowOnSend%1ForApprovalCode';
        RunWorkflowOnCancelForApprovalCode: Label 'RunWorkflowOnCancel%1ForApprovalCode';
        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
        WorkflowSendForApprovalEventDescTxt: Label 'Approval of a %1 is requested.';
        WorkflowCancelForApprovalEventDescTxt: Label 'Approval of a %1 is canceled.';




}