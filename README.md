# DemoMovies

Thoughts and decisions which led to what you see.

1.	I put the source into a public git repo to demonstrate my comfort level of working with git repositories. I find source control is an invaluable lifeboat when you least expect it.

2.	I could not find a working API for retrieving images, so that component is left unfinished.

3.	I avoid application logic existing in views. Hence the use of the MVVM pattern in the main view.

4.	I put the code which actually makes the API calls in a separate object. A further refinement of this would be to have the data engine conform to a protocol so a mock can be injected for on device testing. Just no time to get that done.

5.	I put business logic in the view model and other non-visual objects to facilitate unit testing.

6.	I used TDD to verify my API calls worked. The test file to test the API calls was probably the third object I built, after the data model and dummy data.

7.	I keep data models in their own classes: time permitting I would have put the models in their own separate files.

8.	I am not as fluent as I’d like to be with SwiftUI, so the views are sketchy at best, but they get the job done.

9.	I’m not sure of the meaning of “add a way to view the movies you’ve favorited.” I interpreted that as filtering the list of movies to show just the favorites. It wasn’t until I was close to finished that I thought you might mean actually ordering tickets to a movie. I did not check to see if the movies API even permits or exposes that functionality. 

Truth be told, not counting the two hours I lost trying to get the API calls to work, I spent about four hours on the project. The tail end of that time was getting the sorting working and debugging some of the behavior of applying and removing the favorites filter.

