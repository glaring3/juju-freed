local games = {
    [1008451066] = "https://api.luarmor.net/files/v3/loaders/f6a815eb5fa24e03f6a21e00582072b1.lua",
    [4348829796] = "https://api.luarmor.net/files/v3/loaders/83afa5fcd967550d4124c1ac22e66185.lua",
    [113491250] = "https://api.luarmor.net/files/v3/loaders/dc7209296a81c2e8684daa5cf40d6c44.lua"
}

if game.GameId == 113491250 then -- CREDITS TO iray888 (896378803868295178) @ the krampus discord // i wasn't even aware of these functions krampus pls add docs
    local realDrawings = {}
    local newID, newChannel = create_comm_channel()

    newChannel.Event:Connect(function(method, drawingID, index, value)
        if method == "remove" then
            pcall(function()
                realDrawings[drawingID]:Remove()
            end)
        elseif method == "new" then
            pcall(function()
                realDrawings[drawingID] = Drawing.new(index)
            end)
        else
            local shape = realDrawings[drawingID]
    
            if shape then
                pcall(function()
                    shape[index] = value
                end)
            end
        end
    end)

    run_on_actor(getactors()[1], `script_key="{script_key}"`..game:HttpGet(games[game.GameId]), newID)
    return
end

loadstring(game:HttpGet(games[game.GameId] or "https://api.luarmor.net/files/v3/loaders/e7b8ab8480015787078f991bc7523cb6.lua"))()