*** Settings ***
Resource    ../../_setup/login.robot
Resource    ../../_setup/user_01.resource
Resource    ../Resources/objective.robot

*** Variables ***


*** Test Cases ***
Test Case Leave 01
    ${auth}                        Auth                      email=${01_USER_IN_BRANCH_EMAIL}     password=${01_USER_IN_BRANCH_PASSWORD}
    ${mock_data}                   Generate Mock Data        sentence_length=${20}                use_digits=${True}           use_punctuation=${True}            use_whitespace=${True}         only_white_space=${False}
    ${response}                    Leave Submission          title=${mock_data}[title]            notes=${mock_data}[notes]    start_at=${mock_data}[start_at]    end_at=${mock_data}[end_at]    expected_status=201    auth=${auth}
    Leave Submission Validation    mock_data=${mock_data}    response=${response}

*** Keywords ***
Auth
    [Arguments]    ${email}    ${password}
    ${response}    Open Login Session    email=${email}     password=${password}
    [return]       ${response}

Leave Submission
    [Arguments]    ${title}    ${notes}    ${start_at}    ${end_at}    ${expected_status}    ${auth}
    ${result}      POST Leave    title=${title}    notes=${notes}    start_at=${start_at}    end_at=${end_at}    expected_status=${expected_status}    auth=${auth}
    [return]       ${result}

Generate Mock Data
    [Arguments]    ${sentence_length}    ${use_digits}    ${use_punctuation}    ${use_whitespace}    ${only_white_space}
    IF  ${only_white_space} == ${True}
        ${response}    Make Sentence Only White Space    length=${sentence_length}
    ELSE
        ${response}    Make Sentence    length=${sentence_length}    digits=${use_digits}    punctuation=${use_punctuation}    whitespace=${use_whitespace}
    END

    ${date_future}     Date Future
    ${date_past}       Date Past

    ${data}            Create Dictionary    title=${response}    notes=${response}    start_at=${date_past}    end_at=${date_future}    status=menunggu
    [Return]    ${data}

Leave Submission Validation
    [Arguments]    ${mock_data}    ${response}
    Should Be Equal As Strings    first=Leave created successfully       second=${response.json()}[message]
    Should Be Equal As Strings    first=${mock_data}[title]              second=${response.json()}[data][title]
    Should Be Equal As Strings    first=${mock_data}[notes]              second=${response.json()}[data][notes]
    Should Be Equal As Strings    first=${mock_data}[start_at]           second=${response.json()}[data][start_at]
    Should Be Equal As Strings    first=${mock_data}[end_at]             second=${response.json()}[data][end_at]
    Should Be Equal As Strings    first=${mock_data}[status]             second=${response.json()}[data][status]

