local access = {}
local component = require("component")
local say = component.chat_box.say
-- Библиотеки
local data = require("data")  -- Библиотека данных


-- Объединение никнеймов
function access.NA_in_Line(admins)
  local NewAdmins = ""  -- Список никнеймов админов


  if(admins[1] == "пусто") then -- Если admins пуста (в этом случае всегда admins[1] = "пусто")
    NewAdmins = "пусто"
  else

    -- Перебор списка админов
    for i = 1, #admins do
      if(i == 1) then -- Если это первая запись в admins
        NewAdmins = admins[i]
      else
        NewAdmins = NewAdmins .. "," .. admins[i]
      end
    end

  end


  return NewAdmins
end





-- Получение прав администратора
function access.Get(nick, admins)

  local NewAdmins = access.NA_in_Line(admins)
  print("\nNewAdmins: " .. NewAdmins .. "\n")


  print("Admins:\n")
  for i = 1, #admins do
    print(admins[i])
  end



  
  if(NewAdmins == "пусто") then -- Если строка ников пуста
    say(nick .. ", вам присвоены права!")
    admins = data.Update(nick, "admins", "add") -- Вызов функции записи в конфиг
  else  -- Если есть хотя бы 1 ник
    
    if(NewAdmins:find(nick) ~= nil) then  -- Если в admins нет ника игрока
      say(nick .. ", у вас нет прав на использование этой команды!")
    else  -- Если в admins есть ник
      

      local start_pos, end_pos = NewAdmins:find(nick)
      if((start_pos == 1 or NewAdmins:sub(start_pos-1) == ",") and (end_pos == NewAdmins:len() or NewAdmins:sub(end_pos+1) == ",")) then
        
        say(nick .. ", у вас уже есть права!")

      else
        say(nick .. ", у вас нет прав на использование этой команды!")
      end


    end

  end
  

  return admins
end



return access