#####################################################
# KNS-Python
#
# A library for building Python endpoints to the
# Kinetic Event Architecture system. Provides a
# method for raising events and handling directives.
#####################################################

import urllib, urllib2, json, string

server = "http://cs.kobj.net/blue/"
event_url = server + "event"

# Raises an event in the given domain to the specified ruleset.
# If dev=True, the event is raised to the dev version of the ruleset.
def raise_event(domain, event, ruleset, params, callback, dev=False):
    # Build the URL
    is_dev = "%s:kynetx_app_version=dev" % ruleset if dev else ""
    param_str = urllib.urlencode(params);
    url = "%s/%s/%s/%s?%s&%s" % (event_url, domain, event, ruleset, is_dev, param_str)
    # Raise the event
    handle = urllib2.urlopen(url);
    str = handle.read()
    response = get_json(str)
    # Handle directives, return full response
    handle_directives(response, callback)
    return response

# Iterates over the directives returned, calling the callback function
# for each and passing along the options accompanying that directive
def handle_directives(response, callback):
    # Call the callback for each directive
    for directive in response["directives"]:
        callback(directive["name"], directive["options"])

# Removes KNS comments from the top of the document, getting only
# the JSON at the bottom
def get_json(input):
    # Strip comments
    lines = input.split("\n")
    just_json = ""
    for line in lines:
        if line[:2] != "//":
            just_json += line
    # Parse JSON
    return json.loads(just_json)

