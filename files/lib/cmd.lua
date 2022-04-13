local cmd = {}
local say = require("component").chat_box.say
-- Библиотеки команд
local access = require("access")  -- Библиотека прав администратора
local cipher = require("cipher")  -- Библиотека шифрования




-- Команды
function cmd.Commands(nick, msg, ai_vers, ai_name, auth_users, admins)
  
  local NewAU = access.Line(auth_users)
  local NewAdm = access.Line(admins)



  -- Команды
  local correct = access.CheckCorrect(nick, NewAU) -- Проверка авторизован ли пользователь
  if (correct == true and #msg >=1) then



    -- Авторизация
    if(msg[1] == "auth" or msg[1] == "deauth") then
      if(msg[1] == "auth") then -- Авторизация игрока

        if(msg[2] == nil and #msg == 1) then  -- Если ник игрока не введён
          auth_users = access.Auth(nick, auth_users, admins)  -- Запись ника в таблицу
        elseif(msg[2] ~= nil and #msg == 2) then  -- Если ник игрока введён
          auth_users = access.Auth(nick, auth_users, admins, msg[2])  -- Запись ника в таблицу
        else
          say(nick .. ", введна не корректная команда. Список комманд можно узнать командой: help")
        end

      elseif(msg[1] == "deauth") then -- Деавторизация игрока

        if(msg[2] == nil and #msg == 1) then  -- Если ник игрока не введён
          auth_users = access.Deauth(nick, auth_users, admins)
        elseif(msg[2] ~= nil and #msg == 2) then  -- Если ник игрока введён
          auth_users = access.Deauth(nick, auth_users, admins, msg[2])
        else
          say(nick .. ", введна не корректная команда. Список комманд можно узнать командой: help")
        end

      end
    -- Права администратора
    elseif(msg[1] == "admin" and msg[2] == "rights" and #msg >= 2) then
      if(msg[3] == "set") then  -- Выдача прав администратора
        if(msg[4] ~= nil) then  -- Выдача игроку
          auth_users, admins = access.AdminSet(nick, auth_users, admins)
        else  -- Выдача другому игроку
          auth_users, admins = access.AdminSet(nick, auth_users, admins, msg[4])
        end
      elseif(msg[3] == "delete") then -- Удаление прав администратора
        if(msg[4] ~= nil) then  -- Удаление игроку
          admins = access.AdminSet(nick, auth_users, admins)
        else  -- Удаление другому игроку
          admins = access.AdminSet(nick, auth_users, admins, msg[4])
        end
      else  -- Ошибка ввода данных
        say(nick .. ", введите один из аргументов: get/set <никнейм>")
      end
    -- Список команд
    elseif(msg[1] == "help" and #msg == 1) then
      say("Список команд:\n"..
          "help - посмотреть список команд" ..
          "auth <ник> - авторизация пользователя. Если не введён ник, то авторизует автора команды. Для деавторизации - deauth" ..
          "admin rights <set/delete> <ник/me> - выдать/удалить права администратора (только для администраторов системы)")
    -- Получение админки с помощью пароля (если админов нет)
    elseif(msg[1] == "get_adm" and #msg == 2) then
      local pw_correct = cipher.CheckPassword(msg[2]) -- Проверка правильности пароля
      if pw_correct then  -- Если пароль верный
        -- Если админов нет
        if(NewAdm == "пусто") then
          -- Выдаёт права администратора игроку
          admins = access.AdminGet(nick, admins)  -- Выдача прав администратора
          NewAdm = access.Line(admins)  -- Обновление списка ников
        else  -- Если пароль не верный
          -- Проверка ник игрока в списке или нет
          local adm_cor = access.CheckCorrect(nick, NewAdm)
          if adm_cor then -- Если в списке есть ник игрока
            say(nick .. ", у вас уже есть права!")
          else  -- Если в списке нет ника игрока
            say(nick .. ", получение прав администратора по паролю доступно только если в системе нет ни одного администратора!")
          end
        end
      else
        say(nick .. ", введённый вами пароль не верен! Возможно, он был изменён.")
      end
    -- Ни одна команда не введена правильно
    else
      say(nick, "введена неверная команда! Список комманд можно узнать командой: help")
    end


  -- Получение прав администратора, если администраторов нет
  elseif(correct == false and #msg == 2) then
    
    

    if(msg[1] == "get_adm") then
      local pw_correct = cipher.CheckPassword(msg[2])  -- Проверка правильности пароля
      if pw_correct then  -- Если пароль верный
        

        -- Если админов нет
        if(NewAdm == "пусто") then
          -- Выдаёт права администратора игроку
          admins = access.AdminGet(nick, admins)  -- Выдача прав администратора
          NewAdm = access.Line(admins)  -- Обновление списка ников

          -- Занесение в Авторизованные пользователи
          auth_users = access.Auth(nick, auth_users, admins)  -- Авторизация
          NewAU = access.Line(auth_users) -- Обновление списка ников
        else  -- Если пароль не верный
          -- Проверка ник игрока в списке или нет
            local adm_cor = access.CheckCorrect(nick, NewAdm)
            if adm_cor then -- Если в списке есть ник игрока
              say(nick .. ", у вас уже есть права!")
            else  -- Если в списке нет ника игрока
              say(nick .. ", получение прав администратора по паролю доступно только если в системе нет ни одного администратора!")
            end
        end


      else
        say(nick .. ", введённый вами пароль не верен! Возможно, он был изменён.")
      end
    end

    
    
  end





  return ai_vers, ai_name, auth_users, admins
end



return cmd