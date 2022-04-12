local access = {}
local component = require("component")
local say = component.chat_box.say
-- Библиотеки
local data = require("data")  -- Библиотека данных


-- Поиск ника игрока в таблице админов
function access.FindNick(nick, admins)
  
  local found = false -- Ник найден (изначально false)
  local empty -- Таблица пуста?


  -- Проверка пустая таблица или нет
  if(#admins == 1) then
    if(admins[1] == "пусто") then
      empty = true
      print("Таблица пуста! = кол-во эл-ов таблицы: " .. #admins .. ", первый элемент: " .. admins[1])
    else
      empty = false
      print("Таблица не пуста! = кол-во эл-ов таблицы: " .. #admins .. ", первый элемент: " .. admins[1])
    end
  else
    empty = false
    print("Таблица не пуста! = кол-во эл-ов таблицы: " .. #admins .. ", первый элемент: " .. admins[1])
  end


  -- Если таблица не пуста
  if(empty == false) then
    
    -- Поиск ника среди admins
    for i = 1, #admins do
      if(admins[i] == nick) then  -- Если ник найден в базе
        
        found = true  -- Игрок найден!

        print("Ник найден в таблице! = место в таблице: " .. i .. ", ник в базе: " .. admins[i])
  
        break -- Прекратить поиск игрока
      end
    end

  end

  if(found == false) then
    print("Ник не найден в таблице! Ник: " .. nick)
  end
  

  return empty, found
end





-- Получение прав администратора
function access.Get(nick, admins)


  local empty, found = access.FindNick(nick, admins)


  -- Если таблица пуста
  if(empty) then
    
    say(nick .. ", вам присвоены права!")
    admins = data.Update(nick, "admins", "add") -- Вызов функции записи в конфиг

  -- Если таблица не пуста
  else

    if found then -- Если ник найден
      say(nick .. ", у вас уже есть права!")
    else  -- Если ник не найден
      say(nick .. ", у вас нет прав на использование этой команды!")
    end

  end



  return admins
end



return access