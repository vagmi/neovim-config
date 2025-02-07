require('avante_lib').load()
require('avante').setup({
    provider = "claude",
    vendors = {
        openrouter = {
            __inherited_from = 'openai',
            endpoint = 'https://openrouter.ai/api/v1',
            api_key_name = 'OPENROUTER_API_KEY',
            model = 'google/gemini-2.0-pro-exp-02-05:free',
            -- model ='google/gemini-2.0-flash-lite-preview-02-05:free',
        },
        ollama = {
            __inherited_from = "openai",
            api_key_name = "",
            endpoint = "http://127.0.0.1:11434/v1",
            model = "deepseek-r1:32b",
            disable_tools = true
        },
    },
    file_selector = {
        provider = "telescope",
    }
})
