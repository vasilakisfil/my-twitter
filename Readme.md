мy-тшiттeг
=========

A twitter clone that retrieves all info from Twitter's REST API. It uses the old Twitter's layout.



Installation
--------------

```sh
bundle install
cp _config.yml config.yml
```

Go to twitter dev section and copy paste the following vars: `API_KEY`, `API_SECRET`, `ACCESS_TOKEN`, `ACCESS_TOKEN_SECRET`. Then run

```sh
ruby init.rb

bundle exec thin start -R config.ru
```


License
----

MIT
