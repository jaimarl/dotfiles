-- Actions
vim.keymap.set('n', '<C-c>', '<cmd>:q<CR>')
vim.keymap.set('n', '<C-a>', '<cmd>%y+<CR>')
vim.keymap.set('i', '<C-s>', '<cmd>:w<CR>')
vim.keymap.set('n', '<C-s>', '<cmd>:w<CR>')


-- Yazi
vim.keymap.set('n', '<leader>n', '<cmd>Yazi<cr>')
vim.keymap.set('n', '<C-up>', '<cmd>Yazi toggle<cr>')


-- Bufferline
vim.keymap.set('n','<Tab>', ':BufferLineCycleNext<CR>')
vim.keymap.set('n','<S-Tab>', ':BufferLineCyclePrev<CR>')
vim.keymap.set('n', '<C-l>', ':BufferLineCloseOthers<CR>')
