*** Settings ***
Resource    ../../_setup/login.robot
Resource    ../Resources/objective.robot
Resource    ../../_setup/user_01.resource

*** Variables ***

*** Test Cases ***
Test Case Task Report
    ${auth}           Auth    
    ${mock_data}      Generate Data Default
    ${data}           Create Task for Get Testing    task=${mock_data}[task]    description=${mock_data}[desc]    start_at=${mock_data}[start_at]    end_at=${mock_data}[end_at]    user_id=${617}
    ${response}       PUT Data    task_id=${data.json()}[data][id]     auth=${auth}       expected_status=200
    Validation Task Reporting    response=${response}    data=${data}

*** Keywords ***
Auth
    ${response}    Open Login Session    email=${01_USER_EMAIL}     password=${01_USER_PASSWORD}
    [return]    ${response}

PUT Data
    [Arguments]    ${auth}    ${task_id}    ${expected_status}
    ${get}    PUT Task Report    task_id=${task_id}      auth=${auth}      expected_status=200
    [return]    ${get}

Create Task for Get Testing
    [Arguments]    ${task}    ${description}    ${start_at}    ${end_at}    ${user_id}
    ${response}    Open Login Session    email=${01_USER_EMAIL}     password=${01_USER_PASSWORD}
    ${response}    POST Task    task=${task}    description=${description}    start_at=${start_at}     end_at=${end_at}    user_id=${user_id}    expected_status=201    auth=${response}
    [return]    ${response}

Generate Data Default
    ${sentence}    Default Sentence 
    ${date_future}    date_future
    ${date_past}    date_past
    ${data}    Create Dictionary    task=${sentence}    desc=${sentence}    start_at=${date_past}    end_at=${date_future}
    [Return]    ${data}

Validation Task Reporting
    [Arguments]    ${response}    ${data}
    Should Not Be Equal           first=${response.json()}[data][status]    second=${data.json()}[data][status]
    Should Be Equal As Strings    first=${response.json()}[data][status]    second=done