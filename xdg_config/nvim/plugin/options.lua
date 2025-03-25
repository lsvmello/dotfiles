vim.opt.completeopt = "menu,menuone,noselect,popup"
vim.opt.conceallevel = 0 -- do not hide anything
vim.opt.confirm = true -- confirm to save changes before exiting modified buffer
vim.opt.cursorline = true -- enable cursor line
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.formatoptions = "jcroqlnt" -- tcqj
vim.opt.ignorecase = true -- ignore case
vim.opt.inccommand = "nosplit" -- preview incremental substitute
vim.opt.laststatus = 3 -- global statusline
vim.opt.list = true -- show some invisible characters (tabs...
vim.opt.listchars:append("tab:»·,trail:·,nbsp:␣,precedes:‹,extends:›") -- strings to use as virtual text with a lot of information
vim.opt.mouse = "a" -- enable mouse mode
vim.opt.number = true -- print line number
vim.opt.pumblend = 0 -- popup blend
vim.opt.pumheight = 10 -- maximum number of entries in a popup
vim.opt.scrolloff = 4 -- lines of context
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
vim.opt.shiftround = true -- round indent
vim.opt.shiftwidth = 2 -- size of an indent
vim.opt.shortmess:append({ w = true, i = true, c = true })
vim.opt.showbreak = "↪ " -- hint shown when a line is wrapped
vim.opt.sidescrolloff = 8 -- columns of context
vim.opt.signcolumn = "yes" -- always show the signcolumn, otherwise it would shift the text each time
vim.opt.smartcase = true -- don't ignore case with capitals
vim.opt.smartindent = true -- insert indents automatically
vim.opt.spelllang = { "en", "pt_br" }
vim.opt.splitbelow = true -- put new windows below current
vim.opt.splitkeep = "screen"
vim.opt.splitright = true -- put new windows right of current
vim.opt.swapfile = false -- disable swap files
vim.opt.tabstop = 2 -- number of spaces tabs count for
vim.opt.termguicolors = true -- true color support
vim.opt.undofile = true -- enable undo files
vim.opt.wildmode = "longest:full,full" -- command-line completion mode
vim.opt.wrap = false -- disable line wrap

vim.opt_global.statusline = [[%!v:lua.require'statusline'()]]

if vim.fn.has("win32") == 1 then
  -- set powershell as default shell
  vim.opt.shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"
  vim.opt.shellcmdflag =
    "-NoLogo -NonInteractive -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';$PSStyle.OutputRendering='PlainText';"
  vim.opt.shellredir = '2>&1 | %%{ "$_" } | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  vim.opt.shellpipe = '2>&1 | %%{ "$_" } | Tee-Object %s; exit $LastExitCode'
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
  -- set python path due to conflict with chocolatey
  vim.g.python3_host_prog = "C:\\Python313\\python.exe"
end
