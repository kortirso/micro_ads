# MicroAds microservice with Grape

## Run

```
$ bundle install
$ rackup
```

## Try

```
# version v1 (current)

curl http://localhost:9292/api/v1
{"version":"v1"}

curl http://localhost:9292/api/v1/ads
{"ads":[]}
```
