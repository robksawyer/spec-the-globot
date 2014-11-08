#
#  Description:
#    Scripts that interact with the Bonus.ly service
#
#  Configuration:
#    BONUSLY_TOKEN - Your personal access token from https://bonus.ly/api
#
#  Commands:
#    spec values - Request the values via a command
#    company values - Whenever company values are mentioned, trigger the response
#

#
# Bonus.ly Values
#

module.exports = (robot) ->

  #
  # Values
  # Returns a list of the company values in bonus.ly 
  # 
  robot.hear /bonusly values|company values/i, (msg) ->

    robot.http("https://bonus.ly/api/v1/values?access_token=" + process.env.BONUSLY_TOKEN)
       .header('accept', 'application/json')
       .get() (err, res, body) -> 

          if err
            msg.send "Encountered an error :( #{err}"

          if res.statusCode isnt 200
            msg.send "Spec Global has lost its company values. Just kidding, something went wrong with the request."
          
          # if res.getHeader('Content-Type') isnt 'application/json'
          #   msg.send "Didn't get back JSON"

          # rateLimitRemaining = parseInt res.getHeader('X-RateLimit-Limit') if res.getHeader('X-RateLimit-Limit')
          # if rateLimitRemaining and rateLimitRemaining < 1
          #   msg.send "Bonus.ly rate limit hit, just practice every value you can think of right now."

          data = JSON.parse(body) if body

          if data
            values = ""
            for result in data.result
              values += result.name + "\n"

            msg.send "The Spec Global team really appreciates and rewards the following values: \n #{values}"
  
  #
  # Leaderboard
  # Returns a list of the person with the most gives and receives on bonus.ly
  # 
  robot.hear /bonusly leaders|leaders/i, (msg) -> 

    giver = receiver = ""

    # Gather the giver results
    robot.http("https://bonus.ly/api/v1/leaderboards/count?access_token=" + process.env.BONUSLY_TOKEN + "&role=giver")
       .header('accept', 'application/json')
       .get() (err, res, body) -> 
          if err
            msg.send "Encountered an error :( #{err}"

          if res.statusCode isnt 200
            msg.send "Spec Global has lost its company values. Just kidding, something went wrong with the request."


          g_data = JSON.parse(body) if body
          
          if not g_data
            msg.send("I was unable to find a leading giver.")

          giver = g_data.result[0].user.short_name + " is the leading giver of sweat equity with " + g_data.result[0].count + " point(s)."
          msg.send( giver )

    # Gather the receiver results
    robot.http("https://bonus.ly/api/v1/leaderboards/count?access_token=" + process.env.BONUSLY_TOKEN + "&role=receiver")
       .header('accept', 'application/json')
       .get() (err, res, body) -> 
          if err
            msg.send "Encountered an error :( #{err}"

          if res.statusCode isnt 200
            msg.send "Spec Global has lost its company values. Just kidding, something went wrong with the request."

          r_data = JSON.parse(body) if body

          if not r_data
            msg.send("I was unable to find a leading receiver.")

          receiver = r_data.result[0].user.short_name + " is the leading receiver with " + r_data.result[0].count + " sweat equity point(s)."
          msg.send( receiver )

  #
  # Leaderboard
  # Returns a list of the person with the most gives and receives on bonus.ly
  # 
  robot.hear /sweatin(.*)/i, (msg) -> 
    robot.http("https://bonus.ly/api/v1/bonuses?access_token=" + process.env.BONUSLY_TOKEN + "&limit=10")
       .header('accept', 'application/json')
       .get() (err, res, body) -> 
          if err
            msg.send "Encountered an error :( #{err}"

          if res.statusCode isnt 200
            msg.send "Spec Global has lost its company values. Just kidding, something went wrong with the request."


          data = JSON.parse(body) if body
          
          if not data
            msg.send("I was unable to find any sweat equity points.")

          if data
            bonuses = ""
            for result in data.result
              bonuses += "#{result.giver.short_name} gave 💦 #{result.amount} equity point(s) to #{result.receiver.short_name} #{result.reason}\n"

            msg.send "The following is a list of the latest 10 sweat equity points given:\n#{bonuses}"



  
