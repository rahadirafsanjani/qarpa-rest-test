*** Settings ***
Resource    ../../_setup/login.robot
Resource    ../Resources/objective.robot

*** Variables ***


*** Test Cases ***
Test Case Task 01  
    ${auth}    Auth
    Get Data    auth=${auth}    expected_status=200
    

*** Keywords ***
Auth
    ${response}    Open Login Session    email=xahapa4844@czilou.com     password=passworddd
    [return]    ${response}

Get Data
    [Arguments]    ${auth}   ${expected_status}
    GET Task Quantity    auth=${auth}    expected_status=${expected_status}