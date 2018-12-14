package com.ciandt.library.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ciandt.library.domain.Book;

@Repository
public interface BookRepository extends JpaRepository<Book,Long> {
}
