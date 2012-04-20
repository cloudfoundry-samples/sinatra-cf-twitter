## Who Follows?
============

A simple Sinatra/Redis app - does one Twitter user follow another? 

This is a refactored and improved version of [the app built for RailsConf 2011](http://support.cloudfoundry.com/entries/20117991-cloud-foundry-workshop-at-railsconf-2011) by Charles Lee.

There is an example deployed at <http://whofollows.cloudfoundry.com>

## Overview

This example uses:

- ruby
- bundler
- [Twitter Ruby gem](http://twitter.rubyforge.org/)
- [Sinatra](http://www.sinatrarb.com/) as the framework
- redis as a datastore
- [Twitter Bootstrap](http://twitter.github.com) for visual loveliness
- the latest version of the vmc gem (`gem install vmc --pre`)

It demonstrates:

- setting the location of static content with Sinatra
- the use of a layout template
- how a Cloud Foundry manifest can be used for deployment

## Deployment to Cloud Foundry

First, fork the project. Then run:

    git clone git@github.com:<your_name>/sinatra-cf-twitter.git whofollows
    cd whofollows
    vi manifest.yml

Edit the application name in the manifest file to be a unique value (an appname must be a unique name across all applications running on Cloud Foundry), and save the file.

    bundle install; bundle package
    vmc push

Visit `http://appname.cloudfoundry.com` and run some queries.

To see the use of multiple instances, refresh the page (the initial manifest specifies 2 instances). The IP address and port displayed at the end of the page will vary.

To modify, run `vmc instances +n` (where n is the number of additional instances of the app to create), and then reload the page. Use -n to reduce the number.

## Issues

The following issues are known:

- lack of error handling -> currently if one or both user IDs don't exist, an error is exposed
- Twitter API limits only return the first (100?) users in the list of friends/followers, so if a user has many thousands of followers it may not work (Ruby gem and Twitter API hard limits)

## Future enhancements

A few areas could be tided up:

- implement error handling
- no real need for the query to direct to a separate page, make this dynamic 
- additional Bootstrap features to be added
- add a static page with some background information on how it works
- handle mobile devices (CSS media queries for iPhone etc)

