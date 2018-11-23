local Data = require('stdlib/data/data')

local marker_beams = util.table.deepcopy(data.raw['beam']['electric-beam-no-sound'])
marker_beams.name = 'picker-pointer-beam'
marker_beams.width = 1.0
marker_beams.damage_interval = 2000000000
marker_beams.action = nil
marker_beams.start = {
    filename = '__core__/graphics/empty.png',
    line_length = 1,
    width = 1,
    height = 1,
    frame_count = 1,
    axially_symmetrical = false,
    direction_count = 1,
    hr_version = {
        filename = '__core__/graphics/empty.png',
        line_length = 1,
        width = 1,
        height = 1,
        frame_count = 1,
        axially_symmetrical = false,
        direction_count = 1
    }
}
marker_beams.ending = {
    filename = '__core__/graphics/empty.png',
    line_length = 1,
    width = 1,
    height = 1,
    frame_count = 1,
    axially_symmetrical = false,
    direction_count = 1,
    hr_version = {
        filename = '__core__/graphics/empty.png',
        line_length = 1,
        width = 1,
        height = 1,
        frame_count = 1,
        axially_symmetrical = false,
        direction_count = 1
    }
}
     --
    -- TODO 0.17 version
    --[[marker_beams.ending = {
        filename = "__PickerPipeTools__/graphics/entity/markers/" .. marker_name.box .. ".png",
        line_length = 1,
        width = 64,
        height = 64,
        frame_count = 1,
        axially_symmetrical = false,
        direction_count = 1,
        --shift = {-0.03125, 0},
        scale = 0.5,
        hr_version =
        {
            filename = "__PickerPipeTools__/graphics/entity/markers/" .. marker_name.box .. ".png",
            line_length = 1,
            width = 64,
            height = 64,
            frame_count = 1,
            axially_symmetrical = false,
            direction_count = 1,
            --shift = {0.53125, 0},
            scale = 0.5
        }
    }]]
marker_beams.head = {
    filename = '__PickerExtended__/graphics/entity/markers/beam-arrow.png',
    line_length = 1,
    width = 64,
    height = 64,
    frame_count = 1,
    animation_speed = 1,
    scale = 0.5
}
marker_beams.tail = {
    filename = '__PickerExtended__/graphics/entity/markers/beam-arrow.png',
    line_length = 1,
    width = 64,
    height = 64,
    frame_count = 1,
    animation_speed = 1,
    scale = 0.5
}
marker_beams.body = {
    {
    filename = '__core__/graphics/empty.png',
    line_length = 1,
    width = 1,
    height = 1,
    frame_count = 1,
    animation_speed = 1,
    --direction_count = 1
    }
}
data:extend({marker_beams})
--[[marker_beams.body = {
    {
        filename = '__PickerPipeTools__/graphics/entity/markers/' .. marker_name.dash .. '.png',
        line_length = 1,
        width = 64,
        height = 64,
        frame_count = 1,
        scale = 0.5
    }
}]]--

Data {type = 'custom-input', name = 'picker-dude-wheres-my-car', key_sequence = 'CONTROL + SHIFT + J'}
Data {type = 'custom-input', name = 'picker-toggle-train-control', key_sequence = 'J'}
Data {type = 'custom-input', name = 'picker-goto-station', key_sequence = 'J'}
Data {type = 'custom-input', name = 'picker-goto-next-station', key_sequence = 'SHIFT + J'}
Data {type = 'custom-input', name = 'picker-honk', key_sequence = 'H'}

Data {type = 'sound', name = 'deltic-start', filename = '__PickerExtended__/sounds/deltic_honk_1.ogg'}
Data {type = 'sound', name = 'deltic-stop', filename = '__PickerExtended__/sounds/deltic_honk_2.ogg'}
Data {type = 'sound', name = 'train-stop', filename = '__PickerExtended__/sounds/honk_long.ogg'}
Data {type = 'sound', name = 'train-start', filename = '__PickerExtended__/sounds/honk_2x.ogg'}
Data {type = 'sound', name = 'car-horn', filename = '__PickerExtended__/sounds/horn_honk.ogg'}
