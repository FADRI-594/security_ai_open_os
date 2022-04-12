local access = {}
local component = require("component")
local say = component.chat_box.say
-- Библиотеки
local data = require("data")  -- Библиотека данных

-- Получение прав администратора
function access.Get(nick, msg, admins)

  local NewAdmins = ""  -- Список никнеймов админов

  -- Объединение никнеймов
  if(admins[0] == "пусто") then
      NewAdmins = nil
  else
      for k, s in pairs(admins) do
          if(k == 1) then
              NewAdmins = s
          else
              NewAdmins = NewAdmins .. "," .. s
          end
      end
  end
  

  
  if(NewAdmins ~= nil) then
    if(string.find(NewAdmins, nick) == nil) then
      say(nick .. ", у вас нет прав на использование этой команды!")
    else
      say(nick .. ", у вас уже есть права!")
    end
  else
    say(nick .. ", вам присвоены права!")
    admins = data.Update(nick, "admins", "add") -- Вызов функции записи в конфиг
  end
  
  return admins
end



return access