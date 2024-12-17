local opt = vim.opt

opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 0 -- do not hide anything
opt.confirm = true -- confirm to save changes before exiting modified buffer
opt.cursorline = true
opt.expandtab = true -- use spaces instead of tabs
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.hlsearch = false -- remove highlight after search
opt.ignorecase = true -- ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 3 -- global status line
opt.list = true -- show some invisible characters (tabs...
opt.listchars:append("tab:»·,trail:·,nbsp:␣,precedes:‹,extends:›") -- strings to use as virtual text with a lot of information opt.mouse = "a" -- enable mouse mode
opt.number = true -- print line number
opt.pumblend = 0 -- popup blend
opt.pumheight = 10 -- maximum number of entries in a popup
opt.relativenumber = true -- relative line numbers
opt.scrolloff = 4 -- lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shiftround = true -- round indent
opt.shiftwidth = 2 -- size of an indent
opt.shortmess:append({ w = true, i = true, c = true })
opt.showbreak = "↪ " -- hint shown when a line is wrapped
opt.showmode = false -- dont show mode since we have a statusline
opt.sidescrolloff = 8 -- columns of context
opt.signcolumn = "yes" -- always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- don't ignore case with capitals
opt.smartindent = true -- insert indents automatically
opt.spelllang = { "en" }
opt.splitbelow = true -- put new windows below current
opt.splitkeep = "screen"
opt.splitright = true -- put new windows right of current
opt.swapfile = false -- disable swap files
opt.tabstop = 2 -- number of spaces tabs count for
opt.termguicolors = true -- true color support
opt.undofile = true -- enable undo files
opt.wildmode = "longest:full,full" -- command-line completion mode
opt.wrap = false -- disable line wrap

if vim.fn.has("win32") == 1 then
  local is_powershell = false
  -- set powershell as default shell
  if vim.fn.executable("pwsh") == 1 then
    opt.shell = "pwsh"
    is_powershell = true
  elseif vim.fn.executable("powershell") == 1 then
    opt.shell = "powershell"
    is_powershell = true
  end

  if is_powershell then
    -- TODO: improve/learn this
    opt.shellcmdflag =
    "-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';"
    opt.shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
    opt.shellpipe = '2>&1 | %%{ "$_" } | Tee-Object %s; exit $LastExitCode'
    opt.shellquote = ""
    opt.shellxquote = ""
  end
end
