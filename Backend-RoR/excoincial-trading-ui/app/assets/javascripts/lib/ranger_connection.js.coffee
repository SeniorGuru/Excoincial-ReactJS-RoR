stream = ['global',"#{gon.market.id}", 'order', 'trade', 'account']
query = {stream: stream}
ranger_scheme = if gon.ranger_connect_secure == "true" then "wss://" else "ws://"
ranger_address =  "#{ranger_scheme}#{gon.ranger_host}:#{gon.ranger_port}?" + $.param(query, true)
barongPath = "//#{gon.barong_domain}" + "/users/api/v1/sessions/jwt"
window.ranger = new RangerWebSocket ranger_address
if gon.user
  ranger.bind 'open', ->
    console.info 'Connection to Ranger has been established'
    $.ajax({
      type: "POST",
      url: barongPath,
      async: true,
      xhrFields: {
        withCredentials: true
      },
      success: (res) ->
        console.info 'Solving authorization challenge by sending JWT token'
        ranger.send JSON.stringify {jwt: "Bearer #{res}"}
    })

  ranger.bind 'close', ->
    console.warn 'Ranger connection fishied via bad network, try reconnect'
    ranger.connect()

ranger.connect()
