# Maddô

## Setup

rake paypal:plans:upload
rake paypal:plans:sync


#staging
console:
```
heroku run -a maddo-staging rails c
heroku run -a maddo-staging bash
```

Erase database:
```
rake db:schema:dump
rake db:schema:load DISABLE_DATABASE_ENVIRONMENT_CHECK=1
```
