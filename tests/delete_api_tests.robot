*** Settings ***
Documentation    Comprehensive DELETE API test cases for reqres.in
...              Tests cover scenarios for deleting user data
Resource         ../resources/keywords.robot
Resource         ../resources/variables.robot
Suite Setup      Setup Test Session
Suite Teardown   Teardown Test Session

*** Test Cases ***
# POSITIVE TEST CASES

DELETE User - Valid User ID
    [Documentation]    Verify deleting a user with valid ID returns status 204
    [Tags]    positive    smoke    delete
    ${response}=    Send DELETE Request    /users/${VALID_USER_ID}    ${STATUS_NO_CONTENT}
    Verify Response Time    ${response}    5
    ${content}=    Set Variable    ${response.content}
    Should Be Empty    ${content}

DELETE User - Different User IDs
    [Documentation]    Verify deleting users with different IDs
    [Tags]    positive    delete
    ${response1}=    Send DELETE Request    /users/1    ${STATUS_NO_CONTENT}
    ${response2}=    Send DELETE Request    /users/3    ${STATUS_NO_CONTENT}
    ${response3}=    Send DELETE Request    /users/5    ${STATUS_NO_CONTENT}
    Should Be Empty    ${response1.content}
    Should Be Empty    ${response2.content}
    Should Be Empty    ${response3.content}

DELETE User - Multiple Sequential Deletes
    [Documentation]    Verify multiple DELETE operations work correctly
    [Tags]    positive    delete
    FOR    ${user_id}    IN RANGE    20    23
        ${response}=    Send DELETE Request    /users/${user_id}    ${STATUS_NO_CONTENT}
        Should Be Equal As Integers    ${response.status_code}    ${STATUS_NO_CONTENT}
    END

DELETE User - Verify Response Headers
    [Documentation]    Verify DELETE response contains appropriate headers
    [Tags]    positive    delete
    ${response}=    Send DELETE Request    /users/${VALID_USER_ID}    ${STATUS_NO_CONTENT}
    ${headers}=    Set Variable    ${response.headers}
    Should Contain    ${headers}    Date
    Should Contain    ${headers}    Server

# NEGATIVE TEST CASES

DELETE User - Non-Existent User ID
    [Documentation]    Verify deleting non-existent user still returns 204
    [Tags]    negative    delete
    ${response}=    Send DELETE Request    /users/${INVALID_USER_ID}    ${STATUS_NO_CONTENT}
    # API doesn't validate existence, returns 204 anyway

DELETE User - Very Large User ID
    [Documentation]    Verify DELETE with very large user ID
    [Tags]    negative    delete
    ${response}=    Send DELETE Request    /users/999999999    ${STATUS_NO_CONTENT}

DELETE User - Zero User ID
    [Documentation]    Verify DELETE with user ID 0
    [Tags]    negative    delete
    ${response}=    Send DELETE Request    /users/${ZERO_USER_ID}    ${STATUS_NO_CONTENT}

DELETE User - String User ID
    [Documentation]    Verify DELETE behavior with string as user ID
    [Tags]    negative    delete
    ${response}=    Send DELETE Request    /users/${STRING_USER_ID}    ${STATUS_NO_CONTENT}

DELETE User - Repeated Delete Same User
    [Documentation]    Verify deleting the same user multiple times
    [Tags]    negative    delete
    ${response1}=    Send DELETE Request    /users/50    ${STATUS_NO_CONTENT}
    ${response2}=    Send DELETE Request    /users/50    ${STATUS_NO_CONTENT}
    # All should succeed with 204