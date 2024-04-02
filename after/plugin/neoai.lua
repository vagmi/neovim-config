local neoai = require("neoai");
neoai.setup({
    -- Below are the default options, feel free to override what you would like changed
    ui = {
        output_popup_text = "NeoAI",
        input_popup_text = "Prompt",
        width = 30, -- As percentage eg. 30%
        output_popup_height = 80, -- As percentage eg. 80%
        submit = "<Enter>", -- Key binding to submit the prompt
    },
    models = {
        {
            name = "openai",
            model = "magicoder",
            -- model = "gpt-3.5-turbo-1106",
            -- -- model = "gpt-4-1106-preview",
            params = nil,
        },
    },
    register_output = {
        ["g"] = function(output)
            return output
        end,
        ["c"] = require("neoai.utils").extract_code_snippets,
    },
    inject = {
        cutoff_width = 75,
    },
    prompts = {
        context_prompt = function(context)
            return "Hey, I'd like to provide some context for future "
                .. "messages. Here is the code/text that I want to refer "
                .. "to in our upcoming conversations:\n\n"
                .. context
        end,
    },
    mappings = {
        ["select_up"] = "<C-k>",
        ["select_down"] = "<C-j>",
    },
    open_ai = {
        api_base = "http://localhost:11434/v1/chat/completions",
        api_key = {
            env = "OPENAI_API_KEY",
            value = nil,
        },
    },
    shortcuts = {
        {
            name = "textify",
            key = "<leader>as",
            desc = "fix text with AI",
            use_context = true,
            prompt = [[
                Please rewrite the text to make it more readable, clear,
                concise, and fix any grammatical, punctuation, or spelling
                errors
            ]],
            modes = { "v" },
            strip_function = nil,
        },
        {
            name = "gitcommit",
            key = "<leader>ag",
            desc = "generate git commit message",
            use_context = false,
            prompt = function()
                return [[
                    Using the following git diff generate a consise and
                    clear git commit message, with a short title summary
                    that is 75 characters or less:
                ]] .. vim.fn.system("git diff --cached")
            end,
            modes = { "n" },
            strip_function = nil,
        },
    },
})



function generate_test()
    -- Load necessary modules
    local ts = require('nvim-treesitter')
    local parsers = require('nvim-treesitter.parsers')
    local queries = require('nvim-treesitter.query')
    local ts_utils = require('nvim-treesitter.ts_utils')



    -- Define the query to retrieve the method and struct
    local query = [[
    (method_definition) @method
    (struct_definition) @struct
    ]]
    -- Get the current buffer and language parser
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    -- Concatenate all the lines to get the complete text
    local text = table.concat(lines, '\n')

    local prompt = [[ 
        Given the content of the file below.

        ```
    ]] .. text .. [[
      ```

      Generate a test for the method 
    ]]

    local parser = parsers.get_parser(bufnr)
    if not parser then
        return nil, nil
    end

    local root_tree = parser:parse()[1]:root()
    local current_pos = vim.api.nvim_win_get_cursor(0)
    local current_node = ts_utils.get_node_at_cursor()

    if not current_node then return nil, nil end

    local function_node, struct_node
    local node = current_node

    -- Traverse up the tree to find the function and struct nodes
    while node do
        print('node:type', node:type())
        if not function_node and node:type() == "function_item" then
            function_node = node
        elseif not struct_node and node:type() == "impl_item" then
            struct_node = node
        end
        node = node:parent()
    end
    print('function_node', vim.treesitter.get_node_text(function_node:field('name')[1], bufnr))
    local function_name = function_node and vim.treesitter.get_node_text(function_node:field('name')[1], bufnr) or nil
    print('function_node', vim.treesitter.get_node_text(struct_node:field('type')[1], bufnr))
    local struct_name = struct_node and vim.treesitter.get_node_text(struct_node:field('type')[1], bufnr) or nil

    -- Parse the buffer
    -- Print the results
    -- print('current_method', function_name)
    -- print('current_struct', struct_name)

    if function_name then
        print('Current method:', function_name)
        if struct_name then
            print('Current struct:', struct_name)
            prompt = prompt .. struct_name .. '::' .. function_name
        else
            prompt = prompt .. function_name
        end
    end
    -- print(prompt)
    neoai.smart_toggle(prompt)
end

vim.api.nvim_set_keymap('n', '<leader>st', ':lua generate_test()<CR>', {})
