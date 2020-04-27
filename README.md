# Maskbook

> A Facebook replica wherein users can add and remove friends; create, read, edit and remove posts & comments; create, read, remove likes on posts & comments; receive notifications on friend requests, likes and comments; and see a post feed.

![Posts Feed](/docs/fb-clone-feed.png?raw=true)

The database schema is based on seven (7) models User, FriendRequest, Friendship, Post, Notification, Comment and Like.

![Schema](/docs/erd/logical-diagram.png?raw=true)

## Built With

- Ruby on Rails
- PostgreSQL
- RSpec
- Capybara
- FactoryBot
- DatabaseCleaner
- Faker
- Shoulda
- Figaro

## Live Demo

This web app is deployed on a free tier of Heroku [here](https://sleepy-tor-12192.herokuapp.com/).

## Prerequisites

You need:

* Ruby 2.6.1
* Rails 5
* PostgreSQL 11+

### Setup

```bash
$ git clone https://github.com/adriaanbd/facebook-clone.git
$ cd facebook-clone
```

### Install

```bash
$ bundle install
```

### Usage

#### Setup and migrate database

```bash
$ rails db:setup
$ rails db:migrate
```

#### Development server

```bash
$ rails server
```

### Run tests

```bash
$ rspec -fd
```

## Authors

### Adriaan Beiertz

- [GitHub](https://github.com/adriaanbd)
- [Twitter](https://twitter.com/abeiertz)
- [LinkedIn](https://linkedin.com/adriaanbd)

### Maya Douglas

- [GitHub](https://github.com/mcrd25/)

## Contributing

Contributions, issues and feature requests are welcome
