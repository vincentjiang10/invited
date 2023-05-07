# apdev-final-project

# INVITED!

# Want to invite any of your friends to an event? Simply create an event and invite them through Invited!

# Some screenshots of your app (highlight important features)

<img src="https://user-images.githubusercontent.com/106412989/236647437-377d46dd-e128-4037-a55c-9ffb1bb8b293.png" alt="Screenshot 1" width="200" /> <img src="https://user-images.githubusercontent.com/106412989/236647439-0ae20d7b-e13b-440f-ae1d-26b5e1a3ac34.png" alt="Screenshot 2" width="200" /> <img src="https://user-images.githubusercontent.com/106412989/236647441-0b69781d-0c79-4254-8fa5-6d05df576bf8.png" alt="Screenshot 3" width="200" />


<img src="https://user-images.githubusercontent.com/106412989/236647444-96cb2a0f-97b6-41a8-90d8-baf20d008310.png" alt="Screenshot 4" width="200" /> <img src="https://user-images.githubusercontent.com/106412989/236647445-35ca9978-f2d1-4b13-91e0-d457f1a3e4a2.png" alt="Screenshot 5" width="200" /> <img src="https://user-images.githubusercontent.com/106412989/236647932-2187b765-8094-4c03-9d2f-59334e9ed1b0.png" alt="Screenshot 6" width="200" />

# Features

- :mag: **Search Events:** Use the searchbar to go through public, invited, and created events!

- :bust_in_silhouette: **Create a Profile:** Save your name and email!

- :tada::busts_in_silhouette: **Make Events:** Host events and share them!

- :arrows_counterclockwise: **Refresh:** Swipe up to see new events added to your event feed! 

## Frontend

- We added multiple ViewControllers alongside the main VC: ProfileViewController (PVC), EventDetailViewController (EDVC), EventMakerViewController (EMVC). 
- The PVC shows a screen where the user can write their name and email, which gets saved within the app through UserDefaults. Though initially it used delegation to change the main VC's title to also show the User's name, we lated changed to using persistence and UserDefaults. There's email validation on the frontend side as users cannot write out a random set of chars and pass it off as an email. 
- The EDVC displays data from a `tableviewcell` from the tableview in the main VC and the screen presents all the information about the event. The user can also exit out of any VC that is not the main VC. 
- The EMVC allows the user to create an event itself. Currently, we only support public events; users writing anything other than PUBLIC or PRIVATE will be shown an alert. Another alert is also shown in the EMVC if the start and end timing are written in an incorrect format. 
- When making the event, it does a POST and once created, the EMVC is exited and the main VC is shown. The user can refresh the tableview and see the event they made. 
- The main tableview itself uses GET to show all public events. 
- In terms of filtering, we have public and created events implemented such that the public events filter, when selected, shows all public events and the created events filter, when selected, shows all the events the user created. 
- We also have a `searchbar` that filters through the event names and can be used alongside the filters from the `collectionview`. 
- Our `networkmanager` is connected to the backend API, to reiterate again!

## Backend

# A list of how your app addresses each of the requirements
