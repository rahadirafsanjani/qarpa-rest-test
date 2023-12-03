*** Settings ***
Resource    ../../_setup/login.robot
Resource    ../Resources/objective.robot

*** Variables ***


*** Test Cases ***
Test Case Leave 01  
    ${data}    generate_data    sentence_length=${20}    use_digits=${True}    use_punctuation=${True}    use_whitespace=${True}    only_white_space=${False}
    leave_submission    title=${data}[title]    notes=${data}[notes]    start_at=${data}[start_at]    end_at=${data}[end_at]    expected_status=201

*** Keywords ***
leave_submission
    [Arguments]    ${title}    ${notes}    ${start_at}    ${end_at}    ${expected_status}
    ${response}    Open Login Session    email=xahapa4844@czilou.com     password=passworddd
    ${result}    POST Leave    title=${title}    notes= ${notes}    start_at=${start_at}    end_at=${end_at}    expected_status=${expected_status}    auth=${response}
    [return]    ${result}

generate_data
    [Arguments]    ${sentence_length}    ${use_digits}    ${use_punctuation}    ${use_whitespace}    ${only_white_space}
    IF  ${only_white_space} == ${True}
        ${response}    make_sentence_only_white_space    length=${sentence_length}
    ELSE
        ${response}    Make Sentence    length=${sentence_length}    digits=${use_digits}    punctuation=${use_punctuation}    whitespace=${use_whitespace}
    END
    ${date_future}    date_future
    ${date_past}    date_past
    ${data}    Create Dictionary    title=${response}    notes=${response}    start_at=${date_past}    end_at=${date_future}
    [Return]    ${data}
