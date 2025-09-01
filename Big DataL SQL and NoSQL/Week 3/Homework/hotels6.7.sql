/*Complete the following Textbook Exercises 6.7, 6.8, 6.10, 6.12, 6.13.

6.7

exercise_67-1.sqlDownload exercise_67-1.sql

Consider the following Hotel, Room, Booking and Guest schemas in a DBMS. 
The hotelNo is the primary key for Hotel table and roomNo is the primary key for the Room relation. 
Booking stores the details of room reservations and bookingNo is the primary key. 
Guest stores the guests details and guestNo is the primary key.

Hotel      (hotelNo, hotelName, hotelType, hotelAddress, hotelCity, numRoom)

Room     (roomNo, hotelNo, roomPrice)

Booking (bookingNo, hotelNo, guestNo, checkIn, checkout, totelGuest, roomNo)

Guest      (guestNo, firstName, lastName, guestAddress)

Write the SQL to list full details of all the hotels.
Write the SQL to list full details of all the hotels in New York.
Write the SQL to list the guests in New York in descending order by last name.
 

Please use the exercise_67.sql DDL to complete this exercise. 
You will need to write a join between booking, hotels, and guests. 
Your book specifies how to do on page 222, however, this does not work in PostgreSQL. 
Below is the format you will need to use, please replace all <> to answer the question. 
Please submit the query and the query results.

SELECT a.*

FROM <relation> a

JOIN <relation> b

ON <alias.column> = <alias.column>

JOIN < alias.column > c

ON b.< alias.column > = c.< alias.column >

WHERE c.< alias.column > = '<value>';


*/

-- Write the SQL to list full details of all the hotels.

SELECT a.* 
FROM hotels."hotel" a;

-- Write the SQL to list full details of all the hotels in New York.

SELECT a.* 
FROM hotels."hotel" a
WHERE a."hotelcity" = 'New York';

-- Write the SQL to list the guests in New York in descending order by last name.

SELECT c.*
FROM hotels."booking" a
JOIN hotels."hotel" b
ON a."hotelno" = b."hotelno"
JOIN hotels."guest" c
ON a."guestno" = c."guestno"
WHERE b."hotelcity" = 'New York'
ORDER BY c."lastname" desc;

