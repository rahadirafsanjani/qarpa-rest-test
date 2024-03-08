*** Settings ***
Resource    ../Resources/Objective.robot
Resource    ../../_setup/UserSources.resource
Resource    ../../_setup/Login.robot

*** Test Cases ***
RTM2_TC1
    [Tags]                  BVA-T-02
    [Documentation]         Owner Loged in and Access Post Task Creation using Valid Task (90 Char) 
    ...                    (Other Field Valid) and Valid Format then Response Must Be 201 and Return Data Test 
    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${90}        format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${2}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${5}
    ${payload}=             Data Validator            sentence_1=${sentence}       sentence_2=${sentence}         start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${payload}[task]        description=${payload}[description]    start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${643}    expected_status=201     auth=${permission}
    Positive Validation     ${payload}    ${response}
    
RTM2_TC2
    [Tags]                  BVA-F-05
    [Documentation]         Owner Loged in and Access Post Task Creation using Blank Task (Invalid) 
    ...                     and Valid Format (Blank String) then Response Must Be 422 and Return Error Message 
    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${90}        format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${2}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${5}
    ${payload}=             Data Validator            sentence_1=${sentence}       sentence_2=${sentence}         start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${null}                 description=${payload}[description]    start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${643}    expected_status=422     auth=${permission}
    Negative Validation In Scope                      response=${response}         key1=message      key2=task    key3=0     message=is too short (minimum is 1 character)
    Negative Validation In Scope                      response=${response}         key1=message      key2=task    key3=1     message=can't be blank

RTM2_TC4
    [Tags]                  BVA-T-01
    [Documentation]         Owner Loged in and Access Post Task Creation using Valid Task (254 Char)
    ...                     (Other Field Valid) and Valid Format then Response Must Be 201 and Return Data Test
    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${254}        format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${2}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${5}
    ${payload}=             Data Validator            sentence_1=${sentence}       sentence_2=${sentence}         start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${payload}[task]        description=${payload}[description]    start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${643}    expected_status=201     auth=${permission}
    Positive Validation     ${payload}    ${response}

RTM2_TC5
    [Tags]                  BVA-T-03
    [Documentation]         Owner Loged in and Access Post Task Creation using Valid Task (1 Char)(Other Field Valid) 
    ...                     and Valid Format then Response Must Be 201 and Return Data Test
    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${1}         format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${2}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${5}
    ${payload}=             Data Validator            sentence_1=${sentence}       sentence_2=${sentence}         start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${payload}[task]        description=${payload}[description]    start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${643}    expected_status=201     auth=${permission}
    Positive Validation     ${payload}    ${response}

RTM2_TC6
    [Tags]                  EP-F-06
    [Documentation]         With No Permission and Access Post Task Creation using Valid Data and Valid Format 
    ...                     then Response Must Be 401 and Return Error Message
    Open Session
    ${sentence}=            Generate Sentence         sentence_length=${90}        format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${2}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${5}
    ${payload}=             Data Validator            sentence_1=${sentence}       sentence_2=${sentence}         start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${payload}[task]        description=${payload}[description]    start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${239}    expected_status=401     auth=${null}
    Negative Validation In Scope    response=${response}     key1=message     key2=${null}    key3=${null}     message=You have to log in.

RTM2_TC7
    [Tags]                  EP-F-05
    [Documentation]         Owner Loged in and Access Post Task Creation using Invalid User and Valid Format 
    ...                     then Response Must Be 422 and Return Error Message
    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${1}         format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${2}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${5}
    ${payload}=             Data Validator            sentence_1=${sentence}       sentence_2=${sentence}         start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${payload}[task]        description=${payload}[description]    start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${2222}    expected_status=422     auth=${permission}
    Negative Validation In Scope    response=${response}     key1=message     key2=user_id    key3=${0}     message=User id not valid
    Negative Validation In Scope    response=${response}     key1=message     key2=user    key3=${0}     message=must exist

RTM2_TC8
    [Tags]                  BVA-T-02
    [Documentation]         Owner Loged in and Access Post Task Creation using Valid Desc (90 Char)(Other Field Valid) 
    ...                     and Valid Format then Response Must Be 201 and Return Data Test
    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${90}        format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${2}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${5}
    ${payload}=             Data Validator            sentence_1=${sentence}       sentence_2=${sentence}         start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${payload}[task]        description=${payload}[description]    start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${643}    expected_status=201     auth=${permission}
    Positive Validation     ${payload}    ${response}

