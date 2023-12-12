*** Settings ***
Resource    ../../_setup/login.robot
Resource    ../Resources/objective.robot
Library     ../Resources/generator.py

*** Variables ***


*** Test Cases ***
Test Case Leave 01  
    ${auth}    Auth
    ${data}    Generate_Data
    ${response}   Create Leave Submission    title=${data}[title]    notes=${data}[notes]    start_at=${data}[start_at]    end_at=${data}[end_at]    expected_status=201    auth=${auth}
    ${result}    Accept Submission    auth=${auth}    leave_id=${response.json()}[data][id]    expected_status=200

*** Keywords ***
Auth
    ${response}    Open Login Session    email=xahapa4844@czilou.com     password=passworddd
    [return]    ${response}

Create Leave Submission
    [Arguments]    ${title}    ${notes}    ${start_at}    ${end_at}    ${expected_status}    ${auth}
    ${result}    POST Leave    title=${title}    notes= ${notes}    start_at=${start_at}    end_at=${end_at}    expected_status=${expected_status}    auth=${auth}
    [return]    ${result}

Generate_Data
    ${sentence}    Default Sentence    
    ${date_future}    date_future
    ${date_past}    date_past
    ${data}    Create Dictionary    title=${sentence}    notes=${sentence}    start_at=${date_past}    end_at=${date_future}
    [Return]    ${data}

Accept Submission
    [Arguments]    ${auth}    ${leave_id}    ${expected_status}
    ${data}    PUT Leave Assessment    auth=${auth}    leave_id=${leave_id}    expected_status=${expected_status}    submission_status=${2}
    Log To Console    ${data.json()}[data]