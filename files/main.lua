local component = require("component")
local term = require("term")
local event = require("event")
local unicode = require("unicode")
local fs = require("filesystem")

local gpu = component.gpu


local say = component.chat_box.say

-- Библиотеки
local data = require("data")  -- Библиотека данных
local cmd = require("cmd")  -- Библиотека команд


term.clear()  -- Очистка экрана


local ai_vers, ai_name, auth_users, admins = data.Get()  -- Получение данных из библиотеки даты
print("Admins:\n")
for i = 1, #admins do
  print(admins[i])
end

component.chat_box.setName(ai_name[1])  -- Установить имя для ИИ на чатбокс


--[[
say("Идёт загрузка системы.")
os.sleep(10)
say("Загрузка успешно завершена.")
os.sleep(1)
say("Приветствую!")
]]--



-- Функции
-- Функция чтения чата
function ReadChat()
  local _, add, nick, msg = event.pull("chat_message")

  return nick, msg
end
-- Конец функций


local Cycle = true

-- Постоянный код
while Cycle do
  local nick, msg = ReadChat()
  ai_vers, ai_name, auth_users, admins = cmd.Commands(nick, msg, ai_vers, ai_name, auth_users, admins)
end