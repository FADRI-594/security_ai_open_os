local data = {}

function data.Get()
    local ai_vers
    local ai_name = {}
    local auth_users = {}
    local admins = {}


    local file, err = io.open("config.txt", "r") -- Открываем файл
    if file then
        config = file:read("*a")  -- Читаем весь файл
        config = string.gsub(config, "%s+", "") -- Удаляем все пробелы из строки
    else
        print("Error opening file: " .. err)
    end
    file:close()  -- Закрываем файл

    -- Значения из файла
    local t = {}  -- Массив всех нужных данных из файла

    local i = 0
    for s in string.gmatch(config, "[^;]+") do
        local w = {}
        local k = 0
        for v in string.gmatch(s, "[^:]+") do
            w[k] = v
            k = k+1
        end

        if(w[1] == nil) then
            w[1] = "пусто"
        end

        t[i] = w[1]
        i = i + 1
    end

    -- Разбиение строки имени ИИ
    t[1] = t[1] .. ",Компьютер,Комп"
    local nai = {}   -- Массив всех имён из ИИ из файла
    local i = 0
    for s in string.gmatch(t[1], "[^,]+") do
        nai[i] = s
        i = i+1
    end
    -- Разбиение строки Авторизованных пользователей
    local au = {}   -- Массив всех авторизованных пользователей из файла
    local i = 0
    for s in string.gmatch(t[2], "[^,]+") do
        au[i] = s
        i = i+1
    end
    -- Разбиение строки Администраторов
    local ad = {}   -- Массив всех администраторов из файла
    local i = 0
    for s in string.gmatch(t[3], "[^,]+") do
        ad[i] = s
        i = i+1
    end


    -- Данные
    ai_vers = t[0]
    ai_name = nai
    auth_users = au
    admins = ad

    return ai_vers, ai_name, auth_users, admins
end



function data.Update()
    local ai_vers, ai_name, auth_users, admins = data.Get()
    return ai_vers, ai_name, auth_users, admins
end



return data