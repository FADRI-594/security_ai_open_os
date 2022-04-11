local component = require("component")
local sides = require("sides")
local term = require("term")
local event = require("event")
local unicode = require("unicode")
local fs = require("filesystem")

local gpu = component.gpu


-- Библиотеки
local data = require("/home/lib/data")  -- Библиотека данных
local cmd = require("/home/lib/cmd")  -- Библиотека команд


term.clear()  -- Очистка терминала


local ai_vers, ai_name, auth_users, admins = data.Get()  -- Получение данных из библиотеки даты


component.chat_box.setName(ai_name[0])  -- Установить имя для ИИ на чатбокс


component.chat_box.say("Идёт загрузка системы.")
os.sleep(10)
component.chat_box.say("Загрузка успешно завершена.")
os.sleep(1)
component.chat_box.say("Приветствую!")



-- Функции
-- Функция чтения чата
function ReadChat()
  local _, add, nick, msg = event.pull("chat_message")
  msg = string.lower(msg)

  return nick, msg
end
-- Конец функций

local Cycle = true


-- Постоянный код
while Cycle do
  local nick, msg = ReadChat()
  cmd.Commands(nick, msg, ai_name, admins)
end