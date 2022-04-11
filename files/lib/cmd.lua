local cmd = {}
-- Библиотеки команд
local access = require("access")  -- Библиотека прав администратора

-- Команды
function cmd.Commands(nick, msg, ai_vers, ai_name, auth_users, admins)
  for k, s in pairs(ai_name) do
    if(string.find(msg, s) == 1) then
      

      -- Команды связанные с правами администратора
      if(string.find(msg, "права администратора") ~= nil) then
        if(string.find(msg, "выдать") ~= nil or string.find(msg, "выдай") ~= nil) then
          access.Get(nick, msg, admins)
        end
      end


      break
    end
  end
  return ai_vers, ai_name, auth_users, admins
end



return cmd