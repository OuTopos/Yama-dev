yama = require("yama")

-- Start with the bootloader
yama.boot.start()

-- Start without the bootloader (Don't have to load the boot module)
--yama.start("dev")