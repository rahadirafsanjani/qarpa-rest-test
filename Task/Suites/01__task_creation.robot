*** Settings ***
Resource    ../Resources/Objective.robot
Resource    ../../_setup/UserSources.resource
Resource    ../../_setup/Login.robot

*** Test Cases ***
Unpermission
    [Documentation]     Testing Task Creation Using Valid Data but Null Permission
    Open Session
    ${sentence}=            Generate Sentence    sentence_length=${90}        format_set=Base
    ${future_time}=         Generate Time        time_set=future_time         time_period=${2}
    ${past_time}=           Generate Time        time_set=past_time           time_period=${5}
    ${payload}=             Data Validator       sentence=${sentence}         start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task            task=${payload}[task]        description=${payload}[description]    start_at=${payload}[start_at]    
    ...                                          end_at=${payload}[end_at]    user_id=${643}    expected_status=401     auth=${null}
    Negative Validation     ${response}    message    You have to log in.

Test with Valid Data
    [Documentation]     Testing Task Creation Using Valid Data but Null Permission
    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${90}        format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${2}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${5}
    ${payload}=             Data Validator            sentence=${sentence}         start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${payload}[task]        description=${payload}[description]    start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${643}    expected_status=201     auth=${permission}
    Positive Validation     ${payload}    ${response}
    

*** Keywords ***
Generate Sentence
    [Arguments]    ${sentence_length}    ${format_set}
    ${sentence}=    Run Keyword If    '${format_set}' == 'Base'    Basic Sentence    length=${sentence_length}    
    ...    ELSE     Format Set Sentence    length=${sentence_length}    charset=${format_set}
    [Return]    ${sentence}

Generate Time
    [Arguments]    ${time_set}    ${time_period}
    ${dtime}=    Run Keyword If    '${time_set}' == 'future_time'    Future Time    days=${time_period}
    ...    ELSE IF    '${time_set}' == 'past_time'        Past Time    days=${time_period}
    ...    ELSE IF    '${time_set}' == 'time_same_day'    Time Same Day
    [Return]    ${dtime}

Data Validator
    [Arguments]    ${sentence}    ${start_at}    ${end_at}
    ${counter}=     Count Date           start_at=${start_at}    end_at=${end_at}
    ${payload}=     Create Dictionary    task=${sentence}        description=${sentence}    start_at=${start_at}    end_at=${end_at}    number_of_days=${counter}
    [return]    ${payload}

Positive Validation
    [Arguments]    ${payload}    ${response}
    ${start_at}=    Reformat Date        datetime_string=${payload}[start_at]
    ${end_at}=      Reformat Date        datetime_string=${payload}[end_at]

    Should Not Be Empty           item=${response.json()}
    Should Be Equal As Strings    first=${payload}[task]               second=${response.json()}[data][task]
    Should Be Equal As Strings    first=${payload}[description]        second=${response.json()}[data][description]
    Should Be Equal As Strings    first=${start_at}                    second=${response.json()}[data][start_at]
    Should Be Equal As Strings    first=${end_at}                      second=${response.json()}[data][end_at]
    Should Be Equal As Strings    first=todo                           second=${response.json()}[data][status]
    Should Be Equal As Strings    first=${payload}[number_of_days]     second=${response.json()}[data][number_of_days]

Negative Validation
    [Arguments]    ${response}    ${key}    ${message}
    Should Not Be Empty           item=${response.json()}
    Should Be Equal As Strings    first=${response.json()}[${key}]    second=${message}