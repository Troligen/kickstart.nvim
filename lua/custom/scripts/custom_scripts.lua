-- command to adjust table
function FormatTable()
  -- Get the current buffer
  local bufnr = vim.api.nvim_get_current_buf()

  -- Get the start and end lines of the visual selection
  local start_line = vim.fn.line "'<"
  local end_line = vim.fn.line "'>"

  -- Get the selected text
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false)
  local selected_text = table.concat(lines, '\n')

  -- Write the selected text to a temporary file
  local tmpfile = '/tmp/nvim_tmp_selected_text.txt'
  local f, err = io.open(tmpfile, 'w')
  if not f then
    vim.api.nvim_err_write('Error opening file for writing: ' .. err .. '\n')
    return
  end
  f:write(selected_text)
  f:close()

  -- Execute the script/command and capture its output
  local command = string.format("cat '%s' | python3 ~/.scripts/table_formater.py", tmpfile)

  -- Execute the command and capture its output
  local output = vim.fn.system(command)

  -- Clean up the temporary file
  os.remove(tmpfile)

  -- Check if output is non-empty
  if output and output ~= '' then
    -- Remove trailing newline if it exists
    output = output:gsub('\n$', '')

    -- Split the output into lines
    local output_lines = vim.split(output, '\n')

    -- Replace the selected lines with the output
    vim.api.nvim_buf_set_lines(bufnr, start_line - 1, end_line, false, output_lines)
  else
    vim.api.nvim_err_write 'Error: No output from table_formater.py\n'
  end
end

vim.api.nvim_command [[command! -range FormatTable <line1>,<line2>lua FormatTable()]]
