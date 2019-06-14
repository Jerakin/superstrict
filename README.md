# Superstrict
Super strict is a module for Defold that makes it easier to use and reuse super strict in your projects.


# Installation
You can use Superstrict in your own project by adding this project as a [Defold library dependency](http://www.defold.com/manuals/libraries/). Open your game.project file and in the dependencies field under project add:

https://github.com/Jerakin/superstrict/archive/master.zip


# Usage
If you do not have any Native extensions then you will only need to require the lock `local lock = require "superstrict.lock"` if you want to exclude extensions or other global names then you can add them to superstrict `lock.add({"clipboard", "rnd"})`
