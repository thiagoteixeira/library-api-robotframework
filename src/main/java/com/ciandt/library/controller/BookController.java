package com.ciandt.library.controller;

import java.util.Collection;
import java.util.Optional;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ciandt.library.domain.Book;
import com.ciandt.library.repository.BookRepository;

@RestController
@RequestMapping("/books")
public class BookController {
    @Autowired
    private BookRepository repository;

    @GetMapping
    public Collection<Book> findAll(){
        return repository.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Book> findById(@PathVariable Long id){
        Optional<Book> BookOpt = repository.findById(id);
        return BookOpt.isPresent() ? ResponseEntity.ok(BookOpt.get()) : ResponseEntity.notFound().build();
    }

    @PostMapping
    public ResponseEntity<Book> create(@RequestBody Book Book){
        Book personSaved = repository.save(Book);
        return ResponseEntity.status(HttpStatus.CREATED).body(personSaved);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Book> update(@PathVariable Long id, @RequestBody Book Book){
        Optional<Book> BookOpt = repository.findById(id);

        if(!BookOpt.isPresent()){
            return new ResponseEntity<Book>(HttpStatus.NOT_FOUND);
        }

        Book BookPersisted = BookOpt.get();
        BeanUtils.copyProperties(Book, BookPersisted, "id");

        repository.save(BookPersisted);
        return ResponseEntity.ok(BookPersisted);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity delete(@PathVariable Long id){
        Optional<Book> BookOpt = repository.findById(id);

        if(!BookOpt.isPresent()){
            return ResponseEntity.notFound().build();
        }

        repository.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping
    public void delete(){
        repository.deleteAll();
    }
}
