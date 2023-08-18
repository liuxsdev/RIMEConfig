local function translator(input, seg)
    -- https://github.com/Mintimate/oh-my-rime/blob/main/Lua/date.lua
    local function create_candidate(date_str, comment)
        -- local candidate = Candidate(type, start, end, text, comment)
        local candidate = Candidate("date", seg.start, seg._end, date_str, comment)
        candidate.quality = 100
        yield(candidate)
    end
    if (input == "date" or input == "riqi") then
        create_candidate(os.date("%Y年%m月%d日"),'📅️')
        create_candidate(os.date("%Y-%m-%d"),'📅️')
    end
end

return translator