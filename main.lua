-- Import the Love2dLogger module
require "love2dLogger/logger"

function love.load()
    -- Initialize a new instance of the logger with screen display enabled
    logger = Love2dLogger.new({
        screenDisplay = true
    })

    logger.info("The app is started")

    logger.warn("A problem has occurred")

    logger.error("An error has occurred")

    -- Create and register a custom Error level
    logger.newErrorLevel("My Super Error Level", 2)

    -- Log a message using the custom Error level
    logger.mySuperErrorLevel("Hello, world!")
end

function love.update(dt)
    -- Update the logger with the elapsed time since the last frame
    logger.update(dt)
end

function love.draw()
    -- Draw the logger output on the screen
    logger.draw()
end

function love.mousepressed(x, y, button)
    -- Trigger the custom Error level log on mouse click
    logger.mySuperErrorLevel("Hello, world!")
end
