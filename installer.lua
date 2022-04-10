local shell = require("shell")
local fs = require("filesystem")

-- Массив с программами, которые необходимо загрузить.
-- Первый элемент - название файла, второй - ссылка на файл, третий - директория для сохранения файла.
local applications = {
  -- Основные файлы
  { "main.lua", "https://raw.githubusercontent.com/FADRI-594/security_ai_open_os/security_ai_v.1.0/files/main.lua", "/home/" },  -- Исполняющий файл
  { "config.txt", "https://raw.githubusercontent.com/FADRI-594/security_ai_open_os/security_ai_v.1.0/files/config.txt", "/home/" },  -- Конфиг файл
  { "uninstall.lua", "https://raw.githubusercontent.com/FADRI-594/security_ai_open_os/security_ai_v.1.0/files/uninstall.lua", "/home/" },  -- Файл удаления
  -- Основые библиотеки
  { "data.lua", "https://raw.githubusercontent.com/FADRI-594/security_ai_open_os/security_ai_v.1.0/files/lib/data.lua", "/home/lib/" },  -- Библиотека данных
  { "cmd.lua", "https://raw.githubusercontent.com/FADRI-594/security_ai_open_os/security_ai_v.1.0/files/lib/cmd.lua", "/home/lib/" },  -- Библиотека данных
  { "access.lua", "https://raw.githubusercontent.com/FADRI-594/security_ai_open_os/security_ai_v.1.0/files/lib/access.lua", "/home/lib/" },  -- Библиотека данных
}

-- Создаём папки
os.execute("mkdir lib") -- Создание папки Библиотека

-- Загружаем файлы
for i = 1, #applications do
  print("Устанавливаю " .. applications[i][1])
  fs.makeDirectory(fs.path(applications[i][3] .. applications[i][1]) or "")		
  shell.execute("wget " .. applications[i][2] .. " " .. applications[i][3] .. applications[i][1] .. " -fQ")
  os.sleep(0.3)
end



-- Удаление файла установки
os.execute("rm -fr installer.lua")

print("Готово")


print("Запустить ИИ сейчас? Y\n")
local run = io.read()

if(run ~= "n") then
    os.execute("main.lua")
end