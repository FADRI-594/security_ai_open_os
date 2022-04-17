local term = require("term")
local shell = require("shell")
local fs = require("filesystem")

term.clear()

-- Массив с программами, которые необходимо удалить.
-- Первый элемент - название файла, второй - директория для сохранения файла.
local applications = {
    -- Библиотеки
    "/home/lib",  -- Основная библиотека
    --"/home/displaying", -- Библиотека вывода на экран
    -- Основные файлы
    "/home/main.lua",  -- Исполняющий файл
    "/home/thread.lua", -- Ядра
    "/home/config.txt",  -- Конфиг файл
    "/home/uninstall.lua"  -- Файл удаления
}



-- Удаление файлов
for i = 1, #applications do
    print("Удаляется: " .. applications[i])
    shell.execute("rm -fr " .. applications[i])
    os.sleep(0.3)
end