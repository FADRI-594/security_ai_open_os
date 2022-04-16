local component = require("component")
local term = require("term")
local event = require("event")

-- Компоненты
local gpu = component.gpu
local say = component.chat_box.say

-- Библиотеки
local data = require("data")  -- Библиотека данных
local cmd = require("cmd")  -- Библиотека команд




term.clear()  -- Очистка экрана



local ai_vers, ai_name, auth_users, admins = data.Get()  -- Получение данных из библиотеки даты

component.chat_box.setName(ai_name[1])  -- Установить имя для ИИ на чатбокс





-- Функции
-- Функция lower
function string.lower ( str ) return str:gsub ( "([A-ZА-ЯЁ])", function ( c ) return string.char ( string.byte ( c ) + ( c == 'ё' and 16 or 32 ) ) end ) end


-- Функция разбиения сообщений
function SplitMessage(msg)
  local new_msg = {}

  local i = 1
  for s in string.gmatch(msg, "[^ ]+") do
    new_msg[i] = s
    i = i+1
  end

  return new_msg
end


-- Функция чтения чата
function ReadChat()
  local _, add, nick, msg = event.pull("chat_message")

  msg = string.lower(msg)

  local new_msg = SplitMessage(msg)

  return nick, new_msg
end
-- Конец функций







-- Постоянный код
while true do
  local nick, msg = ReadChat()

  -- Проверка если команда (если перед текстом стоит '#')
  if(string.sub(msg[1], 1, 1) == "#") then
    msg[1] = string.sub(msg[1], 2)
    ai_vers, ai_name, auth_users, admins = cmd.Commands(nick, msg, ai_vers, ai_name, auth_users, admins)
  end
end