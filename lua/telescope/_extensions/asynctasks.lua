local actions = require('telescope.actions')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')


return require('telescope').register_extension {
    exports = {
        all = function(opts)
            opts = opts or {}

            local tasks = vim.api.nvim_call_function("asynctasks#source", {50})

            if vim.tbl_isempty(tasks) then
                return
            end

            local  tasks_formatted = {}

            for i = 1, #tasks do
                local current_task = table.concat(tasks[i], " | ")
                table.insert(tasks_formatted, current_task)
            end

            pickers.new(opts, {
                prompt_title = 'Tasks',
                finder    = finders.new_table {
                    results = tasks_formatted
                },
                sorter = sorters.get_generic_fuzzy_sorter(),
                attach_mappings = function(prompt_bufnr, map)

                    local start_task = function()
                        local selection = actions.get_selected_entry(prompt_bufnr)
                        actions.close(prompt_bufnr)

                        local task_name = tasks[selection.index][1]

                        local cmd = table.concat({"AsyncTask", task_name}, " ")

                        vim.cmd(cmd)
                    end

                    map('i', '<CR>', start_task)
                    map('n', '<CR>', start_task)

                    return true
                end
            }):find()
        end
    }
}
