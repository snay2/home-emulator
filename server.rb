require 'sinatra'

# Default values for the state
set :thermostat, 75
set :media_volume, 0
set :light_level, 10
set :media_state, 'stop'

# Temperature of the thermostat
get '/thermostat/:temp' do
    temp = params[:temp].to_i
    if temp >= 65 and temp <= 85 then
        puts "Thermostat now #{temp}. Was #{settings.thermostat}."
        set :thermostat, temp
    end
    return "{\"temperature\": #{settings.thermostat}}"
end
get '/thermostat' do
    return "{\"temperature\": #{settings.thermostat}}"
end

# Volume of the sound system
get '/media_volume/:level' do
    level = params[:level].to_i
    if level >= 0 and level <= 25 then
        puts "Sound system volume now #{level}. Was #{settings.media_volume}."
        set :media_volume, level
    end
    return "{\"media_volume\": #{settings.media_volume}}"
end
get '/media_volume' do
    return "{\"media_volume\": #{settings.media_volume}}"
end

# Media state (DVD player, stereo, etc.)
get '/media_state/:state' do
    state = params[:state]
    if state == "play" or state == "pause" or state == "stop" then
        puts "Media state is now #{state}. Was #{settings.media_state}."
        set :media_state, state
    end
    return "{\"media_state\": \"#{settings.media_state}\"}"
end
get '/media_state' do
    return "{\"media_state\": \"#{settings.media_state}\"}"
end

# Light level
get '/light_level/:level' do
    level = params[:level].to_i
    if level >= 0 and level <= 10 then
        puts "Light level now #{level}. Was #{settings.light_level}."
        set :light_level, level
    end
    return "{\"light_level\": #{settings.light_level}}"
end
get '/light_level' do
    return "{\"light_level\": #{settings.light_level}}"
end
