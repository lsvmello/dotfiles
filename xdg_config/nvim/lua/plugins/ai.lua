-- TODO: really try this
return {
  {
    'github/copilot.vim',
    cmd = 'Copilot',
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'canary',
    dependencies = {
      'copilot.vim',
      'plenary.nvim',
    },
    opts = {
      -- See Configuration section for options
    },
    cmd = {
      'CopilotChat', 'CopilotChatAgents',
      'CopilotChatClose', 'CopilotChatDebugInfo',
      'CopilotChatLoad', 'CopilotChatModels',
      'CopilotChatOpen', 'CopilotChatReset',
      'CopilotChatSave', 'CopilotChatStop',
      'CopilotChatToggle',
    },
    keys = {
      -- Show prompts actions with telescope
      {
        '<Leader>ap',
        function()
          local actions = require('CopilotChat.actions')
          require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
        end,
        desc = 'CopilotChat - Prompt actions',
      },
      {
        '<Leader>ap',
        ':lua require("CopilotChat.integrations.telescope").pick(require("CopilotChat.actions").prompt_actions({selection = require("CopilotChat.select").visual}))<CR>',
        mode = 'x',
        desc = 'CopilotChat - Prompt actions',
      },
      -- Code related commands
      { '<Leader>ae', '<cmd>CopilotChatExplain<cr>', desc = 'CopilotChat - Explain code' },
      { '<Leader>at', '<cmd>CopilotChatTests<cr>', desc = 'CopilotChat - Generate tests' },
      { '<Leader>ar', '<cmd>CopilotChatReview<cr>', desc = 'CopilotChat - Review code' },
      { '<Leader>aR', '<cmd>CopilotChatRefactor<cr>', desc = 'CopilotChat - Refactor code' },
      { '<Leader>an', '<cmd>CopilotChatBetterNamings<cr>', desc = 'CopilotChat - Better Naming' },
      -- Chat with Copilot in visual mode
      {
        '<Leader>av',
        ':CopilotChatVisual',
        mode = 'x',
        desc = 'CopilotChat - Open in vertical split',
      },
      {
        '<Leader>ax',
        ':CopilotChatInline<cr>',
        mode = 'x',
        desc = 'CopilotChat - Inline chat',
      },
      -- Custom input for CopilotChat
      {
        '<Leader>ai',
        function()
          local input = vim.fn.input('Ask Copilot: ')
          if input ~= '' then
            vim.cmd('CopilotChat ' .. input)
          end
        end,
        desc = 'CopilotChat - Ask input',
      },
      -- Generate commit message based on the git diff
      {
        '<Leader>am',
        '<cmd>CopilotChatCommit<cr>',
        desc = 'CopilotChat - Generate commit message for all changes',
      },
      -- Quick chat with Copilot
      {
        '<Leader>aq',
        function()
          local input = vim.fn.input('Quick Chat: ')
          if input ~= '' then
            vim.cmd('CopilotChatBuffer ' .. input)
          end
        end,
        desc = 'CopilotChat - Quick chat',
      },
      -- Debug
      { '<Leader>ad', '<cmd>CopilotChatDebugInfo<cr>', desc = 'CopilotChat - Debug Info' },
      -- Fix the issue with diagnostic
      { '<Leader>af', '<cmd>CopilotChatFixDiagnostic<cr>', desc = 'CopilotChat - Fix Diagnostic' },
      -- Clear buffer and chat history
      { '<Leader>al', '<cmd>CopilotChatReset<cr>', desc = 'CopilotChat - Clear buffer and chat history' },
      -- Toggle Copilot Chat Vsplit
      { '<Leader>av', '<cmd>CopilotChatToggle<cr>', desc = 'CopilotChat - Toggle' },
      -- Copilot Chat Models
      { '<Leader>a?', '<cmd>CopilotChatModels<cr>', desc = 'CopilotChat - Select Models' },
    },
  },
}
