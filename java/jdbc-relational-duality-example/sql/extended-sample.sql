CREATE TABLE COPY_STATUS_LU
(
  STATUS_ID   NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
  STATUS_NAME VARCHAR2(50)
);

CREATE TABLE BOOKS
(
  BOOK_ID   NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
  BOOK_NAME VARCHAR2(250)
);

CREATE TABLE BOOK_COPY
(
  BOOK_COPY_ID   NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
  BOOK_ID        NUMBER REFERENCES BOOKS (BOOK_ID),
  YEAR_PUBLISHED NUMBER(4),
  STATUS_ID      NUMBER DEFAULT 1 references COPY_STATUS_LU (STATUS_ID)
);

INSERT INTO COPY_STATUS_LU (STATUS_ID, STATUS_NAME) VALUES (1, 'Available');
INSERT INTO COPY_STATUS_LU (STATUS_ID, STATUS_NAME) VALUES (2, 'In Circulation');
INSERT INTO COPY_STATUS_LU (STATUS_ID, STATUS_NAME) VALUES (3, 'Reserved');

-- JSON document of books and a list of its copies
CREATE OR REPLACE JSON RELATIONAL DUALITY VIEW BOOK_COPY_DV AS
SELECT JSON {
  '_id': b.BOOK_ID,
  'name': b.BOOK_NAME,
  'copies': [ SELECT JSON {
    'id' : bc.BOOK_COPY_ID,
    'year' : bc.YEAR_PUBLISHED,
    'status' : bc.STATUS_ID
  } FROM BOOK_COPY bc WITH INSERT UPDATE DELETE
  WHERE bc.BOOK_ID = b.BOOK_ID
]}
FROM BOOKS b WITH INSERT UPDATE DELETE
/

