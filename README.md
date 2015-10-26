# Trips project backend

[ ![Codeship Status](https://codeship.com/projects/70c0b520-567b-0133-5c51-5ebc52a48109/status?branch=master)](https://codeship.com/projects/109381)

The backend of a simple trip planning web application built with Rails 4 + Devise.

## Local development

### Install

    bundle install

### Running specs

    bundle exec rspec

## Deploying to heroku

A heroku instance for dev/testing is running at https://afternoon-harbor-1379.herokuapp.com

If you have heroku setup you just need to push to the heroku branch to redeploy:

    git push heroku master
