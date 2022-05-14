
codeunit 70155344 "AppXite Test RUnner"
{
  Subtype = TestRunner;
  TestIsolation = Disabled;
trigger OnRun()
begin
  CODEUNIT.RUN(CODEUNIT::"AppXite Setup Test");
end;

//"appId": "c00d3fca-de79-4409-a9b1-e50f41a98eac", 
//"name": "AppXite Dynamics 365", 
//"publisher": "Ciellos", 
//"version": "1.0.0.1"
}