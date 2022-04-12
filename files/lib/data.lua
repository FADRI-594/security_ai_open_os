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

    local i = 1
    for s in string.gmatch(config, "[^;]+") do
        local w = {}
        local k = 1
        for v in string.gmatch(s, "[^:]+") do
            w[k] = v
            k = k+1
        end

        if(w[2] == nil) then
            w[2] = "пусто"
        end

        t[i] = w[2]
        i = i + 1
    end

    -- Разбиение строки имени ИИ
    t[1] = t[1] .. ",Компьютер,Комп"
    local nai = {}   -- Массив всех имён из ИИ из файла
    local i = 1
    for s in string.gmatch(t[2], "[^,]+") do
        nai[i] = s
        i = i+1
    end
    -- Разбиение строки Авторизованных пользователей
    local au = {}   -- Массив всех авторизованных пользователей из файла
    local i = 1
    for s in string.gmatch(t[3], "[^,]+") do
        au[i] = s
        i = i+1
    end
    -- Разбиение строки Администраторов
    local ad = {}   -- Массив всех администраторов из файла
    local i = 1
    for s in string.gmatch(t[4], "[^,]+") do
        ad[i] = s
        i = i+1
    end


    -- Данные
    ai_vers = t[1]
    ai_name = nai
    auth_users = au
    admins = ad

    return ai_vers, ai_name, auth_users, admins
end


-- Записать данные
function data.Set(arg, cmd)
    local ai_vers, ai_name, auth_users, admins = data.Get()


    -- Проверка что перезаписать
    if(cmd == "ai_vers") then
        ai_vers = arg
    elseif(cmd == "ai_name") then
        ai_name = arg
    elseif(cmd == "auth_users") then
        auth_users = arg
    elseif(cmd == "admins") then
        admins = arg
    end



    local newLines = {
        {"Версия ИИ", ai_vers},
        {"Имя ИИ", ai_name[0]},
        {"Авторизованные пользователи", auth_users},
        {"Администраторы", admins}
    }

    local file, err = io.open("config.txt", "w") -- Открываем файл
    if file then


        for i = 1, #newLines do
            file:write(newLines[i][1] .. ": ")
            if(type(newLines[i][2]) ~= "table") then    -- Если второе значение не таблица
                file:write(newLines[i][2])
            else    -- Если второе значение таблица


                local line = "" 

                for l = 1, #newLines[i][2] do
                    line = line .. newLines[i][2][l] .. ", "
                end

                local nl = string.sub(line, 1, #line-2)
                file:write(nl)

                
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


    if(cmd1 == "admins") then   -- Если изменения администраторов
        if(cmd2 == "add") then  -- Если добавление администратора

            if(#admins == 1 and admins[#admins] == "пусто") then  -- Если всего 1 запись и она пуста
                admins[#admins] = arg
            else
                admins[#admins+1] = arg
            end

        elseif(cmd2 == "delete") then   -- Если удаление администратора

            for i = 1, #admins do
                if(admins[i] == arg) then   -- Если админ = нику
                    if(i == #admins) then   -- Если админ в самом конце
                        if(#admins > 1) then
                            admins[i] = nil
                        else
                           admins[i] = "пусто" 
                        end
                    else
                        for l = 1, #admins do
                            if(l >= i) then
                                admins[l] = admins[l+1]
                            end
                        end
                    end
                end 
            end

        end

        newArg = admins
        command = "admins"
    end

    
    data.Set(newArg, command)

    return newArg
end



return data