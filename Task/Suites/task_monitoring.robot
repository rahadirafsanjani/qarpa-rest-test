*** Settings ***
Resource    ../../_setup/login.robot
Resource    ../Resources/objective.robot

*** Variables ***


*** Test Cases ***
Test Case Task 01  
    ${auth}    Auth
    Get Data    auth=${auth}    user_permisiion=${2}    expected_status=200
    

*** Keywords ***
Auth
    ${response}    Open Login Session    email=xahapa4844@czilou.com     password=passworddd
    [return]    ${response}

Get Data
    [Arguments]    ${auth}    ${user_permisiion}    ${expected_status}
    GET Task Data    auth=${auth}     user_permission=${user_permisiion}    expected_status=${expected_status}