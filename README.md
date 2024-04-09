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

**Required Must-have Stories**

* [User can [specific action, e.g., register an account]]
* Login/Registration Screen
    * As an international student, I want to be able to log in to my IFriends account so that I can access my personalized feed and connect with other students.
    * As a new user, I want to create an account on IFriends to join the community of international students and start making connections.
* Stream
    * As a user, I want to view a feed of events and posts to stay updated on what's happening within my international student community.
* Creation
    * As a user, I want to share my experiences by posting new content to my stream, contributing to the community and sharing my culture.
* Search
    * As a user, I want to search for other international students or clubs so that I can grow my network and find peers with similar interests.
 

**Optional Nice-to-have Stories**

* [User can [specific action, e.g., persist user information across working sessions]]
* Messaging
    * As a user, I want to message other students privately to plan meetups or ask for advice, creating close-knit connections within my international student community.
* Support and Resources
    *  As a user, I need to access resources for international students to help with my academic and personal adjustment to a new country. 
*  Profile Customization
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

## Wireframes
<img src="https://i.imgur.com/4nZH2ro.jpeg" alt="Image" style="transform: rotate(90deg);">

### [BONUS] Digital Wireframes & Mockups
<img src="https://i.imgur.com/BhSR7vm.png">

### [BONUS] Interactive Prototype
<img src="https://imgur.com/1vivxma.gif" alt="Image" width="200" height="400">


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

- [List of network requests by screen]
- [Example: `[GET] /users` - to retrieve user data]
- ...
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]``
