ruleset a163x128 {
	meta {
		name "Home automation emulator"
		description <<
			Ruleset to handle the events and directives for the home-emulator project
		>>
		author "Steve Nay and Reed Allred"
		logging off
        
        use module a8x157 alias webhook
	}

	dispatch {}

	global {
        set_thermostat = defaction(temp) {
            http:get(app:tunnel + "thermostat/#{temp}");
        };
        get_thermostat = function() {
            http:get(app:tunnel + "thermostat").pick("content").decode().pick("temperature");
        };

        set_volume = defaction(level) {
            http:get(app:tunnel + "media_volume/#{level}");
        };
        get_volume = function() {
            http:get(app:tunnel + "media_volume").pick("content").decode().pick("media_volume");
        };
        
        set_light_level = defaction(level) {
            http:get(app:tunnel + "light_level/#{level}");
        };
        get_light_level = function() {
            http:get(app:tunnel + "light_level").pick("content").decode().pick("light_level");
        };
        
        set_media_state = defaction(state) {
            http:get(app:tunnel + "media_state/#{state}");
        };
        get_media_state = function() {
            http:get(app:tunnel + "media_state").pick("content").decode().pick("media_state");
        };
	}
    
    // This works dynamically with my forked version of localtunnel so that the ruleset is notified
    // each time the tunnel URL changes.
    rule set_tunnel {
        select when webhook set_tunnel
        pre {
            tunnel = "http://" + event:param("tunnel") + "/";
        }
        webhook:text(tunnel);
        fired {
            set app:tunnel tunnel;
        }
    }

    rule test {
        select when pageview ".*"
        pre {
            temperature = get_thermostat();
            volume = get_volume();
            light_level = get_light_level();
            media_state = get_media_state();
            msg = <<
                <strong>Temperature:</strong> #{temperature}<br />
                <strong>Volume:</strong> #{volume}<br />
                <strong>Light level:</strong> #{light_level}<br />
                <strong>Media state:</strong> #{media_state}<br />
            >>;
        }
        notify("Current home state", msg) with sticky=true;
    }
    
	rule set_thermostat {
		select when pageview "ktest.heroku.com/a163x128/temp/(\d{2})" setting (temp)
		set_thermostat(temp);
	}
    
    rule set_volume {
        select when pageview "ktest.heroku.com/a163x128/volume/(\d+)" setting (level)
        set_volume(level);
    }
    
    rule coming_home {
        select when location nearing_home
        {
            set_thermostat(74);
            set_volume(10);
        }
    }
    
    rule incoming_call {
        select when phone incoming_call
        pre {
            media_state = get_media_state();
            new_media_state = (media_state eq "play") => "pause" | media_state;
            light_level = get_light_level();
            new_light_level = (light_level <= 8) => 8 | light_level;
        }
        {
            set_media_state(new_media_state);
            set_light_level(new_light_level);
        }
        fired {
            set app:prev_media_state media_state;
            set app:prev_light_level light_level;
        }
    }
    
    rule call_finished {
        select when phone hung_up
        {
            set_media_state(app:restore_media_state);
            set_light_level(app:prev_light_level);
        }
        fired {
            clear app:prev_media_state;
            clear app:prev_light_level;
        }
    }
}
