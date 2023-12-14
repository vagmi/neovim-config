local M = {}

local latest_buf_id = nil

function delete_buf(bufnr)
  if bufnr ~= nil and vim.api.nvim_buf_is_valid(bufnr) then
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end
end


-- parse the lines from result to get a list of the desirable output
-- Example:
-- // Recursive expansion of the eprintln macro
-- // ============================================

-- {
--   $crate::io::_eprint(std::fmt::Arguments::new_v1(&[], &[std::fmt::ArgumentV1::new(&(err),std::fmt::Display::fmt),]));
-- }
local function parse_lines(t)
  local ret = {}

  local name = t.name
  local text = "// Recursive expansion of the " .. name .. " macro"
  table.insert(ret, "// " .. string.rep("=", string.len(text) - 3))
  table.insert(ret, text)
  table.insert(ret, "// " .. string.rep("=", string.len(text) - 3))
  table.insert(ret, "")

  local expansion = t.expansion
  for string in string.gmatch(expansion, "([^\n]+)") do
    table.insert(ret, string)
  end

  return ret
end
function mk_handler(fn)
  return function(...)
    local config_or_client_id = select(4, ...)
    local is_new = type(config_or_client_id) ~= "number"
    if is_new then
      fn(...)
    else
      local err = select(1, ...)
      local method = select(2, ...)
      local result = select(3, ...)
      local client_id = select(4, ...)
      local bufnr = select(5, ...)
      local config = select(6, ...)
      fn(
        err,
        result,
        { method = method, client_id = client_id, bufnr = bufnr },
        config
      )
    end
  end
end

local function handler(_, result)
  -- echo a message when result is nil (meaning no macro under cursor) and
  -- exit
  if result == nil then
    vim.api.nvim_out_write("No macro under cursor!\n")
    return
  end

  -- check if a buffer with the latest id is already open, if it is then
  -- delete it and continue
  delete_buf(latest_buf_id)

  -- create a new buffer
  latest_buf_id = vim.api.nvim_create_buf(false, true) -- not listed and scratch
  vim.cmd('vsplit')
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, latest_buf_id)
  vim.api.nvim_set_option_value("filetype", "rust", {buf=latest_buf_id})
  -- vim.api.nvim_buf_set_option(latest_buf_id, "filetype", "rust")
  -- write the expansion content to the buffer
  vim.api.nvim_buf_set_lines(latest_buf_id, 0, 0, false, parse_lines(result))

end

-- Sends the request to rust-analyzer to get cargo.tomls location and open it
function M.expand_macro()
    -- get current buffer
    local bufnr = vim.api.nvim_get_current_buf()
    local params = vim.lsp.util.make_position_params()
    return vim.lsp.buf_request(bufnr, "rust-analyzer/expandMacro", params, mk_handler(handler))
end

return M
