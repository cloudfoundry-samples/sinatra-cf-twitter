## Who Follows?
============

A simple Sinatra/Redis app - does one Twitter user follow another? 

This is a refactored and improved version of [the app built for RailsConf 2011](http://support.cloudfoundry.com/entries/20117991-cloud-foundry-workshop-at-railsconf-2011) by Charles Lee.

## Overview

This example uses:

- Ruby
- bundler
- [Sinatra](http://www.sinatrarb.com/) as the framework
- Redis as a datastore
- [Twitter Bootstrap](http://twitter.github.com) for visual loveliness
- the latest version of the vmc gem (`gem install vmc --pre`)

It demonstrates the use of static content with Sinatra; uses a layout template; and shows how a Cloud Foundry manifest can be used for deployment.

## Deployment to Cloud Foundry

First, fork the project. Then run:

    git clone git@github.com:<your_name>/sinatra-cf-twitter.git whofollows
    cd whofollows
    vi manifest.yml

Edit the application name in the manifest file to be a unique value (an appname must be a unique name across all applications running on Cloud Foundry), and save the file.

    bundle install; bundle package
    vmc push

Visit `http://appname.cloudfoundry.com` and run some queries.

To see the use of multiple instances, run `vmc instances +n` (where n is the number of additional instances of the app to create), and then reload the page - the IP address and port displayed at the end of the page will vary.

## Issues

A few areas could be tided up:

- lack of error handling -> currently if one or both user IDs don't exist, an error is exposed
- no real need for the query to direct to a separate page, make this dynamic 
- additional Bootstrap features to be added

