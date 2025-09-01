# -*- coding: utf-8 -*-
"""
Created on Sat Jul 22 21:26:37 2023

@author: Lowhorn
"""

#import pymongo
import pymongo
from pymongo import MongoClient
from pymongo.errors import ServerSelectionTimeoutError


"""
Exercise 1
Create a mongo_db connection with pymongo to your database
https://pymongo.readthedocs.io/en/stable/examples/authentication.html

For the homework we will be using the sample_restaurants.restaurants collection. 

Using find(), write a find query to extract the Italian restaurants in Manhattan to a Python list. 
Use len() to count the number of restaurants located in Manhattan. 

***Note*** All MongoDB functions and fields MUST be in quotes inside of the find() method. Ex $and should be "$and".

https://www.w3schools.com/python/python_mongodb_find.asp
"""
uri = 'mongodb+srv://andersonau:AAunrnidaerson1!@dse6210-sql-nosql.wrnvx.mongodb.net/?retryWrites=true&w=majority&appName=DSE6210-SQL-NoSQL'
client = MongoClient(uri)

#Test to see if it is working:
# try:
#     client = MongoClient(uri)
#     db = client.get_database('sample_geospatial')
#     print("Connection successful!")
#     print("Collections in the database:", db.list_collection_names())
# except ServerSelectionTimeoutError as e:
#     print(f"Error connecting to MongoDB: {e}")

#now do the same for the resturant data.

try:
    client = MongoClient(uri)
    db = client.get_database('sample_restaurants')
    print("Connection successful!")
    print("Collections in the database:", db.list_collection_names())
except ServerSelectionTimeoutError as e:
    print(f"Error connecting to MongoDB: {e}")

collection = db.restaurants

italian_manhattan_query = {"cuisine":"Italian","borough":"Manhattan"}

italian_manhattan_restaurants = list(collection.find(italian_manhattan_query))

print(f"There are {len(italian_manhattan_restaurants)} Italian Restaurant's in Manhattan")
"""
Exercise 2
Using find, determine how many Japanese and Italian restaurants have an A rating in Queens.

"""
ital_jap_manhattan_query = collection.find({"$and": [{"borough": "Queens"}
    ,  {"$or": [ {"cuisine": "Japanese"}
        ,{"cuisine": "Italian"}]}
    ,{"grades.grade": "A"} ]})

ital_jap_manhattan_list = list(ital_jap_manhattan_query)

print(f"There are {len(ital_jap_manhattan_list)} Italian and Japanese Restaurant's in Queens that have an A rating")
"""
Exercise 3
The following MongoDB aggregation query is missing a aggregation expression that will calculate the BSON size of the documents. 
A list of these can be found at the end of this week's notes. Identify the missing aggregation expression.
Print the 10 document ids and sizes that have the highest BSON size. 
"""

res = collection.aggregate([
    { "$addFields": {
        "bsonsize": { "$bsonSize": "$$ROOT" }
    }},
    { "$sort": { "bsonsize": -1 }},
    { "$limit": 10 },
    { "$project": {
        "_id": 1,
        "bsonsize": 1
    }}
])
for document in res:
    print(f'Document ID:{document['_id']}, BSON size:{document['bsonsize']}')

"""
Exercise 4
Find all of the restaurants that have NOT had an 'A', 'B', and 'Not Yet Graded' rating. How many restaurants is this?
"""

not_abnotyet_rating = collection.find({"$and":[{"grades.grade":{"$not":{"$eq":"A"}}}
    ,{"grades.grade":{"$not":{"$eq":"B"}}}
    ,{"grades.grade":{"$not":{"$eq":"Not Yet Graded"}}}]
                                       })

not_abnotyet_rating_list = list(not_abnotyet_rating)

print(f"There are {len(not_abnotyet_rating_list)} restaurant's that do NOT have an A,B, or Not yet graded rating.")