*** Settings ***
Library     RequestsLibrary
Library     String
Library     Collections
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
    ${RESP}                              Post Request               alias=URL_API                         uri=/books          json=${BOOK_PAYLOAD}    headers=${DEFAULT_HEADERS}

    Set Test Variable                    ${RESP}

    ${REQUEST_JSON}                      Evaluate                   json.loads('''${RESP.text}''')        json
    Set Test Variable                    ${REQUEST_JSON}


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
    \    Dictionaries Should Be Equal    ${REQUEST_JSON}            ${item}

Delete all books
    Create Session                       URL_API                    ${URL_API}
    Delete Request                       alias=URL_API              uri=/books

Send a delete request
    Create Session                       URL_API                    ${URL_API}
    Delete Request                       alias=URL_API              uri=/books

The status code must be


And The books deletion successfully