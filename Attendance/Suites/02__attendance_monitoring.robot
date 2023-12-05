*** Settings ***
Resource    ../../_setup/login.robot
Resource    ../Resources/objective.robot

*** Variables ***


*** Test Cases ***
Test Case Attendance Monitoring 01  
    ${auth}    Auth
    Take Monitoring    expected_status=200    auth=${auth}


*** Keywords ***
Auth
    ${response}    Open Login Session    email=xahapa4844@czilou.com     password=passworddd
    [return]    ${response}

Take Monitoring
    [Arguments]    ${expected_status}    ${auth}
    Attendace Monitoring    expected_status=${expected_status}    auth=${auth}