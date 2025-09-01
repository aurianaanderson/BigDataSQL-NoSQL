# -*- coding: utf-8 -*-
"""
Created on Sun Jul  9 11:57:01 2023
Lab question 6 sample code

@author: jlowh
"""
#import pymongo
import pymongo
from pymongo import MongoClient
from pymongo.errors import ServerSelectionTimeoutError


"""
Exercise 1
Create a mongo_db connection with pymongo to your database
https://pymongo.readthedocs.io/en/stable/examples/authentication.html
"""

uri = 'mongodb+srv://andersonau:AAunrnidaerson1!@dse6210-sql-nosql.wrnvx.mongodb.net/?retryWrites=true&w=majority&appName=DSE6210-SQL-NoSQL'
client = MongoClient(uri)

#Test to see if it is working:
try:
    client = MongoClient(uri)
    db = client.get_database('sample_geospatial')
    print("Connection successful!")
    print("Collections in the database:", db.list_collection_names())
except ServerSelectionTimeoutError as e:
    print(f"Error connecting to MongoDB: {e}")

"""
Exercise 2
Using your client created from exercise 1, connect to a new database, homework6. 
Once you have connected to the database set your collection to a new collection, students. 
https://pymongo.readthedocs.io/en/stable/tutorial.html --> getting database and getting collection

"""
try:
    client = MongoClient(uri)
    db = client['homework6']
    students_collection = db['students']
    print(f'Connection successful!, database = {db} and collection =  {students_collection}')
except ServerSelectionTimeoutError as e:
    print(f"Error connecting to MongoDB: {e}")

"""
Exercise 3
I have created a list of student data containing documents that you will need to insert into MongoDB. 
Using insert_many, insert the list of documents into the students collection. 
"""

student_data = [

    {"instructor":"Martin",
     "class":"Chemistry",
     "max_students":25,
     "term":"SP2",
     "students":["Bob Mackey","George Straight","Bill Cowher","Stanley Kubrick",'Martin Sheen',"Charlize Theron"]},
    {"instructor":"Lowhorn",
     "class":"Big Data",
     "max_students":10,
     "term":"SU1",
     "students":["Charles Barkely","Charlie Sheen","Tina Turner","Paul Walker",'Dwayne Johnson',"Courtney Cox", "Margot Robbie"]},
    {"instructor":"Carlin",
     "class":"Discrete Math",
     "max_students":25,
     "term":"SP2",
     "students":["Tim Couch","George Straight","Michael Douglas","Peyton Manning",'Wade Boggs',"Doc Rivers","Drew Bledsoe","Ray Bourque"]},
    {"instructor":"Lowhorn",
     "class":"Programming for DS",
     "max_students":25,
     "term":"SP2",
     "students":["Roger Clemens","Ray Allen","Marcus Smart","Kevin Garnett",'Mo Vaughn',"Uma Thurman","Conan O'Brien","Mark Wahlberg"]},
    ]
students_collection.insert_many(student_data)

"""
Exercise 4
What MongoDB type do Python lists get converted to? 
Submit a screen shot of your collection in MongoDB with this python file. 
"""
#These python lists converted to arrays

"""
Exercise 5
George Straight accidentally registered for two courses in the SP2 Session. 
Using a pymongo.update(), remove him from Carlin's class
Note: Your key is instructor. 
Use the $pull method to extract the element from the array. 
https://www.geeksforgeeks.org/python-mongodb-update_one/
https://www.mongodb.com/docs/manual/reference/operator/update/pull/

"""

remove_george_from_carlin = students_collection.update_one(filter = {"instructor":"Carlin"}
                                                           ,update = {'$pull':{"students":"George Straight"}}
)

if remove_george_from_carlin.modified_count > 0:
    print("George has been successfully removed from Carlin's class")
else:
    print('No Changes made, try again :(!')

"""
Exercise 6
A new student has signed up for all three SP2 sessions, his name is Tom Brady. 
Update the SP2 classes by inserting the student Tom Brady into the students object. 
Note: Many not one. Push not pull. 
"""
Add_Tom = students_collection.update_many(filter = {"term":"SP2"}
                                          ,update = {'$push':{"students":"Tom Brady"}}
)

if Add_Tom.modified_count > 0:
    print("Tom has been successfully been added to all three SP2 sessions :)")
else:
    print('No Changes made, try again :(!')

"""
Exercise 7
The college has decided that Chemistry was not a good fit for the data science program. Delete it from the collection. 
https://www.geeksforgeeks.org/python-mongodb-delete_one/
"""
delete_chemistry = students_collection.delete_one({"class":"Chemistry"})

if delete_chemistry.deleted_count > 0:
    print("Chemistry has successfully been deleted from classes :)")
else:
    print('No Changes made, try again :(!')

"""
Exercise 8
Using find, print all of the documents to the console. This should be a query against the MongoDB database.
"""
all_student_info = students_collection.find()

for document in all_student_info:
    print(document)

"""
Exercise 9
Instead of using the default hash _id, what would you recommend as a unique ID for each document?
"""
#I think custom string IDs would be good so that it cn be formatted maybe off student Initials and student number.
#The course ID's could also be a course abbreviation in number like how we usually see them in University.
#So Tom Brady with a student number 12345 would be TB12345 and a course would be Computer Science 101 would be CS101

"""
Exercise 10
Drop the students collection from the database AND close your client. 
"""
students_collection.drop()

client.close()

print(f"The 'students' collection has been dropped and the client has been closed!")

