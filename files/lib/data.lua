local data = {}
local component = require("component")

-- Получить данные
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


-- Записать данные
function data.Set(arg, cmd)
    local ai_vers, ai_name, auth_users, admins = data.Get()


    -- Проверка что перезаписать
    if(cmd == ai_vers) then
        ai_vers = arg
    elseif(cmd == ai_name) then
        ai_name = arg
    elseif(cmd == auth_users) then
        auth_users = arg
    elseif(cmd == admins) then
        admins = arg
    end



    local newLines = {
        {"Версия ИИ", ai_vers},
        {"Имя ИИ", ai_name},
        {"Авторизованные пользователи", auth_users},
        {"Администраторы", admins}
    }

    local file, err = io.open("config.txt", "w") -- Открываем файл
    if file then

        for i = 1, #newLines do
            file:write(newLines[i][1] .. ": ")
            if(newLines[i][2] ~= nil) then
                file:write(newLines[i][2])
            else
                if newLines[i][2][0] ~= "пусто" then
                    local line = ""
                    for k, s in pairs(newLines[i][2]) do
                        line = line .. s .. ", "
                    end
                    local nLine = string.sub(line, 1, #line-2)
                    file:write(nLine)
                end
            end
            file:write(";\n")
        end

    else
        print("Error opening file: " .. err)
    end
    file:close()  -- Закрываем файл


    return
end


-- Обновить данные
function data.Update(arg, cmd1, cmd2)
    local ai_vers, ai_name, auth_users, admins = data.Get()

    local newArg
    local command

    if(cmd1 == "admins") then
        if(cmd2 == "add") then
            if(#admins == 1 and admins[#admins-1] == "пусто") then
                admins[#admins-1] = arg
            else
                admins[#admins] = arg
            end
        elseif(cmd2 == "delete") then
            for k, s in pairs(admins) do
                if(s == arg) then
                    if(k == #admins) then
                        admins[k-1] = nil
                    else
                        for n, w in pairs(admins) do
                            if(n > k) then
                                admins[n-2] = w
                                admins[n-1] = nil
                            end
                        end
                    end

                    break
                end
            end

            newArg = admins
            command = "admins"
        end
    end

    data.Set(newArg, command)

    return newArg
end



return data