*** Settings ***
Library     RequestsLibrary
Library     OperatingSystem

*** Variables ***
${BASE_URL}    https://qarpa.fly.dev/api/v1/
${LOGIN_URL}       users/auth/signin

*** Keywords ***
Open Session and Login
    [Arguments]    ${email}    ${password}
    ${payload}             Dump Login            email=${email}                    password=${password}
    Create Session         qarpa                 ${BASE_URL}                       verify=true
    ${no_token_header}=    Create Dictionary     Content-Type=application/json
    ${response}=           POST On Session       qarpa                             ${LOGIN_URL}    data=${payload}    headers=${no_token_header}
    [Return]    ${response}

Open Session
    Create Session    qarpa    ${BASE_URL}    verify=true

Dump Login
    [Arguments]    ${email}    ${password}
    ${user_login}=    Create Dictionary    email=${email}    password=${password}
    ${user_login}=    Create Dictionary    user=${user_login}
    ${user_login}=    Evaluate             json.dumps(${user_login})
    [return]    ${user_login}
    
