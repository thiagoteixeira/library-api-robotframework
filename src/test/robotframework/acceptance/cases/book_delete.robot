*** Settings ***
Documentation    Este teste é responsável por consultar um livro no serviço rest
Resource         ../resources/book_resource.robot


*** Test Case ***

Scenario: Books deletion successfully by id
    [Setup]                                Delete all books
    Given A book created
    When Send a delete request
    Then The status code must be           204
    And The books deletion successfully