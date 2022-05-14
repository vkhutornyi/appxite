codeunit 70155345 "AppXite Setup Test"
{
    Subtype = Test;

    // [Test]
    // procedure TestSetupSMTP();

    // var
    //     SMTPMailSetup: Record "SMTP Mail Setup";
    // begin
    //     // IF NOT SMTPMailSetup.Get THEN
    //     //     Error('SMTPMailSetup must have one record.');
    // end;

    [Test]
    procedure TestCustomerCardPageHasAppXiteFields();
    var
        CustomerCardTestPage: TestPage "Customer Card";
    //AssertTest : Codeunit Assert;

    begin
        // [Scenario] Customer Card Page Has Reward Fields When Opened 
        // [Given] Customer Card Page 

        // Using permissions that do not inlcude SUPER 
        //LibraryLowerPermissions.SetO365BusFull; 

        // [When] Customer card page is opened 
        CustomerCardTestPage.OpenView;
        // [Then] ReThink fiels are exist 
        IF NOT CustomerCardTestPage."ApX Last Modified - ReThink".Visible THEN
            ERROR('Last Modified - ReThink should be visible');
        IF NOT CustomerCardTestPage."ApX ReThink ID".Visible THEN
            ERROR('ReThink ID should be visible');
        IF NOT CustomerCardTestPage."ApX Name From ReThink".Visible THEN
            ERROR('ReThink ID should be visible');

    end;

    [Test]
    procedure TestCompanyInfoPageHasAppXiteFields();
    var
        CompanyInfoTestPage: TestPage "Company Information";
    //AssertTest : Codeunit Assert;

    begin
        // [Scenario] Customer Card Page Has Reward Fields When Opened 
        // [Given] Customer Card Page 

        // Using permissions that do not inlcude SUPER 
        //LibraryLowerPermissions.SetO365BusFull; 

        // [When] Customer card page is opened 
        CompanyInfoTestPage.OpenView;

        IF NOT CompanyInfoTestPage."ApX Short Name".Visible THEN
            ERROR('Short Name should be visible');

    end;

}