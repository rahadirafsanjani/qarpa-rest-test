*** Settings ***
Resource    ../../_setup/login.robot
Resource    ../Resources/objective.robot

*** Variables ***


*** Test Cases ***
Test Case Task 01  
    ${data}    Generate Data Default
    ${auth}    Auth
    ${ids}     Create Task for Get Testing    task=${data}[task]    description=${data}[desc]    start_at=${data}[start_at]    end_at=${data}[end_at]    user_id=${388}
    Get Data    task_id=${ids.json()}[data][id]    auth=${auth}    user_permisiion=${2}    expected_status=200
    

*** Keywords ***
Auth
    ${response}    Open Login Session    email=xahapa4844@czilou.com     password=passworddd
    [return]    ${response}

Get Data
    [Arguments]    ${task_id}    ${auth}    ${user_permisiion}    ${expected_status}
    ${sa}    GET Task Overview    task_id=${task_id}   auth=${auth}     user_permission=${user_permisiion}    expected_status=${expected_status}

Create Task for Get Testing
    [Arguments]    ${task}    ${description}    ${start_at}    ${end_at}    ${user_id}
    ${response}    Open Login Session    email=xahapa4844@czilou.com     password=passworddd
    ${response}    POST Task    task=${task}    description=${description}    start_at=${start_at}     end_at=${end_at}    user_id=${user_id}    expected_status=201    auth=${response}
    [return]    ${response}

Generate Data Default
    ${sentence}    Default Sentence 
    ${date_future}    date_future
    ${date_past}    date_past
    ${data}    Create Dictionary    task=${sentence}    desc=${sentence}    start_at=${date_past}    end_at=${date_future}
    [Return]    ${data}