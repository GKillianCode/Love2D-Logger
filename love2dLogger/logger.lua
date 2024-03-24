-- Définir la classe
Love2dLogger = {}
Love2dLogger.__index = Love2dLogger

-- Constructeur
function Love2dLogger.new(initData)
    local self = setmetatable({}, Love2dLogger)

    local DEFAULT_SEPARATION_CHAR = "-"
    local DEFAULT_ALERT_LEVEL = 10
    local DEFAULT_SCREEN_DISPLAY_VALUE = false
    local PATH = "logs/"
    local SCREEN_WIDTH = nil
    local SCREEN_HEIGHT = nil

    local separationChar = initData.separationChar or DEFAULT_SEPARATION_CHAR
    local alertLevel = initData.alertLevel or DEFAULT_ALERT_LEVEL
    local screenDisplay = initData.screenDisplay or false
    local alertLevels = {
        ERROR = {
            name = "ERROR",
            priority = 1
        },
        WARN = {
            name = "WARN",
            priority = 2
        },
        INFO = {
            name = "INFO",
            priority = 3
        },
        TRACE = {
            name = "TRACE",
            priority = 4
        },
        DEBUG = {
            name = "DEBUG",
            priority = 5
        }
    }
    local logs = {}

    local function checkSeparationCharValue()
        if #separationChar < 1 then
            separationChar = DEFAULT_SEPARATION_CHAR
            self.warn("Error with separationChar value replace by default value")
        end
    end

    local function checkAlertLevelValue()
        if type(alertLevel) ~= "number" or alertLevel % 1 ~= 0 then
            alertLevel = DEFAULT_ALERT_LEVEL
            self.warn("Error with alertLevel value replace by default value")
        end
    end

    local function checkScreenDisplayValue()
        if type(screenDisplay) ~= "boolean" then
            screenDisplay = DEFAULT_SCREEN_DISPLAY_VALUE
            self.warn("Error with screenDisplay value replace by default value")
        end
    end

    local function checkData()
        checkSeparationCharValue()
        checkAlertLevelValue()
        checkScreenDisplayValue()
    end

    local function checkIfFileExists(fileName)
        local logFolderExists = love.filesystem.getInfo(PATH)
        if logFolderExists == nil then
            success = love.filesystem.createDirectory(PATH)
            if not success then
                error("Error with logs folder")
            end
        end

        local logFileExists = love.filesystem.getInfo(PATH .. fileName)

        if logFileExists == nil then
            local file = love.filesystem.newFile(PATH .. fileName)
            local openedSuccessfully, err = file:open("w")

            if openedSuccessfully then
                file:write("")
                file:close()
            end
        end
    end

    local function initStartTrace(fileName)
        local file = love.filesystem.newFile(PATH .. fileName)
        local openedSuccessfully, err = file:open("a") -- replace with "a"

        if openedSuccessfully then
            file:write("\n-----------------------------------------")
            file:close()
        end
    end

    function createLog(alertType, content)
        local log = {}
        log.x = 20
        log.y = SCREEN_HEIGHT - 50
        log.data = ""
        log.delete = false

        local currentDate = os.date("%Y-%m-%d")
        local currentDateTime = os.date("%Y-%m-%d %H:%M:%S")
        local FILE_NAME = "log-" .. currentDate .. ".txt"

        local alert = alertLevels[alertType]
        if alert.priority >= 0 and alert.priority <= alertLevel then
            log.data = "\n" .. currentDateTime .. " " .. separationChar .. " " .. alert.name .. " " .. separationChar ..
                           " " .. content
        end

        for i = #logs, 1, -1 do
            local log = logs[i]
            log.y = log.y - 20
        end

        table.insert(logs, log)
    end

    local function init()
        local currentDate = os.date("%Y-%m-%d")
        local FILE_NAME = "log-" .. currentDate .. ".txt"

        SCREEN_WIDTH = love.graphics.getWidth()
        SCREEN_HEIGHT = love.graphics.getHeight()

        checkIfFileExists(FILE_NAME)
        initStartTrace(FILE_NAME)
    end

    function self.update(dt)
        if screenDisplay then

            for i = #logs, 1, -1 do
                local log = logs[i]

                if log.y < -20 then
                    log.delete = true
                end
            end

            for i = #logs, 1, -1 do
                local log = logs[i]

                if log.delete then
                    table.remove(logs, i)
                end
            end

        end
    end

    function self.draw()
        for i = #logs, 1, -1 do
            love.graphics.print(logs[i].data, logs[i].x, logs[i].y)
        end
    end

    local function consolePrint(alertType, content)
        local currentDateTime = os.date("%Y-%m-%d %H:%M:%S")

        local alert = alertLevels[alertType]
        if alert.priority >= 0 and alert.priority <= alertLevel then
            local log = currentDateTime .. " " .. separationChar .. " " .. alert.name .. " " .. separationChar .. " " ..
                            content
            print(log)
        end
    end

    local function logPrint(alertType, content)
        local currentDate = os.date("%Y-%m-%d")
        local currentDateTime = os.date("%Y-%m-%d %H:%M:%S")
        local FILE_NAME = "log-" .. currentDate .. ".txt"

        local alert = alertLevels[alertType]
        if alert.priority >= 0 and alert.priority <= alertLevel then
            local log =
                "\n" .. currentDateTime .. " " .. separationChar .. " " .. alert.name .. " " .. separationChar .. " " ..
                    content

            local file = love.filesystem.newFile(PATH .. FILE_NAME)
            local openedSuccessfully, err = file:open("a")

            if openedSuccessfully then
                file:write(log)
                file:close()
            end
        end
    end

    function self.debug(content)
        logPrint("DEBUG", content)
        consolePrint("DEBUG", content)
        if (screenDisplay) then
            createLog("DEBUG", content)
        end
    end
    function self.trace(content)
        logPrint("TRACE", content)
        consolePrint("TRACE", content)
        if (screenDisplay) then
            createLog("TRACE", content)
        end
    end
    function self.info(content)
        logPrint("INFO", content)
        consolePrint("INFO", content)
        if (screenDisplay) then
            createLog("INFO", content)
        end
    end
    function self.warn(content)
        logPrint("WARN", content)
        consolePrint("WARN", content)
        if (screenDisplay) then
            createLog("WARN", content)
        end
    end
    function self.error(content)
        logPrint("ERROR", content)
        consolePrint("ERROR", content)
        if (screenDisplay) then
            createLog("ERROR", content)
        end
    end

    function self.newErrorLevel(name, priority)
        local nameWithoutWhiteSpaces = string.gsub(name, " ", "-")
        local errorNameUppercase = string.upper(nameWithoutWhiteSpaces):gsub("-(%w)", "_%1"):gsub("-", "")
        local errorNameCamelCase = string.lower(nameWithoutWhiteSpaces):gsub("-(%w)", string.upper):gsub("-", "")

        if type(name) ~= "string" then
            error("Error level must be a string")
        end

        if type(priority) ~= "number" then
            error("Priority must be an integer")
        end

        alertLevels[errorNameUppercase] = {
            name = errorNameUppercase,
            priority = priority
        }

        logger[errorNameCamelCase] = function(content)
            logPrint(errorNameUppercase, content)
            consolePrint(errorNameUppercase, content)
            if (screenDisplay) then
                createLog(errorNameUppercase, content)
            end
        end
    end

    checkData()
    init()

    return self
end
