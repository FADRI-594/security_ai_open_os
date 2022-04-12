local access = {}
local component = require("component")
local say = component.chat_box.say
-- Библиотеки
local data = require("data")  -- Библиотека данных


-- Поиск ника в admins
function access.FindNick(nick, admins)

  local st

  if(#admins == 1 and admins[1] == "пусто") then
    st = "пусто"
  else

    -- Поиск ника в admins
    for i = 1, #admins do
      st = "не найдено"
      if(admins[i] == nick) then  -- Если ник найден в admins
        st = "найдено"
        break -- Перестать искать
      end
    end

  end

  print("st: " .. st)

  return st
end





-- Получение прав администратора
function access.Get(nick, admins)

  local st =  access.FindNick(nick, admins)


  if(st == "пусто") then  -- Если таблица в admins нет ников
    say(nick .. ", вам присвоены права!")
    admins = data.Update(nick, "admins", "add") -- Вызов функции записи в конфиг
  else
    if(st == "не найдено") then -- Если в admins нет ника игрока
      say(nick .. ", у вас нет прав на использование этой команды!")
    elseif(st == "найдено") then  -- Если в admins есть ник
      say(nick .. ", у вас уже есть права!")
    end
  end



  return admins
end



return access