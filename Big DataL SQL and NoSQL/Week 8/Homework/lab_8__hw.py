# -*- coding: utf-8 -*-
"""
Created on Sat Jul 22 21:26:37 2023

@author: Lowhorn
"""

#import pymongo
from pymongo import MongoClient
from pymongo.errors import ServerSelectionTimeoutError
"""
Exercise 1
Create a mongo_db connection with pymongo to your database
https://pymongo.readthedocs.io/en/stable/examples/authentication.html

For the homework we will be using the sample_mflix.movies collection. 

What is the title of the movie with the highest IMDB rating?

***Note*** match, sort, limit, project.
collection.aggregate(query) is the syntax for aggregation pipelines in Python. 

https://pymongo.readthedocs.io/en/stable/examples/aggregation.html
"""

uri = 'mongodb+srv://andersonau:AAunrnidaerson1!@dse6210-sql-nosql.wrnvx.mongodb.net/?retryWrites=true&w=majority&appName=DSE6210-SQL-NoSQL'
client = MongoClient(uri)

try:
     client = MongoClient(uri)
     db = client.get_database('sample_mflix')
     print("Connection successful!")
     print("Collections in the database:", db.list_collection_names())
except ServerSelectionTimeoutError as e:
     print(f"Error connecting to MongoDB: {e}")

collection = db.get_collection('movies')

query = [
    {
        '$match': {
            'imdb.rating': {
                '$ne': None,
                '$ne':''
            }
        }
    },
    {
        '$sort': {
            'imdb.rating': -1
        }
    },
    {
        '$limit': 1
    },
    {
        '$project': {
            'title': 1,
            'imdb.rating': 1
        }
    }
]

result = collection.aggregate(query)

#What is the title of the movie with the highest IMDB rating?

for movie in result:
     print(f"The movie with the highest imdb rating is {movie["title"]} with a rating of {movie['imdb']['rating']}")

"""
Exercise 2
Which year had the most titles released? 
***Note*** group, sort, limit

"""
year_query = [
    {
        '$group': {
            '_id': '$year',
            'count':{'$sum': 1}
        }
    },
    {
        '$sort': {
            'count': -1
        }
    },
    {
        '$limit': 1
    },
    {
        '$project': {
            'year': '$_id',
            'count': 1
        }
    }
]

result_year = collection.aggregate(year_query)

for year in result_year:
     print(f"The year that had the most titles released was the year {year['year']} with {year['count']} titles released.")

"""
Exercise 3
What are the four directors with the most titles accredited to them? 
***Note*** project, unwind, group, sort limit

"""
director_query = [
    {
        '$project': {
            'directors': 1
        }
    },
    {
        '$unwind': '$directors'
    },
    {
        '$group': {
            '_id': '$directors',
            'count': {'$sum': 1}
        }
    },
    {
        '$sort': {
            'count': -1
        }
    },
    {
        '$limit': 4
    },
    {
        '$project': {
            'director': '$_id',
            'count': 1
        }
    }
]

result_director = collection.aggregate(director_query)

for directors in result_director:
     print(f"The four directors with the most titles accredited to them are: {directors['director']} with {directors['count']} titles.")

"""
Exercise 4
Show the title and number of languages the movie was produced in for the following: Year:2013, genre:'Action'


"""

language_query = [
    {
        '$match': {
            'year':  2013,
                'genres': 'Action'
        }
    },
    {
        '$project': {
            'title': 1,
            'languages': 1
        }
    },
    {
        '$addFields': {
            'languages': {'$ifNull': ['$languages', []]}
        }
    },
    {
        '$addFields': {
            'num_languages': {'$size': '$languages'}
        }
    },
    {
         '$project': {
                'title': 1,
                'num_languages': 1
         }
    }
]



result_movies = collection.aggregate(language_query)

for movie in result_movies:
     print(f"Title: {movie['title']} with  a Number of Languages of: {movie['num_languages']}.")

