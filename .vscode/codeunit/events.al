/*
Publishing Events

Creating an event publisher method to publish business and integration events
Example
Related information
The first phase of implementing an event is publishing the event. 
Publishing an event exposes it in the application. It provides hook up points for subscribers to register to the event, and eventually handle the event if it's raised. 
An event is published by adding an AL method that is set up as an event publisher.

Business and integration events require that you manually create an event publisher method for each event that you want to publish.
 An event publisher method declares the event in the application and makes it available for subscription. 
 However, it doesn't raise the event. After an event is published, you can raise it in your application from where event subscribers can react and handle the event.

Trigger events don't require that you create publisher methods. Trigger events are predefined event publisher methods that are called automatically at runtime. 
So trigger events are readily available to subscribers by default.

Creating an event publisher method to publish business and integration events
You create an event publisher method the same way you create any method in AL. 
But there are specific attributes that you set to make it an event publisher. 
Additionally, an event publisher method has the following requirements and restrictions that you must follow, otherwise you can't compile your code changes:

An event publisher method can't include any code except comments.

An event publisher method can't have a return value, variables, or text constants.

The following procedure provides an outline of the tasks that are involved in creating an event publisher method for declaring an event.

To create an event publisher method
Decide where you want to include the event publisher method.

You can include an event publisher method in the AL code of any object type, such as codeunit, page, or table. 
You can create a new object or use an existing object.

 Important

If you include the event publisher method in a page object, the page must have a source table.
 Otherwise, you can't successfully create an event subscriber method to subscribe to the event.

Add an AL method to the object.

If you don't want the event publisher to be raised from other objects than the one defining it, make it a local method by affixing it with local.
 The event still remains available to event subscribers from other objects.

Give the method a name that has the format On[Event], where [Event] is text that indicates what occurred, such as OnAddressLineChanged.

Decorate the method with either the Integration attribute or Business attribute as follows:

[IntegrationEvent(IncludeSender : Boolean, GlobalVarAccess : Boolean)]
    [BusinessEvent(IncludeSender : Boolean)]

 Tip

Use the teventint snippet for an integration event or the teventbus snippet for a business event to get started.

For more information about integration and business events, see Event Types.

Add parameters to the method as needed.

You can include as many parameters of any type as necessary.

Make sure to expose enough information. Parameters enable subscriber methods to add value to the application. However, 
don't expose unnecessary parameters that may constrain you from changing or extending methodically in the future.

You can now add code to the application that raises the event by calling the event publisher method. You can also create subscriber methods that handle the event when it's raised.

Example
This example creates the codeunit 50100 MyPublishers to publish an integration event. The event is published by adding the global method called OnAddressLineChanged. The event takes a single text data type parameter.

 Note

This example is part of a larger, simple scenario where when users change the address of a customer on the page 21 Customer Card, you want to check that the address doesn't include a plus sign (+).
 If it does, you want to display a message. To accomplish this, you will publish an event that is raised when the Address field on Customer Card is changed, and add an event subscriber method to that includes logic that checks the address value and returns a message to the user if it contains a plus sign.
  For a complete description of this scenario and all the code involved, see Event Example.

codeunit 50100 MyPublishers
{
    [IntegrationEvent(false, false)]
    procedure OnAddressLineChanged(line : Text[100])
    begin  
    end;
}

Raising Events

Snippet support
Example
Related information
After an event has been published by an event publisher method, you can modify the application to raise the event where it is needed. 
Subscribers of an event will not react on the event until it is raised in the application.

To raise an event, you add logic in AL code of the application to call the event publisher method that declares the event. 
The procedure for calling the event publisher method is the same as calling any other method in AL.

When the code that calls the event publisher method is run, all event subscriber methods that subscribe to the event are run. If there are multiple subscribers, the subscriber methods are run one at a time in no particular order. 
You cannot specify the order in which the subscriber methods are called.

If there are no subscribers to the published event, then the line of code that calls the event publisher method is ignored and not executed.

Snippet support
Typing the shortcut teventsub will create the basic event subscriber syntax when using the AL Language extension for Microsoft Dynamics 365 Business Central in Visual Studio Code.

 Tip

Typing the keyboard shortcut Ctrl+Space displays IntelliSense to help you fill in the attribute arguments and to discover which events are available to use.

Example
This example uses a page extension object 50100 MyCustomerExt to modify the page 21 Customer Card so that an event is raised when a user changes the Address field. 
This example assumes that the event has already been published by the event publisher method OnAddressLineChanged in a separate codeunit called 50100 MyPublishers.

 Note

This example is part of a larger, simple scenario where when users change the address of a customer on the page 21 Customer Card, you want to check that the address does not include a plus sign (+).
 If it does, you want to return a message to the user. For a description of this scenario and all the code involved, see Event Example.

In the code that follows, the page extension object modifies the OnBeforeValidate trigger of the Customer Card page to raise the event OnAddressLineChanged which includes the new value of the Address field.

pageextension 50100 MyCustomerExt extends "Customer Card"
{
    layout
    {
        modify(Address)
        {
            trigger OnBeforeValidate();
    var
        Publisher: Codeunit MyPublishers;
    begin
        Publisher.OnAddressLineChanged(Rec.Address);
    end;
        }
    }
}

Subscribing to events

Creating an event subscriber method
Example 1
Example 2
Related information
To handle events, you design event subscribers. Event subscribers determine what actions to take in response to an event that is raised.
 An event subscriber is a method that listens for a specific event that is raised by an event publisher. 
 The event subscriber includes code that defines the business logic to handle the event.
  When the published event is raised, the event subscriber is called and its code is run.

Subscribing to an event tells the runtime that the subscriber method must be called whenever the publisher method is run, either by code (as with business and integration events) 
or by the system (as with trigger events). The runtime establishes the link between an event raised by the publisher and its subscribers, by looking for event subscriber methods.

There can be multiple subscribers to the same event from various locations in the application code. When an event is raised, the subscriber methods are run one at a time in no particular order. 
You can't specify the order in which the subscriber methods are called.

 Note

With Business Central 2023 release wave 1, the event publisher parameter in event subscribers now supports being an identifier, allowing full navigability and increased developer productivity.
     Prior to this release the event publisher parameter was string literals only. With this release, a code action is introduced to help convert event subscriber syntax. For more information, see Code actions.

Creating an event subscriber method
You create an event subscriber method just like other methods except that you specify properties that set up the subscription to an event publisher. The procedure is slightly different for database and page trigger events than for business and integration events. Business and integration events are raised by event publisher methods in application code. Trigger events are predefined system events that are raised automatically on tables and pages.

For an explanation about the different types, see Event Types.

To create an event subscriber method
Decide which codeunit to use for the event subscriber method.

You can create a new codeunit or use an existing one.

Add an AL method to the codeunit.

We recommend that you give the method a name that indicates what the subscriber does, and has the format [Action]
    [Event]. [Action] is text that describes what the method does. [Event] is the name of the event publisher method to which it subscribes.

Add code to the method for handling the event.

Decorate the event subscriber method with the EventSubscriber attribute. See the following example code for the syntax.

AL

Copy
[EventSubscriber(ObjectType::<Event Publisher Object Type>, <Event Publisher Object>, '<Published Event Name>', '<Published Event Element Name>', <SkipOnMissingLicense>, <SkipOnMissingPermission>)]
Set the arguments according to the following table. For optional arguments, if you don't want to set a value, use an empty value (''). In this case, the default value, if any, is used.

Argument	Description	Optional
<Event Publisher Object Type>	Specify the type of object that publishes the event. This argument can be Codeunit, Page, Report, Table, or XMLPort.	no
<Event Publisher Object>	Specify the object that publishes the event. You can set this argument to the ID, such as 50100, or the recommended way is to use the object name by using the syntax <Object Type>::"<Object Name>", such as Codeunit::"MyPublishers", or for database triggers Database::"Customer".	no
<Published Event Name>	Specify the name of method that publishes the event in the object that is specified by the <Event Publisher Object> parameter.	no
<Published Event Element Name>	Specifies the table field that the trigger event pertains to. This argument only requires a value for database trigger events, that is, when the <Event Publisher Object Type> is set to Table and the <Published Event Name> argument is a validate trigger event, such as OnAfterValidateEvent.	no
<SkipOnMissingLicense>	Set to true to skip the event subscriber method call if the user's license doesn't cover the event subscriber codeunit. If false, an error is thrown and the code execution stops. false is the default.	yes
<SkipOnMissingPermission>	Set to true to skip the event subscriber method call if the user doesn't have the correct permissions the event subscriber codeunit. If false, an error is thrown and the code execution stops. false is the default.	yes
 Tip

There are a couple of things that can make defining an event subscriber method easier. You can use the teventsub snippet to get started. 
+Then, typing the keyboard shortcut Ctrl+Space displays IntelliSense to help you fill the attribute arguments and discover, which events are available. Or, use the Shift+Alt+E keyboard shortcut to look up the event you want to subscribe to and insert the code.

Optionally, set the codeunit's EventSubscriberInstance property to specify how the event subscriber method will be bound to the instance of this codeunit.

For more information, see the EventSubscriberInstance property.

Example 1
This example creates the codeunit 50101 MySubscribers to subscribe to an event that has been published by the event publisher method called OnAddressLineChanged in the codeunit 50100 MyPublishers.
 The event is raised by a change to the Address field on page 21 Customer Card. This example assumes:

The codeunit 50100 MyPublishers with the event publisher method OnAddressLineChanged already exists. For an example, see Publishing event example.
The code for raising the OnAddressLineChanged event has been added to the Customer Card page. For an example, see Raising event example.
The following code creates a codeunit called 50101 MySubscribers that includes an event subscriber method, called CheckAddressLineOnAddressLineChanged. 
The method includes code for handling the published event.

codeunit 50101 MySubscribers
{
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"MyPublishers", 'OnAddressLineChanged', '', true, true)]
    procedure CheckAddressLineOnAddressLineChanged(line: Text[100])
    begin
        if (StrPos(line, '+') > 0) then begin
            Message('Can''t use a plus sign (+) in the address [' + line + ']');
        end;
    end;
}

 Note

This example is part of a larger, simple scenario where when users change the address of a customer on the page 21 Customer Card, you want to check that the address doesn't include a plus sign (+).
 If it does, you want to return a message to the user. For a description of this scenario and all the code involved, see Event example.

Example 2
This example achieves the same as example 1, except it subscribes to the page trigger event OnBeforeValidateEvent on the Address field instead. By using the page trigger, you avoid creating an event publisher and adding code to raise the event. The event is raised automatically by the system.

codeunit 50101 MySubscribers
{
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::Page, Page::"Customer Card", 'OnBeforeValidateEvent', 'Address', true, true)]
    local procedure CheckAddressLineOnBeforeValidateEvent(var Rec: Record Customer)
    begin
        if (StrPos(Rec.Address, '+') > 0) then begin
            Message('Can''t use a plus sign (+) in the address [%1]', Rec.Address);
        end;
    end;
}


Isolated Events in AL

You can define a business, integration, or internal event to be an isolated event. An isolated event ensures the event publisher continues its code execution after calling an event.
 If an event subscriber's code causes an error, its transaction and associated table changes will be rolled back. The execution continues to the next event subscriber, or it will be handed back to the event's caller.

How isolated events work
Isolated events are implemented by separating each event subscriber into its own transaction. The transaction is created before invoking an event subscriber, then committed afterwards. The following diagram illustrates the flow

[diagram]

Note

Read-only transactions are allowed to call isolated events directly, but write transactions should explicitly be committed before invoking an isolated event. Otherwise, the isolated event will be invoked like an normal event, that is, errors inside an event subscriber will cause the entire operation to fail.

Rollback
Only changes done via Modify/Delete/Insert calls on records of type TableType: Normal will be automatically rolled back. Other state changes, like HTTP calls, variable alterations, changes to single instance codeunit's members, won't be rolled back.

For example, if an integer variable that's passed by VAR is modified by a failing event subscriber, its changes will persist.

Extension installation and upgrade
When the operation is installing, uninstalling, or upgrading extensions, isolated events aren't run isolated. The events run normally instead.

The reason for this behavior is that these operations require that all operations within them are done in one transaction. So explicit Commit calls can't be made during the operations.

How to define an isolated event
The BusinessEvent, IntegrationEvent, and InternalEvent attributes include the Isolated boolean argument, for example:

[InternalEvent(IncludeSender: Boolean, Isolated: Boolean)]

example

codeunit 50145 IsolatedEventsSample
{
    trigger OnRun()
    var
        Counter: Integer;
        cust: Record Customer;
    begin
        // Precondition: Customer table isn't empty.
        if (cust.IsEmpty) then
            Error('Customer table is empty.');

        MyIsolatedEvent(Counter);

        // Code only reaches this point because the above event is isolated and error thrown in FailingEventSubscriber is caught.
        if (Counter <> 2) then
            Error('Both event subscribers should have incremented the counter.');

        // Post-condition: Customer table hasn't been truncated.
        if (cust.IsEmpty) then
            Error('Customer table was truncated, failing event subscriber was not rolled back.');
    end;

    [InternalEvent(false, true)]
    local procedure MyIsolatedEvent(var Counter: Integer)
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::IsolatedEventsSample, 'MyIsolatedEvent', '', false, false)]
    local procedure FailingEventSubscriber(var Counter: Integer)
    var
        cust: Record Customer;
    begin
        Counter += 1; // Change will persist even after throwing. Only database changes will be rolled back.

        cust.DeleteAll(); // Database changes will be rolled back upon error.

        Error('Fail!');

        // Code below won't be reached!
        Counter += 1;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::IsolatedEventsSample, 'MyIsolatedEvent', '', false, false)]
    local procedure IncreasingEventSubscriber(var Counter: Integer)
    begin
        Counter += 1;
    end;
}


*/