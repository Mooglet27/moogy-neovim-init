-- nvim-java commands, mapped buffer local so <leader>J stays free elsewhere.
local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = 0, desc = desc })
end

-- Build & run
map("n", "<leader>Jb", "<cmd>JavaBuildBuildWorkspace<cr>", "Java build workspace")
map("n", "<leader>Jr", "<cmd>JavaRunnerRunMain<cr>", "Java run main class")
map("n", "<leader>Js", "<cmd>JavaRunnerStopMain<cr>", "Java stop running app")
map("n", "<leader>Jl", "<cmd>JavaRunnerToggleLogs<cr>", "Java toggle runner logs")
map("n", "<leader>Jp", "<cmd>JavaProfile<cr>", "Java run/debug profiles")

-- Tests
map("n", "<leader>Jt", "<cmd>JavaTestRunCurrentClass<cr>", "Java test current class")
map("n", "<leader>Jm", "<cmd>JavaTestRunCurrentMethod<cr>", "Java test method under cursor")
map("n", "<leader>JT", "<cmd>JavaTestViewLastReport<cr>", "Java view last test report")

-- Refactor
map({ "n", "v" }, "<leader>Jv", "<cmd>JavaRefactorExtractVariable<cr>", "Java extract variable")
map({ "n", "v" }, "<leader>Jc", "<cmd>JavaRefactorExtractConstant<cr>", "Java extract constant")
map({ "n", "v" }, "<leader>Jf", "<cmd>JavaRefactorExtractField<cr>", "Java extract field")
map("v", "<leader>Jx", "<cmd>JavaRefactorExtractMethod<cr>", "Java extract method")
