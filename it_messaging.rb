require 'xmpp4r'
include Jabber

class ItMessaging < Sinatra::Base

  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader
    Jabber::debug = true
  end

  get '/' do
    client = Client.new(JID::new("test@guinevere.local/it-messaging"))
    client.connect
    client.auth("tester")
  end

end
