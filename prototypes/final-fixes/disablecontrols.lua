if data.raw["custom-input"] and data.raw["custom-input"]["rename"] then
    data.raw["custom-input"]["rename"].enabled = false
end

if data.raw["custom-input"] and data.raw["custom-input"]["toggle-train-control"] then
    data.raw["custom-input"]["toggle-train-control"].enabled = false
end

if data.raw["custom-input"] and data.raw["custom-input"]["honk"] then
    data.raw["custom-input"]["honk"].enabled = false
end
