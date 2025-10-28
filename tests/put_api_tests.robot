*** Settings ***
Documentation    Comprehensive PUT API test cases for reqres.in
...              Tests cover positive and negative scenarios for updating user data
Resource         ../resources/keywords.robot
Resource         ../resources/variables.robot
Suite Setup      Setup Test Session
Suite Teardown   Teardown Test Session

*** Test Cases ***
# POSITIVE TEST CASES

PUT Update User - Valid Data with All Fields
    [Documentation]    Verify updating user with valid name and job returns status 200
    [Tags]    positive    smoke    put
    ${data}=    Create User Data Dictionary    ${UPDATED_USER_NAME}    ${UPDATED_USER_JOB}
    ${response}=    Send PUT Request    /users/${VALID_USER_ID}    ${data}    ${STATUS_OK}
    Verify Updated User Response    ${response}    ${UPDATED_USER_NAME}    ${UPDATED_USER_JOB}

PUT Update User - Only Name Field
    [Documentation]    Verify updating only the name field
    [Tags]    positive    put
    ${data}=    Create Dictionary    name=Michael Scott
    ${response}=    Send PUT Request    /users/${VALID_USER_ID}    ${data}    ${STATUS_OK}
    ${json}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${json}[name]    Michael Scott
    Should Contain    ${json}    updatedAt

PUT Update User - Only Job Field
    [Documentation]    Verify updating only the job field
    [Tags]    positive    put
    ${data}=    Create Dictionary    job=Regional Manager
    ${response}=    Send PUT Request    /users/${VALID_USER_ID}    ${data}    ${STATUS_OK}
    ${json}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${json}[job]    Regional Manager

PUT Update User - Different User IDs
    [Documentation]    Verify updating different user IDs works consistently
    [Tags]    positive    put
    ${data}=    Create User Data Dictionary    John Doe    Developer
    ${response1}=    Send PUT Request    /users/1    ${data}    ${STATUS_OK}
    Verify Updated User Response    ${response1}    John Doe    Developer
    ${response2}=    Send PUT Request    /users/3    ${data}    ${STATUS_OK}
    Verify Updated User Response    ${response2}    John Doe    Developer

PUT Update User - Special Characters
    [Documentation]    Verify updating user with special characters
    [Tags]    positive    put
    ${data}=    Create User Data Dictionary    José García    Software Engineer
    ${response}=    Send PUT Request    /users/${VALID_USER_ID}    ${data}    ${STATUS_OK}
    ${json}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${json}[name]    José García

PUT Update User - Timestamp Validation
    [Documentation]    Verify that updatedAt field contains valid timestamp
    [Tags]    positive    put
    ${data}=    Create User Data Dictionary    Test User    Test Job
    ${response}=    Send PUT Request    /users/${VALID_USER_ID}    ${data}    ${STATUS_OK}
    ${json}=    Set Variable    ${response.json()}
    ${updated_at}=    Get From Dictionary    ${json}    updatedAt
    Should Contain    ${updated_at}    T
    Should Match Regexp    ${updated_at}    \\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}

PATCH Update User - Single Field
    [Documentation]    Verify partial update using PATCH with single field
    [Tags]    positive    patch
    ${data}=    Create Dictionary    name=Patched Name
    ${response}=    Send PATCH Request    /users/${VALID_USER_ID}    ${data}    ${STATUS_OK}
    ${json}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${json}[name]    Patched Name
    Should Contain    ${json}    updatedAt

# NEGATIVE TEST CASES

PUT Update User - Empty Body
    [Documentation]    Verify updating user with completely empty body
    [Tags]    negative    put
    ${data}=    Create Dictionary
    ${response}=    Send PUT Request    /users/${VALID_USER_ID}    ${data}    ${STATUS_OK}
    ${json}=    Set Variable    ${response.json()}
    Should Contain    ${json}    updatedAt

PUT Update User - Very Large User ID
    [Documentation]    Verify updating user with very large ID number
    [Tags]    negative    put
    ${data}=    Create User Data Dictionary    Test User    Test Job
    ${response}=    Send PUT Request    /users/999999    ${data}    ${STATUS_OK}
    # API doesn't validate if ID exists for PUT

PUT Update User - Null Values
    [Documentation]    Verify behavior with null values
    [Tags]    negative    put
    ${data}=    Create Dictionary    name=${None}    job=${None}
    ${response}=    Send PUT Request    /users/${VALID_USER_ID}    ${data}    ${STATUS_OK}

PATCH Update User - Multiple Fields
    [Documentation]    Verify PATCH with multiple fields
    [Tags]    positive    patch
    ${data}=    Create User Data Dictionary    Patched User    Patched Job
    ${response}=    Send PATCH Request    /users/${VALID_USER_ID}    ${data}    ${STATUS_OK}
    Verify Updated User Response    ${response}    Patched User    Patched Job