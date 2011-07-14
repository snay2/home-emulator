# Home-Emulator
A home automation emulator that uses the Kinetic Event Architecture model for raising and responding to events. Uses the `kns-python` project.

# Example invocation
- Run the server on a dev machine with the command `ruby -rubygems server.rb`. Requires Sinatra to be installed.
- Set up a localtunnel (see http://www.twilio.com/engineering/2011/06/06/making-a-local-web-server-public-with-localtunnel/) to forward port 4567 so it's publicly accessible to KNS: `localtunnel 4567`
- Run `raise-events.py`. This will raise the `coming_home` event to KNS. The ruleset responds with two directives to the server. You should see these reflected in the Sinatra log.

