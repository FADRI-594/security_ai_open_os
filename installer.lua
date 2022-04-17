local term = require("term")
local shell = require("shell")
local fs = require("filesystem")

term.clear()

-- Массив с программами, которые необходимо загрузить.
-- Первый элемент - название файла, второй - ссылка на файл, третий - директория для сохранения файла.
local applications = {
  -- Основные файлы
  { "/home/main.lua", "https://raw.githubusercontent.com/FADRI-594/security_ai_open_os/security_ai_v.1.0/files/main.lua" },  -- Исполняющий файл
  { "/home/thread.lua", "https://raw.githubusercontent.com/FADRI-594/security_ai_open_os/security_ai_v.1.0/files/thread.lua" },  -- Ядра
  { "/home/config.txt", "https://raw.githubusercontent.com/FADRI-594/security_ai_open_os/security_ai_v.1.0/files/config.txt" },  -- Конфиг файл
  { "/home/uninstall.lua", "https://raw.githubusercontent.com/FADRI-594/security_ai_open_os/security_ai_v.1.0/files/uninstall.lua" },  -- Файл удаления
  -- Основые библиотеки
  { "/home/lib/data.lua", "https://raw.githubusercontent.com/FADRI-594/security_ai_open_os/security_ai_v.1.0/files/lib/data.lua" },  -- Библиотека данных
  { "/home/lib/cmd.lua", "https://raw.githubusercontent.com/FADRI-594/security_ai_open_os/security_ai_v.1.0/files/lib/cmd.lua" },  -- Библиотека данных
  { "/home/lib/access.lua", "https://raw.githubusercontent.com/FADRI-594/security_ai_open_os/security_ai_v.1.0/files/lib/access.lua" },  -- Библиотека данных
  { "/home/lib/detect.lua", "https://raw.githubusercontent.com/FADRI-594/security_ai_open_os/security_ai_v.1.0/files/lib/detect.lua" },  -- Библиотека данных
  { "/home/lib/cipher.lua", "https://raw.githubusercontent.com/FADRI-594/security_ai_open_os/security_ai_v.1.0/files/lib/cipher.lua" },  -- Библиотека данных
  -- Библиотеки вывода
  { "/home/lib/images.lua", "https://raw.githubusercontent.com/FADRI-594/security_ai_open_os/security_ai_v.1.0/files/displaying/images.lua" },  -- Библиотека изображений
  { "/home/lib/paint.lua", "https://raw.githubusercontent.com/FADRI-594/security_ai_open_os/security_ai_v.1.0/files/displaying/paint.lua" },  -- Библиотека рисования на экране
  { "/home/lib/animate.lua", "https://raw.githubusercontent.com/FADRI-594/security_ai_open_os/security_ai_v.1.0/files/displaying/animate.lua" },  -- Библиотека анимации
  { "/home/lib/output.lua", "https://raw.githubusercontent.com/FADRI-594/security_ai_open_os/security_ai_v.1.0/files/displaying/output.lua" }  -- Библиотека вывода на экран
}

-- Загрузка файлов
for i = 1, #applications do
  print("Устанавливается: " .. applications[i][1])
  fs.makeDirectory(fs.path(applications[i][1]) or "")			
  shell.execute("wget " .. applications[i][2] .. " " .. applications[i][1] .. " -fQ")
  os.sleep(0.3)
end



-- Удаление файла установки
os.execute("rm -fr installer.lua")

print("Готово!\n")


-- Запуск ИИ сразу
print("Запустить ИИ сейчас? [Y/n]")
local run = io.read()

if(run ~= "n") then
    os.execute("main.lua")  -- Запуск файла main.lua
end