local animate = {}

-- Библиотеки
local paint = require("paint")  -- Библиотека рисования изображения на экране
local images = require("images")    -- Библиотека изображения



-- Функция анимации
function animate.AnimEye()
    local Eye = images.Eye  -- Исходное изображение

    -- Изображения для анимации
    local AnimEye1 = images.AnimEye1
    local AnimEye2 = images.AnimEye2
    local AnimEye3 = images.AnimEye3
    local AnimEye4 = images.AnimEye4
    local AnimEye5 = images.AnimEye5
    local AnimEye6 = images.AnimEye6



    local anim = {Eye, AnimEye1, AnimEye2, AnimEye3, AnimEye4, AnimEye5, AnimEye6}
    
    
    


    paint.Output(anim[1].img, anim[1].mirror, anim[1].horizontal, anim[1].vertical) -- Вызов функции рисования



    -- Анимация изображения
    for i = 1, #anim do
        paint.ClearScreen()
        paint.Output(anim[i].img, anim[i].mirror, anim[i].horizontal, anim[i].vertical) -- Вызов функции рисования
    end
    os.sleep(0.5)
    for i = #anim, 1, -1 do
        paint.ClearScreen()
        paint.Output(anim[i].img, anim[i].mirror, anim[i].horizontal, anim[i].vertical) -- Вызов функции рисования
    end
    os.sleep(0.5)



    return
end



return animate