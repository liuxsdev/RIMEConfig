local function translator(input, seg)
    -- https://github.com/Mintimate/oh-my-rime/blob/main/Lua/date.lua
    local function create_candidate(date_str, comment)
        -- local candidate = Candidate(type, start, end, text, comment)
        local candidate = Candidate("time", seg.start, seg._end, date_str, comment)
        candidate.quality = 100
        yield(candidate)
    end
    if (input == "time" or input == "uijm") then
        create_candidate(os.date("%H:%M:%S"),'⏲️')
    end
end

return translator