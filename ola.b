use("kyuuji")
use("settei")

def greeting(s, who)
  subject = if who == nil || who == ""
    settei::setting(s, "subject")
  else
    who
  end
  text = "#{settei::setting(s, "greeting")}, #{subject}!"
  if settei::flag(s, "shout")
    upcase(text)
  else
    text
  end
end

def handle(s, req)
  if get(req, :path) == "/" && get(req, :method) == "GET"
    kyuuji::text(200, "#{greeting(s, kyuuji::query_param(req, "who"))}\n")
  else
    kyuuji::not_found(req)
  end
end

if settei::serving?()
  s = settei::current()
  kyuuji::serve_settings(s, fn(req) handle(s, req) end)
end

def settings(shout)
  {"greeting" => "Olá", "subject" => "mundo", "flags" => {"shout" => shout}}
end

test "the root greets the configured subject"
  r = handle(settings(false), kyuuji::request("GET", "/", ""))
  assert get(r, :status) == 200
  assert get(r, :body) == "Olá, mundo!\n"
end

test "a who parameter is greeted instead, and an empty one is not"
  assert greeting(settings(false), "ryn") == "Olá, ryn!"
  assert greeting(settings(false), "") == "Olá, mundo!"
end

test "the shout flag turns the greeting up"
  assert greeting(settings(true), nil) == "OLÁ, MUNDO!"
end

test "only GET / is a route"
  assert get(
    handle(settings(false), kyuuji::request("POST", "/", "")),
    :status
  ) ==
    404
  assert get(
    handle(settings(false), kyuuji::request("GET", "/x", "")),
    :status
  ) ==
    404
end
