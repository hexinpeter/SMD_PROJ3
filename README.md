# SMD_PROJ3

Team,44

hex1,He	Xin,625282

soc1,Chen,Bill,617292

tangw1,Tang,Wen Zhe,633818

Submitted as SMD project 3 part 2

Github Link: [https://github.com/hexinpeter/SMD_PROJ3](https://github.com/hexinpeter/SMD_PROJ3)


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


## Algorithm
### When the specified location is not in our database

* The cloesest postal area is found, and the weather prediction of that area is returned.
* The closest postal area is found by calculating the sum of difference in lat and long between the given location and every registered locations in database; the location with the smallest difference is returned.
* When the sum of difference exceeds 1, approximately 100km in distance, a "beyond our prediction range" error will be returned.

### Prediction

* 4 types of regression will be done over the data, linear, polynomial, exponential, logarithmic. The one with the largest R-square value will be chosen as the best fit regression to calculate predictions.

* The predictions get more accurate when the app is left to run for a longer time with recurring task set up.


## Change Data Retrieving Frequency

* Change the `FREQUENCY` variable in `config/schedule.rb`
* Change the number of locations available by changing the `POST_CODE_GAP` in `db/seeds.rb`


## Multi-timezone Support

* every time instance must be saved to the db with a timezone attached to it
* `config/application.rb` sets the default timezone to be Melbourne (UTC +10), i.e. every time instance is converted to Melb timezone before saving by Active Record


## Note of Team Contribution

Though from the commit history, it may appear that one person did most of the commits, this is mainly because that one person is more familiar with Rails than the rest. The other two have contributed as much as they can and learnt a lot in the process, they are also the main contributers for the reflection report. We often sit together and worked together as a team, each individual of us has put in roughly the same amount of time in this project. All in all, we had a good time working together.
