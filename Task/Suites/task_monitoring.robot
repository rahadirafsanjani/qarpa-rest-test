*** Settings ***
Library     Collections
Resource    ../../_setup/login.robot
Resource    ../../_setup/user_01.resource
Resource    ../Resources/objective.robot

*** Test Cases ***
Test Case Task 01  
    ${data_mock_sum}=         Set Variable                        ${5}
    ${auth_owner}             Auth                                email=${01_USER_EMAIL}               password=${01_USER_PASSWORD}
    ${auth_employee}          Auth                                email=${01_USER_IN_BRANCH_EMAIL}     password=${01_USER_IN_BRANCH_PASSWORD}
    ${mock_data}              Generate Multiple Mock Task         sum=${data_mock_sum}
    ${data_test_list}         Create Multiple Task                list=${mock_data}                    sum=${data_mock_sum}    auth=${auth_owner}    user_id=${01_USER_IN_BRANCH_ID}
    ${response}               Task Monitoring                     auth=${auth_employee}                user_permisiion=${1}    expected_status=200
    Validate Multiple task    data_test_list=${data_test_list}    response=${response}                 sum=${data_mock_sum}

*** Keywords ***
Auth
    [Arguments]    ${email}    ${password}
    ${response}    Open Login Session    email=${email}     password=${password}
    [return]       ${response}

Task Creation (Task Monitoting Test)
    [Arguments]    ${task}    ${description}    ${start_at}    ${end_at}    ${user_id}    ${auth}
    ${response}    POST Task    task=${task}    description=${description}    start_at=${start_at}     end_at=${end_at}    user_id=${user_id}    expected_status=201    auth=${auth}
    [return]       ${response}

Task Monitoring
    [Arguments]    ${auth}    ${user_permisiion}    ${expected_status}
    ${response}    GET Task Data    auth=${auth}     user_permission=${user_permisiion}    expected_status=${expected_status}
    [return]       ${response}

Task Validation
    [Arguments]    ${response}    ${data}
    ${number_of_days}             count_date    date_str1=${data}[end_at]    date_str2=${data}[start_at]
    Should Be Equal As Strings    first=${data}[task]            second=${response}[task]
    Should Be Equal As Strings    first=${data}[description]     second=${response}[description]
    Should Be Equal As Strings    first=${data}[start_at]        second=${response}[start_at]
    Should Be Equal As Strings    first=${data}[end_at]          second=${response}[end_at]
    Should Be Equal As Strings    first=todo                     second=${response}[status]
    Should Be Equal As Strings    first=${number_of_days}        second=${response}[number_of_days]

Generate Mock Task (Default)
    ${sentence}       Default Sentence 
    ${date_future}    Date Future
    ${date_past}      Date Past
    ${data}           Create Dictionary    task=${sentence}    description=${sentence}    start_at=${date_past}    end_at=${date_future}
    [Return]    ${data}

Generate Multiple Mock Task
    [Arguments]    ${sum}  
    @{list}=       Create List

    FOR    ${i}    IN RANGE    ${sum}
        ${data}    Generate Mock Task (Default)
        Append To List    ${list}    ${data}
    END

    [return]    ${list}

Create Multiple Task
    [Arguments]    ${list}    ${sum}    ${auth}    ${user_id}
    @{data_test_list}=        Create List

    FOR  ${i}  IN RANGE  ${sum}
        ${data_test}      Task Creation (Task Monitoting Test)    task=${list}[${i}][task]    description=${list}[${i}][description]    start_at=${list}[${i}][start_at]    end_at=${list}[${i}][end_at]    user_id=${user_id}    auth=${auth}
        Append To List    ${data_test_list}    ${data_test.json()}[data]
    END

    [return]    ${data_test_list}

Validate Multiple task
    [Arguments]    ${data_test_list}    ${response}    ${sum}

    FOR  ${i}  IN RANGE  ${sum}
        ${sliced}          Get Task By Id        target_id=${data_test_list}[${i}][id]     task_list=${response.json()}[data]
        Task Validation    response=${sliced}    data=${data_test_list}[${i}]
    END 