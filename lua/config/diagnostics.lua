-- LSP Diagnostics Float Configuration
-- Place this in your init.lua or a separate lua file

local M = {}

-- Configuration options
local config = {
    -- Auto show float when there are multiple diagnostics
    auto_show_threshold = 2,
    -- Float window options
    float_opts = {
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
        scope = "line",
        focusable = false,
        close_events = { "CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre" },
    },
    -- Virtual text options
    virtual_text = {
        enabled = true,
        spacing = 4,
        prefix = "●",
        severity = {
            min = vim.diagnostic.severity.HINT,
        },
    },
}

-- Track current float window
local float_win_id = nil

-- Function to close existing float window
local function close_float()
    if float_win_id and vim.api.nvim_win_is_valid(float_win_id) then
        vim.api.nvim_win_close(float_win_id, true)
        float_win_id = nil
    end
end

-- Function to show diagnostics in float window
local function show_diagnostics_float()
    close_float()

    -- Get current cursor position
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))

    local opts = vim.tbl_deep_extend("force", config.float_opts, {
        -- Position the float above the current line
        pos = { row - 1, col },
        anchor = "SW", -- Southwest anchor (bottom-left of float at position)
    })
    vim.diagnostic.open_float(opts)

    -- Get the newly created float window ID
    local wins = vim.api.nvim_list_wins()
    for _, win in ipairs(wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buf_name = vim.api.nvim_buf_get_name(buf)
        if buf_name == "" and vim.api.nvim_win_get_config(win).relative ~= "" then
            float_win_id = win
            break
        end
    end
end

-- Function to get diagnostics count for current line
local function get_line_diagnostics_count()
    local bufnr = vim.api.nvim_get_current_buf()
    local line = vim.api.nvim_win_get_cursor(0)[1] - 1
    local diagnostics = vim.diagnostic.get(bufnr, { lnum = line })
    return #diagnostics
end

-- Function to toggle virtual text based on diagnostics count
local function update_virtual_text()
    local count = get_line_diagnostics_count()
    local should_show_virtual_text = count <= 1

    -- Get current diagnostic config to preserve existing settings
    local current_config = vim.diagnostic.config()

    -- Only update virtual_text while preserving all other settings
    vim.diagnostic.config(vim.tbl_deep_extend("force", current_config, {
        virtual_text = should_show_virtual_text and config.virtual_text or false,
    }))
end

-- Function to handle cursor movement
local function on_cursor_moved()
    close_float()

    local count = get_line_diagnostics_count()

    -- Update virtual text visibility
    update_virtual_text()

    -- Auto show float if there are multiple diagnostics
    if count >= config.auto_show_threshold then
        -- Add small delay to avoid flickering
        vim.defer_fn(function()
            -- Check if cursor is still on the same line
            local new_count = get_line_diagnostics_count()
            if new_count >= config.auto_show_threshold then
                show_diagnostics_float()
            end
        end, 100)
    end
end

-- Setup function
function M.setup(user_config)
    -- Merge user config with defaults
    if user_config then
        config = vim.tbl_deep_extend("force", config, user_config)
    end

    -- Configure diagnostics while preserving existing settings
    local current_config = vim.diagnostic.config()
    vim.diagnostic.config(vim.tbl_deep_extend("force", current_config, {
        virtual_text = config.virtual_text,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = config.float_opts,
    }))

    -- Create autocommand group
    local group = vim.api.nvim_create_augroup("DiagnosticsFloat", { clear = true })

    -- Set up cursor movement handler
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        group = group,
        callback = on_cursor_moved,
    })

    -- Close float when leaving buffer or entering insert mode
    vim.api.nvim_create_autocmd({ "BufLeave", "InsertEnter" }, {
        group = group,
        callback = close_float,
    })

    -- Create user commands
    vim.api.nvim_create_user_command("DiagnosticsFloat", show_diagnostics_float, {
        desc = "Show diagnostics in floating window",
    })

    vim.api.nvim_create_user_command("DiagnosticsFloatToggle", function()
        if float_win_id and vim.api.nvim_win_is_valid(float_win_id) then
            close_float()
        else
            show_diagnostics_float()
        end
    end, {
        desc = "Toggle diagnostics floating window",
    })

    -- Key mappings
    vim.keymap.set("n", "<leader>df", show_diagnostics_float, { desc = "Show diagnostics float", silent = true })
    vim.keymap.set("n", "<leader>dt", function()
        if float_win_id and vim.api.nvim_win_is_valid(float_win_id) then
            close_float()
        else
            show_diagnostics_float()
        end
    end, { desc = "Toggle diagnostics float", silent = true })
end

-- Initialize with default config if called directly
M.setup()

return M
