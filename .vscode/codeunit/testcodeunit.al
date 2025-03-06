/*
To add the workflow event code to the Workflow Event table

[EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', true, true)]
    procedure AddMyWorkflowEventsToLibrary()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(MyWorkflowEventCode(), Database::"Purchase Header", 'My workflow event description', 0, false);
    end;


To publish an event that the workflow event subscribes to

Create another codeunit, such as MyEvents.codeunit.al,
 and add a method that publishes your event.
  Name the method to reflect that it is used as the publisher event, such as OnAfterPostPurchaseHeader.


codeunit 50102 MyEvents
{
    [IntegrationEvent(false, false)]
    procedure OnAfterPostPurchaseHeader(PurchaseHeader: Record "Purchase Header")
    begin
    end;
}

To raise the event
Create an object or an extension object to add the code that will raise the event that triggers the workflow event, such as the Purch.-Post codeunit.

The following code raises the event by extending the Purchase Orderpage object in a new file, MyPurchOrder.PageExt.al.

pageextension 50100 WFW_PurchaseOrder extends "Purchase Order"
{
    layout
    {
        modify(Status)
        {
            trigger OnBeforeValidate();
            var
                MyEvents: Codeunit MyEvents;
            begin
                MyEvents.OnAfterPostPurchaseHeader(Rec)
            end;
        }
    }
}

 To subscribe to the event and implement the workflow event
Go back to the MyWorkflowEvents.codeunit.al file and add another method in the MyWorkflowEvents codeunit. Name the new method to reflect that it is used to subscribe to and implement the workflow event, such as RunWorkflowOnAfterPostPurchaseHeader.
The following code illustrates the new workflow event that subscribes to your previously created event:

[EventSubscriber(ObjectType::Codeunit, Codeunit::MyEvents, 'OnAfterPostPurchaseHeader', '', true, true)]
 local procedure RunWorkflowOnAfterPostPurchaseHeader(var PurchaseHeader: Record "Purchase Header")
 var
     WorkflowManagement: Codeunit "Workflow Management";
 begin
     WorkflowManagement.HandleEvent(MyWorkflowEventCode, PurchaseHeader);
 end;

 Workflow response
Create a new .al file, such as MyWorkflowResponses.codeunit.al, with code to identify the workflow response, add the workflow response code to the library, implement the workflow response, and then enable that the workflow response can be executed.

To create a workflow response code that identifies the workflow response
Add a new codeunit that will be used for the new workflow responses. Name it to reflect that it handles your new responses, such MyWorkflowResponses.

Add a method in the codeunit. Name the method to reflect that it is used to identify the workflow response, such as MyWorkflowResponseCode with a return value of code (128).

 To add the workflow response code to the Workflow Response table
1. Add another method in the codeunit that will be the event subscriber. Name it to reflect that it is used to add the workflow response to the library, such as AddMyWorkflowResponsesToLibrary and set it to subscribe to the OnAddWorkflowResponsesToLibrarymethod in theWorkflow Response Handling` codeunit.

[EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', false, false)]
 local procedure AddWorkflowEventHierarchiesToLibrary(EventFunctionName: Code[128])
 begin
 end;

 2. Add a local variable for the codeunit:
[...]
var
WorkflowResponseHandling: Codeunit "Workflow Response Handling";

3.In the method, write code that registers the response, so that you end up with something like the following code.

[EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', true, true)]
 local procedure AddMyWorkflowResponsesToLibrary()
 var
     WorkflowResponseHandling: Codeunit "Workflow Response Handling";
 begin
     WorkflowResponseHandling.AddResponseToLibrary(MyWorkflowResponseCode, Database::"Purchase Header", 'Send a notification.', 'GROUP 0');
     End
 end;

 example of codeunit how it look
 codeunit 50103 MyWorkflowResponses
{
    procedure MyWorkflowResponseCode(): code[128]
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', true, true)]
    local procedure AddMyWorkflowResponsesToLibrary()
    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(MyWorkflowResponseCode, Database::"Purchase Header", 'Send a notification.', 'GROUP 0');
    end;
}


To implement the workflow response
1.Create another method in the codeunit. Name it to reflect that it is used to implement the workflow response, such as MyWorkflowResponse, that takes a parameter based on the Purchase Header table.

2.In the method, write code that handles the response, so that you end up with something like the following code.

procedure MyWorkflowResponse(PurchaseHeader: Record "Purchase Header")
begin
    Message('Status change on: %1 %2', PurchaseHeader."Document Type", PurchaseHeader."No.");
end;

To enable that the workflow response can be executed
1.Create another method in the codeunit that subscribes to the OnExecuteWorkflowResponse event on the Workflow ResponseHandlingcodeunit.
 Name it to reflect that it is used to enable the new workflow response to be executed alongside existing workflow responses, such as ExecuteMyWorkflowResponses.

2.In the event subscriber method, write code that enables the response, so that you end up with something like the following code.

[EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', true, true)]
procedure ExecuteMyWorkflowResponses(ResponseWorkflowStepInstance: Record "Workflow Step Instance"; var ResponseExecuted: Boolean; var Variant: Variant; xVariant: Variant)
var
    WorkflowResponse: record "Workflow Response";
begin
    if WorkflowResponse.GET(ResponseWorkflowStepInstance."Function Name") then
        case WorkflowResponse."Function Name" of
            MyWFResponseCode:
                BEGIN
                    MyWorkflowResponse(Variant);
                    ResponseExecuted := TRUE;
                END;
        END;
end;

To add a new workflow response option
1.Create a table extension object that extends table 1523, Workflow Step Argument, such as MyWorkflowStepArgument.TableExt.al.

2.Add a field that reflects your new response option, such as My New Response Option

tableextension 50100 WFW_WorkflowStepArgument extends "Workflow Step Argument"
{
    fields
    {
        field(50100; "My New Response Option"; Text[100])
        {
        }
    }
}

3.Create a page extension object that extends page 1523, Workflow Response Options, such as MyworkflowStepArgument.PageExt.al.

4.Add a group and a control for the new field.
pageextension 50101 WFW_WorkflowResponseOptions extends "Workflow Response Options"
{
    layout
    {
        addlast(content)
        {
            group(Group50100)
            {
                Visible = Rec."Response Option Group" = 'GROUP 50100';
                ShowCaption = false;

                field(MyNewResponseOption; Rec."My New Response Option")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}

Here, the Visibility property of the group is set to "Response Option Group" = 'GROUP 50100', but you can set it to another value.

5.Go back to MyWorkflowResponses.codeunit.al and the ´AddMyWorkflowResponsesToLibrary` method.

6.In the method code, change 'GROUP 0' to 'GROUP 50100'.

[EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', true, true)]
local procedure AddMyWorkflowResponsesToLibrary()
var
    WorkflowResponseHandling: Codeunit "Workflow Response Handling";
begin
    WorkflowResponseHandling.AddResponseToLibrary(MyWorkflowResponseCode, Database::"Purchase Header", 'Send a notification.', 'GROUP 50100');
end;

7.To use the new option in the MyWorkflowResponse method, proceed to add a local parameter and a local variable and show a message as the response.
   
   local procedure MyWorkflowResponse(PurchaseHeader: Record "Purchase Header"; WorkflowStepInstance: Record "Workflow Step Instance")
 var
     WorkflowStepArgument: Record "Workflow Step Argument";
 begin
     if WorkflowStepArgument.Get(WorkflowStepInstance.Argument) then;

     Message('Status change on: %1 %2.\%3', PurchaseHeader."Document Type", PurchaseHeader."No.", WorkflowStepArgument."My New Response Option")
 end;

 8.In the ExecuteMyWorkflowResponses method, make the following code change:

Change from this code: MyWorkflowResponse(Variant);

Change to this code: MyWorkflowResponse(Variant,ResponseWorkflowStepInstance);

You have now created the actual workflow event and response. Proceed to perform various tasks that enable them to be used in workflows.
   
   
   Register workflow event/response combinations
In this section, you'll add new workflow event/response combinations to table 1509 WF Event/Response Combination so that they appear correctly in the Workflow Events and Workflow Responses pages.

   To register workflow event/response combinations needed for the new workflow response
1.Open the codeunit that you created in the Workflow response section, My Workflow Responses.

2.Create another method in the codeunit that subscribes to the OnAddWorkflowResponsePredecessorsToLibrary event on the Workflow Response Handling codeunit . Name it to reflect that it is used to add the workflow event/response combinations to table 1509 WF Event/Response Combination, such as AddMyWorkflowEventResponseCombinationsToLibrary.

[EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', false, false)]
    local procedure AddMyworkflowEventOnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    var
        MyWorkflowEvents: Codeunit MyWorkflowEvents;
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    begin
        Case ResponseFunctionName of
            MyWorkflowResponseCode():
                WorkflowResponseHandling.AddResponsePredecessor(MyWorkflowResponseCode(), MyWorkflowEvents.MyWorkflowEventCode());
        End
    end;

In the method, write code that registers event/response combinations that you want to support in your application, using a CASE statement, such as the code in the example above.

You can also do this work from the user interface on page 1507 Workflow-Event-Response-Combinations.


Register workflow event hierarchies
In this section, you'll add new workflow event/event combinations to table 1509 WF Event/Response Combination so that the workflow events appear in the correct hierarchy in the Workflow Events page.

To register workflow event hierarchies needed for the new workflow event
1.Go back to the MyWorkflowEvents.codeunit.al file with the codeunit that you created in the To create a workflow event code that identifies the workflow event section, My Workflow Events.

2.Create another method in the codeunit that subscribes to the OnAddWorkflowEventPredecessorsToLibrary event on the Workflow Event Handling codeunit. Name it to reflect that it is used to add the workflow event hierarchies to table 1509 WF Event/Response Combination, such as AddWorkflowEventHierarchiesToLibrary.

[EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', false, false)]
    local procedure AddWorkflowEventHierarchiesToLibrary(EventFunctionName: Code[128])
    var
        WorkflowEventHandling: codeunit "Workflow Event Handling";
    begin
        Case EventFunctionName of
            MyWorkflowEventCode():
                //WorkflowEventHandling.AddEventPredecessor(MyWorkflowEventCode(), WorkflowEventHandling.
                //[Add your predecessor event code]);
                ;

        End
    end;

Create table relations
Workflows events can be executed on different types of records. To keep track of these, you must define relations between the involved records. In this section, you'll create relationships between the entities that are used when the new workflow event and response are used.

To create table relations between entities that are processed when the new workflow event and response are used in workflows
Got back to the MyWorkflowEvents.codeunit.al file with the codeunit that you created in the To create a workflow event code that identifies the workflow event section, My Workflow Events.

Create another method in the codeunit that subscribes to the OnAddWorkflowTableRelationsToLibrary event on the Workflow Event Handling codeunit. Name it to reflect that it is used add workflow table relations in table 1505 Workflow Table Relation, such as AddWorkflowTableRelationsToLibrary.


[EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowTableRelationsToLibrary', '', false, false)]
    local procedure AddWorkflowTableRelationsToLibrary()
    var
        WorkflowSetup: Codeunit "Workflow Setup";
    begin
        WorkflowSetup.InsertTableRelation(Database::"Purchase Header", 1, Database::"Approval Entry", 2);
    end;

In the method, write code that registers table relations that you want to support in your application, such as the example above.

You can also do this work from the user interface on page 1509 Workflow Table-Relations.

You have now enabled a new workflow scenario by implementing the required workflow event and response in the application code. The workflow administrator can now select the workflow event and workflow response from the Workflow page to define new or edit existing workflows. For more information, see Set Up Workflows in the business functionality content
    */