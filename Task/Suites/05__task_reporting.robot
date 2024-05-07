*** Settings ***
Library     Collections
Resource    ../Resources/Objective.robot
Resource    ../../_setup/UserSources.resource
Resource    ../../_setup/Login.robot

*** Variables ***

*** Test Cases ***
TC06_01
    [Tags]              EP_T_04
    [Documentation]     Employee Loged in and Access Put Task Report using Permissible 
    ...                 Task ID then Response Must Be 200 and Task should updated to "Done"
    
    ${permission}=      Open Session and Login    email=${OWNER_1_EMAIL}              password=${OWNER_1_PASSWORD}
    ${payload}=         Payload
    ${response}         POST Task    
        ...    task=${payload}[task]    
        ...    description=${payload}[description]    
        ...    start_at=${payload}[start_at]    
        ...    end_at=${payload}[end_at]    
        ...    user_id=${642}    
        ...    expected_status=201
        ...    auth=${permission}


    ${permission}=      Open Session and Login    email=${EMPLOYEE_1.2.1_EMAIL}              password=${EMPLOYEE_1.2.1_PASSWORD}
    ${response}         PUT Task Report    task_id=${response.json()}[data][id]      auth=${permission}      expected_status=200
    Task Validation     response=${response.json()}[data]    payload=${payload}

TC06_02
    [Tags]              EP_F_05
    [Documentation]     Employee Loged in and Access Put Task Report using Unpermissible Task ID 
    ...                 then Response Must Be 403 and Task should not Update

    ${permission1}=      Open Session and Login    email=${OWNER_1_EMAIL}              password=${OWNER_1_PASSWORD}
    ${permission2}=      Open Session and Login    email=${EMPLOYEE_1.1.1_EMAIL}       password=${EMPLOYEE_1.1.1_PASSWORD}
    ${permission3}=      Open Session and Login    email=${EMPLOYEE_1.2.1_EMAIL}       password=${EMPLOYEE_1.2.1_PASSWORD}

    ${payload}=         Payload
    ${response}         POST Task    
        ...    task=${payload}[task]    
        ...    description=${payload}[description]    
        ...    start_at=${payload}[start_at]    
        ...    end_at=${payload}[end_at]    
        ...    user_id=${permission2.json()}[user][id]    
        ...    expected_status=403
        ...    auth=${permission1}

    ${response}         PUT Task Report    task_id=${response.json()}[data][id]      auth=${permission3}      expected_status=200
    Negative Validation    response=${response}     key1=error     key2=${null}     key3=${null}     message=permission invalid

*** Keywords ***
Payload
    ${sentence}             Basic Sentence       length=${40}
    ${future_time}=         Future Time          days=${1}
    ${past_time}=           Past Time            days=${1}
    ${counter}              Count Date           start_at=${past_time}    end_at=${future_time}
    ${data}                 Create Dictionary    task=${sentence}           description=${sentence}    start_at=${past_time}    end_at=${future_time}    number_of_days=${counter}
    [Return]          ${data}
    
Task Validation
    [Arguments]    ${response}    ${payload}
    ${start_at}=    Reformat Date        datetime_string=${payload}[start_at]
    ${end_at}=      Reformat Date        datetime_string=${payload}[end_at]

    Should Not Be Empty    item=${response}    
    Should Be Equal As Strings    first=${payload}[task]                second=${response}[task]
    Should Be Equal As Strings    first=${payload}[description]         second=${response}[description]
    Should Be Equal As Strings    first=${start_at}            second=${response}[start_at]
    Should Be Equal As Strings    first=${end_at}             second=${response}[end_at]
    Should Be Equal As Strings    first=done                         second=${response}[status]
    Should Be Equal As Strings    first=${payload}[number_of_days]      second=${response}[number_of_days]

Negative Validation
    [Arguments]    ${response}    ${key1}    ${key2}    ${key3}    ${message}
    Should Not Be Empty           item=${response.json()}
    ${validation}=    Run Keyword If    '${key2}' != '${null}' and '${key3}' != '${null}'    Should Be Equal As Strings    first=${response.json()}[${key1}][${key2}][${key3}]     second=${message}
    ...    ELSE IF    '${key1}' != '${null}'        Should Be Equal As Strings    first=${response.json()}[${key1}]    second=${message}


