local paint = {}
local component = require("component")
local gpu = component.gpu


-- Функции
-- Очистка экрана
function paint.ClearScreen()
  gpu.setBackground(0xFFFFFF)
  gpu.setForeground(0xFFFFFF)

  local w, h = gpu.getResolution()    -- Получение разрешения экрана

  gpu.fill(1, 1, w, h, " ")

  return
end


-- Объединение рисунка
function paint.Merging(img, horizontal, vertical)
  local newImage = img
  if(horizontal == true) then

    for nLine = 1, #img do  -- Перебор линий таблицы
      newImage[nLine] = img[nLine]  -- Записываем старые строки
    end
    local newLine = #img + 1
    for nLine = #img, 1, -1 do  -- Перебор линий таблицы (с конца)
      -- Записываем в новую таблицу-изображение на место новой линии [newLine] линию из старой таблицы-изображения с места nLine
      newImage[newLine] = img[nLine]
      newLine = newLine + 1
    end

    img = newImage  -- Изменяем начальное изображение на новое

  end
  if(vertical == true) then

    for nLine = 1, #img do  -- Перебор линий таблицы
      local clm = {} -- Создаём временную таблицу строки 
      local columns = img[nLine] -- Колонки таблицы-изображения
      for nColumn = 1, #columns do -- Перебор колонок таблицы

        clm[nColumn] = columns[nColumn]  -- Добавляем старые записи
        
      end
      local newColumn = #columns + 1 -- Номер новой колонки
      for nColumn = #columns, 1, -1 do -- Перебор колонок таблицы (с конца)

        -- Добавляем в строку на место [newColumn] значение, которое берется из строки с места nColumn
        clm[newColumn] = columns[nColumn]
        
        newColumn = newColumn + 1

      end
      newImage[nLine] = clm  -- Заносим в новую таблицу-изображение в линую [newLine] таблицу колонок (clm)
    end

    img = newImage  -- Изменяем начальное изображение на новое

  end

  return img
end


-- Цвета в HEX
function paint.Colors()
  local colorList = {}

  -- Черный цвет
  colorList.Black = {}
  colorList.Black.number = 1
  colorList.Black.normal = 0x000000
  colorList.Black.light = 0x303030
  colorList.Black.dark = 0x000000

  -- Красный цвет
  colorList.Red = {}
  colorList.Red.number = 2
  colorList.Red.normal = 0xFF0000
  colorList.Red.light = 0xFF3030
  colorList.Red.dark = 0xBB0000

  -- Зеленый цвет
  colorList.Green = {}
  colorList.Green.number = 3
  colorList.Green.normal = 0x00FF00
  colorList.Green.light = 0x30FF30
  colorList.Green.dark = 0x00BB00

  -- Синий цвет
  colorList.Blue = {}
  colorList.Blue.number = 4
  colorList.Blue.normal = 0x0000FF
  colorList.Blue.light = 0x3030FF
  colorList.Blue.dark = 0x0000BB

  -- Желтый
  colorList.Yellow = {}
  colorList.Yellow.number = 5
  colorList.Yellow.normal = 0xFFFF00
  colorList.Yellow.light = 0xFFFFAA
  colorList.Yellow.dark = 0xD0D01E

  -- Аквамарин
  colorList.Aquamarine = {}
  colorList.Aquamarine.number = 6
  colorList.Aquamarine.normal = 0x00FFFF
  colorList.Aquamarine.light = 0xAAFFFF
  colorList.Aquamarine.dark = 0x1ED0D0

  -- Розовый
  colorList.Pink = {}
  colorList.Pink.number = 7
  colorList.Pink.normal = 0xFF00FF
  colorList.Pink.light = 0xFFAAFF
  colorList.Pink.dark = 0xD01ED0

  -- Серый
  colorList.Grey = {}
  colorList.Grey.number = 8
  colorList.Grey.normal = 0xC0C0C0
  colorList.Grey.light = 0xA0A0A0
  colorList.Grey.dark = 0xD0D0D0


  return colorList
end

-- Имена цветов
function paint.ColorsName(numOne)
  local clrName
  if(numOne == 1) then
      clrName = "Black"
  elseif(numOne == 2) then
      clrName = "Red"
  elseif(numOne == 3) then
      clrName = "Green"
  elseif(numOne == 4) then
      clrName = "Blue"
  elseif(numOne == 5) then
      clrName = "Yellow"
  elseif(numOne == 6) then
      clrName = "Aquamarine"
  elseif(numOne == 7) then
      clrName = "Pink"
  elseif(numOne == 8) then
      clrName = "Grey"
  end
  
  return clrName
end



-- Функция рисования
function paint.Output(img, mirror, horizontal, vertical)
  local colorList = paint.Colors() -- Получаем список цветов

  if(mirror == true) then -- Если изображение нужно отзеркалить
    local img = paint.Merging(img, horizontal, vertical)  -- Получаем отзеркаленное изображение
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


        local tbl = {}
        local i = 1
        nclr = tostring(nclr)
        for v in string.gmatch(nclr, "%d") do
            tbl[i] = tonumber(v)
            i = i+1
        end

        local clrName = paint.ColorsName(tbl[1])

        local tl
        for i, s in pairs(colorList) do
            if(i == clrName) then
                tl = s
                break
            end
        end

        if(#tbl == 1) then
            color = tl.normal
        elseif(#tbl == 2) then

            if(tbl[2] == 0) then
                color = tl.light
            elseif(tbl[2] == 1) then
                color = tl.dark
            end

        end

        
      end
      gpu.setBackground(color)


      -- Рисует:
      -- от начальной точки X + (текущий столбец - 1) * размер пикселя по X;
      -- от начальной точки Y + (текущий столбец - 1) * размер пикселя по Y;
      -- пиксель x; пиксель y; пустота (ничего)
      gpu.fill(point1[1]+(nColumn-1)*pixelX, point1[2]+(nLine-1)*pixelY,   pixelX, pixelY,   " ")
    end
  end

  return
end
-- Конец функций



return paint