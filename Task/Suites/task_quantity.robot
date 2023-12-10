*** Settings ***
Resource    ../../_setup/login.robot
Resource    ../Resources/objective.robot
Resource    ../../_setup/user_01.resource

*** Variables ***


*** Test Cases ***
Test Case Task 01  
    ${auth}            Auth                 email=${01_USER_IN_BRANCH_EMAIL}          password=${01_USER_IN_BRANCH_PASSWORD}
    ${validator}       Get ALL TASK         auth=${auth}                              user_permisiion=${2}     expected_status=200
    ${validator}       Count Task Status    task_list=${validator.json()}[data]
    ${response}        Get Data             auth=${auth}                              expected_status=200
    Should Be Equal As Integers             first=${validator}[todo_task_count]       second=${response.json()}[data][todo]
    Should Be Equal As Integers             first=${validator}[done_task_count]       second=${response.json()}[data][done]

    
*** Keywords ***
Auth
    [Arguments]    ${email}    ${password}
    ${response}    Open Login Session    email=${email}     password=${password}
    [return]    ${response}

Get Data
    [Arguments]    ${auth}   ${expected_status}
    ${response}    GET Task Quantity    auth=${auth}    expected_status=${expected_status}
    [return]    ${response}

Get ALL TASK
    [Arguments]    ${auth}    ${user_permisiion}    ${expected_status}
    ${get}    GET Task Data    auth=${auth}     user_permission=${user_permisiion}    expected_status=${expected_status}
    [return]    ${get}