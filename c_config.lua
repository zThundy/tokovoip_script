TokoVoipConfig = {
	refreshRate = 150, -- Rate at which the data is sent to the TSPlugin
	networkRefreshRate = 2000, -- Rate at which the network data is updated/reset on the local ped
	playerListRefreshRate = 5000, -- Rate at which the playerList is updated
	minVersion = "1.5.0", -- Version of the TS plugin required to play on the server
	enableDebug = false, -- Enable or disable tokovoip debug (Shift+9)

	distance = {
		15, -- Normal speech distance in gta distance units
		5, -- Whisper speech distance in gta distance units
		40, -- Shout speech distance in gta distance units
	},
	headingType = 0, -- headingType 0 uses GetGameplayCamRot, basing heading on the camera's heading, to match how other GTA sounds work. headingType 1 uses GetEntityHeading which is based on the character's direction
	radioKey = Keys["CAPS"], -- Keybind used to talk on the radio
	keySwitchChannels = Keys["L"], -- Keybind used to switch the radio channels
	keySwitchChannelsSecondary = Keys["LEFTSHIFT"], -- If set, both the keySwitchChannels and keySwitchChannelsSecondary keybinds must be pressed to switch the radio channels
	keyProximity = Keys["L"], -- Keybind used to switch the proximity mode
	radioClickMaxChannel = 400, -- Set the max amount of radio channels that will have local radio clicks enabled
	radioAnim = true, -- Enable or disable the radio animation
	radioEnabled = true, -- Enable or disable using the radio
	wsServer = "ADD_WS_SERVER_HERE", -- Address of the websocket server

	plugin_data = {
		-- The following is purely TS client settings, to match tastes
		local_click_on = false, -- Is local click on sound active
		local_click_off = false, -- Is local click off sound active
		remote_click_on = false, -- Is remote click on sound active
		remote_click_off = false, -- Is remote click off sound active
		enableStereoAudio = true, -- If set to true, positional audio will be stereo (you can hear people more on the left or the right around you)
		-- ClickVolume = -15, -- Set the radio clicks volume, -15 is a good default

		localName = "USER", -- If set, this name will be used as the user's teamspeak display name
		localNamePrefix = "[" .. GetPlayerServerId(PlayerId()) .. "] ", -- If set, this prefix will be added to the user's teamspeak display name
	}
};

-- Update config properties from another script
function SetTokoProperty(key, value)
	if TokoVoipConfig[key] ~= nil and TokoVoipConfig[key] ~= "plugin_data" then
		TokoVoipConfig[key] = value

		if voip then
			if voip.config then
				if voip.config[key] ~= nil then
					voip.config[key] = value
				end
			end
		end
	end
end

-- Make exports available on first tick
exports("SetTokoProperty", SetTokoProperty)
