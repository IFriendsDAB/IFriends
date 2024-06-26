# IFriends

## Table of Contents

1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)

## Overview

### Description

IFriends is an app that connect international students within college campuses. It addresses the need for a centralized and accessible space where international students can find and interact with each other, fostering a sense of community, support and cultural exchange. It aims to alleviate feelings of isolation and homesickness often experienced by international students.

### App Evaluation

[Evaluation of your app across the following attributes]
- **Category:** Social, Education
- **Mobile:** This is only a mobile app
- **Story:**  IFriends tells a story of connecting international students, creating a supportive community to enhance their college experience.
- **Market:** International students in college
- **Habit:** Likely a daily use app for staying connected and engaged with the community.
- **Scope:** Moderately broad, with essential social networking features tailored for international students, with potential for more specialized features.

## Product Spec

### 1. User Stories (Required and Optional)
**Finished**
- [X] Created AppIcon and LaunchScreen
- [X] Set up Login Page StoryBoard
- [X] Logout and login persists
- [X] Add Registration Page StoryBoard
- [X] Set up Back4App for the User information Login
- [X] Add posts, upload image, add caption which would be visible to the home feed page
- [X] Working on Add post Tab
- [X] Working on Feed Page
- [X] Comment option where users can comment on the posts
- [X] Users can like and the number of likes can be seen in the posts
- [X] Users can cutomize their profile by changing profile picture
- [X] Set up Back4App for the User, Post, Comment, Search to store the user information
- [X] Polished UI for the comment section, animation for the like button
- [X] Separate profile page where user can see their user information and also search for other users using their username

**Required Must-have Stories**

- [X] Login/Registration Screen
    * As an international student, I want to be able to log in to my IFriends account so that I can access my personalized feed and connect with other students.
    * As a new user, I want to create an account on IFriends to join the community of international students and start making connections.
- [X] Login Persists
- [X] View content Stream
    * As a user, I want to view a feed of events and posts to stay updated on what's happening within my international student community.
- [X] Creation of posts
    * As a user, I want to share my experiences by posting new content to my stream, contributing to the community and sharing my culture.
- [X] Search
    * As a user, I want to search for other international students or clubs so that I can grow my network and find peers with similar interests.
 

**Optional Nice-to-have Stories**

- [ ] Messaging
    * As a user, I want to message other students privately to plan meetups or ask for advice, creating close-knit connections within my international student community.
   **Note** We were able to set up the messaging and hit the road block while trying set it up working one-to-one messaging but we will work on it. 
- [ ] Support and Resources
    *  As a user, I need to access resources for international students to help with my academic and personal adjustment to a new country. 
- [X]  Profile Customization
    *  As a user, I want to personalize my profile with information about my home country and interests to share with the community and find like-minded friends.

### 2. Screen Archetypes

* Login Screen
    * User can login.
* Registration Screen
    * User can create a new account and sign in after registration.
* Home Feed
    * User can see posts from international student clubs.
    * User can like the posts and put comments.
* Posting Page
    * User is able to make a post which can be seen on the home page.
* User Profile Page
    * User can view their own profile.
    * User can change their profile picture.
    * Logout from app.

### 3. Navigation

**Tab Navigation** (Tab to Screen)


- [ ] Home Feed (Main Screen)
- [ ] Posting Screen
- [ ] Messages
- [ ] User Profile


**Flow Navigation** (Screen to Screen)

- [ ] [**Login Page**]
  * Leads to [**SignUp Page**] if there is no account created.
  * Leads to [**Home Page**]
- [ ] [**SignUp Page**]
  * Leads to [**Home Page**]
- [ ] [**Home Page**]
  * Leads to [**Home Page**] full of posts from international students and clubs.
  * Users can like posts and put comments for the posts on the feed.
- [ ] [**Profile Page**]
  * User can visit Profiles of club page and students.
- [ ] [**Message Page**]
  * Lets user compose message and shar files and pictures.
- [ ] [** Add Post Page**]
  * User can create posts and attach images, links and files and share.

## GIFs for each Milestones

### Current Progress GIF
![login-register-tab-page](https://github.com/IFriendsDAB/IFriends/assets/64405568/93923e13-c0cf-45b4-9056-7efbb94828b7)


## Wireframes
<img src="https://i.imgur.com/YiMMYHS.jpeg" style="transform: rotate(90deg);">

### [BONUS] Digital Wireframes & Mockups
<img src="https://i.imgur.com/BhSR7vm.png">

### [BONUS] Interactive Prototype
<img src="https://imgur.com/1vivxma.gif" alt="Image" width="200" height="400">

## Narrated Video Demonstrating Application
<a href="https://www.loom.com/share/6371988cc1f84fe79955b1635dcfee5b">
</a>
<a href="https://www.loom.com/share/6371988cc1f84fe79955b1635dcfee5b">
<img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/6371988cc1f84fe79955b1635dcfee5b-with-play.gif">
</a>


## Schema 


### Models

#### User
| Property | Type   | Description                                  |
|----------|--------|----------------------------------------------|
| username | String | unique id for the user post (default field)   |
| password | String | user's password for login authentication      |
| fullname | String | user's fullname |
| profile picture | String(URL)    | user's profile picture |
| country | String | user's home country |
| email | String | user's email address |
| friends | Array(User) | friend roster for current user
| posts | Array(Post) | list of posts made by user|

#### Post
| Property | Type   | Description                                  |
|----------|--------|----------------------------------------------|
| id | Integer | unique identifier for the post  |
|username |String | foreign key to the User model, indicating who created the post
| image |String(URL) | link to the image included in the post. |
| caption | String | a caption describing the post. |
| likes| Integer | counts number of likes for the post |
| creationTime | DateTime | creation time of post |

#### Message
| Property | Type   | Description                                  |
|----------|--------|----------------------------------------------|
| id | Integer | a unique identifier for each message |
| senderUsername | String | username from user model idenifying the sender |
| recieverUsername | String | username from user model idenifying the reciever |
| content | String | text content of the message |
| sendTime | DateTime | time at which the message was sent |



### Networking

#### Login Screen
- [POST] /login 
  - Endpoint to authenticate user login credentials.

#### Registration Screen
- [POST] /register 
  - Endpoint to create a new user account.

#### Home Screen
- [GET] /feed 
  - Endpoint to retrieve posts for the user's feed.

#### Add Post Screen
- [POST] /posts 
  - Endpoint to add a new post to the user's profile.

#### Messaging Screen
- [GET] /messages/{conversation_id} 
  - Endpoint to retrieve messages for a specific conversation.
- [POST] /messages 
  - Endpoint to send a message in a conversation.

#### User Profile
- [GET] /profile/{username} 
  - Endpoint to retrieve user profile information for a specific user.

