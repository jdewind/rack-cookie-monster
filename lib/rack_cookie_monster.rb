module Rack
  class CookieMonster
    class<<self
      def configure
        @picnic ||= Picnic.new
        yield(@picnic)
      end
    
      def snackers
        @picnic.snackers
      end
    
      def cookies
        @picnic.cookies
      end
    end
  
    def initialize(app)
      @app = app
    end
  
    def call(env)
      shares_with(env["HTTP_USER_AGENT"]) do
        request = ::Rack::Request.new(env)
        env["HTTP_COOKIE"] = build_cookie_string(request)
        @app.call(env)      
      end
    end

    private
  
    def shares_with(agent)
      yield if self.class.snackers.empty?
    
      any_matches = self.class.snackers.any? do |snacker|
        case snacker
        when String
          snacker == agent
        when Regexp
          snacker.match(agent) != nil
        end
      end
    
      yield if any_matches
    end
  
    def build_cookie_string(request)
      cookies = request.cookies.dup
      new_cookies = {}
      
      self.class.cookies.each do |cookie_name| 
        value = request.params[cookie_name.to_s]
        if value
          cookies.delete(cookie_name)
          new_cookies[cookie_name.to_s] = value
        end
      end
      
      new_cookies.merge!(cookies)    
      new_cookies.map do |k,v|
        "#{k}=#{v}"
      end.compact.join("; ").freeze
    end
  
  end
end