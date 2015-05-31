# SMD_PROJ3

## Assumptions

* Only Victoria locations and postcodes[3000 - 3999] are allowed in the usage of this application

## Installation

* $ `bundle install`
* $ `rake db:create`
* $ `rake db:migrate`
* $ `rake db:seed`
* $ `rake weather:forecastio`
* $ `rails s`

## Set Up Recurring Task
If in "development" environment:

1. `whenever --update-crontab`

If in "production":

1. Change the environtment from `development` to `production` in `config/schedule.rb`
2. Run from console `whenever --update-crontab`


## Multi-timezone Support

* every time instance must be saved to the db with a timezone attached to it
* `config/application.rb` sets the default timezone to be Melbourne (UTC +10), i.e. every time instance is converted to Melb timezone before saving by Active Record


## Algorithm
### When the specified location is not in our database

* The cloesest postal area is found, and the weather prediction of that area is returned.
* The closest postal area is found by calculating the sum of difference in lat and long between the given location and every registered locations in database; the location with the smallest difference is returned.
* When the sum of difference exceeds 1, approximately 100km in distance, a "beyond our prediction range" error will be returned.

### Prediction

* 4 types of regression will be done over the data, linear, polynomial, exponential, logarithmic. The one with the largest R-square value will be chosen as the best fit regression to calculate predictions.

* The predictions get more accurate when there are more past data.

