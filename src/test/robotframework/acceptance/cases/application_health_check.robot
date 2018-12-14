*** Settings ***
Documentation    Spring Actuator Health Check
Library          String
Library          RequestsLibrary
Resource         ../variables.robot


*** Test Cases ***
Application Health Check
    Create Session                URL_API                  ${URL_API}
    ${resp}                       Get Request              URL_API            /actuator/health
    Should Be Equal As Strings    ${resp.status_code}      200
    ${jsondata}=                  To Json                  ${resp.content}
    Should Be Equal               ${jsondata['status']}    UP