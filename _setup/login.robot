*** Settings ***
Library     RequestsLibrary
Library     Collections
Library     OperatingSystem

*** Variables ***
${BASE_URL}    https://qarpa.fly.dev/api/v1/
${login}       users/auth/signin

*** Keywords ***
Open Login Session
    [Arguments]    ${email}    ${password}
    ${user_login_new}    Create Dictionary    email=${email}    password=${password}
    ${user_login_new}    Create Dictionary    user=${user_login_new}
    ${user_login_new}    Evaluate    json.dumps(${user_login_new})
    Log To Console    ${user_login_new}
    Create Session    qarpa    ${BASE_URL}    verify=true
    ${header-no-token}=    Create Dictionary    Content-Type=application/json
    ${login_response}=    POST On Session    qarpa    ${login}    data=${user_login_new}    headers=${header-no-token}
    [Return]    ${login_response}

Open Login Session Fails
    [Arguments]    ${email}    ${password}
    ${user_login_new}    Create Dictionary    email=${email}    password=${password}
    ${user_login_new}    Create Dictionary    user=${user_login_new}
    ${user_login_new}    Evaluate    json.dumps(${user_login_new})
    Log To Console    ${user_login_new}
    Create Session    qarpa    ${BASE_URL}    verify=true
    ${header-no-token}=    Create Dictionary    Content-Type=application/json
    ${fails_response}=    POST On Session    qarpa    ${login}    data=${user_login_new}    headers=${header-no-token}    expected_status=401
    [Return]     ${fails_response}