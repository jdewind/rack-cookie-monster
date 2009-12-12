module Rack
  class CookieMonster
    
    class Hungry < StandardError; end    
    
    class<<self
      def configure
        @picnic ||= CookieMonsterConfig.new
        yield(@picnic)
        @configured = true
      end
    
      def snackers
        ensure_monster_configured!
        @picnic.snackers
      end
    
      def cookies
        ensure_monster_configured!
        @picnic.cookies
      end
      
      def configure_for_rails
        ensure_monster_configured!
        ActionController::Dispatcher.middleware.insert_before(
          ActionController::Base.session_store,
          self
        )
      end
      
      private
      
      def ensure_monster_configured!
        raise Hungry.new("Cookie Monster has not been configured") unless @configured
      end
      
    end
    
    def initialize(app)
      @app = app
    end
  
    def call(env)
      shares_with(env["HTTP_USER_AGENT"]) do
        request = ::Rack::Request.new(env)
        eat_cookies!(env, request)
      end
      @app.call(env)
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
  
    def eat_cookies!(env, request)
      cookies = request.cookies
      new_cookies = {}
      
      self.class.cookies.each do |cookie_name| 
        value = request.params[cookie_name.to_s]
        if value
          cookies.delete(cookie_name.to_s)
          new_cookies[cookie_name.to_s] = value
        end
      end
      
      new_cookies.merge!(cookies)    
      env["HTTP_COOKIE"] = new_cookies.map do |k,v|
        "#{k}=#{v}"
      end.compact.join("; ").freeze
    end
  
  end
  
  class CookieMonsterConfig
    attr_reader :cookies, :snackers

    def initialize
      @cookies = []
      @snackers = []
    end

    def eat(cookie)
      @cookies << cookie.to_sym
    end

    def share_with(snacker)
      @snackers << snacker
    end
  end
end