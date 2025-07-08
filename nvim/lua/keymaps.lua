local map = vim.keymap.set
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Save current file
map("n", "<leader>w", ":w<cr>", { desc = "Save file", remap = true })

-- ESC pressing jk
map("i", "jk", "<ESC>", { desc = "jk to esc", noremap = true })

-- Quit Neovim
map("n", "<leader>q", ":q<cr>", { desc = "Quit Neovim", remap = true })

-- Increment/decrement
map("n", "+", "<C-a>", { desc = "Increment numbers", noremap = true })
map("n", "-", "<C-x>", { desc = "Decrement numbers", noremap = true })

-- Select all
map("n", "<C-a>", "gg<S-v>G", { desc = "Select all", noremap = true })

-- Indenting
map("v", "<", "<gv", { desc = "Indenting", silent = true, noremap = true })
map("v", ">", ">gv", { desc = "Indenting", silent = true, noremap = true })

-- New tab
map("n", "te", ":tabedit")

-- Split window
map("n", "<leader>sh", ":split<Return><C-w>w", { desc = "splits horizontal", noremap = true })
map("n", "<leader>sv", ":vsplit<Return><C-w>w", { desc = "Split vertical", noremap = true })

-- Navigate vim panes better
map("n", "<C-k>", "<C-w>k", { desc = "Navigate up" })
map("n", "<C-j>", "<C-w>j", { desc = "Navigate down" })
map("n", "<C-h>", "<C-w>h", { desc = "Navigate left" })
map("n", "<C-l>", "<C-w>l", { desc = "Navigate right" })

-- Resize window
map("n", "<C-Up>", ":resize -3<CR>")
map("n", "<C-Down>", ":resize +3<CR>")
map("n", "<C-Left>", ":vertical resize -3<CR>")
map("n", "<C-Right>", ":vertical resize +3<CR>")

-- Barbar
map("n", "<Tab>", ":BufferNext<CR>", { desc = "Move to next tab", noremap = true })
map("n", "<S-Tab>", ":BufferPrevious<CR>", { desc = "Move to previous tab", noremap = true })
map("n", "<leader>x", ":BufferClose<CR>", { desc = "Buffer close", noremap = true })
map("n", "<A-p>", ":BufferPin<CR>", { desc = "Pin buffer", noremap = true })

-- Start
vim.api.nvim_set_keymap('n', '<F5>', '', {
  noremap = true,
  silent = true,
  callback = function()
    local filetype = vim.bo.filetype
    local filename = vim.fn.expand('%')
    local fname_no_ext = vim.fn.expand('%:r')
    local term_buf = nil

    -- Функция для закрытия терминала после выполнения
    local function setup_term_close(bufnr)
      vim.api.nvim_create_autocmd('TermClose', {
        buffer = bufnr,
        callback = function()
          vim.api.nvim_buf_delete(bufnr, { force = true })
        end
      })
    end

    vim.cmd('w') -- Сохраняем файл перед запуском

    if filetype == "c" then
      term_buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_open_term(term_buf, {})
      setup_term_close(term_buf)
      vim.api.nvim_chan_send(
        vim.api.nvim_get_option_value('channel', { buf = term_buf }),
        'gcc ' .. filename .. ' -o ' .. fname_no_ext .. ' && ./' .. fname_no_ext .. '\r'
      )
    elseif filetype == "cpp" then
      term_buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_open_term(term_buf, {})
      setup_term_close(term_buf)
      vim.api.nvim_chan_send(
        vim.api.nvim_get_option_value('channel', { buf = term_buf }),
        'g++ ' .. filename .. ' -o ' .. fname_no_ext .. ' && ./' .. fname_no_ext .. '\r'
      )
    elseif filetype == "python" then
      term_buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_open_term(term_buf, {})
      setup_term_close(term_buf)
      vim.api.nvim_chan_send(
        vim.api.nvim_get_option_value('channel', { buf = term_buf }),
        'python3 ' .. filename .. '\r'
      )
    else
      print("F5: No run command set for filetype: " .. filetype)
    end
  end
})
