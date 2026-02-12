local ScriptInformation = require("@Shared/Constants/ScriptInformation")
local UserInformation = require("@Shared/Constants/UserInformation")

local WebhookManager = {}

function WebhookManager.send(embedData: {title: string, content : string | nil, description: string?})
    LRM_SEND_WEBHOOK("lolz", {
        content = embedData.content,
        embeds = {
            { 
                title = embedData.title,
                color = 16711680,
                description = embedData.description,
                fields = {
                    {
                        name = "Key",
                        value = "||%USER_KEY%||"
                    },
                    {
                        name = "Script",
                        value = LRM_SANITIZE(ScriptInformation.ScriptName, "[a-zA-Z0-9 _\\-':()!]{1,50}")
                    },
                    {
                        name = "Roblox",
                        value = LRM_SANITIZE(UserInformation.RobloxUsername, "[a-zA-Z0-9_]{3,20}"),
                        inline = true
                    },
                    {
                        name = "Discord",
                        value = "<@%DISCORD_ID%>",
                        inline = true
                    },
                    {
                        name = "Country",
                        value = ":flag_%COUNTRY_CODE%:",
                        inline = true
                    },
                    {
                        name = "HWID",
                        value = LRM_SANITIZE(UserInformation.HWID, "[a-fA-F0-9]{64}"),
                        inline = true
                    },
                },
                footer = {
                    text = "Total Executions: " .. LRM_SANITIZE(UserInformation.TotalExecutions, "(?:0|[1-9][0-9]{0,5}|1000000)")
                }
            }
        }
    });
end

return WebhookManager