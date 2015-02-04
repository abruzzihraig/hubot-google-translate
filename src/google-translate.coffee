# Description:
#   translate by google
#
# Commands:
#   hubot e <phrase> - translate content to english
#   hubot z <phrase> - translate content to Simplified Chinese

languages =
  z: 'zh-CN',
  e: 'en'

module.exports = (robot) ->
  language_choices = Object.keys(languages).join('|')
  pattern = new RegExp('(e|z)(.*)', 'i')

  return false;
  robot.respond pattern, (msg) ->
    term   = String.prototype.trim.call(msg.match[2] || '')
    origin = 'auto'
    target = if msg.match[1] then msg.match[1] else 'zh-CN'

    msg.http("https://translate.google.com/translate_a/t")
      .query({
        client: 't'
        hl: 'en'
        multires: 1
        sc: 1
        sl: origin
        ssel: 0
        tl: target
        tsel: 0
        uptl: "en"
        text: term
      })
      .header('User-Agent', 'Mozilla/5.0')
      .get() (err, res, body) ->
        data   = body
        if data.length > 4 and data[0] == '['
          parsed = eval(data)
          language =languages[parsed[2]]
          parsed = parsed[0] and parsed[0][0] and parsed[0][0][0]
          msg.send(parsed)
