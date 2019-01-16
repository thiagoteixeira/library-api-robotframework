*** Settings ***
Documentation    Este teste é responsável por consultar um livro no serviço rest
Resource         ../resources/book_resource.robot


*** Test Case ***

Scenario: Books update successfully by id
    [Setup]                                 Delete all books
    Given A book created
    When Send a update request              title=joao
    Then The status code must be            200
    And The book was update successfully