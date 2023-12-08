*** Settings ***
Library     Collections
Resource    ../../_setup/login.robot
Resource    ../Resources/objective.robot

*** Test Cases ***
Test Case Task 01  
    ${data_mock_sum}=         Set Variable    ${5}
    ${auth}                   Auth
    ${mock_data}              Generate Multiple data              sum=${data_mock_sum}
    ${data_test_list}         Create Multiple Task                list=${mock_data}       sum=${data_mock_sum}
    ${response}               Get Data    auth=${auth}            user_permisiion=${1}    expected_status=200
    Validate Multiple task    data_test_list=${data_test_list}    response=${response}    sum=${data_mock_sum}

*** Keywords ***
Auth
    ${response}    Open Login Session    email=xahapa4844@czilou.com     password=passworddd
    [return]    ${response}

Get Data
    [Arguments]    ${auth}    ${user_permisiion}    ${expected_status}
    ${get}    GET Task Data    auth=${auth}     user_permission=${user_permisiion}    expected_status=${expected_status}
    [return]    ${get}

Generate Data Default
    ${sentence}       Default Sentence 
    ${date_future}    Date Future
    ${date_past}      Date Past
    ${data}           Create Dictionary    task=${sentence}    desc=${sentence}    start_at=${date_past}    end_at=${date_future}
    [Return]    ${data}

Create Task for Get Testing
    [Arguments]    ${task}    ${description}    ${start_at}    ${end_at}    ${user_id}
    ${response}    Open Login Session    email=xahapa4844@czilou.com     password=passworddd
    ${response}    POST Task    task=${task}    description=${description}    start_at=${start_at}     end_at=${end_at}    user_id=${user_id}    expected_status=201    auth=${response}
    [return]    ${response}

Validation
    [Arguments]    ${response}    ${data}
    ${number_of_days}    count_date    date_str1=${data}[end_at]    date_str2=${data}[start_at]
    Should Be Equal As Strings    first=${data}[task]            second=${response}[task]
    Should Be Equal As Strings    first=${data}[description]     second=${response}[description]
    Should Be Equal As Strings    first=${data}[start_at]        second=${response}[start_at]
    Should Be Equal As Strings    first=${data}[end_at]          second=${response}[end_at]
    Should Be Equal As Strings    first=todo                     second=${response}[status]
    Should Be Equal As Strings    first=${number_of_days}        second=${response}[number_of_days]

Generate Multiple data
    [Arguments]    ${sum}  
    @{list}=    Create List
    FOR    ${i}    IN RANGE    ${sum}
        ${data}    Generate Data Default
        Append To List    ${list}    ${data}
    END
    [return]    ${list}

Create Multiple Task
    [Arguments]    ${list}    ${sum}
    @{data_test_list}=        Create List
    FOR  ${i}  IN RANGE  ${sum}
        ${data_test}     Create Task for Get Testing    task=${list}[${i}][task]    description=${list}[${i}][desc]    start_at=${list}[${i}][start_at]    end_at=${list}[${i}][end_at]    user_id=${388}
        Append To List    ${data_test_list}    ${data_test.json()}[data]
    END
    [return]    ${data_test_list}

Validate Multiple task
    [Arguments]    ${data_test_list}    ${response}    ${sum}
    FOR  ${i}  IN RANGE  ${sum}
        ${sliced}     Get Task By Id        target_id=${data_test_list}[${i}][id]     task_list=${response.json()}[data]
        Validation    response=${sliced}    data=${data_test_list}[${i}]
    END 