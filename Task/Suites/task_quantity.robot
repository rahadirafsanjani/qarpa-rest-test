*** Settings ***
Resource    ../../_setup/login.robot
Resource    ../Resources/objective.robot
Resource    ../../_setup/user_01.resource

*** Variables ***


*** Test Cases ***
Test Case Task 01  
    ${auth}            Auth                      email=${01_USER_IN_BRANCH_EMAIL}     password=${01_USER_IN_BRANCH_PASSWORD}
    ${mock_data}       Get Task List             auth=${auth}                         user_permisiion=${2}     expected_status=200
    ${response}        Task Quantity             auth=${auth}                         expected_status=200
    Task Validation    mock_data=${mock_data}    response=${response}

*** Keywords ***
Auth
    [Arguments]    ${email}    ${password}
    ${response}    Open Login Session    email=${email}     password=${password}
    [return]       ${response}

Task Quantity
    [Arguments]    ${auth}   ${expected_status}
    ${response}    GET Task Quantity    auth=${auth}    expected_status=${expected_status}
    [return]       ${response}

Get Task List 
    [Arguments]    ${auth}    ${user_permisiion}    ${expected_status}
    ${get}         GET Task Data    auth=${auth}     user_permission=${user_permisiion}    expected_status=${expected_status}
    [return]       ${get}

Task Validation
    [Arguments]    ${mock_data}    ${response}
    ${mock_data}                   Count Task Status    task_list=${mock_data.json()}[data]
    Should Be Equal As Integers    first=${mock_data}[todo_task_count]       second=${response.json()}[data][todo]
    Should Be Equal As Integers    first=${mock_data}[done_task_count]       second=${response.json()}[data][done]