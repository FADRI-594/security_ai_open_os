local component = require("component")
local gpu = component.gpu




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





-- Функции
-- Очистка экрана
function ClearScreen()
  gpu.setBackground(0xFFFFFF)
  gpu.setForeground(0xFFFFFF)

  local w, h = gpu.getResolution()    -- Получение разрешения экрана

  gpu.fill(1, 1, w, h, " ")

  return
end


-- Объединение рисунка
function Merging(img, mirror, horizontal, vertical)
  if(mirror == true) then -- Если нужно отразить
   
    if(horizontal == true) then -- Если нужно отразить по горизонтале

      local newLine = #img + 1
      for nLine = #img, 1 do  -- Проход по всем строкам (снизу вверх)
        for nColumn = 1, img[nLine] do  -- Проход по всем столбцам
          img[newLine][nColumn] = img[nLine][nColumn]
        end
        newLine = newLine + 1
      end

    end
    if(vertical == true) then -- Если нужно отразить по вертикали
      
      for nLine = 1, #img do  -- Проход по всем строкам
        local newColumn = #img[nLine] + 1
        for nColumn = img[nLine], 1 do  -- Проход по всем столбцам (справа налево)
          img[nLine][newColumn] = img[nLine][nColumn]
          newColumn = newColumn + 1
        end
      end

    end
  end

  return img
end


function Color()
  -- Цвета в HEX
  local colorList = {
    0x000000, -- 1. Black
    0xFF0000, -- 2. Red
    0x00FF00, -- 3. Green
    0x0000FF, -- 4. Blue
    0xFFFF00, -- 5. Yellow
    0x00FFFF, -- 6. Bright blue
    0xFF00FF, -- 7. Pink
    0xC0C0C0  -- 8. Grey
  }
  return colorList
end


