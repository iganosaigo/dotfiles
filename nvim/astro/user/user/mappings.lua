return {
  n = {
    L = {
      function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
      desc = "Next buffer",
    },
    H = {
      function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
    },
    ["<leader>fw"] = false,
    ["<leader>fW"] = false,
    ["<leader>fg"] = { function() require("telescope.builtin").live_grep() end, desc = "Find words" },
    ["<leader>fG"] = {
      function()
        require("telescope.builtin").live_grep {
          additional_args = function(args) return vim.list_extend(args, { "--hidden", "--no-ignore" }) end,
        }
      end, desc = "Find words" 
    },
    ["<leader>fGa"] = { function() require("telescope").extensions.live_grep_args.live_grep_args() end, desc = "Find words with args" },
    ["<leader>fc"] = false,
    ["<leader>fs"] = { function() require("telescope.builtin").grep_string() end, desc = "Find word under cursor" },
    ["<leader>fH"] = {
      function()
        require("telescope.builtin").find_files { hidden = true, no_ignore = true }
      end, desc = "Find all files" 
    },
  }
}

