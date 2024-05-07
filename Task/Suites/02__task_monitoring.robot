*** Settings ***
Library     Collections
Resource    ../Resources/Objective.robot
Resource    ../../_setup/UserSources.resource
Resource    ../../_setup/Login.robot


*** Test Cases ***
TC02_01
    [Tags]             EP_T_02    
    [Documentation]    Owner Loged in and Access Get Task Monitoring (Owner) 
    ...                then Response Must Be 200 and Only Permissible Task Provided
    
    ${permission1}=               Open Session and Login              email=${OWNER_1_EMAIL}              password=${OWNER_1_PASSWORD}
    ${permission2}=               Open Session and Login              email=${EMPLOYEE_1.1.1_EMAIL}                 password=${EMPLOYEE_1.1.1_PASSWORD}
    ${payload_list}=              List of Payload                     task_check=${5}
    ${data_test_list}=            Create Multiple Task                payload_list=${payload_list}    task_check=${5}             permission=${permission1}    user_id=${permission2.json()}[user][id]
    ${response}=                  GET Task Monitoring                 auth=${permission1}             user_permission=owner      expected_status=200
    Validate Multiple task        data_test_list=${data_test_list}    response=${response}    task_check=${5}

TC03_01
    [Tags]             EP_T_02
    [Documentation]    Employee Loged in and Access Get Task Monitoring (Employee)
    ...                then Response Must Be 200 and Only Permissible Task Provided

    ${permission1}=               Open Session and Login    email=${OWNER_1_EMAIL}              password=${OWNER_1_PASSWORD}
    ${permission2}=               Open Session and Login    email=${EMPLOYEE_1.1.1_EMAIL}                 password=${EMPLOYEE_1.1.1_PASSWORD}
    ${payload_list}=              List of Payload           task_check=${5}
    ${data_test_list}=            Create Multiple Task      payload_list=${payload_list}     task_check=${5}             permission=${permission1}    user_id=${permission2.json()}[user][id]
    ${response}=                  GET Task Monitoring       auth=${permission2}              user_permission=employee    expected_status=200
    Validate Multiple task        data_test_list=${data_test_list}    response=${response}    task_check=${5}

*** Keywords ***
Payload
    ${sentence}             Basic Sentence       length=${40}
    ${future_time}=         Future Time          days=${1}
    ${past_time}=           Past Time            days=${1}
    ${counter}              Count Date           start_at=${future_time}    end_at=${past_time}
    ${data}                 Create Dictionary    task=${sentence}           description=${sentence}    start_at=${past_time}    end_at=${future_time}    number_of_days=${counter}
    [Return]          ${data}

List of Payload
    [Arguments]    ${task_check}  
    @{list}=       Create List

    FOR    ${i}    IN RANGE    ${task_check}
        ${data}    Payload
        Append To List    ${list}    ${data}
    END

    [return]    ${list}

Create Multiple Task
    [Arguments]    ${payload_list}    ${task_check}    ${permission}    ${user_id}
    @{data_test_list}=        Create List

    FOR  ${i}  IN RANGE  ${task_check}
        ${data_test}      POST Task    
        ...    task=${payload_list}[${i}][task]    
        ...    description=${payload_list}[${i}][description]    
        ...    start_at=${payload_list}[${i}][start_at]    
        ...    end_at=${payload_list}[${i}][end_at]    
        ...    user_id=${user_id}    
        ...    expected_status=201    
        ...    auth=${permission}

        Append To List    ${data_test_list}    ${data_test.json()}[data]
    END

    [return]    ${data_test_list}

Validate Multiple task
    [Arguments]    ${data_test_list}    ${response}    ${task_check}

    FOR  ${i}  IN RANGE  ${task_check}
        ${sliced}          Get Task By Id        
        ...    target_id=${data_test_list}[${i}][id]     
        ...    task_list=${response.json()}[data]

        Task Validation    response=${sliced}    data=${data_test_list}[${i}]
    END 

Task Validation
    [Arguments]    ${response}    ${data}
    Should Not Be Empty    item=${response}    
    Should Be Equal As Strings    first=${data}[task]                second=${response}[task]
    Should Be Equal As Strings    first=${data}[description]         second=${response}[description]
    Should Be Equal As Strings    first=${data}[start_at]            second=${response}[start_at]
    Should Be Equal As Strings    first=${data}[end_at]              second=${response}[end_at]
    Should Be Equal As Strings    first=todo                         second=${response}[status]
    Should Be Equal As Strings    first=${data}[number_of_days]      second=${response}[number_of_days]

