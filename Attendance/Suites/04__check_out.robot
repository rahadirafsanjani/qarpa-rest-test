*** Settings ***
Resource    ../../_setup/login.robot
Resource    ../Resources/objective.robot

*** Variables ***


*** Test Cases ***
Test Case Check Out 01  
    ${data}    Generate Data
    ${auth}    Auth
    Hit Endpoint    timestamp=${data}    expected_result=200    auth=${auth}


*** Keywords ***
Auth
    ${response}    Open Login Session    email=xahapa4844@czilou.com     password=passworddd
    [return]    ${response}

Generate Data
    ${response}    Timestamp
    [Return]    ${response}

Hit Endpoint
    [Arguments]    ${timestamp}    ${expected_result}    ${auth}
    ${test}    Check Out Report    timestamp=${timestamp}    expected_status=${expected_result}    auth=${auth}
    Log To Console    ${test}