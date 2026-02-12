local WebhookManager = require("@Loader/Services/Protection/WebhookManager")
local ProtectionFlags = require("@Loader/Services/Protection/ProtectionFlags")

local PlayersService = cloneref(game:GetService("Players"))

local getRawMetatable = getrawmetatable
local setRawMetatable = setrawmetatable
local coroutineResume = coroutine.resume
local coroutineCreate = coroutine.create
local coroutineStatus = coroutine.status
local coroutineClose = coroutine.close
local coroutineWrap = coroutine.wrap
local sendWebhook = WebhookManager.send
local taskSpawn = task.spawn
local taskDelay = task.delay
local delFolder = delfolder
local taskWait = task.wait
local osClock = os.clock
local pcall = pcall

local ProtectionService = {
    _detectionFunctions = {}
} 
local detectionFunctions = ProtectionService._detectionFunctions

local detectionCount = 0
local isEnabled = nil :: any

function ProtectionService.init()
    isEnabled = 1
    if LPH_OBFUSCATED then
        sendWebhook({
            title = "New Execution",
            description = "A new execution was detected.",
            content = "",
        })
    end

    local addDetection = ProtectionService.addDetection
    local flag = ProtectionService.flag
    for _, detectionData in next, ProtectionFlags do
        local isThread = detectionData.thread
        local detection = detectionData.detection

        if not isThread then
            taskSpawn(detection, flag)
        else
            addDetection(detection)
        end
    end

    addDetection(LPH_JIT(function()
        while true do
            for i = 1, detectionCount do
                local thread = detectionFunctions[i]
                if not thread then
                    flag("coroutine fail " .. i)
                    break
                end
            end
            taskWait(1)
        end
    end))

    return ProtectionService
end

function ProtectionService.unload(): ()
    isEnabled = nil
    for i = 1, detectionCount do
        local thread = detectionFunctions[i]
        pcall(coroutineClose, thread)
        detectionFunctions[i] = nil
    end
end

function ProtectionService.flag(flagData: string): ()
    if not isEnabled then 
        return 
    end

    if LPH_OBFUSCATED then
        xpcall(function()
            sendWebhook({
                title = "Protection Flagged",
                content = "@everyone",
                description = "A protection flag was triggered: " .. flagData
            })

            pcall(delFolder, "juju")
            
            taskDelay(0.1, function()
                LPH_CRASH()
            end)
        end, function()
            LPH_CRASH()
        end)
    else
        warn("Protection flagged: " .. flagData)
    end
end

function ProtectionService.addDetection(detectionFunction: (flag: (flagData: string) -> ()) -> ()): ()
    local thread = coroutineCreate(function()
        detectionFunction(ProtectionService.flag)
    end)

    coroutineResume(thread)
    detectionFunctions[#detectionFunctions + 1] = thread
    detectionCount+=1
end

return ProtectionService