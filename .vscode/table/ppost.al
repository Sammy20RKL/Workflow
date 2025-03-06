/*Creating a Human Resource (HR) leave management system in Dynamics 365 Business Central without creating a separate table for employees is possible by leveraging the standard Employee table (Employee table, typically table ID 5200). Here's a step-by-step guide:

1. Understand the Employee Table
The Employee table in Business Central already holds essential details about employees, such as:

No. (Employee ID)
First Name, Last Name
Employment Date
Department
And more…
You can utilize this table to store employee-specific data and relate it to leave requests.

2. Create a Leave Request Table
You will need a custom table to store leave requests, but it will link to the existing Employee table. The custom table should include fields like:

Request No. (Primary Key)
Employee No. (Linked to the Employee table)
Start Date (Leave start date)
End Date (Leave end date)
Leave Type (e.g., annual, sick, unpaid)
Reason (Leave reason)
Approval Status (Pending/Approved/Rejected)
Approver (if needed)
3. Create a Leave Request Page
Develop a Page for employees to request leave:

Use the new Leave Request table as the source.
Add a Lookup or AssistEdit feature for selecting the Employee No. from the Employee table.
Include fields like Leave Type, Start Date, End Date, and Reason.
4. Add Approvals Workflow
Use Workflows in Business Central to handle leave approval:

Configure a Workflow that routes leave requests to managers or approvers.
Set conditions like:
When a request is created or modified.
Notifications to the approver.
Actions like approving, rejecting, or requesting more information.
5. Restrict Access to Employee Data
To ensure employees can only access their own data:

Use Filters in the page to display only the leave requests for the logged-in employee.
Example: Add a filter like Employee No. = CURRENTUSER.
6. Build Reports for HR
Develop reports for HR to track:

Total leaves taken by employees.
Pending approvals.
Leave balances (if needed).
Example AL Code Snippet
Here’s a simplified structure for your Leave Request Table:

al
Copy code
table 50100 "Leave Request"
{
    fields
    {
        field(1; "Request No."; Code[20]) { DataClassification = CustomerContent; }
        field(2; "Employee No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee."No."; // Link to Employee table
        }
        field(3; "Start Date"; Date) { DataClassification = CustomerContent; }
        field(4; "End Date"; Date) { DataClassification = CustomerContent; }
        field(5; "Leave Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Annual Leave", "Sick Leave", "Unpaid Leave";
        }
        field(6; "Reason"; Text[250]) { DataClassification = CustomerContent; }
        field(7; "Approval Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Pending, Approved, Rejected;
        }
    }
}
7. Optional Enhancements
Add notifications for approvers when a leave request is created.
Integrate with Payroll to deduct unpaid leave automatically.
Build a Power BI dashboard for HR leave analytics
*/