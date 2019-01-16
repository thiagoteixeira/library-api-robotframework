*** Settings ***
Documentation    Este teste é responsável por consultar um livro no serviço rest
Resource         ../resources/book_resource.robot


*** Test Case ***

Scenario: Get book by id succesfully
    [Setup]                                      Delete all books
    Given A book created
    When Send a get request by id
    Then The status code must be                 200
    And The response must be the created book