-- Функция рисования
function Paint(img, mirror, horizontal, vertical)
  local colorList = Color()

  if(mirror == true) then
    local img = Merging(img, mirror, horizontal, vertical)
  end

  -- Разрешение экрана
  local screenWidth, screenHeight = gpu.getResolution() -- Получение разрешения экрана
  local center = { screenWidth / 2, screenHeight / 2 }  -- Центр экрана

  
  -- Столбцы (количество всех элементов первого элемента img), строки (количество всех элементов img)
  local need_pixels = { #img[1], #img }

  -- Размер пикселя, а именно - количество символов по X и Y пикселя (чем больше - тем больше сам пиксель)
  local pixelX, pixelY = 2, 1




  -- Строки и столбцы
  local indent = {} -- Отступ

  -- Строка и стобец чисел делятся на 2 (нанесение с двух сторон от центра и сверху и снизу)
  indent[1], indent[2] = (need_pixels[1]/2), (need_pixels[2]/2)
  


  -- Координаты
  -- X: центральная точка -+ ((количество всех пикселей в линии в рисунке/2) * размер пикселя по X)
  -- Y: центральная точка -+ ((количество всех пикселей в линии в рисунке/2) * размер пикселя по Y)
  local point1 = { center[1]-(indent[1]*pixelX), center[2]-(indent[2]*pixelY) } -- Левая верхняя точка (начальная) X/Y
  local point2 = { center[1]+(indent[1]*pixelX), center[2]+(indent[2]*pixelY) } -- Нижняя правая точка (конечная) X/Y



  -- Рисуем рисунок!
  for nLine = 1, need_pixels[2] do  -- Проход по всем строкам
    for nColumn = 1, need_pixels[1] do  -- Проход по всем столбцам
      -- Меняем цвет
      local nclr = img[nLine][nColumn]  -- Номер цвета из файла изображения
      local color -- Цвет

      if(nclr == 0) then  -- Если номер цвета в файле 0
        color = 0xFFFFFF  -- Цвет = белый
      else
        color = colorList[nclr] -- Цвет = цвет из таблицы по номеру из файла
      end
      gpu.setBackground(color)


      -- Рисует:
      -- от начальной точки X + (текущий столбец - 1) * размер пикселя по X;
      -- от начальной точки Y + (текущий столбец - 1) * размер пикселя по Y;
      -- пиксель x; пиксель y; пустота (ничего)
      gpu.fill(point1[1]+(nColumn-1)*pixelX, point1[2]+(nLine-1)*pixelY,   pixelX, pixelY,   " ")
    end
  end





  

  gpu.setBackground(0x000000)
  print("\n\nШирина экрана: " .. screenWidth .. "\nВысота экрана: " .. screenHeight .. "\nЦентр экрана: " .. center[1] .. ", " .. center[2])
  print("\n\nНачальная точка: " .. point1[1] .. ", " .. point1[2] .. "\nКонечная точка: " .. point2[1] .. ", " .. point2[2])

  return
end
-- Конец функций






ClearScreen() -- Очистка экрана



-- Изображения
local imgCircle = {
  {0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0}, -- 1
  {0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0}, -- 2
  {0,0,0,0,0,0,1,1,1,1,1,6,6,6,6,6,6,6,6,6,6,1,1,1,1,1,0,0,0,0,0,0}, -- 3
  {0,0,0,0,0,1,1,1,1,6,6,6,6,6,6,6,6,6,6,6,6,6,6,1,1,1,1,0,0,0,0,0}, -- 4
  {0,0,0,0,1,1,1,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,1,1,1,0,0,0,0}, -- 5
  {0,0,0,1,1,1,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,1,1,1,0,0,0}, -- 6
  {0,0,1,1,1,6,6,6,6,6,6,6,6,1,1,1,1,1,1,6,6,6,6,6,6,6,6,1,1,1,0,0}, -- 7
  {0,0,1,1,6,6,6,6,6,6,6,1,1,1,1,1,1,1,1,1,1,6,6,6,6,6,6,6,1,1,0,0}, -- 8
  {0,1,1,1,6,6,6,6,6,6,1,1,1,1,0,0,0,0,1,1,1,1,6,6,6,6,6,6,1,1,1,0}, -- 9
  {0,1,1,6,6,6,6,6,6,1,1,1,0,0,0,0,0,0,0,0,1,1,1,6,6,6,6,6,6,1,1,0}, -- 10
  {1,1,1,6,6,6,6,6,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,6,6,6,6,6,1,1,1}, -- 11
  {1,1,6,6,6,6,6,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,6,6,6,6,6,1,1}, -- 12
  {1,1,6,6,6,6,6,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,6,6,6,6,6,1,1}, -- 13
  {1,1,6,6,6,6,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,6,6,6,6,1,1}, -- 14
  {1,1,6,6,6,6,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,6,6,6,6,1,1}, -- 15
  {1,1,6,6,6,6,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,6,6,6,6,1,1}, -- 16
  {1,1,6,6,6,6,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,6,6,6,6,1,1}, -- 17
  {1,1,6,6,6,6,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,6,6,6,6,1,1}, -- 18
  {1,1,6,6,6,6,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,6,6,6,6,1,1}, -- 19
  {1,1,6,6,6,6,6,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,6,6,6,6,6,1,1}, -- 20
  {1,1,6,6,6,6,6,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,6,6,6,6,6,1,1}, -- 21
  {1,1,1,6,6,6,6,6,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,6,6,6,6,6,1,1,1}, -- 22
  {0,1,1,6,6,6,6,6,6,1,1,1,0,0,0,0,0,0,0,0,1,1,1,6,6,6,6,6,6,1,1,0}, -- 23
  {0,1,1,1,6,6,6,6,6,6,1,1,1,1,0,0,0,0,1,1,1,1,6,6,6,6,6,6,1,1,1,0}, -- 24
  {0,0,1,1,6,6,6,6,6,6,6,1,1,1,1,1,1,1,1,1,1,6,6,6,6,6,6,6,1,1,0,0}, -- 25
  {0,0,1,1,1,6,6,6,6,6,6,6,6,1,1,1,1,1,1,6,6,6,6,6,6,6,6,1,1,1,0,0}, -- 26
  {0,0,0,1,1,1,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,1,1,1,0,0,0}, -- 27
  {0,0,0,0,1,1,1,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,1,1,1,0,0,0,0}, -- 28
  {0,0,0,0,0,1,1,1,1,6,6,6,6,6,6,6,6,6,6,6,6,6,6,1,1,1,1,0,0,0,0,0}, -- 29
  {0,0,0,0,0,0,1,1,1,1,1,6,6,6,6,6,6,6,6,6,6,1,1,1,1,1,0,0,0,0,0,0}, -- 30
  {0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0}, -- 31
  {0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0} -- 32
}


local imgEye1 = {
  {0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0}, -- 1
  {0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0}, -- 2
  {0,0,0,0,0,0,1,1,1,1,1,6,6,6,6,6,6,6,6,6,6,1,1,1,1,1,0,0,0,0,0,0}, -- 3
  {0,0,0,0,0,1,1,1,1,6,6,6,6,6,6,6,6,6,6,6,6,6,6,1,1,1,1,0,0,0,0,0}, -- 4
  {0,0,0,0,1,1,1,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,1,1,1,0,0,0,0}, -- 5
  {0,0,0,1,1,1,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,1,1,1,0,0,0}, -- 6
  {0,0,1,1,1,6,6,6,6,6,6,6,6,1,1,1,1,1,1,6,6,6,6,6,6,6,6,1,1,1,0,0}, -- 7
  {0,0,1,1,6,6,6,6,6,6,6,1,1,1,1,1,1,1,1,1,1,6,6,6,6,6,6,6,1,1,0,0}, -- 8
  {0,1,1,1,6,6,6,6,6,6,1,1,1,1,0,0,0,0,1,1,1,1,6,6,6,6,6,6,1,1,1,0}, -- 9
  {0,1,1,6,6,6,6,6,6,1,1,1,0,0,0,0,0,0,0,0,1,1,1,6,6,6,6,6,6,1,1,0}, -- 10
  {1,1,1,6,6,6,6,6,1,1,1,0,0,0,2,2,2,2,0,0,0,1,1,1,6,6,6,6,6,1,1,1}, -- 11
  {1,1,6,6,6,6,6,1,1,1,0,0,0,2,2,2,2,2,2,0,0,0,1,1,1,6,6,6,6,6,1,1}, -- 12
  {1,1,6,6,6,6,6,1,1,1,0,0,0,2,2,2,2,2,2,0,0,0,1,1,1,6,6,6,6,6,1,1}, -- 13
  {1,1,1,6,6,6,6,6,1,1,1,0,0,0,2,2,2,2,0,0,0,1,1,1,6,6,6,6,6,1,1,1}, -- 14
  {0,1,1,6,6,6,6,6,6,1,1,1,0,0,0,0,0,0,0,0,1,1,1,6,6,6,6,6,6,1,1,0}, -- 15
  {0,1,1,1,6,6,6,6,6,6,1,1,1,1,0,0,0,0,1,1,1,1,6,6,6,6,6,6,1,1,1,0}, -- 16
  {0,0,1,1,6,6,6,6,6,6,6,1,1,1,1,1,1,1,1,1,1,6,6,6,6,6,6,6,1,1,0,0}, -- 17
  {0,0,1,1,1,6,6,6,6,6,6,6,6,1,1,1,1,1,1,6,6,6,6,6,6,6,6,1,1,1,0,0}, -- 18
  {0,0,0,1,1,1,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,1,1,1,0,0,0}, -- 19
  {0,0,0,0,1,1,1,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,1,1,1,0,0,0,0}, -- 20
  {0,0,0,0,0,1,1,1,1,6,6,6,6,6,6,6,6,6,6,6,6,6,6,1,1,1,1,0,0,0,0,0}, -- 21
  {0,0,0,0,0,0,1,1,1,1,1,6,6,6,6,6,6,6,6,6,6,1,1,1,1,1,0,0,0,0,0,0}, -- 32
  {0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0}, -- 23
  {0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0} -- 24
}


local imgEye2 = {
  {0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0}, -- 1
  {0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0}, -- 2
  {0,0,0,0,0,0,0,1,1,1,1,1,6,6,6,6,6,6,6,6,6,6,1,1,1,1,1,0,0,0,0,0,0,0}, -- 3
  {0,0,0,0,0,0,1,1,1,1,6,6,6,6,6,6,6,6,6,6,6,6,6,6,1,1,1,1,0,0,0,0,0,0}, -- 4
  {0,0,0,0,0,1,1,1,6,6,6,6,6,6,1,1,1,1,1,1,6,6,6,6,6,6,1,1,1,0,0,0,0,0}, -- 5
  {0,0,0,0,1,1,1,6,6,6,6,6,1,1,1,1,1,1,1,1,1,1,6,6,6,6,6,1,1,1,0,0,0,0}, -- 6
  {0,0,0,1,1,1,6,6,6,6,6,1,1,1,1,0,0,0,0,1,1,1,1,6,6,6,6,6,1,1,1,0,0,0}, -- 7
  {0,0,1,1,1,6,6,6,6,6,1,1,1,0,0,0,0,0,0,0,0,1,1,1,6,6,6,6,6,1,1,1,0,0}, -- 8
  {0,1,1,1,6,6,6,6,6,1,1,1,0,0,0,2,2,2,2,0,0,0,1,1,1,6,6,6,6,6,1,1,1,0}, -- 9
  {1,1,1,6,6,6,6,6,1,1,1,0,0,0,2,2,2,2,2,2,0,0,0,1,1,1,6,6,6,6,6,1,1,1}, -- 10
  {1,1,1,6,6,6,6,6,1,1,1,0,0,0,2,2,2,2,2,2,0,0,0,1,1,1,6,6,6,6,6,1,1,1}, -- 11
  {0,1,1,1,6,6,6,6,6,1,1,1,0,0,0,2,2,2,2,0,0,0,1,1,1,6,6,6,6,6,1,1,1,0}, -- 12
  {0,0,1,1,1,6,6,6,6,6,1,1,1,0,0,0,0,0,0,0,0,1,1,1,6,6,6,6,6,1,1,1,0,0}, -- 13
  {0,0,0,1,1,1,6,6,6,6,6,1,1,1,1,0,0,0,0,1,1,1,1,6,6,6,6,6,1,1,1,0,0,0}, -- 14
  {0,0,0,0,1,1,1,6,6,6,6,6,1,1,1,1,1,1,1,1,1,1,6,6,6,6,6,1,1,1,0,0,0,0}, -- 15
  {0,0,0,0,0,1,1,1,6,6,6,6,6,6,1,1,1,1,1,1,6,6,6,6,6,6,1,1,1,0,0,0,0,0}, -- 16
  {0,0,0,0,0,0,1,1,1,1,6,6,6,6,6,6,6,6,6,6,6,6,6,6,1,1,1,1,0,0,0,0,0,0}, -- 17
  {0,0,0,0,0,0,0,1,1,1,1,1,6,6,6,6,6,6,6,6,6,6,1,1,1,1,1,0,0,0,0,0,0,0}, -- 18
  {0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0}, -- 19
  {0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0}, -- 20
}


local imgEye3 = {
  {0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1}, -- 1
  {0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1}, -- 2
  {0,0,0,0,0,0,0,1,1,1,1,1,6,6,6,6,6}, -- 3
  {0,0,0,0,0,0,1,1,1,1,6,6,6,6,6,6,6}, -- 4
  {0,0,0,0,0,1,1,1,6,6,6,6,6,6,1,1,1}, -- 5
  {0,0,0,0,1,1,1,6,6,6,6,6,1,1,1,1,1}, -- 6
  {0,0,0,1,1,1,6,6,6,6,6,1,1,1,1,0,0}, -- 7
  {0,0,1,1,1,6,6,6,6,6,1,1,1,0,0,0,0}, -- 8
  {0,1,1,1,6,6,6,6,6,1,1,1,0,0,0,2,2}, -- 9
  {1,1,1,6,6,6,6,6,1,1,1,0,0,0,2,2,2} -- 10
}







local mirror = true

local horizontal = true
local vertical = true


Paint(imgEye3, mirror, horizontal, vertical)  -- Вызов функции рисования