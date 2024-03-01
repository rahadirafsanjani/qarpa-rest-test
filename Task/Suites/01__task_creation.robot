*** Settings ***
Resource    ../../_setup/Login.robot
Resource    ../../_setup/UserSources.resource
Resource    ../Resources/Objective.robot

*** Variables ***

*** Test Cases ***
Unpermission
    [Documentation]     Testing Task Creation Using Valid Data
    ${data}=            Generate Mock Task    sentence_length=${90}    use_digits=${True}                  use_punctuation=${True}       use_whitespace=${True}    only_white_space=${False}
    ${auth}=            Open Session and Login    email=${E_DUMB}          password=${PW_DUMB} 
    ${response}=        Task Creation         task=${data}[task]       description=${data}[description]    start_at=${data}[start_at]    end_at=${data}[end_at]    user_id=${643}    expected_status=401    auth=${null}
    Log To Console      ${response.content}
    # Task Validation     mock_data=${data}     response=${response}
    # Set Test Message    message=Test Success

Valid Data
    [Documentation]     Testing Task Creation Using Valid Data
    ${data}=            Generate Mock Task    sentence_length=${90}    use_digits=${True}                  use_punctuation=${True}       use_whitespace=${True}    only_white_space=${False}
    ${auth}=            Open Session and Login    email=${E_DUMB}          password=${PW_DUMB} 
    ${response}=        Task Creation         task=${data}[task]       description=${data}[description]    start_at=${data}[start_at]    end_at=${data}[end_at]    user_id=${643}    expected_status=201     auth=${auth}
    Log To Console      ${response}
    # Task Validation     mock_data=${data}     response=${response}
    # Set Test Message    message=Test Success


*** Keywords ***
Task Creation
    [Arguments]    ${task}    ${description}    ${start_at}    ${end_at}    ${user_id}    ${expected_status}    ${auth}    
    ${response}    POST Task      task=${task}    description=${description}    start_at=${start_at}     end_at=${end_at}    user_id=${user_id}    expected_status=${expected_status}    auth=${auth}
    [return]       ${response}

Generate Mock Task
    [Arguments]    ${sentence_length}    ${use_digits}    ${use_punctuation}    ${use_whitespace}    ${only_white_space}

    IF  ${only_white_space} == ${True}
        ${response}=    make_sentence_only_white_space    length=${sentence_length}
    ELSE
        ${response}=    Make Sentence    length=${sentence_length}    digits=${use_digits}    punctuation=${use_punctuation}    whitespace=${use_whitespace}
    END

    ${date_future}=    date_future
    ${date_past}=      date_past
    ${daydiff}=        Count Date           date_str1=${date_future}    date_str2=${date_past}
    ${data}=           Create Dictionary    task=${response}            description=${response}    start_at=${date_past}    end_at=${date_future}    number_of_days=${daydiff}

    [Return]    ${data}

Task Validation
    [Arguments]    ${mock_data}    ${response}

    IF    '${auth}' == '${null}'
        ${header}=    Create Dictionary
        ...           Content-Type=application/json
        ...           Authorization=${EMPTY}
    ELSE
        ${header}=    Create Dictionary
        ...           Content-Type=application/json
        ...           Authorization=Bearer ${auth.json()}[access_token]
    END

    Should Be Equal As Strings    first=${mock_data}[task]               second=${response.json()}[data][task]
    Should Be Equal As Strings    first=${mock_data}[description]        second=${response.json()}[data][description]
    Should Be Equal As Strings    first=${mock_data}[start_at]           second=${response.json()}[data][start_at]
    Should Be Equal As Strings    first=${mock_data}[end_at]             second=${response.json()}[data][end_at]
    Should Be Equal As Strings    first=todo                             second=${response.json()}[data][status]
    Should Be Equal As Strings    first=${mock_data}[number_of_days]     second=${response.json()}[data][number_of_days]