/*codeunit 50135 ResponseHandling
{
    [IntegrationEvent(false, false)]
    local procedure MyWorkflowResponseCode(): Code[128];
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddMyWorkflowResponseToLibrary', '', true, true)]
    local procedure AddMyWorkflowResponseToLibrary()
    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(MyWorkflowResponseCode(), Database::"Purchase Header", 'Send Notification of sales', 'Group 0')
    end;
}*/
/* codeunit 50125 Publication
{
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;
} */