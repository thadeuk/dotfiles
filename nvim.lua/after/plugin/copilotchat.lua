require("CopilotChat").setup({
  debug = true,
  show_help = "yes",
  prompts = {
    Explain = "Explain how it works by English language.",
    FixError = "Please explain the errors in the text above and provide a solution.",
    Tests = "Briefly explain how the selected code works, then generate unit tests.",
    Refactor = "Refactor the code to improve clarity and readability.",
    Annotations = "Add annotations to the code to explain its purpose.",
    Commit = "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
    CommitStage = "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
  }
})



local select = require("CopilotChat.select")
local prompts = {
    Explain     = { prompt = "Explain how the code works." },
    FixError    = { prompt = "please explain the errors in the text above and provide a solution." },
    Review      = { prompt = "Please review the code above and provide suggestions for improvement." },
    Refactor    = { prompt = "Please refactor the following code to improve its clarity and readability." },
    Tests       = { prompt = "Briefly explain how the selected code works and then generate a unit test." },
    Annotations = { prompt = "Add comments to the above code" },

    Commit = {
        prompt = 'Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.',
        selection = select.gitdiff,

    },
    CommitStaged = {
        prompt = 'Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.',
        selection = function(source)
            return select.gitdiff(source, true)
        end,

    },
}
local Chat_cmd = "CopilotChat"
local options = {}
for key, value in pairs(prompts) do
    table.insert(options, key)
end

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local Telescope_CopilotActions = function(opts)
    opts = opts or {}
    pickers.new(opts, {
        prompt_title = "Select Copilot prompt",
        finder = finders.new_table {
            results = options
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                local choice = selection[1]

                if choice ~= nil then
                    local msg = ""
                    -- Find the item message base on the choice
                    for item, body in pairs(prompts) do
                        if item == choice then
                            msg = body.prompt
                            break
                        end
                    end
                    local get_type = vim.api.nvim_buf_get_option(0, 'filetype')
                    local Ask_msg = Chat_cmd .. " " .. "This is a ".. get_type .. " code, ".. msg
                    -- vim.print(Ask_msg)
                    require("CopilotChat").ask(Ask_msg)
                end
            end)
            return true
        end,
    }):find()
end
vim.api.nvim_create_user_command("CopilotActions",
    function() Telescope_CopilotActions(require("telescope.themes").get_dropdown{}) end,
    { nargs = "*", range = true }
)

vim.api.nvim_set_keymap('n', "<leader>ccp", ":CopilotActions<cr>", { noremap = true, silent = true, desc = "CopilotChat Toggle" })
vim.api.nvim_set_keymap('n', "<leader>ccc", ":CopilotChatToggle<cr>", { noremap = true, silent = true, desc = "CopilotChat Toggle" })