RTM2_TC9
    [Tags]                  BVA-F-05
    [Documentation]         Owner Loged in and Access Post Task Creation using Blank Desc (Invalid) 
    ...                     and Valid Format (Blank String) then Response Must Be 422 and Return Error Message

    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${90}        format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${2}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${5}
    ${payload}=             Data Validator            sentence_1=${sentence}       sentence_2=${sentence}         start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${payload}[task]        description=${null}          start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${643}    expected_status=422     auth=${permission}
    Negative Validation In Scope                      response=${response}         key1=message      key2=description    key3=0     message=is too short (minimum is 1 character)
    Negative Validation In Scope                      response=${response}         key1=message      key2=description    key3=1     message=can't be blank

RTM2_TC11
    [Tags]                  BVA-T-01
    [Documentation]         Owner Loged in and Access Post Task Creation using Valid Desc (254 Char)(Other Field Valid) 
    ...                     and Valid Format then Response Must Be 201 and Return Data Test

    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${254}       format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${2}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${5}
    ${payload}=             Data Validator            sentence_1=${sentence}       sentence_2=${sentence}         start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${payload}[task]        description=${payload}[description]    start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${643}    expected_status=201     auth=${permission}
    Positive Validation     ${payload}    ${response}

RTM2_TC12
    [Tags]                  BVA-T-03
    [Documentation]         Owner Loged in and Access Post Task Creation using Valid Desc (1 Char)(Other Field Valid) 
    ...                     and Valid Format then Response Must Be 201 and Return Data Test

    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${1}       format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${2}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${5}
    ${payload}=             Data Validator            sentence_1=${sentence}       sentence_2=${sentence}         start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${payload}[task]        description=${payload}[description]    start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${643}    expected_status=201     auth=${permission}
    Positive Validation     ${payload}    ${response}

RTM2_TC13
    [Tags]                  BVA-T-02
    [Documentation]         Owner Loged in and Access Post Task Creation using Valid Date (start_at < end_at) (Other Field Valid) 
    ...                     and Valid Format then Response Must Be 201 and Return Data Test

    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${90}       format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${0}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${0}
    ${payload}=             Data Validator            sentence_1=${sentence}       sentence_2=${sentence}         start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${payload}[task]        description=${payload}[description]    start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${643}    expected_status=201     auth=${permission}
    Positive Validation     ${payload}    ${response}

RTM2_TC14
    [Tags]                  BVA-T-02
    [Documentation]         Owner Loged in and Access Post Task Creation using Valid Date (start_at < end_at) (Other Field Valid) 
    ...                     and Valid Format then Response Must Be 201 and Return Data Test

    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${90}       format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${5}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${1}
    ${payload}=             Data Validator            sentence_1=${sentence}       sentence_2=${sentence}         start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${payload}[task]        description=${payload}[description]    start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${643}    expected_status=201     auth=${permission}
    Positive Validation     ${payload}    ${response}

RTM2_TC15
    [Tags]                  BVA-F-05
    [Documentation]         Owner Loged in and Access Post Task Creation using Invalid Date (Start_at > End_at) (Other Vield Valid) 
    ...                     and Valid Format then Response Must Be 422 and Return Error Message

    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${90}       format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${-5}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${0}
    ${payload}=             Data Validator            sentence_1=${sentence}       sentence_2=${sentence}         start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${payload}[task]        description=${payload}[description]    start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${643}    expected_status=422     auth=${permission}
    Negative Validation In Scope                      response=${response}         key1=message      key2=start_at    key3=0     message=Start at cannot bigger than end at

RTM2_TC16
    [Tags]                  BVA-F-05
    [Documentation]         Owner Loged in and Access Post Task Creation using Blank end_at (Invalid) 
    ...                     and Valid Format (Blank String) then Response Must Be 422 and Return Error Message

    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${90}        format_set=Base
    ${past_time}=           Generate Time             time_set=past_time           time_period=${0}
    ${response}=            POST Task                 task=${sentence}             description=${sentence}     start_at=${past_time}    
    ...                                               end_at=${null}    user_id=${643}    expected_status=422     auth=${permission}
    Negative Validation In Scope                      response=${response}         key1=message      key2=end_at    key3=0     message=End at cannot be blank

RTM2_TC17
    [Tags]                  BVA-F-05
    [Documentation]         Owner Loged in and Access Post Task Creation using Blank start_at (Invalid) 
    ...                     and Valid Format (Blank String) then Response Must Be 422 and Return Error Message

    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${90}        format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${2}
    ${response}=            POST Task                 task=${sentence}             description=${sentence}    start_at=${null} 
    ...                                               end_at=${future_time}        user_id=${643}    expected_status=422     auth=${permission}
    Negative Validation In Scope                      response=${response}         key1=message      key2=start_at    key3=0     message=Start at cannot be blank

