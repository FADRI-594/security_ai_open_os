local component = require("component")
local event = require("event")
local gpu = component.gpu

-- Библиотеки
local paint = require("paint")  -- Библиотека рисования изображения на экране
local images = require("images")    -- Библиотека изображения
local animate = require("animate")  -- Библиотека анимаций



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


local img = "Eye"


local mfs
for i, s in pairs(images) do    -- Перебор списка всех изображений
  if(i == img) then   -- Если имя изображения равно заданному изображению
      mfs = s
      break
  end
end


if(mfs ~= nil) then -- Если есть изображение
  paint.Output(mfs.img, mfs.mirror, mfs.horizontal, mfs.vertical) -- Вызов функции рисования
end



while true do
  event.timer(10, animate.AnimEye())
end