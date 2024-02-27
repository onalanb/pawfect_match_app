Instructions / notes:
- When you launch the app, you will first be navigated to the login page.
- The login details are as follows:
    - valid usernames: baran, james, varun
    - valid password: password (for all three accounts)
- If account information is incorrect, a dialog box indicating login failure will appear
  and you will have to retry.
- Upon successful login, you will see the accounts and dog pictures of other users (but not self).
- For swipe an match, profile info comes from the real database (sqlite), but left and right swipes
  for likes and dislikes are not yet connected to the database.
  (This will be in the next milestone.)
- If you don't have an account and would like to make one, you can click SignUp
  and navigate to the Create Profile page. This allows entering profile information,
  taking a new picture or selecting one from the gallery.
- Save Profile button is not connected to the database yet.
  (This will also be in the next milestone.)
- Currently, for easy testing and development purposes, our database is primed in main before 
  launching our app. And even the pictures are primed in that database using a base64 format.
  Once Create Profile is connected to the database, we will remove this hardcoded database
  initialization.

For milestone 2:
- We will add all required columns to our database schema.
- We will connect all the remaining functionality to the database. 
  This includes saved profiles, left and right swipes, pictures/images, and more data that will
  come with new widgets.
- We will add new widgets for:
    - Heart widget that will appear as a matching icon on the swiping page and navigate to a Matches widget.
      Heart widget has a counter that displays the number of matches for the logged in person.
      When the counter changes (increment or decrement) there will be an animation on the icon.
      A match is defined by mutual liking of two users.
    - Reporting inappropriate profiles, this widget allows users to report profiles and provide a reason. 
      (this would normally send an email to some administrative role for review but we wont do this.)
    - Matches widget that will navigate the user to a new matches page. Here, they will be able to view
      all details about the person they have matched with just as they would normally in the swiping page.
      However, they will also have access to the user's phone number so that they can make contact with them.

For milestone 3:
  - TBD 