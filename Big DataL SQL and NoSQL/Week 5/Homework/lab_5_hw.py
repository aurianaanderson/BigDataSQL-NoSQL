# -*- coding: utf-8 -*-
"""
Created on Sun Jul  9 11:57:01 2023
Lab question 6 sample code
@author: jlowh
"""
#import pymongo
import pymongo

#create your connection string
connect_string = 'mongodb+srv://andersonau:AAunrnidaerson1!@dse6210-sql-nosql.wrnvx.mongodb.net/?retryWrites=true&w=majority&appName=DSE6210-SQL-NoSQL'

# Connect to MongoDB client
client = pymongo.MongoClient(connect_string)

#connect to the sample_restaraunts database
restaurants_db = client.sample_restaurants

#establish a connection to the restarants collection
rest_coll = restaurants_db["restaurants"]

#find a document with the restaraunt name Nordic Delicacies
nordic = rest_coll.find_one({"name": "Nordic Delicacies"})

#added code to answer question 1:
if nordic:
   print("Cuisine type:", nordic.get("cuisine", "Cuisine not found"))
else:
   print("Restaurant not found.")

#find the type of the queried document
print(type(nordic))
if nordic:
   print("Nordic Delicacies Object:", nordic)

db = client.sample_airbnb

collection = db['listingsAndReviews']

test = collection.find({'bedrooms':{'$gte':10}})

# for bedroom in test:
#     print(bedroom)

test = collection.find()