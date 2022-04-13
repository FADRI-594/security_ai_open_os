local detect = {}
local component = require("component")


-- Проверка находится ли игрок рядом с радаром
function detect.Player(nick)
    local playersNearby = component.radar.getPlayers()  -- Обнаруженные игроки

    local detected = false  -- Игрок обнаружен (нет)

    -- Перебор обнаруженных игроков
    for i = 1, #playersNearby do
        -- Ники игроков в строке таблицы - playersNearby[i].name
        if(playersNearby[i].name == nick) then
            detected = true -- Игрок обнаружен!

            break
        end
    end


    return detected
end



return detect