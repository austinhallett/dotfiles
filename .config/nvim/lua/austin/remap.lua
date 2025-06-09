vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set('n', '<leader>h', function()
  vim.cmd('belowright split | terminal')
end, { desc = 'Open terminal below' })
