ruleset a163x128 {
	meta {
		name "Home automation emulator"
		description <<
			Ruleset to handle the events and directives for the home-emulator project
		>>
		author "Steve Nay and Reed Allred"
		logging off
	}

	dispatch {}

	global {
        tunnel = "http://4kkb.localtunnel.com/";
        
        set_thermostat = defaction(temp) {
            http:get(tunnel + "thermostat/#{temp}");
        };

        set_volume = defaction(level) {
            http:get(tunnel + "stereo_volume/#{level}");
        };
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
        select when future coming_home
        {
            set_thermostat(74);
            set_volume(10);
        }
    }
}
