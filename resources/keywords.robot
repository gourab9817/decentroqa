*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    String
Resource   variables.robot

*** Keywords ***
# Session Management Keywords
Setup Test Session
    [Documentation]    Creates a new session for API testing with API key header
    ${headers}=    Create Dictionary    x-api-key=${API_KEY}
    Create Session    reqres    ${BASE_URL}    headers=${headers}    verify=${True}    disable_warnings=${True}

Teardown Test Session
    [Documentation]    Deletes the session after test completion
    Delete All Sessions

# GET Request Keywords
Send GET Request
    [Documentation]    Sends a GET request and returns the response
    [Arguments]    ${endpoint}    ${expected_status}=${STATUS_OK}
    Sleep    0.5s    # Delay to avoid rate limiting
    ${response}=    GET On Session    reqres    ${endpoint}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    ${expected_status}
    RETURN    ${response}

Verify User Data In Response
    [Documentation]    Verifies that user data is present in response
    [Arguments]    ${response}    ${expected_id}
    ${data}=    Set Variable    ${response.json()}[data]
    Should Be Equal As Integers    ${data}[id]    ${expected_id}
    Should Not Be Empty    ${data}[email]
    Should Not Be Empty    ${data}[first_name]
    Should Not Be Empty    ${data}[last_name]
    Should Not Be Empty    ${data}[avatar]

Verify List Response Structure
    [Documentation]    Verifies the structure of list response
    [Arguments]    ${response}
    Should Contain    ${response.json()}    page
    Should Contain    ${response.json()}    per_page
    Should Contain    ${response.json()}    total
    Should Contain    ${response.json()}    total_pages
    Should Contain    ${response.json()}    data
    ${data_list}=    Get From Dictionary    ${response.json()}    data
    Should Not Be Empty    ${data_list}

# POST Request Keywords
Send POST Request
    [Documentation]    Sends a POST request with JSON data and returns response
    [Arguments]    ${endpoint}    ${data}    ${expected_status}=${STATUS_CREATED}
    Sleep    0.2s    # Small delay to avoid rate limiting
    ${response}=    POST On Session    reqres    ${endpoint}    json=${data}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    ${expected_status}
    RETURN    ${response}

Create User Data Dictionary
    [Documentation]    Creates a dictionary with user data
    [Arguments]    ${name}    ${job}
    ${data}=    Create Dictionary    name=${name}    job=${job}
    RETURN    ${data}

Verify Created User Response
    [Documentation]    Verifies that created user response contains correct data
    [Arguments]    ${response}    ${expected_name}    ${expected_job}
    ${json}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${json}[name]    ${expected_name}
    Should Be Equal As Strings    ${json}[job]    ${expected_job}
    Should Contain    ${json}    id
    Should Contain    ${json}    createdAt
    Should Not Be Empty    ${json}[id]
    Should Not Be Empty    ${json}[createdAt]

# PUT Request Keywords
Send PUT Request
    [Documentation]    Sends a PUT request with JSON data and returns response
    [Arguments]    ${endpoint}    ${data}    ${expected_status}=${STATUS_OK}
    Sleep    0.2s    # Small delay to avoid rate limiting
    ${response}=    PUT On Session    reqres    ${endpoint}    json=${data}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    ${expected_status}
    RETURN    ${response}

Verify Updated User Response
    [Documentation]    Verifies that updated user response contains correct data
    [Arguments]    ${response}    ${expected_name}    ${expected_job}
    ${json}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${json}[name]    ${expected_name}
    Should Be Equal As Strings    ${json}[job]    ${expected_job}
    Should Contain    ${json}    updatedAt
    Should Not Be Empty    ${json}[updatedAt]

# PATCH Request Keywords
Send PATCH Request
    [Documentation]    Sends a PATCH request with JSON data and returns response
    [Arguments]    ${endpoint}    ${data}    ${expected_status}=${STATUS_OK}
    Sleep    0.2s    # Small delay to avoid rate limiting
    ${response}=    PATCH On Session    reqres    ${endpoint}    json=${data}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    ${expected_status}
    RETURN    ${response}

# DELETE Request Keywords
Send DELETE Request
    [Documentation]    Sends a DELETE request and returns response
    [Arguments]    ${endpoint}    ${expected_status}=${STATUS_NO_CONTENT}
    Sleep    0.2s    # Small delay to avoid rate limiting
    ${response}=    DELETE On Session    reqres    ${endpoint}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    ${expected_status}
    RETURN    ${response}

# Registration Keywords
Create Registration Data
    [Documentation]    Creates a dictionary with registration data
    [Arguments]    ${email}    ${password}
    ${data}=    Create Dictionary    email=${email}    password=${password}
    RETURN    ${data}

Verify Registration Success
    [Documentation]    Verifies successful registration response
    [Arguments]    ${response}
    ${json}=    Set Variable    ${response.json()}
    Should Contain    ${json}    id
    Should Contain    ${json}    token
    # ID can be integer, so just verify it exists
    Should Not Be Equal    ${json}[id]    ${None}
    Should Not Be Empty    ${json}[token]

Verify Error Response
    [Documentation]    Verifies error response contains error message
    [Arguments]    ${response}
    ${json}=    Set Variable    ${response.json()}
    Should Contain    ${json}    error
    Should Not Be Empty    ${json}[error]

# Validation Keywords
Verify Response Time
    [Documentation]    Verifies that response time is within acceptable range
    [Arguments]    ${response}    ${max_time_seconds}=5
    ${elapsed}=    Set Variable    ${response.elapsed.total_seconds()}
    ${elapsed_seconds}=    Convert To Number    ${elapsed}
    ${max_time}=    Convert To Number    ${max_time_seconds}
    Run Keyword If    ${elapsed_seconds} >= ${max_time}    
    ...    Fail    Response time exceeded ${max_time_seconds} seconds (actual: ${elapsed_seconds}s)

Verify JSON Response
    [Documentation]    Verifies that response contains valid JSON
    [Arguments]    ${response}
    ${json}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${json}

Verify Response Contains Key
    [Documentation]    Verifies that response JSON contains specific key
    [Arguments]    ${response}    ${key}
    ${json}=    Set Variable    ${response.json()}
    Should Contain    ${json}    ${key}

Verify Response Header
    [Documentation]    Verifies that response contains specific header
    [Arguments]    ${response}    ${header_name}    ${expected_value}
    ${header_value}=    Get From Dictionary    ${response.headers}    ${header_name}
    Should Be Equal As Strings    ${header_value}    ${expected_value}

