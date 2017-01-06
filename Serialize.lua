local testTB = {"hello", ["key"] = {3, 4},  55};

local szRet = "";

function SaveValue2Buffer(value)
	local szBuf = "";

    if type(value) == "number" then         -- number
        if math.floor(value) == value then  
            if value >= 0 and value <= 9 then           -- '0'-'9' -> 0-9
                szRet = szRet .. tostring(value+48)             

            elseif value >= 0 and value <= 0xff then    -- 'b' -> BYTE
                szRet = szRet .. "b"
                szRet = szRet .. tostring(value)

            elseif value >= 0 and value <= 0xffff then  -- 'w' -> WORD
                szRet = szRet .. "w"
                szRet = szRet .. tostring(value)
            
            else    
                szRet = szRet .. "d"
                szRet = szRet .. tostring(value)
            end
        else
            szRet = szRet .. "n"
            szRet = szRet .. tostring(value)
        end
   
    elseif type(value) == "string" then 
        local nStrLen = string.len(value);
		szRet = szRet .. "s"
        szRet = szRet .. tostring(nStrLen)
		szRet = szRet .. value

    elseif type(value) == "table" then
        SaveTable2Buffer(value);

    end
end

function SaveTable2Buffer(tbValue)
	szRet = szRet .. "{";
	
	local tbKey = {};
    -- array
    for i, value in ipairs (tbValue) do
        tbKey[i] = 1;
        SaveValue2Buffer(value);
    end
	
	-- hash
    local nSplit = 0;
    for key, value in pairs (tbValue) do
        if not tbKey[key] then
            tbKey[key] = 1;
            if nSplit == 0 then
                szRet = szRet .. ";"

                nSplit = 1;
            end
                     
            SaveValue2Buffer(key);         -- key
            SaveValue2Buffer(value);       -- value          
        end
    end
	
	szRet = szRet .. "}";
	
end

SaveTable2Buffer(testTB)
print(szRet)
