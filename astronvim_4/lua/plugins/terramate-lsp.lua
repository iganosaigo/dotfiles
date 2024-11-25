return {
  "AstroNvim/astrolsp",
  ---@param opts AstroLSPOpts
  opts = function(plugin, opts)
    opts.servers = opts.servers or {}
    table.insert(opts.servers, "terramate_lsp")
    opts.config = require("astrocore").extend_tbl(opts.config or {}, {
      terramate_lsp = {
        cmd = {
          "terramate-ls",
        },
        filetypes = { "hcl" },
        root_dir = require("lspconfig.util").root_pattern "*.tm.hcl",
      },
    })
  end,
}
