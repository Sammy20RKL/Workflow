table 50124 "Custom Worlkflow"
{
    DataClassification = ToBeClassified;
    Caption = 'Custom Workflow';
    DrillDownPageId = "Workflow List";
    LookupPageId = "Workflow List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    PurchSetup.Get();
                    NoSeriesMgt.TestManual(PurchSetup."Workflow Header No.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Description; Text[140])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(3; Status; Enum "Customer Workflow")
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            PurchSetup.Get();
            PurchSetup.TestField("Workflow Header No.");
            NoSeriesMgt.InitSeries(PurchSetup."Workflow Header No.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
    end;

    var
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}