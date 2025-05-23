codeunit 50107 "Custom Workflow Mgmt"
{

    procedure CheckApprovalsWorkflowEnabled(var RecRef: RecordRef): Boolean
    begin
        if not WorkflowMgt.CanExecuteWorkflow(RecRef, GetWorkflowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef)) then
            Error(NoWorkflowEnabledErr);
        exit(true);
    end;

    procedure GetWorkflowCode(WorkflowCode: code[128]; RecRef: RecordRef): Code[128]
    begin
        exit(DelChr(StrSubstNo(WorkflowCode, RecRef.Name), '=', ' '));
    end;



    [IntegrationEvent(false, false)]
    procedure OnSendWorkflowForApproval(var RecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelWorkflowForApproval(var RecRef: RecordRef)
    begin
    end;



    //add event to the libray

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventsToLibrary()
    var
        RecRef: RecordRef;
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    //   v: Codeunit "Workflow Response Handling";
    // t: Codeunit "Approvals Mgmt.";
    // y: Codeunit "Release Incoming Document";
    //  r: Record "Employee";




    begin
        RecRef.Open(Database::"Custom Worlkflow");
        WorkflowEventHandling.AddEventToLibrary(GetWorkflowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef), DATABASE::"Custom Worlkflow",
          GetWorkflowEventDesc(WorkflowSendForApprovalEventDescTxt, RecRef), 0, false);
        WorkflowEventHandling.AddEventToLibrary(GetWorkflowCode(RUNWORKFLOWONCANCELFORAPPROVALCODE, RecRef), DATABASE::"Custom Worlkflow",
          GetWorkflowEventDesc(WorkflowCancelForApprovalEventDescTxt, RecRef), 0, false);

    end;
    //subscribe

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Custom Workflow Mgmt", 'OnSendWorkflowForApproval', '', false, false)]
    local procedure RunWorkflowOnSendWorkflowForApproval(var RecRef: RecordRef)
    begin
        WorkflowMgt.HandleEvent(GetWorkflowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef), RecRef);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Custom Workflow Mgmt", 'OnCancelWorkflowForApproval', '', false, false)]
    local procedure RunWorkflowOnCancelWorkflowForApproval(var RecRef: RecordRef)
    begin
        WorkflowMgt.HandleEvent(GetWorkflowCode(RUNWORKFLOWONCancelFORAPPROVALCODE, RecRef), RecRef);
    end;

    procedure GetWorkflowEventDesc(WorkflowEventDesc: Text; RecRef: RecordRef): Text
    begin
        exit(StrSubstNo(WorkflowEventDesc, RecRef.Name));
    end;

    //handle the document
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        CustomWorlkflow: Record "Custom Worlkflow";
    begin
        case RecRef.Number of
            Database::"Custom Worlkflow":
                begin
                    RecRef.SetTable(CustomWorlkflow);
                    CustomWorlkflow.Validate(Status, CustomWorlkflow.Status::Open);
                    CustomWorlkflow.Modify(true);
                    Handled := true;
                end;

        end

    end;

    //handle the document
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnSetStatusToPendingApproval, '', false, false)]
    local procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        CustomWorlkflow: Record "Custom Worlkflow";

    begin
        case RecRef.Number of
            Database::"Custom Worlkflow":
                begin
                    case RecRef.Number of
                        Database::"Custom Worlkflow":
                            begin
                                RecRef.SetTable(CustomWorlkflow);
                                CustomWorlkflow.Validate(Status, CustomWorlkflow.Status::Pending);
                                CustomWorlkflow.Modify(true);
                                Variant := CustomWorlkflow;
                                IsHandled := true;

                            end;
                    end;

                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', false, false)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        CustomWorlkflow: Record "Custom Worlkflow";
    begin
        case RecRef.Number of
            Database::"Custom Worlkflow":
                begin
                    RecRef.SetTable(CustomWorlkflow);

                    ApprovalEntryArgument."Document No." := CustomWorlkflow."No.";
                end;
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        CustomWorkflow: Record "Custom Worlkflow";
    begin
        case RecRef.Number of
            Database::"Custom Worlkflow":
                begin
                    RecRef.SetTable(CustomWorkflow);
                    CustomWorkflow.Validate(Status, CustomWorkflow.Status::Approved);
                    CustomWorkflow.Modify(true);
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
    local procedure OnRejectApprovalRequest(var ApprovalEntry: Record "Approval Entry")

    var
        RecRef: RecordRef;
        CustomWorlkflow: Record "Custom Worlkflow";
        g: Codeunit "Record Restriction Mgt.";
        t: Record "Finance Charge Interest Rate";
        y: Record "Human Resources Setup";
    begin
        case ApprovalEntry."Table ID" of
            Database::"Custom Worlkflow":
                begin
                    if CustomWorlkflow.Get(ApprovalEntry."Document No.") then begin
                        CustomWorlkflow.Validate(Status, CustomWorlkflow.Status::Rejected);
                        CustomWorlkflow.Modify(true);
                    end;
                end;
        end;
    end;

    var

        WorkflowMgt: Codeunit "Workflow Management";

        RUNWORKFLOWONSENDFORAPPROVALCODE: Label 'RUNWORKFLOWONSEND%1FORAPPROVAL';
        RUNWORKFLOWONCANCELFORAPPROVALCODE: Label 'RUNWORKFLOWONCANCEL%1FORAPPROVAL';
        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
        WorkflowSendForApprovalEventDescTxt: Label 'Approval of %1 is requested.';
        WorkflowCancelForApprovalEventDescTxt: Label 'Approval of %1 is canceled.';



}
