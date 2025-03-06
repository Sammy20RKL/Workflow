codeunit 50124 MySubscriber
{
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"MyPublishers", 'OnAddressLineChange', '', true, true)]
    local procedure CheckAddressLineOnAddressLineChanged(line: Text[150])
    begin
        if (StrPos(line, '+') > 0) then begin
            Message('Can''t use sign plus (+) to the address [' + line + ']');
        end;


    end;

    var
        myInt: Integer;
}