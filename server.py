from bottle import route, run, debug

thermostat = 75

@route('/thermostat/:temp')
def adjust_temp(temp):
    temp = int(temp)
    thermostat = 0
    if temp >= 65 and temp <= 85:
        print "Thermostat now %s. Was %s." % (temp, thermostat)
        thermostat = temp
    return '{"temperature": %s}' % thermostat

debug(True)
run(host='localhost', port=8080, reloader=True)

