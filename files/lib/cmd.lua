local cmd = {}
-- Библиотеки команд
local access = require("access")  -- Библиотека прав администратора

-- Проверка есть ли имя ИИ в тексте на 1 месте 
function cmd.CheckNAI(msg, ai_name)
  local n_in_text = false
  for i = 1, #ai_name do

    if(string.find(msg, ai_name[i])) then
      n_in_text = true
      break
    end
  
  end


  return n_in_text
end



-- Команды
function cmd.Commands(nick, msg, ai_vers, ai_name, auth_users, admins)
  
  local f = cmd.CheckNAI(msg, ai_name)
  if f then


    -- Команды связанные с правами администратора
    if(string.find(msg, "права администратора") ~= nil) then
      if(string.find(msg, "выдать") ~= nil or string.find(msg, "выдай") ~= nil) then
        admins = access.Get(nick, msg, admins)
      end
    end


  end

  return ai_vers, ai_name, auth_users, admins
end



return cmd