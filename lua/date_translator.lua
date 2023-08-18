local function translator(input, seg)
    if (input == "date" or input == "riqi") then
       --- Candidate(type, start, end, text, comment)
       yield(Candidate("date", seg.start, seg._end, os.date("%Y年%m月%d日"), " 📅️"))
       yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), " 📅️"))
    end
end
 
return translator