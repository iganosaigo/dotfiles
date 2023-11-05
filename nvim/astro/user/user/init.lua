return {
  colorscheme = "sonokai",
  options = {
    g = {
      icons_enabled = true,
      mapleader = ';'
    },
  },
  lsp = {
    formating = {
      format_on_save = {
        enabled = false,
        allow_filetypes = {
          "terraform",
        },
        ignore_filetypes = {
          -- "py",
        },
      }
    }
  },
  polish = function()
    local function yaml_ft(path, bufnr)
      local path_regex = vim.regex "(tasks\\|playbooks\\|roles\\|handlers\\|molecule)/"
      local path_match = path_regex:match_str(path)

      if path_match then
        return "yaml.ansible" 
      end

      return "yaml"
    end

    vim.filetype.add {
      extension = {
        yml = yaml_ft,
        yaml = yaml_ft
      },
    }
  end,
} 
