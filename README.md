![Shortify](shortify.png)

# Shortify

[![Build Status](https://travis-ci.org/snada/shortify.svg?branch=master)](https://travis-ci.org/snada/shortify)

- [Description](#description)
- [Install and launch](#install)
- [Test](#test)
- [Development notes](#dev)
- [Releases](#releases)

## <a name="description"></a> Description

This is Shortify, a simple short-url web-service.

### Creating a short url

```
POST http://localhost:3000
```
The post request must contain a `url` parameter containing the target address of the url.

If a `slug` parameter is passed, the system will try to create the short-url using that slug.

The output is always a JSON response. In case of success, both the target and short-url will be returned with `url` and `shortcut` keys:

```
{
  "url": "http://example.com",
  "shortcut": "http://localhost:3000/v7k"
}
```

When something goes wrong the response body will have an errors array, containing messages explaining the reasons of the failure, and the HTTP status will change accordingly.

```
{
  "errors": [
    "Validation failed: Slug has already been taken"
  ]
}
```

The system is completely transparent to the user: when a creation request matches with a record already present in the system, that one will be returned without any message, to avoid duplicate records.

### Visiting a short-url

You can be redirected to the target url appending a slug to the root of the webservice, like this:

```
GET http://localhost:3000/xYz
```

If the slug is not present in the database, the HTTP status will be 404 and JSON response will be something like this:

```
{
  "errors": [
    "Couldn't find a shortcut with slug example"
  ]
}
```

## <a name="install"></a> Install and launch

Shortify is a Ruby on Rails 4 app: it was developed using Ruby language version `2.2.3`.

Use your favorite Ruby version manager to install the right version: the included `.ruby-version` file will make sure that it will be automatically selected for you.

All the required dependencies can be installed by simply navigating to the app folder and running:

```
bundle
```

This project was originally developed on top of a PostgreSQL database: anyway, code is compliant to standard SQL rules: it's safe to run it on top of other DBMSs, but a new adapter must be added in the `Gemfile` and installed running bundler.

Prepare your database setup by writing a `config/database.yml` file. In the same folder you'll find a `config/database.yml.example` that provides guidelines.

Once the database is ready, you can launch it with:

```
bundle exec rails server
```

## <a name="test"></a> Test

### Automated tests

An automated test suite is included, and you can launch the tests with:

```
bundle exec rake
```

A (very simple) code coverage tool is included: you can take a look at the results opening the `coverage/index.html` file with your browser.

All the test are written using `rspec`. Data mocking is done with the `FactoryGirl` gem.

### Stress test

During development I like to test algorithms and the general stability of the platform pushing a lot of data to see the outcomes.

While your development server is running, you can invoke a simple task with:

```
bundle exec rake stress_test:launch[size]
```

This will make size times short-url creation requests with fake data to your server.

## <a name="dev"></a> Development notes

I developed this project with these simple goals in mind:

- Generate the shortest address possible
- Generate human readable and url-safe addresses
- Keep code clean and tested

This goals led me to adopt the following strategies.

### Short and readable slugs

Slugs are generated calculating a SHA2 hex hash from the actual url and then transforming it into a Base62 encoded string.

Once the token is generated, the system will then use as a new slug the shortest [0...n] substring possible.

SHA2 was chosen because of it's collision resistance and fairly long outputs. Also, the avalanche effect allows us to generate very different slugs for near-close urls keeping the average slug length the shortest possible.

Base62 was chosen instead a url-safe variant of Base64 to completely avoid the presence of special characters in urls. This slightly decreases the number of possible combinations, but keeps the readability of the generated urls very high.

Indexes are provided on the database: the b-tree data-structure used by PostgreSQL ensure that the substring query (almost like a reverse-index search) gets executed the fastest way possible.

It's my habit, when possible, to never use the `id` attribute of a record to generate public-exposed informations, to release as little information as possible on the internal system structure and procedures.

To ensure a minimum level of security to the system, I developed a few procedures:

- The only allowed protocols are HTTP and HTTPS: the system will force http when not specified
- Slugs and urls are cleaned: slugs can only have Base62 values and urls are escaped

### Keeping code clean and tested

I mainly focused on keeping all of the logic in the right place:

- The Base62 encoder is in a lib, because out of the specific app domain. It does not convert directly from a hex hash to resemble the Base64 module, included by default in the Rails framework. Same for url cleaning lib.
- The slug generation code is a static function in the Shortcut model. In my opinion a concern isn't the right place because it's not a shared behavior with other (hypothetical) models.
- The url protocol validation is a custom Rails validator
- The stress test is a rake task.

One of the best ways of documenting the code is by writing good tests. In the `spec` directory you'll find the best documentation to learn of this app.

## <a name="releases"></a> Releases

### 1.0.0

- Bug fixing, version, root

### 0.0.2-beta

- Fixed slug validation with base62 chars

### 0.0.1-beta

- Fixed stress test rake task

### 0.0.0-beta

- Everything works, docs still to write.
- Needs stress test
