require('telescope').load_extension('fzf')
require('telescope').setup {
  defaults = {
    ignore_case = true,
    smart_case = true
  }
}
