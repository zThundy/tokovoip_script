TokoVoipConfig = {
	channels = {
		{name = "PD Radio", subscribers = {}},
		{name = "EMS Radio", subscribers = {}},
		{name = "PD/SO/EMS Shared Radio", subscribers = {}},
		{name = "SO Radio", subscribers = {}},
		{name = "PD/SO Shared Radio", subscribers = {}}
	},
	plugin_data = {
		-- TeamSpeak channel name used by the voip	
		-- If the TSChannelWait is enabled, players who are currently in TSChannelWait will be automatically moved	
		-- to the TSChannel once everything is running	
		TSChannel = "ADD_CHANNEL_NAME_HERE",	
		TSPassword = "ADD_CHANNEL_PASSWORD_HERE", -- TeamSpeak channel password (can be empty)	

		-- Optional: TeamSpeak waiting channel name, players wait in this channel and will be moved to the TSChannel automatically	
		-- If the TSChannel is public and people can join directly, you can leave this empty and not use the auto-move	
		TSChannelWait = "ADD_HUB_CHANNEL_NAME_HERE",	

		-- Blocking screen informations	
		TSServer = "ADD_TS_IP_HERE", -- TeamSpeak server address to be displayed on blocking screen	
		TSChannelSupport = "ADD_CHANNEL_SUPPORT_NAME_HERE", -- TeamSpeak support channel name displayed on blocking screen	
		TSDownload = "https://github.com/Itokoyamato/TokoVOIP_TS3/releases", -- Download link displayed on blocking screen	
		TSChannelWhitelist = { -- Black screen will not be displayed when users are in those TS channels	
			"Support 1",	
			"Support 2",	
		},
	}
};
