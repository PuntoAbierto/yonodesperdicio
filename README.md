# Yonodesperdicio.org (from nolotiro.org v3)

![Yonodesperdicio](https://yonodesperdicio.org/assets/propias/cabecera-yonodesperdicio-316c77932e19fcc5b186349caf6164cc.png)


Yonodesperdicio is a Ruby on Rails application to share food between users, avoiding the waste of food.

## License

[Affero GPL 3](http://www.gnu.org/licenses/agpl-3.0.html), based on [Nolotiro](http://nolotiro.org). 

-----------------------------------------

## Ruby and Rails version

* Yonodesperdicio Ruby 2.2.2p95 (2015-04-13 revision 50295)
* Yonodesperdicio Rails 4.2.3
-----------------------------------------

## API 

API REST Json.
curl from command line.

To create things you have to make a POST request with a json with the data, if something is missing it will give an error and return a json with the error messages, if it goes well returns a json with the created record. To update it would have to make a PUT request with the modified json.


Routes in general will then be something like, eg:

* At beta: http://beta.yonodesperdicio.org/api/users/1 
* At production: http://yonodesperdicio.org/api/users/1

### Search:

Ideas can be filtered by passing parameters in the url for category and / or user_id, for example:

* /api/ideas?user_id=5
* /api/ideas?category=trucos

Ads can be filtered by user_id, food_category, zipcode and query (as in the web).

* /api/ads?food_category=bebidas
* /api/ads?user_id=1
* /api/ads?zipcode=28011
* /api/ads?query=avellanas

### Users

View an user: 

http://beta.yonodesperdicio.org/api/users/1

Create an user:

POST to / api / users with json with user registration data (username, password, name, zipcode, email)

Example:

curl -H "Content-Type: application/json" -X POST -d '{"user": {"username":"xyz","password":"12345678","name":"XYZ", "zipcode":"123", "email":"zxy@example.com"}}'  -X POST http://beta.yonodesperdicio.org/api/users

After creating the account must be confirmed by email.

Authenticate user:

POST to /api/sessions with username and password as parameters.

Example:

curl -d "username=xyz&password=12345678"  -X POST http://beta.yonodesperdicio.org/api/sessions

This returns a json with an auth_token to be used in the Authorization header in the following HTTP requests to create / update / delete things:

{"Session_user": {"id": 16, "username": "xyz", "email": "zxy@example.com", "auth_token": "aYByuB16ap-5VcNB9Xsf"}}

On the web, the user and ad (food) location data go through a zipcode and city, simply so that the user does not have to give his exact address for privacy and LOPD issues and such.

When creating a food, this takes by default the user's zipcode, but this zipcode can be changed for each ad later (eg in cases where the user moves from place to place and prefers to give his food elsewhere, or in a place on the way to work, or things like that).


### Ads (alimentos=food)

View all ads: 

http://beta.yonodesperdicio.org/api/ads

Views the ad with id=1: 

http://beta.yonodesperdicio.org/api/ads/1

Create an ad:

POST to / api / ads with ad data and the Authorization header with the token that returned the login

Example:

curl -H "Content-Type: application/json"  -H "Authorization: TB1T2pDQuGYExhJQ5vYB" -X POST -d '{"ad": {"title":"probando desde api","body":"un alimento muy rico","grams":"120", "status":"1", "food_category":"bebidas"}}'  -X POST http://localhost:3000/api/ads

Returns the saved ad, with the id assigned in the database:

{"ad":{"id":5,"title":"probando desde api","body":"un alimento muy rico","status":1,"grams":120,"expiration_date":null,"pick_up_date":null,"comments_enabled":null,"image":"propias/d_ads_original.png","zipcode":"123","city":null,"province":null,"food_category":"bebidas","user_id":3}}

### Ofertas

View all offers:

http://beta.yonodesperdicio.org/api/offers


View the offer with id=1:

http://beta.yonodesperdicio.org/api/offers/1

Create an offer:

POST to /api/offers with the offer data and the Authorization header with the token that returned the login

Example:

```
curl -H "Content-Type: application/json"  -H "Authorization: TB1T2pDQuGYExhJQ5vYB" -X POST -d '{"offer":{"title": "Title of offer", "address": "The offer address", "store": "The offer store", "until": "2018-10-21", "description": "The offer description"}}' -X POST http://localhost:3000/api/offers
```

Returns the saved offer, with the id assigned in the database:

```
{"id":4,"title":"Title of offer","address":"The offer address","store":"The offer store","until":"2018-10-21T00:00:00.000Z","status":"available","image":{"medium":"http://localhost:3000/assets/propias/offer_medium.png","large":"http://localhost:3000/assets/propias/offer_large.png","original":"http://localhost:3000/propias/offer_original.png"}}
```

### Ideas (recetas o trucos)

Ideas: http://beta.yonodesperdicio.org/api/ideas

An idea with id=1: http://beta.yonodesperdicio.org/api/ideas/1

Create an idea:

curl -H "Content-Type: application/json"  -H "Authorization: TB1T2pDQuGYExhJQ5vYB" -X POST -d '{"idea": {"category":"truco", "title":"una idea desde api", "body":"un idea genial", "introduction":"intro intro"}}'  -X POST http://localhost:3000/api/ideas

Returns the saved idea:

{"idea":{"id":9,"category":"truco","title":"una idea desde api","introduction":"intro intro","ingredients":null,"body":"un idea genial","image":"propias/d_brick_original.png","tag_list":[],"user_id":3}}

### Comments on ads or ideas

Create comments: 

POST con json {"comment": {"body": "cuerpo del comentario"}} a /api/ads/AD_ID/comments para ads  o  /api/ideas/IDEA_ID/comments para ideas

Examples:

curl -H "Content-Type: application/json"  -H "Authorization: 8qqRb_KFdp9W2-CNVFKU" -X POST  -d '{"comment": {"body":"comentario desde api"}}' http://localhost:3000/api/ads/1/comments

curl -H "Content-Type: application/json"  -H "Authorization: 8qqRb_KFdp9W2-CNVFKU" -X POST  -d '{"comment": {"body":"comentario desde api"}}' http://localhost:3000/api/ideas/1/comments

Returns comment created json.

### Messages

View conversations of a mailbox (being logged in):

/api/mailboxes/MAILBOX_ID/conversations

curl -H "Content-Type: application/json"  -H "Authorization: 8qqRb_KFdp9W2-CNVFKU" http://localhost:3000/api/mailboxes/inbox/conversations

Mailbox_id can be: “inbox”, “sent” o “trash”

View messages from a conversation:

/api/mailboxes/MAILBOX_ID/conversations/CONVERSATION_ID/messages
curl -H "Content-Type: application/json"  -H "Authorization: 8qqRb_KFdp9W2-CNVFKU" http://localhost:3000/api/mailboxes/inbox/conversations/1/messages

Respond to a conversation:

POST to /api/mailboxes/invox/conversations/CONVERSATION_ID/messages
with json {"message": {"body": "cuerpo del mensaje 3"}}

curl -H "Content-Type: application/json"  -H "Authorization: 8qqRb_KFdp9W2-CNVFKU" -X POST -d '{"message": {"body": "cuerpo del mensaje 3"}}' http://localhost:3000/api/mailboxes/inbox/conversations/1/messages

New message:

POST to /api/new_message/RECIPIENT_ID
with json {"message": {"subject": "test2", "body": "cuerpo del mensaje 3"}}

curl -H "Content-Type: application/json"  -H "Authorization: 8qqRb_KFdp9W2-CNVFKU" -X POST -d '{"message": {"subject": "test2", "body": "cuerpo del mensaje 3"}}' http://localhost:3000/api/new_message/2

### Delivered food (ads) counter:

The total amount of kilos delivered in: / api / total_kg
(The total amount of kilos delivered is the sum of each ad with status = delivered)

-----------------------------------------

# From Nolotiro:

[Nolotiro documentation](https://github.com/alabs/nolotiro.org "Nolotiro")
