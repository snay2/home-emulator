require 'sinatra'

# Default values for the state
set :thermostat, 75
set :stereo_volume, 0

# Set the temperature of the thermostat
get '/thermostat/:temp' do
    temp = params[:temp].to_i
    if temp >= 65 and temp <= 85 then
        puts "Thermostat now #{temp}. Was #{settings.thermostat}."
        set :thermostat, temp
    end
    return '{"temperature": #{settings.thermostat}}'
end

# Set the volume of the stereo
get '/stereo_volume/:level' do
    level = params[:level].to_i
    if level >= 0 and level <= 25 then
        puts "Stereo level now #{level}. Was #{settings.stereo_volume}."
        set :stereo_volume, level
    end
    return '{"stereo_volume": #{settings.stereo_volume}}'
end

