-- Загрузка базовых модулей
require("vim-options")
require("keymaps")
require("cmds")

-- Настройка Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Инициализация плагинов
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
  },
})

-- Настройка диагностики
vim.diagnostic.config({
  virtual_text = true,
  virtual_lines = { current_line = true },
  underline = true,
  update_in_insert = false
})

-- Обработчик F5 для запуска кода
vim.api.nvim_set_keymap('n', '<F5>', '', {
  noremap = true,
  silent = true,
  callback = function()
    local filetype = vim.bo.filetype
    local filename = vim.fn.expand('%')
    local fname_no_ext = vim.fn.expand('%:r')
    local term_buf = nil

    local function setup_term_close(bufnr)
      vim.api.nvim_create_autocmd('TermClose', {
        buffer = bufnr,
        callback = function()
          vim.api.nvim_buf_delete(bufnr, { force = true })
        end
      })
    end

    vim.cmd('w') -- Сохраняем файл перед запуском

    -- Проверка наличия компиляторов
    local function is_executable(name)
      return vim.fn.executable(name) == 1
    end

    if filetype == "c" then
      if not is_executable('gcc') then
        vim.notify("gcc not found!", vim.log.levels.ERROR)
        return
      end
      term_buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_open_term(term_buf, {})
      setup_term_close(term_buf)
      vim.api.nvim_chan_send(
        vim.api.nvim_get_option_value('channel', { buf = term_buf }),
        'gcc ' .. filename .. ' -o ' .. fname_no_ext .. ' && ./' .. fname_no_ext .. '\r'
      )
    elseif filetype == "cpp" then
      if not is_executable('g++') then
        vim.notify("g++ not found!", vim.log.levels.ERROR)
        return
      end
      term_buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_open_term(term_buf, {})
      setup_term_close(term_buf)
      vim.api.nvim_chan_send(
        vim.api.nvim_get_option_value('channel', { buf = term_buf }),
        'g++ ' .. filename .. ' -o ' .. fname_no_ext .. ' && ./' .. fname_no_ext .. '\r'
      )
    elseif filetype == "python" then
      if not is_executable('python3') then
        vim.notify("python3 not found!", vim.log.levels.ERROR)
        return
      end
      term_buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_open_term(term_buf, {})
      setup_term_close(term_buf)
      vim.api.nvim_chan_send(
        vim.api.nvim_get_option_value('channel', { buf = term_buf }),
        'python3 ' .. filename .. '\r'
      )
    else
      vim.notify("F5: No run command set for filetype: " .. filetype, vim.log.levels.WARN)
    end
  end
})
