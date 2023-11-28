*** Settings ***
Library     RequestsLibrary
Library     Collections
Library     OperatingSystem

*** Variable ***
${attendance_check_in_report}     attendances/check_in
${attendance_check_out_report}    attendances/check_out
${attendance_status}              attendances/show
${attendance_monitoring}          employee/attendances/history


*** Keywords ***
Attendance Report
    [Arguments]    ${timestamp}    ${latitude}    ${longitude}    ${expected_status}
    ${hdr}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Authorization=Bearer ${login_response.json()}[access_token]

    ${attendance_data}=    Create Dictionary
    ...    check_in=${timestamp}
    ...    latitude= ${latitude}
    ...    longitude= ${longitude}

    ${attendance_data}    Evaluate    json.dumps(${attendance_data})

    ${check_in}    POST On Session        
    ...    qarpa
    ...    ${attendance_check_in_report}
    ...    data=${attendance_data}
    ...    headers=${hdr}
    ...    expected_status=${expected_status}
    
    [return]  ${check_in}

