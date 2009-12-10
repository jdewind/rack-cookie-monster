require 'spec_helper'
require 'rack_cookie_monster'
require 'action_controller'

describe Rack::CookieMonster do  
  subject { Class.new(described_class) }
  
  describe ".configure" do
    
    it "specifies what cookies are to be eaten" do
      subject.configure do |c|
        c.eat :_session_id
        c.eat :user_credentials
      end
      
      subject.cookies.should == [:_session_id, :user_credentials]
    end
    
    it "turns the cookie keys into symbols" do
      subject.configure do |c|
        c.eat "burt"
      end
      
      subject.cookies.should == [:burt]      
    end
    
    it "specifies what user agents can snack" do
      subject.configure do |c|
        c.share_with "MSIE 6.0"
        c.share_with /safari \d+/
      end
      
      subject.snackers.should == ["MSIE 6.0", /safari \d+/]
    end
    
    it "raises an error if it is not configured" do
      lambda { subject.cookies }.should raise_error(Rack::CookieMonster::Hungry, /not been configured/i)
      lambda { subject.snackers }.should raise_error(Rack::CookieMonster::Hungry, /not been configured/i)
      lambda { subject.configure_for_rails }.should raise_error(Rack::CookieMonster::Hungry, /not been configured/i)
    end
  end
  
  describe ".configure_for_rails" do
    it "injects itself into the rails request stack" do
      subject.configure {}
      subject.configure_for_rails
      ActionController::Dispatcher.middleware[2].should == subject
      ActionController::Dispatcher.middleware[3].should == ActionController::Session::CookieStore
    end
  end
  
  describe "#call" do
    before do
      @target = subject.new(stub_instance(:app))
      @environment = {
        "HTTP_COOKIE" => "",
        "QUERY_STRING" => "oatmeal_cookie=delicious&chocolate_cookie=yummy",
        "REQUEST_METHOD" => "PUT"
      }
      
      subject.configure do |c|
        c.eat :oatmeal_cookie
        c.eat :chocolate_cookie
      end
    end
    
    it "builds cookie string from environment params" do
      @app.expects(:call).with do |env|
        env["HTTP_COOKIE"].should == "chocolate_cookie=yummy; oatmeal_cookie=delicious"
        env["HTTP_COOKIE"].should be_frozen
      end
      
      @target.call(@environment)
    end
    
    it "will play nice with existing cookies" do
      @environment["HTTP_COOKIE"] = "oatmeal_cookie=gross; peanutbutter_cookie=good"
      
      @app.expects(:call).with do |env|
        env["HTTP_COOKIE"].should == "peanutbutter_cookie=good; chocolate_cookie=yummy; oatmeal_cookie=gross"        
      end
      
      @target.call(@environment)
    end
    
    it "will not append an empty cookie" do
      @environment["QUERY_STRING"] = ""
      @app.expects(:call).with do |env|
        env["HTTP_COOKIE"].should == ""
        env["HTTP_COOKIE"].should be_frozen
      end
      
      @target.call(@environment)
    end
    
    describe "optional user agents" do
      before do
        subject.configure do |c|
          c.share_with /^(Adobe|Shockwave) Flash/
          c.share_with "MSIE 6.0"
        end        
      end
      
      it "will match against regular expressions" do
        @app.expects(:call).twice
        
        @environment["HTTP_USER_AGENT"] = "Shockwave Flash"
        @target.call(@environment)
        @environment["HTTP_USER_AGENT"] = "Adobe Flash"
        @target.call(@environment)
        @environment["HTTP_USER_AGENT"] = "Flash"
        @target.call(@environment)
      end
      
      it "will exact match against strings" do
        @app.expects(:call).once
        
        @environment["HTTP_USER_AGENT"] = "MSIE 6.0"
        @target.call(@environment)
        @environment["HTTP_USER_AGENT"] = "MSIE"
        @target.call(@environment)
      end
      
    end
  end
end
