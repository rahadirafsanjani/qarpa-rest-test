*** Settings ***
Resource    ../../_setup/login.robot
Resource    ../Resources/objective.robot

*** Variables ***


*** Test Cases ***
Test Employee Creation - 01
    ${data}    Generate Data    
    Create Employee Account    name=${data}[name]    email=${data}[email]     password=${data}[password]    branch_id=19    expected_status=201    

*** Keywords ***
Create Employee Account
    [Arguments]    ${name}    ${email}    ${password}    ${branch_id}    ${expected_status}
    ${auth}    Open Login Session    email=xahapa4844@czilou.com     password=passworddd
    ${response}    POST Employee    name=${name}    email=${email}    password=${password}    branch_id=${branch_id}    expected_status=${expected_status}    auth=${auth}
    Log To Console    ${response}

Generate Data
    ${name}    Make Name    length_name=20
    ${email}    Make Email    length_email=20
    ${password}    Make Password    length_password=20
    ${data}    Create Dictionary    name=${name}    email=${email}    password=${password}
    [Return]    ${data}
