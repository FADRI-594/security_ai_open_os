-- Основные файлы
os.execute("wget -f https://pastebin.com/raw/R1JycGkn /home/main.lua") -- Исполняющий файл
os.execute("wget -f https://pastebin.com/raw/7mEPaWza /home/config.txt")   -- Конфиг

os.execute("wget -f https://pastebin.com/raw/SuN5mz1t /home/uninstall.lua")   -- Файл удаления


os.execute("mkdir lib") -- Создание папки Библиотека


-- Установка библиотек
os.execute("wget -f https://pastebin.com/raw/Yj3pVC8v /home/lib/data.lua") -- Библиотека Данных
os.execute("wget -f https://pastebin.com/raw/vuLay2rP /home/lib/cmd.lua")  -- Библиотека Команд
os.execute("wget -f https://pastebin.com/raw/HQfxrwXF /home/lib/access.lua")   -- Библиотека Административных прав


-- Удаление файла установки
os.execute("rm -fr installer.lua")
