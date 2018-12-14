*** Settings ***
Documentation    Este teste é responsável por consultar um livro no serviço rest
Resource         ../resources/book_resource.robot


*** Test Case ***

Scenario: Get books successfully
    Given A book created
    When Send a get request
    Then The service must return books