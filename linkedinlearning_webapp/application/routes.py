#ALL of the routes should be kept in this file 

#import app from the __init__ file 
from application import app
from flask import render_template, request

#create a route to run the simple app 
@app.route("/")
#below, we make another one off of the root route
@app.route("/index")
#each of these things are called "decorators"
@app.route("/home")
#all of the above are aliases for the others 

def index():
    #return "<h1> Hello, World!!! Testing AGAIN </h1>"
    #to replace the above, we will use the render_template function
    #you can pass additional parameters to render_template
    return render_template("index.html", index = True)


#make our other functions for other tabs in our site 
@app.route("/login")
def login():
    #the final parameter is a step towards highlighting the tab that is open
    return render_template("login.html", login = True)

@app.route("/register")
def register():
    return render_template("register.html", register = True)

@app.route("/courses/")
@app.route("/courses/<term>")
def courses(term = "2020"):
    courseData = [{"courseId":"CSC1100", "Title":"Intro to Computing", "Credits":"4", "Term":"Fall/Spring"},
                  {"courseId":"CSC1810", "Title":"Principles of Computer Science", "Credits":"4", "Term":"Fall/Spring"},
                  {"courseId":"CSC1820", "Title":"Principles of CS 2", "Credits":"4", "Term":"Fall/Spring"},
                  {"courseId":"CSC2810", "Title":"Database Design", "Credits":"4", "Term":"Fall"},
                  {"courseId":"CSC4100", "Title":"Thesis Completion", "Credits":"1", "Term":"Spring"}]
    return render_template("courses.html", courseData = courseData, courses = True, term = term)


@app.route("/enrollment")
def enrollment():
    id = request.args.get('courseId')
    title = request.args.get('Title')
    term = request.args.get('Term')
    return render_template("enrollment.html", data = {"id":id, "title": title, "term":term})