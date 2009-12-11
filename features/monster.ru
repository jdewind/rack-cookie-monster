class CookieMonsterApplication
  def call(env)
    request = ::Rack::Request.new(env)
    cookies = request.cookies
    params = request.params
    
    res = ::Rack::Response.new
    res.write %{
      <html>
        <head>
          <title>Form</title>
        </head>
        <body>
          <p>#{env.inspect}</p>
          <form action="/" method="post">
            Cookie 1: <input type="text" name="cookie_1" />
            Cookie 2: <input type="text" name="cookie_2" />
            Non Cookie: <input type="text" name="non_cookie" />
            <input type="submit" value="Submit" />
          </form>
          <div id="cookies">
          #{
            cookies.map do |k,v|
              "<p>#{k} - #{v}</p>"
            end.join("\n")
          }
          </div>
          <div id="params">
          #{
            params.map do |k,v|
              "<p>#{k} - #{v}</p>"
            end.join("\n")        
          }
          </div>
        </body>
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