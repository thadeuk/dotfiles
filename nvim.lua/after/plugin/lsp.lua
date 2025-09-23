local ok_cmp, cmp = pcall(require, 'cmp')
if ok_cmp then
  cmp.setup({
    snippet = {
      expand = function(args)
        local ok_snip, luasnip = pcall(require, 'luasnip')
        if ok_snip then
          luasnip.lsp_expand(args.body)
        end
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-y>'] = cmp.mapping.confirm({ select = true }),
      ['<C-Space>'] = cmp.mapping.complete(),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'buffer' },
    }),
  })
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp_lsp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if ok_cmp_lsp then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end

local servers = {
  ts_ls = {},
  eslint = {},
  pyright = {},
  dartls = {},
  jsonls = {},
  dockerls = {},
  bashls = {},
  yamlls = {},
  html = {},
  cssls = {},
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = { globals = { 'vim' } },
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  },
}

for name, config in pairs(servers) do
  local merged = vim.tbl_deep_extend('force', { capabilities = capabilities }, config)
  vim.lsp.config(name, merged)
  vim.lsp.enable(name)
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local opts = { buffer = event.buf, silent = true, noremap = true }
    local map = function(mode, lhs, rhs)
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    map('n', 'gd', vim.lsp.buf.definition)
    map('n', 'K', vim.lsp.buf.hover)
    map('n', '<leader>vws', vim.lsp.buf.workspace_symbol)
    map('n', '<leader>vd', vim.diagnostic.open_float)
    map('n', '[d', vim.diagnostic.goto_next)
    map('n', ']d', vim.diagnostic.goto_prev)
    map('n', '<leader>vca', vim.lsp.buf.code_action)
    map('n', '<leader>vrr', vim.lsp.buf.references)
    map('n', '<leader>vrn', vim.lsp.buf.rename)
    map('i', '<C-h>', vim.lsp.buf.signature_help)
  end,
})

vim.diagnostic.config({
  virtual_text = true,
})
