require 'xmpp4r'
include Jabber

class ItMessaging < Sinatra::Base

  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader
    Jabber::debug = true
  end

  configure do
    set :jid, JID::new("test","guinevere.local","itm")
    @@xmpp = Client.new(settings.jid)
    @@xmpp.connect
    @@xmpp.auth("tester")

    @@messages_times = []

    @@xmpp.add_message_callback do |m|
      delay_elem = m.first_element('delay')
      tstamp = delay_elem.attribute('stamp').to_s unless delay_elem.nil?
      time = (tstamp.nil? || tstamp.empty?) ? Time.new : Time.parse(tstamp)
      @@messages_times << {message: m, time: time.to_time}
    end
    @@xmpp.send(Presence.new.set_type(:available))
    sleep 5
  end


  get '/' do
    @messages_times = @@messages_times
    haml :index
  end

  post '/send' do
    m = Message.new(JID::new(params[:nick], 'guinevere.local'), params[:message])
    @@xmpp.send(m)

    redirect to '/'
  end

end
