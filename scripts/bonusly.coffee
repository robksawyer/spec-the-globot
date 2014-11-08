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

  robot.hear /values/i, (msg) ->

    robot.http("https://bonus.ly/api/v1/values?access_token=" + process.env.BONUSLY_TOKEN)
       .header('accept', 'application/json')
       .get() (err, res, body) -> 

          if err
            msg.send "Encountered an error :( #{err}"

          msg.send(res)

          if res.statusCode isnt 200
            msg.send "Spec Global has lost its company values. Just kidding, something went wrong with the request."
          
          # if res.getHeader('Content-Type') isnt 'application/json'
          #   msg.send "Didn't get back JSON"

          # rateLimitRemaining = parseInt res.getHeader('X-RateLimit-Limit') if res.getHeader('X-RateLimit-Limit')
          # if rateLimitRemaining and rateLimitRemaining < 1
          #   msg.send "Bonus.ly rate limit hit, just practice every value you can think of right now."

          data = JSON.parse(body) if body
          
          msg.send(data.result)

          if data
            values = ""
            for result in data.result
              values += result.name + "\n"

            msg.send "The Spec Global team really appreciates and rewards the following values: \n #{values}"
