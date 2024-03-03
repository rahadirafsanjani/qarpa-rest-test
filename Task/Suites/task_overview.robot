*** Settings ***
Resource    ../../_setup/login.robot
Resource    ../../_setup/user_01.resource
Resource    ../Resources/objective.robot

*** Variables ***

*** Test Cases ***
Test Case Task 01  
    ${mock_data}        Generate Mock Task (Default)
    ${auth_owner}       Auth                           email=${01_USER_EMAIL}                  password=${01_USER_PASSWORD}
    ${auth_employee}    Auth                           email=${01_USER_IN_BRANCH_EMAIL}        password=${01_USER_IN_BRANCH_PASSWORD}
    ${task_id}          Task Creation for Testing      task=${mock_data}[task]                 description=${mock_data}[description]    start_at=${mock_data}[start_at]    end_at=${mock_data}[end_at]    user_id=${01_USER_IN_BRANCH_ID}    auth=${auth_owner}
    ${response}         Task Overview                  task_id=${task_id.json()}[data][id]     auth=${auth_employee}                    expected_status=200
    Task Validation     mock_data=${mock_data}         response=${response}
    
*** Keywords ***
Auth
    [Arguments]    ${email}    ${password}
    ${response}    Open Login Session    email=${email}     password=${password}
    [return]       ${response}

Task Overview
    [Arguments]    ${task_id}    ${auth}        ${expected_status}
    ${response}    GET Task Overview    task_id=${task_id}   auth=${auth}     expected_status=${expected_status}
    [return]       ${response}

Task Creation for Testing
    [Arguments]    ${task}    ${description}    ${start_at}    ${end_at}    ${user_id}    ${auth}
    ${response}    POST Task    task=${task}    description=${description}    start_at=${start_at}     end_at=${end_at}    user_id=${user_id}    expected_status=201    auth=${auth}
    [return]       ${response}

Generate Mock Task (Default)
    ${sentence}       Default Sentence 
    ${date_future}    date_future
    ${date_past}      date_past
    ${daydiff}        Count Date           date_str1=${date_future}    date_str2=${date_past}
    ${data}           Create Dictionary    task=${sentence}            description=${sentence}    start_at=${date_past}    end_at=${date_future}    number_of_days=${daydiff}
    [Return]          ${data}

Task Validation
    [Arguments]    ${mock_data}    ${response}
    Should Be Equal As Strings    first=Task found                       second=${response.json()}[message]
    Should Be Equal As Strings    first=${mock_data}[task]               second=${response.json()}[data][task]
    Should Be Equal As Strings    first=${mock_data}[description]        second=${response.json()}[data][description]
    Should Be Equal As Strings    first=${mock_data}[start_at]           second=${response.json()}[data][start_at]
    Should Be Equal As Strings    first=${mock_data}[end_at]             second=${response.json()}[data][end_at]
    Should Be Equal As Strings    first=todo                             second=${response.json()}[data][status]
    Should Be Equal As Strings    first=${mock_data}[number_of_days]     second=${response.json()}[data][number_of_days]