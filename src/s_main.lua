------------------------------------------------------------
------------------------------------------------------------
---- Author: Dylan 'Itokoyamato' Thuillier              ----
----                                                    ----
---- Email: itokoyamato@hotmail.fr                      ----
----                                                    ----
---- Resource: tokovoip_script                          ----
----                                                    ----
---- File: s_main.lua                                   ----
------------------------------------------------------------
------------------------------------------------------------

--------------------------------------------------------------------------------
--	Server: radio functions
--------------------------------------------------------------------------------

local channels = TokoVoipConfig.channels;
local serverId;

SetConvarReplicated("gametype", GetConvar("GameName"));

function addPlayerToRadio(channelId, playerServerId, radio)
	if (not channels[channelId]) then
		if(radio) then
			channels[channelId] = {id = channelId, name = channelId .. " Mhz", subscribers = {}};
		else
			channels[channelId] = {id = channelId, name = "Call with " .. channelId, subscribers = {}};
		end
	end
	if (not channels[channelId].id) then
		channels[channelId].id = channelId;
	end

	channels[channelId].subscribers[playerServerId] = playerServerId;
	-- print("Added [" .. playerServerId .. "] " .. (GetPlayerName(playerServerId) or "") .. " to channel " .. channelId);

	for _, subscriberServerId in pairs(channels[channelId].subscribers) do
		if (subscriberServerId ~= playerServerId) then
			TriggerClientEvent("TokoVoip:onPlayerJoinChannel", subscriberServerId, channelId, playerServerId);
		else
			-- Send whole channel data to new subscriber
			TriggerClientEvent("TokoVoip:onPlayerJoinChannel", subscriberServerId, channelId, playerServerId, channels[channelId]);
		end
	end
end
RegisterServerEvent("TokoVoip:addPlayerToRadio");
AddEventHandler("TokoVoip:addPlayerToRadio", addPlayerToRadio);

function removePlayerFromRadio(channelId, playerServerId)
	if (channels[channelId] and channels[channelId].subscribers[playerServerId]) then
		channels[channelId].subscribers[playerServerId] = nil;
		if (channelId > 100) then
			if (tablelength(channels[channelId].subscribers) == 0) then
				channels[channelId] = nil;
			end
		end
		-- print("Removed [" .. playerServerId .. "] " .. (GetPlayerName(playerServerId) or "") .. " from channel " .. channelId);

		-- Tell unsubscribed player he's left the channel as well
		TriggerClientEvent("TokoVoip:onPlayerLeaveChannel", playerServerId, channelId, playerServerId);

		-- Channel does not exist, no need to update anyone else
		if (not channels[channelId]) then return end

		for _, subscriberServerId in pairs(channels[channelId].subscribers) do
			TriggerClientEvent("TokoVoip:onPlayerLeaveChannel", subscriberServerId, channelId, playerServerId);
		end
	end
end
RegisterServerEvent("TokoVoip:removePlayerFromRadio");
AddEventHandler("TokoVoip:removePlayerFromRadio", removePlayerFromRadio);

function removePlayerFromAllRadio(playerServerId)
	for channelId, channel in pairs(channels) do
		if (channel.subscribers[playerServerId]) then
			removePlayerFromRadio(channelId, playerServerId);
		end
	end
end
RegisterServerEvent("TokoVoip:removePlayerFromAllRadio");
AddEventHandler("TokoVoip:removePlayerFromAllRadio", removePlayerFromAllRadio);

AddEventHandler("playerDropped", function()
	removePlayerFromAllRadio(source);
end);

function initTokovoip()
	-- print("init script")
	Citizen.Wait(1000)
	TriggerClientEvent("TokoVoip:initializeTokovoip", -1, TokoVoipConfig.plugin_data) -- Trigger this event whenever you want to start the voip
end

RegisterServerEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function()
	initTokovoip()
end)

Citizen.CreateThreadNow(initTokovoip)

--------------------------------------------------------------------------------
--	Server: phone functions
--------------------------------------------------------------------------------

local phoneChannels = {}

function addPlayerToPhone(channelId, playerServerId)
	if (not phoneChannels[channelId]) then
		phoneChannels[channelId] = {id = channelId, name = "Call with " .. channelId, subscribers = {}};
	end
	if (not phoneChannels[channelId].id) then
		phoneChannels[channelId].id = channelId;
	end

	phoneChannels[channelId].subscribers[playerServerId] = playerServerId;
	-- print("Added [" .. playerServerId .. "] " .. (GetPlayerName(playerServerId) or "") .. " to phone channel " .. channelId);

	for _, subscriberServerId in pairs(phoneChannels[channelId].subscribers) do
		if (subscriberServerId ~= playerServerId) then
			TriggerClientEvent("TokoVoip:onPlayerJoinPhoneChannel", subscriberServerId, channelId, playerServerId);
		else
			-- Send whole channel data to new subscriber
			TriggerClientEvent("TokoVoip:onPlayerJoinPhoneChannel", subscriberServerId, channelId, playerServerId, phoneChannels[channelId]);
		end
	end
end
RegisterServerEvent("TokoVoip:addPlayerToPhone");
AddEventHandler("TokoVoip:addPlayerToPhone", addPlayerToPhone);

function removePlayerFromPhone(channelId, playerServerId)
	if (phoneChannels[channelId] and phoneChannels[channelId].subscribers[playerServerId]) then
		phoneChannels[channelId].subscribers[playerServerId] = nil;
		if (channelId > 100) then
			if (tablelength(phoneChannels[channelId].subscribers) == 0) then
				phoneChannels[channelId] = nil;
			end
		end
		-- print("Removed [" .. playerServerId .. "] " .. (GetPlayerName(playerServerId) or "") .. " from phone channel " .. channelId);

		-- Tell unsubscribed player he's left the channel as well
		TriggerClientEvent("TokoVoip:onPlayerLeavePhoneChannel", playerServerId, channelId, playerServerId);

		-- Channel does not exist, no need to update anyone else
		if (not phoneChannels[channelId]) then return end

		for _, subscriberServerId in pairs(phoneChannels[channelId].subscribers) do
			TriggerClientEvent("TokoVoip:onPlayerLeavePhoneChannel", subscriberServerId, channelId, playerServerId);
		end
	end
end
RegisterServerEvent("TokoVoip:removePlayerFromPhone");
AddEventHandler("TokoVoip:removePlayerFromPhone", removePlayerFromPhone);

































function printChannels()
	for i, channel in pairs(channels) do
		RconPrint("Channel: " .. channel.name .. "\n");
		for j, player in pairs(channel.subscribers) do
			RconPrint("- [" .. player .. "] " .. GetPlayerName(player) .. "\n");
		end
	end
end

AddEventHandler('rconCommand', function(commandName, args)
	if commandName == 'voipChannels' then
		printChannels();
		CancelEvent();
	end
end)

function getServerId() TriggerClientEvent("TokoVoip:onClientGetServerId", source, serverId); end
RegisterServerEvent("TokoVoip:getServerId");
AddEventHandler("TokoVoip:getServerId", getServerId);

AddEventHandler("onResourceStart", function(resource)
	if (resource ~= GetCurrentResourceName()) then return end;
	serverId = randomString(32);
	print("TokoVOIP FiveM Server ID: " .. serverId);
end);
