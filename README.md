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

For the next milestone:
- We will add all required columns to our database schema.
- We will connect all the remaining functionality to the database. 
  This includes saved profiles, left and right swipes, pictures/images, and more data that will
  come with new widgets.
- We will add new widgets for:
    - Locations (latitude and longitude) for the users/dogs of account profiles
    - Distance range for match filtering
    - Reporting inappropriate profiles