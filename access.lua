local component = require("component")

local access = {}

-- Получение прав администратора
function access.Get(nick, msg, ai_name, admins)

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
      component.chat_box.say(nick .. ", у вас нет прав на использование этой команды!")
    else
      component.chat_box.say(nick .. ", у вас уже есть права!")
    end
  else
    component.chat_box.say(nick .. ", вам присвоены права!")
    --data.RecordData(nick) -- Вызов функции записи в конфиг
  end
  
  return
end



return access