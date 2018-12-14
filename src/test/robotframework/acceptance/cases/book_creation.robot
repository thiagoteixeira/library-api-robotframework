*** Settings ***
Documentation    Este teste é responsável por inserir um livro no serviço rest
Resource         ../resources/book_resource.robot


*** Test Case ***

Scenario: Insert a book successfully
    Given A book payload                     title=My book    author=Eu
    When Send this book to be created
    Then Book must be created succesfully
