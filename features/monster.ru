class CookieMonsterApplication
  def call(env)
    cookies = ::Rack::Request.new(env).cookies
    res = ::Rack::Response.new
    res.write %{
      <html>
        <head>
          <title>Form</title>
        </head>
        <body>
          #{env["HTTP_USER_AGENT"]}
          <form action="/" method="post">
            Cookie 1: <input type="text" name="cookie_1" />
            Cookie 2: <input type="text" name="cookie_2" />
            Non Cookie: <input type="text" name="non_cookie" />
            <input type="submit" value="Submit" />
          </form>
        </body>
        #{
          cookies.map do |k,v|
            "<p>#{k} - #{v}</p>"
          end.join("\n")
        }
      </html>
    }
    res.finish
  end
end

Rack::CookieMonster.configure do |c|
  c.eat :cookie_1
  c.eat :cookie_2
  c.share_with /firefox/i
end

use Rack::CookieMonster
run CookieMonsterApplication.new