*** Settings ***
Library     RequestsLibrary
Library     generator.py


*** Variables ***
# sample
${real_enpoint_and_params1}     leave_managements/actions?id=20&status=disetujui
${real_enpoint_and_params2}     leave_managements/actions?id=20&status=ditolak
# interactive endpoint
${leave_request_base}      leave_managements
${leave_request_action}    leave_managements/actions
${submission_accept}       disetujui
${submission_reject}       ditolak


*** Keywords ***
POST Leave
    [Arguments]    ${title}    ${notes}    ${start_at}    ${end_at}    ${expected_status}    ${auth}
    ${leave_data}=    Create Dictionary
    ...    title=${title}
    ...    notes=${notes}
    ...    start_at=${start_at}
    ...    end_at=${end_at}

    ${leave_data}=    Create Dictionary    
    ...    leave_management=${leave_data}
    
    ${leave_data}=    Evaluate    
    ...    json.dumps(${leave_data})

    ${hdr}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Authorization=Bearer ${auth.json()}[access_token]

    ${result}=    POST On Session
    ...    qarpa
    ...    ${leave_request_base}
    ...    data=${leave_data}
    ...    headers=${hdr}
    ...    expected_status=${expected_status}

    [return]  ${result}

PUT Leave Assessment
    [Arguments]    ${auth}    ${leave_id}    ${expected_status}    ${submission_status}

    ${hdr}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Authorization=Bearer ${auth.json()}[access_token]

    IF  ${submission_status} == ${1}
        ${params}=    Set Variable   id=${leave_id}&status=${submission_accept}
    ELSE IF  ${submission_status} == ${2}
        ${params}=    Set Variable   id=${leave_id}&status=${submission_reject}
    END

    ${result}=    PUT On Session
    ...    qarpa
    ...    ${leave_request_action}
    ...    params=${params}
    ...    headers=${hdr}
    ...    expected_status=${expected_status}

    [return]  ${result}

GET Leave Data
    [Arguments]    ${auth}    ${user_permission}    ${expected_status}

    ${hdr}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Authorization=Bearer ${auth.json()}[access_token]
    
    IF  ${user_permission} == ${1}
        ${endpoint}=    Set Variable    ${leave_request_base}
    ELSE IF  ${user_permission} == ${2}  
        ${endpoint}=    Set Variable    employee/${leave_request_base}
    END
    
    ${result}=    Get On Session
    ...    qarpa
    ...    ${endpoint}
    ...    headers=${hdr}
    ...    expected_status=${expected_status}

    [return]  ${result}

