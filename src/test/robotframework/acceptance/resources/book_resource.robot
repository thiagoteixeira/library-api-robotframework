*** Settings ***
Library     RequestsLibrary
Library     String
Resource    ../variables.robot

*** Keywords ***
A book payload
    [Arguments]                     ${title}=Who is mayaro?    ${author}=Pepeto
    ${BOOK_PAYLOAD}=                Create Dictionary          title=${title}      author=${author}
    Log To Console                  ${BOOK_PAYLOAD}
    Set Test Variable               ${BOOK_PAYLOAD}

Send this book to be created
    Log To Console                  ${BOOK_PAYLOAD}
    Create Session                  URL_API                    ${URL_API}
    ${RESP}                         Post Request               alias=URL_API       uri=/books          json=${BOOK_PAYLOAD}    headers=${DEFAULT_HEADERS}
    Set Test Variable               ${RESP}


Book must be created succesfully
    Should Be Equal As Strings      ${RESP.status_code}        201

A book created
    A book payload
    Send this book to be created
