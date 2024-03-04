*** Settings ***
Resource    ../Resources/Objective.robot
Resource    ../../_setup/UserSources.resource
Resource    ../../_setup/Login.robot

*** Test Cases ***
RTM2_TC1
    # [Documentation]     Testing Task Creation Using Valid Data but Null Permission
    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${90}        format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${2}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${5}
    ${payload}=             Data Validator            sentence=${sentence}         start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${payload}[task]        description=${payload}[description]    start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${643}    expected_status=201     auth=${permission}
    Positive Validation     ${payload}    ${response}
    
RTM2_TC2
    # [Documentation]     Testing Task Creation Using Valid Data but Null Permission
    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${90}        format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${2}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${5}
    ${payload}=             Data Validator            sentence=${sentence}         start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${null}                 description=${payload}[description]    start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${643}    expected_status=422     auth=${permission}
    Negative Validation In Scope                      response=${response}         key1=message      key2=task    key3=0     message=is too short (minimum is 1 character)
    Negative Validation In Scope                      response=${response}         key1=message      key2=task    key3=1     message=can't be blank

RTM2_TC3
    # [Documentation]     Testing Task Creation Using Valid Data but Null Permission
    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${256}        format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${2}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${5}
    ${payload}=             Data Validator            sentence=${sentence}         start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${payload}[task]        description=${payload}[description]    start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${643}    expected_status=422     auth=${permission}
    Negative Validation In Scope                      response=${response}         key1=message      key2=task    key3=0     message=is too long (maximum is 255 characters)

RTM2_TC4
    # [Documentation]     Testing Task Creation Using Valid Data but Null Permission
    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${254}        format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${2}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${5}
    ${payload}=             Data Validator            sentence=${sentence}         start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${payload}[task]        description=${payload}[description]    start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${643}    expected_status=201     auth=${permission}
    Positive Validation     ${payload}    ${response}

RTM2_TC5
    # [Documentation]     Testing Task Creation Using Valid Data but Null Permission
    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${1}        format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${2}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${5}
    ${payload}=             Data Validator            sentence=${sentence}         start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${payload}[task]        description=${payload}[description]    start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${643}    expected_status=201     auth=${permission}
    Positive Validation     ${payload}    ${response}

RTM2_TC6
    # [Documentation]     Testing Task Creation Using Valid Data but Null Permission
    Open Session
    ${sentence}=            Generate Sentence         sentence_length=${90}        format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${2}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${5}
    ${payload}=             Data Validator            sentence=${sentence}         start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${payload}[task]        description=${payload}[description]    start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${239}    expected_status=401     auth=${null}
    Negative Validation In Scope    response=${response}     key1=message     key2=${null}    key3=${null}     message=You have to log in.

RTM2_TC7
    # [Documentation]     Testing Task Creation Using Valid Data but Null Permission
    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${1}        format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${2}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${5}
    ${payload}=             Data Validator            sentence=${sentence}         start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${payload}[task]        description=${payload}[description]    start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${2222}    expected_status=422     auth=${permission}
    Negative Validation In Scope    response=${response}     key1=message     key2=user_id    key3=${0}     message=User id not valid
    Negative Validation In Scope    response=${response}     key1=message     key2=user    key3=${0}     message=must exist

RTM2_TC8
    # [Documentation]     Testing Task Creation Using Valid Data but Null Permission
    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${90}        format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${2}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${5}
    ${payload}=             Data Validator            sentence=${sentence}         start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${payload}[task]        description=${payload}[description]    start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${643}    expected_status=201     auth=${permission}
    Positive Validation     ${payload}    ${response}

RTM2_TC9
    # [Documentation]     Testing Task Creation Using Valid Data but Null Permission
    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${90}        format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${2}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${5}
    ${payload}=             Data Validator            sentence=${sentence}             start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${payload}[task]        description=${null}          start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${643}    expected_status=422     auth=${permission}
    Negative Validation In Scope                      response=${response}         key1=message      key2=description    key3=0     message=is too short (minimum is 1 character)
    Negative Validation In Scope                      response=${response}         key1=message      key2=description    key3=1     message=can't be blank

RTM2_TC10
    # [Documentation]     Testing Task Creation Using Valid Data but Null Permission
    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${255}        format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${2}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${5}
    ${payload}=             Data Validator            sentence=${sentence}         start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${payload}[task]        description=${payload}[description]    start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${643}    expected_status=422     auth=${permission}
    Negative Validation In Scope                      response=${response}         key1=message      key2=description    key3=0     message=is too long (maximum is 255 characters)

RTM2_TC10 NOT WRONG
    # [Documentation]     Testing Task Creation Using Valid Data but Null Permission
    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${256}        format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${2}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${5}
    ${payload}=             Data Validator            sentence=${sentence}         start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${payload}[task]        description=${payload}[description]    start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${643}    expected_status=422     auth=${permission}
    Negative Validation In Scope                      response=${response}         key1=message      key2=description    key3=0     message=is too long (maximum is 255 characters)

RTM2_TC11
    # [Documentation]     Testing Task Creation Using Valid Data but Null Permission
    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${254}       format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${2}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${5}
    ${payload}=             Data Validator            sentence=${sentence}         start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${payload}[task]        description=${payload}[description]    start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${643}    expected_status=201     auth=${permission}
    Positive Validation     ${payload}    ${response}

RTM2_TC12
    # [Documentation]     Testing Task Creation Using Valid Data but Null Permission
    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${1}       format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${2}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${5}
    ${payload}=             Data Validator            sentence=${sentence}         start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${payload}[task]        description=${payload}[description]    start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${643}    expected_status=201     auth=${permission}
    Positive Validation     ${payload}    ${response}

RTM2_TC13
    # [Documentation]     Testing Task Creation Using Valid Data but Null Permission
    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${90}       format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${0}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${0}
    ${payload}=             Data Validator            sentence=${sentence}         start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${payload}[task]        description=${payload}[description]    start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${643}    expected_status=201     auth=${permission}
    Positive Validation     ${payload}    ${response}

RTM2_TC14
    # [Documentation]     Testing Task Creation Using Valid Data but Null Permission
    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${90}       format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${5}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${1}
    ${payload}=             Data Validator            sentence=${sentence}         start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${payload}[task]        description=${payload}[description]    start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${643}    expected_status=201     auth=${permission}
    Positive Validation     ${payload}    ${response}

# RTM2_TC15
# RTM2_TC16
# RTM2_TC17
# RTM2_TC18
# RTM2_TC26
# RTM2_TC27
# RTM2_TC28
# RTM2_TC29
# RTM2_TC30
# RTM2_TC31

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

Negative Validation In Scope
    [Arguments]    ${response}    ${key1}    ${key2}    ${key3}    ${message}
    Should Not Be Empty           item=${response.json()}
    ${validation}=    Run Keyword If    '${key2}' != '${null}' and '${key3}' != '${null}'    Should Be Equal As Strings    first=${response.json()}[${key1}][${key2}][${key3}]     second=${message}
    ...    ELSE IF    '${key1}' != '${null}'        Should Be Equal As Strings    first=${response.json()}[${key1}]    second=${message}