## bouttime

> 'Bout time we got this game started.

### Dependencies

* postgresql ~> 9.3
* ruby = 2.1.5

#### homebrew

```bash
./bin/setup/homebrew.sh
./bin/setup/rbenv.sh # if you do not manage your own rubbies
```

#### laptop

If you do not manage your own environment already then you can take a look at [laptop](https://github.com/wiserstudios/laptop).

> Laptop is a script to set up a Mac OS X or Linux laptop for Rails development.

#### Environment Variables

### Setup

```bash
bundle install
```

### Deployment

#### Environment Variables

* DATABASE_URL
* SECRET_KEY_BASE

#### Dependencies

* capistrano

#### Make It So!

```bash
cap <environment> deploy
```

Where environment can be staging or production.
