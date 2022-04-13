local cipher = {}
local encrypt = require("component").cipher.encrypt


-- Функции
function string.lower ( str ) return str:gsub ( "([A-ZА-ЯЁ])", function ( c ) return string.char ( string.byte ( c ) + ( c == 'ё' and 16 or 32 ) ) end ) end
-- Конец функций



-- Шифрование пароля
function cipher.Encrypt()
    local word = "password" -- Кодовое слово


    local encrypted_word = string.lower(encrypt(word)) -- Зашифрованное кодовое слово
    encrypted_word = encrypted_word:sub(1, encrypted_word:len()-2)  -- Убрать последние 2 символа (==)


    local mid = math.floor((encrypted_word:len()/2)+0.5)    -- Вычисление середины кодового слова

    local pw_start = encrypted_word:sub(1, 2)   -- 2 символа в начале
    local pw_middle = encrypted_word:sub(mid, mid) -- 1 символ в середине (Округление числа и поиск)
    local pw_end = encrypted_word:sub(encrypted_word:len()-1, encrypted_word:len()) -- 2 символа в конце


    local password = pw_start .. pw_middle .. pw_end    -- Пароль (5 знаков)


    return password
end


-- Проверка пароля
function cipher.CheckPassword(code)
    local password = cipher.Encrypt()   -- Получение пароля
    
    local correct = false

    if(password == code) then
        correct = true
    end

    return correct
end