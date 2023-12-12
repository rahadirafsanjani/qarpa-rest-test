*** Settings ***
Resource    ../../_setup/login.robot
Resource    ../../_setup/user_01.resource
Resource    ../Resources/objective.robot

*** Variables ***

*** Test Cases ***
Test Case Task Report
    ${auth_owner}       Auth           email=${01_USER_EMAIL}                  password=${01_USER_PASSWORD}
    ${auth_employee}    Auth           email=${01_USER_IN_BRANCH_EMAIL}        password=${01_USER_IN_BRANCH_PASSWORD}
    ${mock_data}        Generate Mock Task (Default)
    ${data}             Task Creation for Testing    task=${mock_data}[task]    description=${mock_data}[desc]    start_at=${mock_data}[start_at]    end_at=${mock_data}[end_at]    user_id=${01_USER_IN_BRANCH_ID}    auth=${auth_owner}
    ${response}         Task Reporting    task_id=${data.json()}[data][id]     auth=${auth_employee}       expected_status=200
    Task Validation    response=${response}    data=${data}

*** Keywords ***
Auth
    [Arguments]    ${email}    ${password}
    ${response}    Open Login Session    email=${email}     password=${password}
    [return]       ${response}

Task Reporting
    [Arguments]    ${auth}    ${task_id}    ${expected_status}
    ${get}         PUT Task Report    task_id=${task_id}      auth=${auth}      expected_status=200
    [return]       ${get}

Task Creation for Testing
    [Arguments]    ${task}    ${description}    ${start_at}    ${end_at}    ${user_id}    ${auth}
    ${response}    POST Task    task=${task}    description=${description}    start_at=${start_at}     end_at=${end_at}    user_id=${user_id}    expected_status=201    auth=${auth}
    [return]       ${response}

Generate Mock Task (Default)
    ${sentence}       Default Sentence 
    ${date_future}    date_future
    ${date_past}      date_past
    ${data}           Create Dictionary    task=${sentence}    desc=${sentence}    start_at=${date_past}    end_at=${date_future}
    [Return]          ${data}

Task Validation
    [Arguments]    ${response}    ${data}
    Should Not Be Equal           first=${response.json()}[data][status]    second=${data.json()}[data][status]
    Should Be Equal As Strings    first=${response.json()}[data][status]    second=done