# Facebook Clone
Clone of facebook.com using rails 5

> Testing our knowedge of MVC by building an a rails 5 app to clone a version of facebook.com. This project will help us implement knowedge of Models, Associations, Valdiation, HTML/CSS and so on.

## Collaborators 

* Adriaan Beiertz - [@adriaanbd](https://github.com/adriaanbd)
* Maya Douglas - [@mcrd25](https://github.com/mcrd25/)

## Project Description


## System Requirements


## Getting started

Before cloning repo you should have Postgres installed. You can get various installation instructions [here]()

Once you have PostgreSQL You must create a user with the same name of the app (fb-clone)

1. First enter Postgres console
	```
	psql postgres
	```

2. Next create the database user with whichever password you would like
	```
	create role fb-clone with createdb login password 'password1';
	```

3. You should now see the user on your list of users. Enter `\du` to see the list. (Type `q` to come out of list)

4. You can then come out of PostgreSQL console by typing `\q`

---

To get started with the app, clone the repo and then install the needed gems:

```
$ bundle install --without production
```

Next, migrate the database:

```
$ rails db:migrate
```

Finally, run the test suite to verify that everything is working correctly:

```
$ rails test
```

If the test suite passes, you'll be ready to run the app in a local server:

```
$ rails server
```


