*** Settings ***
Library     RequestsLibrary
Library     generator.py

*** Variables ***
# User Managements
${login}                         users/auth/signin
${create_employee}               users/create
${delete_employee}               users/delete
${monitoring_employee}           users/get_all
${current_user}                  users/current
${dropdown_user}                 users/dropdown

*** Keywords ***
POST Employee
    [Arguments]    ${name}    ${email}    ${password}    ${branch_id}    ${expected_status}   ${auth}
    ${user_data}=    Create Dictionary
    ...    name=${name}
    ...    email=${email}
    ...    password=${password}
    ...    branch_id=${branch_id}
    
    ${user_data}=    Create Dictionary    user=${user_data}
    ${user_data}=    Evaluate    json.dumps(${user_data})

    ${hdr}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Authorization=Bearer ${auth.json()}[access_token]

    IF    ${expected_status} == ${201}
        ${response}=    POST On Session
        ...    qarpa
        ...    ${create_employee}
        ...    data=${user_data}
        ...    headers=${hdr}
        ...    expected_status=${expected_status}
    ELSE
        ${response}=    POST On Session
        ...    qarpa
        ...    ${create_employee}
        ...    data=${user_data}
        ...    headers=${hdr}
        ...    expected_status=${expected_status}
    END

    [Return]    ${response}