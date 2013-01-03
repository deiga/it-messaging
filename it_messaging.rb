require 'xmpp4r'
require 'xmpp4r/muc'
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

    muc = MUC::SimpleMUCClient.new(client)
    muc.on_message do |time,nick,text|
      puts (time || Time.new).strftime('%I:%M') + " <#{nick}> #{text}"
    end
    muc.join(JID::new('itm@conference.guinevere.local/ITM-Bot'))
    muc.say('Foo')
    client.close
    "Successfull"
  end

end
