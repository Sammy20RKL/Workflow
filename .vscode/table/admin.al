table 50138 Administration
{
    DataClassification = ToBeClassified;
    Caption = 'Administartion';
    DrillDownPageId = "Administration list";
    LookupPageId = "Administration list";
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
}