#ALL of the routes should be kept in this file 

#import app from the __init__ file 
from application import app
from flask import render_template

#create a route to run the simple app 
@app.route("/")
#below, we make another one off of the root route
@app.route("/index")
#each of these things are called "decorators"


def default():
    #return "<h1> Hello, World!!! Testing AGAIN </h1>"
    #to replace the above, we will use the render_template function
    return render_template("index.html")