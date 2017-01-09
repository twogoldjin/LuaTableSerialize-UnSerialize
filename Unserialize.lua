---------------------------
---- not completed. just logic. need bit operation. by twogold
-----------------------------


local szTxt = "{s5hellob55;s3key{5152}}";

function LoadBuffer2Value(ParamBuffer, szFlag)
    local szFlag = szFlag or ParamBuffer:ReadStringByLen(1);

    if szFlag == 'N' then
        return nil

    elseif szFlag == 'T' then
        return true

    elseif szFlag == 'F' then
        return false

    elseif szFlag == 'b' then
        --assert(ParamBuffer:GetLength() >= 2)

        local value = ParamBuffer:ReadByte();
        --log("b>>>>>"..value)

        return value

    elseif szFlag == 'w' then
        --assert(ParamBuffer:GetLength() >= 3)

        local value = ParamBuffer:ReadShort();
        --log("w>>>>>"..value)

        return value

    elseif szFlag == 'd' then
        --assert(ParamBuffer:GetLength() >= 5)
        local value = ParamBuffer:ReadUInt();
        --log("d>>>>>"..value)

        return value

    elseif szFlag == 'n' then
        local value = ParamBuffer:ReadLong();
        --log("n>>>>>")

        return value

    elseif szFlag == 's' then
        --assert(ParamBuffer:GetLength() >= 3)
        local nStrLen = ParamBuffer:ReadShort()
        --assert(ParamBuffer:GetLength() >= 3 + nStrLen)

        local value = ParamBuffer:ReadStringByLen(nStrLen);
        --log("s>>>>>"..value)

        return value

    elseif szFlag == '{' then

        return self:LoadBuffer2Table(ParamBuffer)

    end

    if (tonumber(szFlag) >= 0 and tonumber(szFlag) <= 9) then
        return tonumber(szFlag);
    end

    return
end

function LoadBuffer2Table(ParamBuffer)
    local t, idx = {}, 1
    local szFlag = "";
    -- array 处理
    while true do 
        szFlag = string.sub(1,1);
		ParamBuffer = string.sub(2, string.len(ParamBuffer))

        if szFlag == ';' then
            break;
        end
        if szFlag == '}' then
            break;
        end

        t[idx] = LoadBuffer2Value(ParamBuffer, szFlag);       
	    idx = idx + 1;
    end

    -- hash处理
    local nFlag = 0;
    local k, v;
    while szFlag ~= '}' do  
        if nFlag == 0 then
            k = LoadBuffer2Value(ParamBuffer);
        else 
            k = LoadBuffer2Value(ParamBuffer, szFlag);
        end

        v = LoadBuffer2Value(ParamBuffer);

        t[k] = v;

        szFlag = string.sub(1,1);
		ParamBuffer = string.sub(2, string.len(ParamBuffer))

        nFlag = 1;
    end

    return t;
end

LoadBuffer2Table(szTxt);
