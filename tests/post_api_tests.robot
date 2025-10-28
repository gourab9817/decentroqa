*** Settings ***
Documentation    Comprehensive POST API test cases for reqres.in
...              Tests cover positive and negative scenarios for creating user data
Resource         ../resources/keywords.robot
Resource         ../resources/variables.robot
Suite Setup      Setup Test Session
Suite Teardown   Teardown Test Session

*** Test Cases ***
# POSITIVE TEST CASES

POST Create User - Valid Data
    [Documentation]    Verify creating a user with valid data returns status 201
    [Tags]    positive    smoke    post    create
    ${data}=    Create User Data Dictionary    ${NEW_USER_NAME}    ${NEW_USER_JOB}
    ${response}=    Send POST Request    /users    ${data}    ${STATUS_CREATED}
    Verify Created User Response    ${response}    ${NEW_USER_NAME}    ${NEW_USER_JOB}
    Verify Response Time    ${response}    5

POST Create User - Only Name Field
    [Documentation]    Verify creating a user with only name field
    [Tags]    positive    post    create
    ${data}=    Create Dictionary    name=Only Name User
    ${response}=    Send POST Request    /users    ${data}    ${STATUS_CREATED}
    ${json}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${json}[name]    Only Name User
    Should Contain    ${json}    id

POST Create User - Only Job Field
    [Documentation]    Verify creating a user with only job field
    [Tags]    positive    post    create
    ${data}=    Create Dictionary    job=Only Job Title
    ${response}=    Send POST Request    /users    ${data}    ${STATUS_CREATED}
    ${json}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${json}[job]    Only Job Title

POST Create User - Extra Fields
    [Documentation]    Verify creating a user with additional fields
    [Tags]    positive    post    create
    ${data}=    Create Dictionary    name=Extra User    job=Tester    email=test@example.com
    ${response}=    Send POST Request    /users    ${data}    ${STATUS_CREATED}
    ${json}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${json}[name]    Extra User

POST Create User - Special Characters
    [Documentation]    Verify creating a user with special characters
    [Tags]    positive    post    create
    ${data}=    Create User Data Dictionary    José García    Engineer @2024
    ${response}=    Send POST Request    /users    ${data}    ${STATUS_CREATED}
    ${json}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${json}[name]    José García

POST Register - Successful Registration
    [Documentation]    Verify successful user registration with valid credentials
    [Tags]    positive    smoke    post    register
    ${data}=    Create Registration Data    ${VALID_EMAIL}    ${VALID_PASSWORD}
    ${response}=    Send POST Request    /register    ${data}    ${STATUS_OK}
    Verify Registration Success    ${response}

POST Login - Successful Login
    [Documentation]    Verify successful login with valid credentials
    [Tags]    positive    smoke    post    login
    ${data}=    Create Registration Data    ${VALID_EMAIL}    ${VALID_PASSWORD}
    ${response}=    Send POST Request    /login    ${data}    ${STATUS_OK}
    ${json}=    Set Variable    ${response.json()}
    Should Contain    ${json}    token

# NEGATIVE TEST CASES

POST Create User - Empty Data
    [Documentation]    Verify creating a user with empty data
    [Tags]    negative    post    create
    ${data}=    Create Dictionary
    ${response}=    Send POST Request    /users    ${data}    ${STATUS_CREATED}
    # API accepts empty data and creates resource

POST Create User - Null Values
    [Documentation]    Verify creating a user with null values
    [Tags]    negative    post    create
    ${data}=    Create Dictionary    name=${None}    job=${None}
    ${response}=    Send POST Request    /users    ${data}    ${STATUS_CREATED}

POST Register - Missing Password
    [Documentation]    Verify registration fails without password
    [Tags]    negative    post    register
    ${data}=    Create Dictionary    email=${VALID_EMAIL}
    ${response}=    Send POST Request    /register    ${data}    ${STATUS_BAD_REQUEST}
    Verify Error Response    ${response}

POST Register - Missing Email
    [Documentation]    Verify registration fails without email
    [Tags]    negative    post    register
    ${data}=    Create Dictionary    password=${VALID_PASSWORD}
    ${response}=    Send POST Request    /register    ${data}    ${STATUS_BAD_REQUEST}
    Verify Error Response    ${response}

POST Login - Missing Password
    [Documentation]    Verify login fails without password
    [Tags]    negative    post    login
    ${data}=    Create Dictionary    email=${VALID_EMAIL}
    ${response}=    Send POST Request    /login    ${data}    ${STATUS_BAD_REQUEST}
    Verify Error Response    ${response}

POST Login - Missing Email
    [Documentation]    Verify login fails without email
    [Tags]    negative    post    login
    ${data}=    Create Dictionary    password=${VALID_PASSWORD}
    ${response}=    Send POST Request    /login    ${data}    ${STATUS_BAD_REQUEST}
    Verify Error Response    ${response}