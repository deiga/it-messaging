require 'xmpp4r'
include Jabber

class ItMessaging < Sinatra::Base

  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader
    Jabber::debug = true
  end

  get '/' do
    client = Client.new(JID::new("test","guinevere.local","itm"))
    client.connect
    client.auth("tester")
    # client.auth_anonymous
    client.send(Presence.new.set_type(:available))

    client.close
  end

end
