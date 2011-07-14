from bottle import route, run, debug

# Default values for the state
thermostat = 75
stereo_volume = 0

# Set the temperature of the thermostat
@route('/thermostat/:temp')
def get_temp(temp):
    temp = int(temp)
    global thermostat
    if temp >= 65 and temp <= 85:
        print "Thermostat now %s. Was %s." % (temp, thermostat)
        thermostat = temp
    return '{"temperature": %s}' % thermostat

# Set the volume of the stereo
@route('/stereo_volume/:level')
def set_volume(level):
    level = int(level)
    global stereo_volume
    if level >= 0 and level <= 25:
        print "Stereo level now %s. Was %s." % (level, stereo_volume)
        stereo_volume = level
    return '{"stereo_volume": %s}' % stereo_volume

# Run the server
debug(True)
run(host='localhost', port=8080, reloader=True)

