vim.g.mapleader = " "

-- Spaces instead of tabs
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2

vim.o.number = true
vim.o.relativenumber = true

-- Sync clipboard between OS and Neovim
vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    vim.o.clipboard = 'unnamedplus'
  end,
})

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Highlight the line where the cursor is on
vim.o.cursorline = true

-- Show <tab> and trailing spaces
vim.o.list = true
vim.o.confirm = true

-- Map <A-j>, <A-k>, <A-h>, <A-l> to navigate between windows in any modes
vim.keymap.set({ 't', 'i' }, '<A-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set({ 't', 'i' }, '<A-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set({ 't', 'i' }, '<A-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set({ 't', 'i' }, '<A-l>', '<C-\\><C-n><C-w>l')
vim.keymap.set({ 'n' }, '<A-h>', '<C-w>h')
vim.keymap.set({ 'n' }, '<A-j>', '<C-w>j')
vim.keymap.set({ 'n' }, '<A-k>', '<C-w>k')
vim.keymap.set({ 'n' }, '<A-l>', '<C-w>l')

-- setup lazy and load plugins
require("config.lazy")
require("lazy").setup("plugins")



-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
local telescope_builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", telescope_builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", telescope_builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>gd", telescope_builtin.lsp_definitions, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>gr", telescope_builtin.lsp_references, { desc = "Go to references" })
vim.keymap.set("n", "<leader>gi", telescope_builtin.lsp_implementations, { desc = "Go to implementation" })
vim.keymap.set("n", "<leader>ds", telescope_builtin.lsp_document_symbols, { desc = "Document symbols" })
vim.keymap.set("n", "<leader>ws", telescope_builtin.lsp_workspace_symbols, { desc = "Workspace symbols" })
vim.keymap.set("n", "<leader>dd", telescope_builtin.diagnostics, { desc = "Document diagnostics" })

local capabilities = require("blink.cmp").get_lsp_capabilities()
vim.lsp.config["tsserver"] = {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "typescript" },
  root_dir = vim.fs.root(0, { "package.json", ".git" }),
  capabilities = capabilities,
}

vim.lsp.config["lua_ls"] = {
  -- Command and arguments to start the server.
  cmd = { "lua-language-server" },
  -- Filetypes to automatically attach to.
  filetypes = { "lua" },
  -- Sets the "workspace" to the directory where any of these files is found.
  -- Files that share a root directory will reuse the LSP server connection.
  -- Nested lists indicate equal priority, see |vim.lsp.Config|.
  root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
  capabilities = capabilities,
  -- Specific settings to send to the server. The schema is server-defined.
  -- Example: https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" }
      },
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true)
      }
    },
  },
}

vim.lsp.enable("lua_ls")
vim.lsp.enable("tsserver")

-- Format on save (LSP)
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    local clients = vim.lsp.get_active_clients({ bufnr = 0 })
    for _, client in ipairs(clients) do
      if client.server_capabilities.documentFormattingProvider then
        vim.lsp.buf.format({ async = false })
        return
      end
    end
  end,
})

-- Disable unused vim.providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
