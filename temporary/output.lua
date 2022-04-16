local component = require("component")
local gpu = component.gpu

-- Библиотеки
local paint = require("paint")



-- Выставление разрешения экрана в зависимости от экрана
-- Код от ECS - https://computercraft.ru/topic/2501-kak-ubrat-chyornye-polosy-po-krayam-ekrana-v30/
-- Получаем масштаб в качестве первого аргумента скрипта и корректируем его значение
local scale = tonumber(select(1, ...) or 1)
if not scale or scale > 1 then
  scale = 1
elseif scale < 0.1 then
  scale = 0.1
end

local blockCountByWidth, blockCountByHeight = component.proxy(gpu.getScreen()).getAspectRatio()
local maxWidth, maxHeight = gpu.maxResolution()
local proportion = (blockCountByWidth * 2 - 0.5) / (blockCountByHeight - 0.25)

local height = scale * math.min(
  maxWidth / proportion,
  maxWidth,
  math.sqrt(maxWidth * maxHeight / proportion)
)

local screenWidth = math.floor(height * proportion)
local screenHeight = math.floor(height)

-- Выставляем полученное разрешение
gpu.setResolution(screenWidth, screenHeight)
-- Конец чужого кода



-- Функции
-- Очистка экрана
function ClearScreen()
    gpu.setBackground(0xFFFFFF)
    gpu.setForeground(0xFFFFFF)

    local w, h = gpu.getResolution()    -- Получение разрешения экрана

    gpu.fill(1, 1, w, h, " ")

    return
end
-- Конец функций







ClearScreen() -- Очистка экрана
paint.Output(imgEye, mirror, horizontal, vertical)  -- Вызов функции рисования