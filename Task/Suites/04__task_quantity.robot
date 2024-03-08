*** Settings ***
Library     Collections
Resource    ../Resources/Objective.robot
Resource    ../../_setup/UserSources.resource
Resource    ../../_setup/Login.robot

*** Test Cases ***
RTM2_TC25 
    [Tags]              EP-T-02
    [Documentation]     Employee Loged in and Access Get Task Amount then Response 
    ...                 Must Be 200 and Return Correct Task Calculation

    ${permission}=      Open Session and Login    email=${EMPLOYEE_1.2.1_EMAIL}              password=${EMPLOYEE_1.2.1_PASSWORD}
    ${response}         GET Task Quantity    auth=${permission}     expected_status=200
    ${counter}          Counter Task    permission=${permission}     user_role=employee
    Task Validation    mock_data=${counter}    response=${response}

*** Keywords ***
Task Validation
    [Arguments]    ${mock_data}    ${response}
    Should Be Equal As Integers    first=${mock_data}[todo_task_count]       second=${response.json()}[data][todo]
    Should Be Equal As Integers    first=${mock_data}[done_task_count]       second=${response.json()}[data][done]

Counter Task
    [Arguments]    ${permission}    ${user_role}
    ${response}=      GET Task Monitoring       auth=${permission}    user_permission=${user_role}    expected_status=200
    ${response}=      count_task_status         task_list=${response.json()}[data]
    [Return]    ${response}