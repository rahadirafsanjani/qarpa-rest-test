*** Settings ***
Library     RequestsLibrary
Library     DataBuilder.py

*** Variables ***
${task_monitoring_owner}=        management_works
${task_base}=                    management_works
${task_monitoring_employee}=     employee/management_works
${task_creation}=                management_works
${task_overview}=                management_works
${task_quantity}=                employee/management_works/amount
${task_report}=                  employee/management_works

*** Keywords ***
POST Task
    [Arguments]    ${task}    ${description}    ${start_at}    ${end_at}    ${user_id}    ${expected_status}    ${auth}
    ${task_data}=    Create Dictionary
    ...    task=${task}
    ...    description=${description}
    ...    start_at=${start_at}
    ...    end_at=${end_at}
    ...    user_id=${user_id}

    ${task_data}=    Create Dictionary    
    ...    management_work=${task_data}
    
    ${task_data}=    Evaluate    
    ...    json.dumps(${task_data})

    IF    '${auth}' == '${null}'
        ${header}=    Create Dictionary
        ...           Content-Type=application/json
        ...           Authorization=${EMPTY}
    ELSE
        ${header}=    Create Dictionary
        ...           Content-Type=application/json
        ...           Authorization=Bearer ${auth.json()}[access_token]
    END
    
    # ${header}=    Create Dictionary
    # ...    Content-Type=application/json
    # ...    Authorization=Bearer ${auth.json()}[access_token]

    ${result}=    POST On Session
    ...    qarpa
    ...    ${task_base}
    ...    data=${task_data}
    ...    headers=${header}
    ...    expected_status=${expected_status}

    [return]  ${result}

GET Task Monitoring
    [Arguments]    ${auth}    ${user_permission}    ${expected_status}

    ${header}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Authorization=Bearer ${auth.json()}[access_token]
    
    IF  '${user_permission}' == 'owner'
        ${endpoint}=    Set Variable    ${task_base}
    ELSE IF  ${user_permission} == employee  
        ${endpoint}=    Set Variable    employee/${task_base}
    END
    
    ${result}=    Get On Session    
    ...    qarpa
    ...    ${endpoint}
    ...    headers=${header}
    ...    expected_status=${expected_status}

    [return]    ${result}


GET Task Overview
    [Arguments]    ${task_id}    ${auth}    ${expected_status}

    ${header}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Authorization=Bearer ${auth.json()}[access_token]
    
    ${result}=    Get On Session
    ...    qarpa
    ...    ${task_base}/${task_id}
    ...    headers=${header}
    ...    expected_status=${expected_status}

    [return]  ${result}

GET Task Quantity
    [Arguments]    ${auth}    ${expected_status}

    ${header}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Authorization=Bearer ${auth.json()}[access_token]
    
    ${result}=    Get On Session
    ...    qarpa
    ...    ${task_quantity}
    ...    headers=${header}
    ...    expected_status=${expected_status}

    [return]  ${result}


PUT Task Report
    [Arguments]    ${task_id}    ${auth}    ${expected_status}

    ${header}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Authorization=Bearer ${auth.json()}[access_token]
    
    ${result}=    PUT On Session
    ...    qarpa
    ...    employee/${task_base}/${task_id}
    ...    headers=${header}
    ...    expected_status=${expected_status}

    [return]  ${result}
