ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent("ps_pizza:gettip")
AddEventHandler("ps_pizza:gettip", function(money)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addAccountMoney("money", money)
end)

RegisterServerEvent("ps_pizza:getreward")
AddEventHandler("ps_pizza:getreward", function(reward)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addAccountMoney("money", reward)
    local text = string.format(Translation[Config.Locale]['webhook_done_job'], reward)
    webhook_pizza(text)
end)

function webhook_pizza(text)
    local xPlayer = ESX.GetPlayerFromId(source)
    local webhook = Config.Webhook
	local information = {
		{
			["color"] = '6684876',
			["author"] = {
				["icon_url"] = 'https://i.ibb.co/DgtFmvr6/ps-logo-1-circle.png',
				["url"] = 'https://discord.com/invite/CUXK7CWx3P',
				["name"] = 'Phoenix Studios',
			},
			
			['url'] = 'https://github.com/xrisingphoenix/ps_pizzadelivery',
			["title"] = 'Pizza Job',
	
			["description"] = text,
	
			["footer"] = {
				["text"] = os.date('%d/%m/%Y [%X] • PHOENIX STUDIOS'),
				["icon_url"] = 'https://i.ibb.co/60rCYFmk/logo2.png',
			}
		}
	}
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = 'PHOENIX STUDIOS', embeds = information, avatar_url = 'https://i.ibb.co/mV504dFz/ps-logo-2-circle.png' }), {['Content-Type'] = 'application/json'}) 
end

