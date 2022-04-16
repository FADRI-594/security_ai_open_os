local paint = {}
local component = require("component")
local gpu = component.gpu


-- Функции
-- Объединение рисунка
function Merging(img, horizontal, vertical)
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
function Color()
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
-- Конец функций


-- Функция рисования
function paint.Output(img, mirror, horizontal, vertical)
  local colorList = Color() -- Получаем список цветов

  if(mirror == true) then -- Если изображение нужно отзеркалить
    local img = Merging(img, horizontal, vertical)  -- Получаем отзеркаленное изображение
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

  return
end
-- Конец функций



return paint