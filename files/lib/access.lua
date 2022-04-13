local access = {}
local say = require("component").chat_box.say
-- Библиотеки
local data = require("data")  -- Библиотека данных
local detect = require("detect") -- Библиотека поиска поблизости


-- Функции
-- Объединение никнеймов
function access.Line(table)
  local NewLine = ""  -- Список никнеймов

  if(table[1] == "пусто") then -- Если auth_users пуста
    NewLine = "пусто"
  else  -- Если в auth_users есть ники

    -- Перебор списка админов
    for i = 1, #table do
      if(i == 1) then -- Если это первая запись в auth_users
        NewLine = table[i]
      else
        NewLine = NewLine .. "," .. table[i]
      end
    end

  end

  return NewLine
end


-- Проверка точно ли тот ник
function access.CheckCorrect(nick, line)
  local correct = false

  -- Если есть хотя бы 1 ник в таблице
  if(line ~= "пусто") then
    if(line:find(nick) ~= nil) then  -- Если в строке есть ник игрока
      local start_pos, end_pos = line:find(nick) -- Получение позиций ника в списке ников
      -- Проверка точно ли тот ник, а не часть часть записанного ника
      if((start_pos == 1 or line:sub(start_pos-1) == ",") and (end_pos == line:len() or line:sub(end_pos+1) == ",")) then
        
        correct = true
        
      end
    end
  end

  return correct
end
-- Конец функций





-- Авторизация
function access.Auth(nick, auth_users, admins, arg)
  local AdmLine = access.Line(admins)

  local correct = access.CheckCorrect(nick, AdmLine)  -- Проверка админ ли игрок
  if correct then -- Если игрок админ
    

    local AULine = access.Line(auth_users)
    local nc

    -- Проверка авторизован(а) ли игрок/цель
    if(arg == nil) then  -- Если нет цели авторизации
      nc = access.CheckCorrect(nick, AULine)
    else   -- Если есть цель авторизации
      nc = access.CheckCorrect(arg, AULine)
    end



    if nc then  -- Если игрок/цель авторизован(а)
      if(arg == nil) then  -- Если нет цели авторизации
        say(nick, ", вы не можете авторизовать себя, так как вы уже авторизованы!")
      else   -- Если есть цель авторизации
        say(nick, ", вы не можете авторизовать" .. arg .. ", так как он уже авторизован!")
      end
    else  -- Если игрок/цель не авторизован(а)
      if(arg == nil) then -- Если нет цели авторизации
        auth_users = data.Update(nick, "auth_users", "add") -- Вызов функции записи в конфиг игрока (авторизация игрока)
        say(nick .. ", вы успешно авторизованы!")
      else  -- Если есть цель авторизации
        local detected = detect.Player(arg) -- Проверка рядом ли игрок
        if detected then  -- Если цель рядом
          auth_users = data.Update(arg, "auth_users", "add") -- Вызов функции записи в конфиг цели (авторизация цели)
          say(nick .. ", вы успешно авторизовали " .. arg .. "!")
        else
          say(nick .. ", вы не можете авторизовать " .. arg .. ", так как этот игрок не рядом!")
        end
      end
    end
    
  else
    say(nick .. ", у вас нет прав на использование этой команды!")
  end


  return auth_users
end


-- Деавторизация
function access.Deauth(nick, auth_users, admins, arg)
  local AdmLine = access.Line(admins)

  local correct = access.CheckCorrect(nick, AdmLine)  -- Проверка админ ли игрок
  if correct then -- Если игрок админ
    

    if(arg == nil) then -- Если не указана цель
      admins = data.Update(nick, "admins", "delete") -- Вызов функции удаления игрока (удаление авторизаии игрока)
      auth_users = data.Update(nick, "auth_users", "delete") -- Вызов функции удаления игрока (удаление авторизаии игрока)
      say(nick .. ", вы успешно деавторизовали себя!")
    else  -- Если указана цель
      admins = data.Update(arg, "auth_users", "delete") -- Вызов функции удаления цели (удаление авторизации цели)
      auth_users = data.Update(arg, "auth_users", "delete") -- Вызов функции удаления цели (удаление авторизации цели)
      say(nick .. ", вы успешно удалили деавторизовали " .. arg .. "!")
    end
    

  else
    say(nick .. ", у вас нет прав на использование этой команды!")
  end


  return auth_users
end


-- Получение прав администратора
function access.AdminGet(nick, admins)
  local NewAdmins = access.Line(admins) -- Получение списка админов

  admins = data.Update(nick, "admins", "add") -- Вызов функции записи в конфиг
  say(nick .. ", вам присвоены права администратора!")

  return admins
end


-- Установка прав администратора
function access.AdminSet(nick, auth_users, admins, arg)
  local AdmLine = access.Line(admins)

  local correct = access.CheckCorrect(nick, AdmLine)  -- Проверка админ ли игрок
  if correct then -- Если игрок админ
    

    local AULine = access.Line(auth_users)
    local nc



    if(arg == nil) then
      say(nick .. ", вы не можете выдать себе права администратора, так как они у вас уже есть!")
    else
      local detected = detect.Player(arg) -- Проверка рядом ли игрок
      if detected then  -- Если цель рядом
        nc = access.CheckCorrect(arg, AULine)
        if(nc == false) then  -- Если цель не авторизована
          auth_users = data.Update(arg, "auth_users", "add") -- Вызов функции записи в конфиг цели (авторизация цели)
        end
        admins = data.Update(arg, "admins", "add") -- Вызов функции записи в конфиг цели (выдача прав администратора цели)
        say(nick .. ", вы успешно выдали права администратора " .. arg .. "!")
      else  -- Если цель не рядом
        say(nick .. ", вы не можете выдать права администратора " .. arg .. ", так как этот игрок не рядом!")
      end
    end


    
  else
    say(nick .. ", у вас нет прав на использование этой команды!")
  end


  return auth_users, admins
end



-- Удаление прав администратора
function access.AdminDelete(nick, admins, arg)
  local AdmLine = access.Line(admins)

  local correct = access.CheckCorrect(nick, AdmLine)  -- Проверка админ ли игрок
  if correct then -- Если игрок админ
    


    if(arg == nil) then -- Если не указана цель
      admins = data.Update(nick, "admins", "delete") -- Вызов функции удаления игрока (удаление прав администратора игрока)
      say(nick .. ", вы успешно удалили свои права администратора!")
    else  -- Если указана цель
      admins = data.Update(arg, "admins", "delete") -- Вызов функции удаления цели (удаление прав администратора цели)
      say(nick .. ", вы успешно удалили права администратора " .. arg .. "!")
    end


    
  else
    say(nick .. ", у вас нет прав на использование этой команды!")
  end


  return admins
end



return access