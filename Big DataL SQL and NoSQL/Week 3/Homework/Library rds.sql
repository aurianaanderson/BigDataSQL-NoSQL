DROP TABLE IF EXISTS library.book CASCADE;
DROP TABLE IF EXISTS library.book_authors CASCADE;
DROP TABLE IF EXISTS library.publisher CASCADE;
DROP TABLE IF EXISTS library.book_copies CASCADE;
DROP TABLE IF EXISTS library.book_loans CASCADE;
DROP TABLE IF EXISTS library.library_branch CASCADE;
DROP TABLE IF EXISTS library.borrower CASCADE;
DROP SCHEMA IF EXISTS library;

CREATE SCHEMA IF NOT EXISTS library;

CREATE TABLE IF NOT EXISTS library.publisher (
	Name VARCHAR(255) PRIMARY KEY,
	Address VARCHAR(255),
	Phone VARCHAR(20)
	);

CREATE TABLE IF NOT EXISTS library.book (
	Book_id INT PRIMARY KEY,
	Title VARCHAR(255) NOT NULL,
	Publisher_name VARCHAR(255) NOT NULL,
	FOREIGN KEY (Publisher_name) REFERENCES library.publisher (Name) ON DELETE SET NULL
	);
	
CREATE TABLE IF NOT EXISTS library.book_authors (
	Author_name VARCHAR(255) NOT NULL,
	Book_id INT,
	PRIMARY KEY (Book_id, Author_name),
	FOREIGN KEY (Book_id) REFERENCES library.book(Book_id) ON DELETE CASCADE
	);

CREATE TABLE IF NOT EXISTS library.library_branch (
	Branch_id INT PRIMARY KEY,
	Branch_name VARCHAR(255) NOT NULL,
	Address VARCHAR(255) NOT NULL
	);

CREATE TABLE IF NOT EXISTS library.book_copies (
	Book_id INT,
	Branch_id INT ,
	No_of_copies INT NOT NULL,
	PRIMARY KEY (Book_id, Branch_id),
	FOREIGN KEY (Book_id) REFERENCES library.book(Book_id) ON DELETE CASCADE,
	FOREIGN KEY (Branch_id) REFERENCES library.library_branch(Branch_id) ON DELETE CASCADE,
	CHECK (No_of_copies >= 0)
	);

CREATE TABLE IF NOT EXISTS library.borrower (
	Card_no INT PRIMARY KEY,
	Name VARCHAR(255) NOT NULL,
	Address VARCHAR(255),
	Phone VARCHAR(20)
	);

CREATE TABLE IF NOT EXISTS library.book_loans (
	Book_id INT,
	Branch_id INT,
	Card_no INT,
	Date_out DATE NOT NULL,
	Due_date DATE NOT NULL,
	PRIMARY KEY (Book_id, Branch_id, Card_no),
	FOREIGN KEY (Book_id) REFERENCES library.book(Book_id) ON DELETE CASCADE,
	FOREIGN KEY (Branch_id) REFERENCES library.library_branch(Branch_id) ON DELETE CASCADE,
	FOREIGN KEY (Card_no) REFERENCES library.borrower(Card_no) ON DELETE CASCADE
	);
