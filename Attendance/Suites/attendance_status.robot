*** Settings ***
Resource    ../../_setup/login.robot
Resource    ../Resources/objective.robot

*** Variables ***


*** Test Cases ***
Test Case Attendance Status 01  
    ${auth}    Auth
    Take Status    expected_status=200    auth=${auth}


*** Keywords ***
Auth
    ${response}    Open Login Session    email=xahapa4844@czilou.com     password=passworddd
    [return]    ${response}

Take Status
    [Arguments]    ${expected_status}    ${auth}
    Attendace Status    expected_status=${expected_status}    auth=${auth}