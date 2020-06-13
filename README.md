# MicroAds microservice with Grape

## Run

```
$ bundle install

# create database manually by psql

$ rake db:migrate
# or reset db
$ rake db:reset

$ rake db:seed
$ bin/puma
```

## Try

```
# version v1 (current)

curl http://localhost:9292/api/v1
{"version":"v1"}

curl http://localhost:9292/api/v1/ads
{"ads":[]}
```