RTM2_TC18
    [Tags]                  BVA-T-02
    [Documentation]         Owner Loged in and Access Post Task Creation using Valid Task (Other Field Valid) 
    ...                     and Invalid Format (Integer) then Response Must Be 201 and Return Data Test

    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${30}        format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${2}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${5}
    ${payload}=             Data Validator            sentence_1=${123232}         sentence_2=${sentence}                    start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${payload}[task]        description=${payload}[description]       start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${643}    expected_status=201     auth=${permission}
    Positive Validation     ${payload}    ${response}

RTM2_TC19
    [Tags]                  BVA-T-02
    [Documentation]         Owner Loged in and Access Post Task Creation using Valid Date (Other Field Valid) 
    ...                     and Valid Format then Response Must Be 201 and Return Data Test

    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${30}        format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${2}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${5}
    ${payload}=             Data Validator            sentence_1=${sentence}       sentence_2=${123232}                    start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${payload}[task]        description=${payload}[description]       start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${643}    expected_status=201     auth=${permission}
    Positive Validation     ${payload}    ${response}

RTM2_TC20
    [Tags]                  BVA-T-03
    [Documentation]         Owner Loged in and Access Post Task Creation using Invalid Start_at 
    ...                     and Valid Format (Incomplete Date Format)  then Response Must Be 422 and Return Error Message

    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${30}        format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${2}
    ${response}=            POST Task                 task=${sentence}             description=${sentence}       start_at=2023  
    ...                                               end_at=${future_time}        user_id=${643}    expected_status=422     auth=${permission}
    Negative Validation In Scope    response=${response}    key1=message    key2=start_at    key3=0    message=Start at cannot be blank

RTM2_TC21
    [Tags]                  BVA-T-03
    [Documentation]         Owner Loged in and Access Post Task Creation using Invalid End_at and Valid Format (Incomplete Date Format) 
    ...                     then Response Must Be 422 and Return Error Message

    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${30}        format_set=Base
    ${past_time}=           Generate Time             time_set=past_time           time_period=${5}
    ${response}=            POST Task                 task=${sentence}             description=${sentence}       start_at=${past_time}  
    ...                                               end_at=2025        user_id=${643}    expected_status=422     auth=${permission}
    Negative Validation In Scope    response=${response}    key1=message    key2=end_at    key3=0    message=End at cannot be blank

# Fails
RTM2_TC3
    [Tags]                  BVA-F-04
    [Documentation]         Owner Loged in and Access Post Task Creation using Invalid Task (255 Char)(Other Field Valid) 
    ...                     and Valid Format then Response Must Be 422 and Return Error Message

    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${255}        format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${2}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${5}
    ${payload}=             Data Validator            sentence_1=${sentence}       sentence_2=${sentence}         start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${payload}[task]        description=${payload}[description]    start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${643}    expected_status=422     auth=${permission}
    Negative Validation In Scope                      response=${response}         key1=message      key2=task    key3=0     message=is too long (maximum is 255 characters)


RTM2_TC10
    [Tags]                  BVA-F-04
    [Documentation]         Owner Loged in and Access Post Task Creation using Invalid Desc (255 Char)
    ...                    (Other Field Valid) and Valid Format then Response Must Be 422 and Return Error Message

    ${permission}=          Open Session and Login    email=${E_DUMB}              password=${PW_DUMB}
    ${sentence}=            Generate Sentence         sentence_length=${255}        format_set=Base
    ${future_time}=         Generate Time             time_set=future_time         time_period=${2}
    ${past_time}=           Generate Time             time_set=past_time           time_period=${5}
    ${payload}=             Data Validator            sentence_1=${sentence}       sentence_2=${sentence}         start_at=${past_time}    end_at=${future_time}
    ${response}=            POST Task                 task=${payload}[task]        description=${payload}[description]    start_at=${payload}[start_at]    
    ...                                               end_at=${payload}[end_at]    user_id=${643}    expected_status=422     auth=${permission}
    Negative Validation In Scope                      response=${response}         key1=message      key2=description    key3=0     message=is too long (maximum is 255 characters)

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
    [Arguments]    ${sentence_1}    ${sentence_2}    ${start_at}    ${end_at}
    ${counter}=     Count Date           start_at=${start_at}    end_at=${end_at}
    ${payload}=     Create Dictionary    task=${sentence_1}        description=${sentence_2}    start_at=${start_at}    end_at=${end_at}    number_of_days=${counter}
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



