-- local function yaml_ft(path, bufnr)
--   local path_regex = vim.regex "(tasks\\|playbooks\\|roles\\|handlers\\|molecule)/"
--   local path_match = path_regex:match_str(path)
--
--   if path_match then return "yaml.ansible" end
--   return "yaml"
-- end
-- Set up custom filetypes
vim.filetype.add {
  extension = {
    foo = "fooscript",
    -- yml = yaml_ft,
    -- yaml = yaml_ft,
  },
  filename = {
    ["Foofile"] = "fooscript",
  },
  pattern = {
    ["~/%.config/foo/.*"] = "fooscript",
  },
}
