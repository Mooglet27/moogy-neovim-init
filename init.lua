-- require("impatient")
require("config.basic")
require("config.lazy")
require("config.keymap")
require("config.diagnostics").setup({
    auto_show_treshold = 3,
    virtual_text = {
        prefix = "", -- Change virtual text prefix
        spacing = 4, -- Adjust spacing
    },
})
