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
