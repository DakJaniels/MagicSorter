---@class MDebugLogger
local MDebugLogger = {}

---@class NOP
---@field Debug fun(self: NOP, message: string, ...: any)
---@field Info fun(self: NOP, message: string, ...: any)
---@field Warn fun(self: NOP, message: string, ...: any)
---@field Error fun(self: NOP, message: string, ...: any)
local NOP = {}

--- Debug logger function that falls back to df()
---@param message string The message to log
---@param ... any Additional values to format into message
function NOP:Debug(message, ...)
    if select("#", ...) > 0 then
        df(message, ...)
    else
        d(message)
    end
end

--- Info logger function that falls back to df()
---@param message string The message to log
---@param ... any Additional values to format into message
function NOP:Info(message, ...)
    if select("#", ...) > 0 then
        df(message, ...)
    else
        d(message)
    end
end

--- Warning logger function that falls back to df()
---@param message string The message to log
---@param ... any Additional values to format into message
function NOP:Warn(message, ...)
    if select("#", ...) > 0 then
        df(message, ...)
    else
        d(message)
    end
end

--- Error logger function that falls back to df()
---@param message string The message to log
---@param ... any Additional values to format into message
function NOP:Error(message, ...)
    if select("#", ...) > 0 then
        df(message, ...)
    else
        d(message)
    end
end

local logger
local debugEnabled = false
local useNOP = false

function MDebugLogger:Initialize()
    if not logger then
        if LibDebugLogger then
            logger = LibDebugLogger("MagicSorter")
            useNOP = false
        else
            logger = NOP
            useNOP = true
        end
    end
end

function MDebugLogger:GetLogger()
    if not logger then
        self:Initialize()
    end
    return logger
end

function MDebugLogger:SetDebugEnabled(enabled)
    debugEnabled = enabled
    local log = self:GetLogger()
    if not useNOP and log.SetMinLevelOverride and log.SetEnabled then
        if enabled then
            log:SetMinLevelOverride(LibDebugLogger.LOG_LEVEL_DEBUG)
            log:SetEnabled(true)
        else
            log:SetMinLevelOverride(nil)
            log:SetEnabled(false)
        end
    end
end

function MDebugLogger:ToggleDebug()
    local enabled = not debugEnabled
    self:SetDebugEnabled(enabled)
    local log = self:GetLogger()
    log:Info("Sort Manager: Debug is %s.", enabled and "enabled" or "disabled")
end

function MDebugLogger:IsDebugEnabled()
    return debugEnabled
end

function MDebugLogger:TableToString(t, output, depth)
    if not output then
        output = {}
        depth = 1
    end
    local tType = type(t)
    if tType == "nil" then
        table.insert(output, "nil")
    elseif tType == "string" then
        if #t > 20 then
            t = string.sub(t, 1, 20) .. "..."
        end
        table.insert(output, string.format("\"%s\"", t))
    elseif tType == "function" then
        table.insert(output, "[function]")
    elseif tType ~= "table" then
        table.insert(output, tostring(t))
    else
        if depth <= 3 then
            table.insert(output, "{")
            for key, value in pairs(t) do
                self:TableToString(key, output, depth + 1)
                table.insert(output, ":")
                self:TableToString(value, output, depth + 1)
                table.insert(output, ", ")
            end
            table.insert(output, "}")
        else
            table.insert(output, "[nested table]")
        end
    end
    if depth == 1 then
        return table.concat(output)
    end
end

function MDebugLogger:FormatParams(...)
    local params = { ... }
    local formatted = {}
    for paramIndex, param in ipairs(params) do
        local t = type(param)
        if t == "nil" then
            formatted[paramIndex] = "nil"
        elseif t ~= "table" then
            formatted[paramIndex] = tostring(param)
        else
            formatted[paramIndex] = self:TableToString(param)
        end
    end
    return formatted
end

function MDebugLogger:WriteDebug(message, ...)
    if not message or not debugEnabled then
        return
    end
    local log = self:GetLogger()
    local numArgs = select("#", ...)
    if numArgs == 0 then
        log:Debug(message)
    else
        local formatted = self:FormatParams(...)
        log:Debug(message, unpack(formatted))
    end
end

function MDebugLogger:WriteDebugArguments(message, ...)
    if not message or not debugEnabled then
        return
    end
    local log = self:GetLogger()
    local numArgs = select("#", ...)
    if numArgs == 0 then
        self:WriteDebug(message)
    else
        local formatted = self:FormatParams(...)
        local argsStr = {}
        for _, param in ipairs(formatted) do
            table.insert(argsStr, tostring(param))
        end
        local fullMessage = string.format("%s(%s)", message, table.concat(argsStr, ", "))
        log:Debug(fullMessage)
    end
end

function MDebugLogger:WriteDebugCall(procedureName, ...)
    if not procedureName or not debugEnabled then
        return
    end
    local log = self:GetLogger()
    local numArgs = select("#", ...)
    if numArgs == 0 then
        log:Debug("Call %s", procedureName)
    else
        local formatted = self:FormatParams(...)
        local argsStr = {}
        for _, param in ipairs(formatted) do
            table.insert(argsStr, tostring(param))
        end
        log:Debug("Call %s(%s)", procedureName, table.concat(argsStr, ", "))
    end
end

function MDebugLogger:WriteDebugReturn(procedureName, ...)
    if not procedureName or not debugEnabled then
        return
    end
    local log = self:GetLogger()
    local numArgs = select("#", ...)
    if numArgs == 0 then
        log:Debug("Return %s", procedureName)
    else
        local formatted = self:FormatParams(...)
        local argsStr = {}
        for _, param in ipairs(formatted) do
            table.insert(argsStr, tostring(param))
        end
        log:Debug("Return %s: %s", procedureName, table.concat(argsStr, ", "))
    end
end

-- Convenience methods for different log levels
function MDebugLogger:Info(message, ...)
    local log = self:GetLogger()
    local numArgs = select("#", ...)
    if numArgs == 0 then
        log:Info(message)
    else
        log:Info(message, ...)
    end
end

function MDebugLogger:Warn(message, ...)
    local log = self:GetLogger()
    local numArgs = select("#", ...)
    if numArgs == 0 then
        log:Warn(message)
    else
        log:Warn(message, ...)
    end
end

function MDebugLogger:Error(message, ...)
    local log = self:GetLogger()
    local numArgs = select("#", ...)
    if numArgs == 0 then
        log:Error(message)
    else
        log:Error(message, ...)
    end
end

-- Helper to strip ESO color codes from messages
function MDebugLogger:StripColorCodes(message)
    if type(message) ~= "string" then
        return message
    end
    -- Remove ESO color codes like |cff0000, |r, etc.
    return string.gsub(message, "|c[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]", "")
        :gsub("|r", "")
end

MAGIC_SORTER_DEBUG_LOGGER = MDebugLogger
