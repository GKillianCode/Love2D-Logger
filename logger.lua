if pcall(require, "lldebugger") then require("lldebugger").start() end
io.stdout:setvbuf("no")

local logger = {
    separationChar = "|",
    alertLevelView = 10,
    showLoggerinfo = true,
    alertLevel = {
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
        },
        LOGGERINFO = {
            name = "LOGGERINFO",
            priority = 0
        },
    }
}

function logger.print(alertType, text)
    local alertType = logger.alertLevel[alertType]
    if alertType.priority <= logger.alertLevelView then
        print(alertType.name .. " " .. logger.separationChar .. " " .. text)
    end
end

function logger.debug(text) logger.print("DEBUG", text) end
function logger.trace(text) logger.print("TRACE", text) end
function logger.info(text) logger.print("INFO", text) end
function logger.warn(text) logger.print("WARN", text) end
function logger.error(text) logger.print("ERROR", text) end

function logger.newErrorLevel(errorLevel, priority)
    local errorNameUppercase = string.upper(errorLevel)
    local errorNameLowercase = string.lower(errorLevel)

    -- Vérifier que errorLevel est une chaîne de caractères
    if type(errorLevel) ~= "string" then
        error("Le niveau d'erreur doit être une chaîne de caractères")
    end

    -- Vérifier que priority est un entier
    if type(priority) ~= "number" then
        error("La priorité doit être un entier")
    end

    -- Créér le nouveau errorLevel
    logger.alertLevel[errorNameUppercase] = {
        name = errorNameUppercase,
        priority = priority
    }

    -- Créér la fonction d'affichage du nouveau errorLevel
    logger[errorNameLowercase] = function(text)
        logger.print(errorNameUppercase, text)
    end

    -- Affichage du message de recapitulation
    if logger.showLoggerinfo == true then
        logger.print("LOGGERINFO", ("Le nouveau type d'erreur [%s] a été mis en place"):format(errorNameUppercase))
        logger.print("LOGGERINFO", ("Pour l'utiliser utiliser la fonction 'logger.%s()'"):format(errorNameLowercase))
    end
end


return logger