import kns

# Raises the "coming_home" event, which is handled by the ruleset
result = kns.raise_event("future", "coming_home", "a163x128", {}, None, True)
print result
