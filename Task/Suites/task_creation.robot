*** Settings ***
Resource    ../../_setup/login.robot
Resource    ../Resources/objective.robot

*** Variables ***


*** Test Cases ***
Test Case Task 01  
    ${data}    generate_data    sentence_length=${20}    use_digits=${True}    use_punctuation=${True}    use_whitespace=${True}    only_white_space=${False}
    task_creation    task=${data}[task]    description=${data}[desc]    start_at=${data}[start_at]    end_at=${data}[end_at]    user_id=${388}    daydiff=${data}[number_of_days]

*** Keywords ***
task_creation
    [Arguments]    ${task}    ${description}    ${start_at}    ${end_at}    ${user_id}    ${daydiff}
    ${response}    Open Login Session    email=xahapa4844@czilou.com     password=passworddd
    ${response}    POST Task      task=${task}    description=${description}    start_at=${start_at}     end_at=${end_at}    user_id=${user_id}    expected_status=201    auth=${response}
    Should Be Equal As Strings    first=${task}    second=${response.json()}[data][task]
    Should Be Equal As Strings    first=${description}    second=${response.json()}[data][description]
    Should Be Equal As Strings    first=${start_at}    second=${response.json()}[data][start_at]
    Should Be Equal As Strings    first=${end_at}    second=${response.json()}[data][end_at]
    Should Be Equal As Strings    first=todo    second=${response.json()}[data][status]
    Should Be Equal As Strings    first=${daydiff}    second=${response.json()}[data][number_of_days]

generate_data
    [Arguments]    ${sentence_length}    ${use_digits}    ${use_punctuation}    ${use_whitespace}    ${only_white_space}
    IF  ${only_white_space} == ${True}
        ${response}    make_sentence_only_white_space    length=${sentence_length}
    ELSE
        ${response}    Make Sentence    length=${sentence_length}    digits=${use_digits}    punctuation=${use_punctuation}    whitespace=${use_whitespace}
    END
    ${date_future}    date_future
    ${date_past}    date_past
    ${daydiff}    Count Date    date_str1=${date_future}    date_str2=${date_past}
    Log To Console    ${daydiff}
    ${data}    Create Dictionary    task=${response}    desc=${response}    start_at=${date_past}    end_at=${date_future}    number_of_days=${daydiff}
    [Return]    ${data}
