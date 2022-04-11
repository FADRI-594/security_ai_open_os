local shell = require("shell")
local fs = require("filesystem")

-- Массив с программами, которые необходимо удалить.
-- Первый элемент - название файла, второй - директория для сохранения файла.
local applications = {
    -- Основые библиотеки
    { "lib", "/home/" },  -- Библиотека
    -- Основные файлы
    { "main.lua", "/home/" },  -- Исполняющий файл
    { "config.txt", "/home/" },  -- Конфиг файл
    { "uninstall.lua", "/home/" }  -- Файл удаления
}



-- Удаление файлов
for i = 1, #applications do
    print("Удаляется: " .. applications[i][1])
    shell.execute("rm -fr " .. applications[i][2] .. " " .. applications[i][1] .. " -fQ")
    os.sleep(0.3)
end