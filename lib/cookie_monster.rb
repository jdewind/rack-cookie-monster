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
      params = ::Rack::Request.new(env).params
      env["HTTP_COOKIE"] = build_cookie_string(params)
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
  
  def build_cookie_string(params)
    self.class.cookies.map { |cookie_name| 
      value = params[cookie_name.to_s]
      "#{cookie_name}=#{value}" if value
    }.compact.join("; ").freeze
  end
  
end