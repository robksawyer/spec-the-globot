# Description
#   whatthefuckshouldimakefordinner.com scrapes for Hubot
#
# Configuration:
#   none
#
# Dependencies:
#   "cheerio": "~0.16.0"
#
# Commands:
#   dinner? - returns a random dinner suggestion (with link)
#
# Author:
#   nickfletcher

cheerio = require 'cheerio'

module.exports = (robot) ->
  robot.hear /^(dinner\?)$/i, (msg) ->
    robot.http("http://whatthefuckshouldimakefordinner.com/veg.php")
      .get() (err, res, body) ->
        $ = cheerio.load(body)
        action = $('dt dl').first().text()
        meal = $('dl dt a').text()
        link = $('dl dt a').attr('href')
        dinner = action + " " + meal + " " + "(" + link + ")"

        msg.send dinner