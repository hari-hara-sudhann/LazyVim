-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local indent_group = vim.api.nvim_create_augroup("user_language_indent", { clear = true })

local web_filetypes = {
  html = true,
  css = true,
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
}

local function set_indent(width)
  vim.bo.tabstop = width
  vim.bo.softtabstop = width
  vim.bo.shiftwidth = width
  vim.bo.expandtab = true
end

vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
  group = indent_group,
  callback = function()
    local filetype = vim.bo.filetype
    if web_filetypes[filetype] then
      set_indent(2)
      return
    end

    if filetype ~= "" then
      set_indent(4)
    end
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = indent_group,
  callback = function(args)
    local filetype = vim.bo[args.buf].filetype
    if not web_filetypes[filetype] then
      return
    end

    if vim.lsp.inlay_hint then
      vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })
    end
  end,
})
