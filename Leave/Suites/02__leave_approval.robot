*** Settings ***
Resource    ../../_setup/login.robot
Resource    ../../_setup/user_01.resource
Resource    ../Resources/objective.robot
Library     ../Resources/generator.py

*** Variables ***
${approve}    disetujui
${reject}     ditolak

*** Test Cases ***
Test Case Leave 01
    ${status}              Set Variable               ${approve}
    ${mock_data}           Generate_Data              status=${status}
    ${auth}                Auth                       email=${01_USER_EMAIL}     password=${01_USER_PASSWORD}
    ${ids}                 Create Leave Submission    title=${mock_data}[title]       notes=${mock_data}[notes]       start_at=${mock_data}[start_at]    end_at=${mock_data}[end_at]    expected_status=201    auth=${auth}
    ${response}            Submission Approval        auth=${auth}               leave_id=${ids.json()}[data][id]    expected_status=200    submission_status=${status}
    Approval Validation    mock_data=${mock_data}     response=${response}

*** Keywords ***
Auth
    [Arguments]    ${email}    ${password}
    ${response}    Open Login Session    email=${email}     password=${password}
    [return]       ${response}

Create Leave Submission
    [Arguments]    ${title}    ${notes}    ${start_at}    ${end_at}    ${expected_status}    ${auth}
    ${response}    POST Leave    title=${title}    notes=${notes}    start_at=${start_at}    end_at=${end_at}    expected_status=${expected_status}    auth=${auth}
    [return]       ${response}

Generate_Data
    [Arguments]       ${status}
    ${sentence}       Default Sentence    
    ${date_future}    Date Future
    ${date_past}      Date Past
    ${data}           Create Dictionary    title=${sentence}    notes=${sentence}    start_at=${date_past}    end_at=${date_future}    status=${status}
    [Return]          ${data}

Submission Approval
    [Arguments]    ${auth}    ${leave_id}    ${expected_status}    ${submission_status}
    IF  "${submission_status}" == "disetujui"
        ${submission_status}    Set Variable    ${1}
    ELSE IF  "${submission_status}" == "ditolak"
        ${submission_status}    Set Variable    ${2}
    ELSE
        Log To Console    message="error at status"
        No Operation
    END
    
    IF  ${submission_status} == ${1} or ${submission_status} == ${2}
        ${data}    PUT Leave Assessment    auth=${auth}    leave_id=${leave_id}    expected_status=${expected_status}    submission_status=${submission_status}
    END

    [return]    ${data}

Approval Validation
    [Arguments]    ${mock_data}    ${response}
    Should Be Equal As Strings    first=Leave updated successfully       second=${response.json()}[message]
    Should Be Equal As Strings    first=${mock_data}[title]              second=${response.json()}[data][title]
    Should Be Equal As Strings    first=${mock_data}[notes]              second=${response.json()}[data][notes]
    Should Be Equal As Strings    first=${mock_data}[start_at]           second=${response.json()}[data][start_at]
    Should Be Equal As Strings    first=${mock_data}[end_at]             second=${response.json()}[data][end_at]
    Should Be Equal As Strings    first=${mock_data}[status]             second=${response.json()}[data][status]