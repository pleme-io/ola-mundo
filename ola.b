use("kyuuji")
use("settei")
use("teeburu")

def greeting(s, who)
  subject = if who.nil? or who == ""
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

def recorded(s, text)
  if teeburu::enabled?(s)
    c = teeburu::open(s)
    row = teeburu::insert(c, "greetings", {"text" => text})
    pg_close(c)
    "#{text} (greeting #{to_s(get(row, "id"))})"
  else
    text
  end
end

def latest(s)
  c = teeburu::open(s)
  rows = teeburu::latest(c, "greetings", 5)
  pg_close(c)
  map(
    fn(r)
      {
        "id" => get(r, "id"),
        "text" => get(r, "text"),
        "created_at" => get(r, "created_at")
      }
    end,
    rows
  )
end

def handle(s, req)
  path = get(req, :path)
  if get(req, :method) != "GET"
    kyuuji::not_found(req)
  elsif path == "/"
    kyuuji::text(
      200,
      unlines([recorded(s, greeting(s, kyuuji::query_param(req, "who")))])
    )
  elsif path == "/greetings" and teeburu::enabled?(s)
    kyuuji::json(200, latest(s))
  else
    kyuuji::not_found(req)
  end
end

if settei::serving?
  s = settei::current
  kyuuji::serve_settings(s, (req) -> handle(s, req))
end

def settings(shout)
  {"greeting" => "Olá", "subject" => "mundo", "flags" => {"shout" => shout}}
end

test "the root greets the configured subject"
  r = handle(settings(false), kyuuji::request("GET", "/", ""))
  assert get(r, :status) == 200
  assert get(r, :body) == unlines(["Olá, mundo!"])
end

test "a who parameter is greeted instead, and an empty one is not"
  assert greeting(settings(false), "ryn") == "Olá, ryn!"
  assert greeting(settings(false), "") == "Olá, mundo!"
end

test "the shout flag turns the greeting up"
  assert greeting(settings(true), nil) == "OLÁ, MUNDO!"
end

test "without a database a greeting is not recorded and /greetings is not a route"
  assert recorded(settings(false), "Olá, mundo!") == "Olá, mundo!"
  assert get(
    handle(settings(false), kyuuji::request("GET", "/greetings", "")),
    :status
  ) == 404
end

test "only GET / is a route"
  assert get(
    handle(settings(false), kyuuji::request("POST", "/", "")),
    :status
  ) == 404
  assert get(
    handle(settings(false), kyuuji::request("GET", "/x", "")),
    :status
  ) == 404
end
