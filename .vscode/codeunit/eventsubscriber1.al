codeunit 50123 MySubscriber1


{

    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::Page, Page::"Customer Card", OnBeforeValidateEvent, 'Address', true, true)]
    local procedure CheckAddressLineOnBeforeValidateEvent(var Rec: Record Customer);
    begin
        if (StrPos(Rec.Address, '+') > 0) then begin
            Message('Can''t use a plus sign (+) in the address %1', Rec.Address);
        end;
    end;

    var
        myInt: Integer;
}