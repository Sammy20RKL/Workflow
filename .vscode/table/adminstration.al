table 50137 Adminstration
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Name; Text[15])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Age"; Code[8])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Status"; Enum student)
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(pk; Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}