tableextension 50108 Purchase extends "Purchases & Payables Setup"
{
    fields
    {
        field(50; "Workflow Header No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(pk; "Workflow Header No.")
        {

        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}

//SbPz#6rcNW! sammy kimeu password
//SAww#8gTUo! samuel password