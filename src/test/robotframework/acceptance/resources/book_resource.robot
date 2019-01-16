*** Settings ***
Library     RequestsLibrary
Library     String
Library     Collections
Library     JSONLibrary
Resource    ../variables.robot

*** Keywords ***
A book payload
    [Arguments]                          ${title}=Who is mayaro?    ${author}=Pepeto
    ${BOOK_PAYLOAD}=                     Create Dictionary          title=${title}                        author=${author}
    #Log To Console                       ${BOOK_PAYLOAD}
    Set Test Variable                    ${BOOK_PAYLOAD}

Send this book to be created
    #Log To Console                       ${BOOK_PAYLOAD}
    Create Session                       URL_API                    ${URL_API}
    ${RESP}                              Post Request               alias=URL_API                         uri=/books               json=${BOOK_PAYLOAD}    headers=${DEFAULT_HEADERS}

    Set Test Variable                    ${RESP}

    ${POST_RESPONSE_JSON}                Evaluate                   json.loads('''${RESP.text}''')        json
    Set Test Variable                    ${POST_RESPONSE_JSON}


    ${ids}                               Get Value From Json        ${POST_RESPONSE_JSON}                 $..id
    ${BOOK_ID}                           Set Variable               ${ids[0]}

    Set Test Variable                    ${BOOK_ID}

Book must be created succesfully
    Should Be Equal As Strings           ${RESP.status_code}        201

A book created
    A book payload
    Send this book to be created

Send a get request
    Create Session                       URL_API                    ${URL_API}
    ${RESPONSE}                          Get Request                alias=URL_API                         uri=/books

    Set Test Variable                    ${RESPONSE}

The service must return books
    Should Be Equal As Strings           ${RESPONSE.status_code}    200

    ${RESPONSE_BODY}=                    evaluate                   json.loads('''${RESPONSE.text}''')    json

    ${length}                            Get Length                 ${RESPONSE_BODY}
    Should Be Equal As Numbers           ${length}                  1

    :FOR  ${item}  IN  @{RESPONSE_BODY}
    \
    \    Log To Console                  \n\n${item}
    \    Dictionaries Should Be Equal    ${POST_RESPONSE_JSON}      ${item}

Delete all books
    Create Session                       URL_API                    ${URL_API}
    Delete Request                       alias=URL_API              uri=/books

Send a delete request
    Create Session                       URL_API                    ${URL_API}
    ${RESPONSE}                          Delete Request             alias=URL_API                         uri=/books/${BOOK_ID}
    Set Test Variable                    ${RESPONSE}

The status code must be
    [Arguments]                          ${code}
    Should Be Equal As Strings           ${RESPONSE.status_code}    ${code}

The books deletion successfully

    Send a get request by id
    The status code must be              404

Send a get request by id

    Create Session                       URL_API                    ${URL_API}
    ${RESPONSE}                          Get Request                alias=URL_API                         uri=/books/${BOOK_ID}
    Set Test Variable                    ${RESPONSE}

The response must be the created book

    ${RESPONSE_JSON}                     Evaluate                   json.loads('''${RESPONSE.text}''')    json
    Dictionaries Should Be Equal         ${POST_RESPONSE_JSON}      ${RESPONSE_JSON}


Send a update request

    [Arguments]                          ${title}=new title
    ${BOOK_UPDATE}                       Update Value To Json       ${POST_RESPONSE_JSON}                 $..title                 ${title}
    Set Test variable                    ${BOOK_UPDATE}
    ${RESPONSE}                          Put Request                alias=URL_API                         uri=/books/${BOOK_ID}    json=${BOOK_UPDATE}
    Set Test Variable                    ${RESPONSE}

The book was update successfully

    Send a get request by id
    ${RESPONSE_JSON}                     Evaluate                   json.loads('''${RESPONSE.text}''')    json
    Dictionaries Should Be Equal         ${BOOK_UPDATE}             ${RESPONSE_JSON}
    Log                                  ${RESPONSE_JSON}
