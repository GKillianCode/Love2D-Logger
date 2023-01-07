# Love2D Logger

## Description
It is a simple logger for the development of your games.

## Download
It is a very simple installation.

### First method : via the command line
```
git clone https://github.com/GKillianCode/Love2d-Logger
```

### Second method :
-> Download the zip folder.

# Usage Exemple
Import the library :
``` lua
local logger = require "logger"
```

The library code defines a logger variable which is an object containing various information about log configuration. The object also contains several functions for logging messages of different severity levels (debug, trace, info, warn, error).

Severity levels are defined in a alertLevel subtable of logger. Each level is represented by a subtable containing a name and priority. The logger.print function is used to display a message with the severity level name and the message separated by the logger.separationChar character. The message will only be displayed if its priority is less than or equal to logger.alertLevelView.

The logger.newErrorLevel function allows you to create a new log severity level by specifying its name and priority. A log function for this new level will also be created, for example if you create a new CRITICAL severity level with a priority of 1, you can use the logger.critical(text) function to display a message with this severity level. If logger.showLoggerinfo is true, information about the creation of the new log level will also be displayed.

Here are some examples of using the logger function:

``` lua
-- Display a debug message
logger.debug("This is a debug message")

-- Display a warning message
logger.warn("Warning, there has been an error")

-- Create a new "CRITICAL" log level with a priority of 1
logger.newErrorLevel("CRITICAL", 1)

-- Display a message of "CRITICAL" level
logger.critical("Critical error, stopping program")
```
Messages will be displayed in the console with the log level first, followed by the logger.separationChar character and the message. 
For example:

``` lua
DEBUG | This is a debug message
WARN | Warning, there has been an error
CRITICAL | Critical error, stopping program
```