This is an IOS demo application for displaying the latest Box Office movies using the RottenTomatoes API. 

Time Spent: 15 hours

Completed User Stories:
 * [x] Required: User can view a list of movies from Rotten Tomatoes. Poster imagesload asynchronously.
 * [x] Required: User can view movie details by tapping on a cell
 * [x] Required: User sees loading state while waiting for movies API.
 * [x] Required: User sees error message when there's a networking error.
 * [x] Required: User can pull to refresh the movie list
 * [x] Optional: All images fade in
 * [x] Optional: For the large poster, load the low-res image first, switch to high-res when complete
 * [x] Optional: User sees error message when there's a networking error.
 * [x] Optional: Customize the highlight and selection effect of the cell.
 * [x] Optional: Customize the navigation bar
 * [x] Optional: Add a tab bar for Box Office and DVD.
 * [x] Optional: Add a search bar.

Notes: Spent a lot of time on focussing on UX
1. When a user scrolls up the search bar and the tabs hide away. They dont happen immediately but rather when I know that the user is in browsing mode and does not need the search bar. 
2. User clicks on the full poster image, he/she gets to see uninterrupted full screen view of the poster.

Walkthrough of all user stories:

![Video Walkthrough](anim_rotten_tomatoes.gif)
