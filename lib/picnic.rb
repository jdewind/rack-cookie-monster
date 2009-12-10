class Picnic
  attr_reader :cookies, :snackers
  
  def initialize
    @cookies = []
    @snackers = []
  end
  
  def eat(cookie)
    @cookies << cookie
  end
  
  def share_with(snacker)
    @snackers << snacker
  end
end