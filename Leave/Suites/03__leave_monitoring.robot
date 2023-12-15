*** Settings ***
Library     ../Resources/generator.py
Library     Collections

Resource    ../../_setup/login.robot
Resource    ../../_setup/user_01.resource
Resource    ../Resources/objective.robot


*** Variables ***


*** Test Cases ***
Test Case Leave 01  
    [Documentation]    Test Monitoring Owner (Access by Owner)
    ${data_mock_sum}=          Set Variable                        ${4}
    ${mock_data}               Generate Multiple Mock Leave         sum=${data_mock_sum}
    ${auth_employee}           Auth     email=${01_USER_IN_BRANCH_EMAIL}     password=${01_USER_IN_BRANCH_PASSWORD}
    ${data_test_list}          Create Multiple Leave                list=${mock_data}                    sum=${data_mock_sum}    auth=${auth_employee}
    ${auth_owner}              Auth     email=${01_USER_EMAIL}     password=${01_USER_PASSWORD}
    ${response}                Leave Monitoring                     auth=${auth_owner}                   user_permisiion=${1}    expected_status=200
    Validate Multiple leave    data_test_list=${data_test_list}          response=${response}                 sum=${data_mock_sum}
Test Case Leave 02    
    [Documentation]    Test Monitoring Employee (Access by Empoyee)
    ${data_mock_sum}=          Set Variable                        ${4}
    ${mock_data}               Generate Multiple Mock Leave         sum=${data_mock_sum}
    ${auth_employee}           Auth     email=${01_USER_IN_BRANCH_EMAIL}     password=${01_USER_IN_BRANCH_PASSWORD}
    ${data_test_list}          Create Multiple Leave                list=${mock_data}                    sum=${data_mock_sum}    auth=${auth_employee}
    ${response}                Leave Monitoring                     auth=${auth_employee}                   user_permisiion=${2}    expected_status=200
    Validate Multiple leave    data_test_list=${data_test_list}          response=${response}                 sum=${data_mock_sum}

*** Keywords ***
Auth
    [Arguments]    ${email}    ${password}
    ${response}    Open Login Session    email=${email}     password=${password}
    [return]       ${response}

Leave Monitoring
    [Arguments]    ${auth}    ${user_permisiion}    ${expected_status}
    IF  ${user_permisiion} == ${2}
        ${result}    GET Leave Data    auth=${auth}     user_permission=${user_permisiion}    expected_status=${expected_status}
        ${result}    Set Variable    ${result.json()}[data][data]
    ELSE
        ${result}    GET Leave Data    auth=${auth}     user_permission=${user_permisiion}    expected_status=${expected_status}
        ${result}    Replace Key In List    input_list=${result.json()}[data]  
        ${result}    Set Variable    ${result}
    END
    [return]    ${result}
    
Leave Submission
    [Arguments]    ${title}    ${notes}    ${start_at}    ${end_at}    ${expected_status}    ${auth}
    ${result}      POST Leave    title=${title}    notes=${notes}    start_at=${start_at}    end_at=${end_at}    expected_status=${expected_status}    auth=${auth}
    [return]       ${result}

Generate Mock Leave
    ${sentence}        Default Sentence
    ${date_future}     Date Future
    ${date_past}       Date Past
    ${data}            Create Dictionary    title=${sentence}    notes=${sentence}    start_at=${date_past}    end_at=${date_future}
    [Return]    ${data}

Find Leave by Id
    [Arguments]    ${leave_list}    ${target_id}
    ${data}    Get Leave Submission By Id    leave_list=${leave_list}     target_id=${target_id}
    [return]    ${data}

Leave Submission Validation
    [Arguments]    ${response}    ${data}
    Should Be Equal As Strings    first=${data}[title]               second=${response}[title]
    Should Be Equal As Strings    first=${data}[notes]               second=${response}[notes]
    Should Be Equal As Strings    first=${data}[start_at]            second=${response}[start_at]
    Should Be Equal As Strings    first=${data}[end_at]              second=${response}[end_at]
    Should Be Equal As Strings    first=menunggu                     second=${response}[leave_status]

# Multiple data handler
Generate Multiple Mock Leave
    [Arguments]    ${sum}  
    @{list}=       Create List

    FOR    ${i}    IN RANGE    ${sum}
        ${data}    Generate Mock Leave
        Append To List    ${list}    ${data}
    END

    [return]    ${list}

Create Multiple leave
    [Arguments]    ${list}    ${sum}    ${auth}
    @{data_test_list}=        Create List

    FOR  ${i}  IN RANGE  ${sum}
        ${data_test}      Leave Submission    title=${list}[${i}][title]    notes=${list}[${i}][notes]    start_at=${list}[${i}][start_at]    end_at=${list}[${i}][end_at]    expected_status=201    auth=${auth}
        Append To List    ${data_test_list}    ${data_test.json()}[data]
    END

    [return]    ${data_test_list}

Validate Multiple Leave
    [Arguments]    ${data_test_list}    ${response}    ${sum}

    FOR  ${i}  IN RANGE  ${sum}
        ${sliced}      Find Leave by Id    leave_list=${response}    target_id=${data_test_list}[${i}][id]     
        Leave Submission Validation    response=${sliced}    data=${data_test_list}[${i}]
    END 