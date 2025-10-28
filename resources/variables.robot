*** Variables ***
# Base URL for the API
${BASE_URL}    https://reqres.in/api

# API Key for reqres.in
${API_KEY}     reqres-free-v1

# HTTP Status Codes
${STATUS_OK}                200
${STATUS_CREATED}           201
${STATUS_NO_CONTENT}        204
${STATUS_BAD_REQUEST}       400
${STATUS_UNAUTHORIZED}      401
${STATUS_NOT_FOUND}         404
${STATUS_UNPROCESSABLE}     422
${STATUS_SERVER_ERROR}      500

# Test Data - Valid Users
${VALID_USER_ID}            2
${VALID_USER_EMAIL}         janet.weaver@reqres.in
${VALID_USER_FIRST_NAME}    Janet
${VALID_USER_LAST_NAME}     Weaver

# Test Data - Invalid/Edge Cases
${INVALID_USER_ID}          999
${ZERO_USER_ID}             0
${NEGATIVE_USER_ID}         -1
${STRING_USER_ID}           abc

# Test Data - User Creation
${NEW_USER_NAME}            John Doe
${NEW_USER_JOB}             Software Engineer
${UPDATED_USER_NAME}        Jane Smith
${UPDATED_USER_JOB}         Senior Developer

# Test Data - Pagination
${PAGE_1}                   1
${PAGE_2}                   2
${PER_PAGE}                 6

# Test Data - Registration
${VALID_EMAIL}              eve.holt@reqres.in
${VALID_PASSWORD}           pistol
${INVALID_EMAIL}            test@test.com

