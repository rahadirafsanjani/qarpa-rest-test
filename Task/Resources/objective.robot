*** Settings ***
Library     RequestsLibrary
Library     generator.py


*** Variables ***
${task_monitoring_owner}        management_works
${task_monitoring_employee}     employee/management_works
${task_creation}                management_works/
${task_overview}                management_works/
${task_quantity}                employee/management_works/amount
${task_report}                  employee/management_works/


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

    ${hdr}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Authorization=Bearer ${auth.json()}[access_token]

    Log To Console    ${task_data}

    ${result}=    POST On Session
    ...    qarpa
    ...    ${task_creation}
    ...    data=${task_data}
    ...    headers=${hdr}
    ...    expected_status=${expected_status}

    [return]  ${result}
