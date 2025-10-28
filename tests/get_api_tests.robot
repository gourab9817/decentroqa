*** Settings ***
Documentation    Comprehensive GET API test cases for reqres.in
...              Tests cover positive and negative scenarios for retrieving user data
Resource         ../resources/keywords.robot
Resource         ../resources/variables.robot
Suite Setup      Setup Test Session
Suite Teardown   Teardown Test Session

*** Test Cases ***
# POSITIVE TEST CASES

GET Single User - Valid ID
    [Documentation]    Verify retrieving a single user with valid ID returns status 200
    [Tags]    positive    smoke    get
    ${response}=    Send GET Request    /users/${VALID_USER_ID}    ${STATUS_OK}
    Verify User Data In Response    ${response}    ${VALID_USER_ID}
    Verify Response Time    ${response}    5

GET List Users - Default Page
    [Documentation]    Verify retrieving list of users with default pagination
    [Tags]    positive    smoke    get
    ${response}=    Send GET Request    /users    ${STATUS_OK}
    Verify List Response Structure    ${response}
    Verify Response Time    ${response}    5

GET List Users - Page 1
    [Documentation]    Verify retrieving list of users from page 1
    [Tags]    positive    get    pagination
    ${response}=    Send GET Request    /users?page=${PAGE_1}    ${STATUS_OK}
    ${json}=    Set Variable    ${response.json()}
    Should Be Equal As Integers    ${json}[page]    ${PAGE_1}
    Should Be Equal As Integers    ${json}[per_page]    ${PER_PAGE}

GET List Users - Page 2
    [Documentation]    Verify retrieving list of users from page 2
    [Tags]    positive    get    pagination
    ${response}=    Send GET Request    /users?page=${PAGE_2}    ${STATUS_OK}
    ${json}=    Set Variable    ${response.json()}
    Should Be Equal As Integers    ${json}[page]    ${PAGE_2}

GET List Users - Custom Per Page
    [Documentation]    Verify retrieving list with custom per_page parameter
    [Tags]    positive    get    pagination
    ${response}=    Send GET Request    /users?per_page=3    ${STATUS_OK}
    ${json}=    Set Variable    ${response.json()}
    Should Be Equal As Integers    ${json}[per_page]    3

GET Single Resource
    [Documentation]    Verify retrieving a single resource by ID
    [Tags]    positive    get
    ${response}=    Send GET Request    /unknown/2    ${STATUS_OK}
    ${data}=    Set Variable    ${response.json()}[data]
    Should Be Equal As Integers    ${data}[id]    2
    Should Not Be Empty    ${data}[name]

GET Users - With Delay
    [Documentation]    Verify delayed response endpoint works correctly
    [Tags]    positive    get    delay
    ${response}=    Send GET Request    /users?delay=3    ${STATUS_OK}
    Verify List Response Structure    ${response}

# NEGATIVE TEST CASES

GET Single User - Not Found
    [Documentation]    Verify that requesting non-existent user returns 404
    [Tags]    negative    get
    ${response}=    Send GET Request    /users/${INVALID_USER_ID}    ${STATUS_NOT_FOUND}
    ${json}=    Set Variable    ${response.json()}
    Should Be Empty    ${json}

GET Single Resource - Not Found
    [Documentation]    Verify that requesting non-existent resource returns 404
    [Tags]    negative    get
    ${response}=    Send GET Request    /unknown/${INVALID_USER_ID}    ${STATUS_NOT_FOUND}
    ${json}=    Set Variable    ${response.json()}
    Should Be Empty    ${json}

GET List Users - Empty Page
    [Documentation]    Verify behavior when requesting a page beyond available data
    [Tags]    negative    get    pagination
    ${response}=    Send GET Request    /users?page=100    ${STATUS_OK}
    ${json}=    Set Variable    ${response.json()}
    ${data_list}=    Get From Dictionary    ${json}    data
    Should Be Empty    ${data_list}

