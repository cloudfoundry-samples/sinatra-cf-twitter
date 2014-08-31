## Who Follows?

A simple Sinatra/Redis app - does one Twitter user follow another?

This is a refactored and improved version of [the app built for RailsConf 2011](http://support.cloudfoundry.com/entries/20117991-cloud-foundry-workshop-at-railsconf-2011) by Charles Lee.

There is an example deployed at <http://twhofollows.cfapps.io>

## Overview

This example uses:

- Ruby 2+
- Bundler
- [Twitter Ruby gem](https://github.com/sferik/twitter)
- [Sinatra](http://www.sinatrarb.com/) as the framework
- Redis as the cache/datastore
- [Bootstrap](http://getbootstrap.com) for visual loveliness
- the latest version of the [cf CLI](https://console.run.pivotal.io/tools) for deployment to Cloud Foundry

It demonstrates:

- setting the location of static content with Sinatra
- the use of layout templates
- how a Cloud Foundry manifest can be used for deployment

Limitations:

- the app queries the Twitter [GET followers/ids](https://dev.twitter.com/docs/api/1.1/get/followers/ids) REST endpoint, which is [rate-limited](https://dev.twitter.com/docs/rate-limiting/1.1/limits) to 15 calls in a 15 minute window, so it cannot be used heavily. This is just a demonstration of some simple API functionality.  

## Running the app locally

Fork the project.

Then run:

    git clone git@github.com:<your_name>/sinatra-cf-twitter.git whofollows
    cd whofollows

You will need a local Redis server running. If you need to connect with a password, edit the follow line to add a `:password` value.

```ruby
REDIS_CLIENT = Redis.new(:host => 'localhost', :port => 6379)
```

You will need to create a [Twitter app](http://apps.twitter.com) and place the API keys in the environment variables `TW_CONSUMER_KEY`, `TW_CONSUMER_SECRET`, `TW_ACCESS_TOKEN` and `TW_ACCESS_TOKEN_SECRET`.

Run `rackup` to start the server, and navigate to `http://localhost:9292` to access the application.

To clear the database cache, hit the `/cleardb` endpoint.

## Deployment to Cloud Foundry

First, fork the project. Then run:

    git clone git@github.com:<your_name>/sinatra-cf-twitter.git whofollows
    cd whofollows
    cp manifest.yml.example manifest.yml
    vi manifest.yml

Edit the application name in the manifest file to be a unique value (an appname must be a unique name across all applications running on a Cloud Foundry instance); enter a Redis service instance name; enter your [Twitter app API keys](http://apps.twitter.com); then save the file.

    bundle install
    cf create-service rediscloud 25mb <service-name>
    cf push

Visit `http://appname.cfapps.io` and run some queries.

To see the use of multiple instances, refresh the page (the initial manifest specifies 2 instances). The port displayed at the end of the page will vary.

To modify, run `cf scale -i n` (where n is the number of instances of the app to create), and then reload the page. Repeat with a lower value of n to reduce the number.

To clear the database cache, hit the `/cleardb` endpoint.

## Issues

The following issues are known:

- lack of strong error handling -> currently if one or both user IDs don't exist, a "page does not exist" error is shown
- Twitter API limits only return the first (100?) users in the list of friends/followers, so if a user has many thousands of followers it may not work (Ruby gem and Twitter API hard limits)

## Future enhancements

A few areas could be tided up:

- better error handling
- no real need for the query to direct to a separate page, make this dynamic
- add a static page with some background information on how it works
- nicer mobile support (hide fork me banner)
