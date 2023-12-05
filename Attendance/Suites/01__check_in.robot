*** Settings ***
Resource    ../../_setup/login.robot
Resource    ../Resources/objective.robot

*** Variables ***


*** Test Cases ***
Test Case Attendace 01  
    ${data}    generate_data
    check_in    datetime=${data}[timestamp]    latitude=${data}[latitude]    longitude=${data}[longitude]

*** Keywords ***
check_in
    [Arguments]    ${datetime}    ${latitude}    ${longitude}
    ${response}    Open Login Session    email=xahapa4844@czilou.com     password=passworddd
    Attendance Report    timestamp=${datetime}    latitude=${latitude}    longitude=${longitude}    expected_status=200    auth=${response}

generate_data
    ${response1}    Generate Lat Long
    ${response2}    Current Time
    ${data}    Create Dictionary    latitude=${response1}[latitude]    longitude=${response1}[longitude]    timestamp=${response2}
    [Return]    ${data}

