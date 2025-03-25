return {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim", cmd = "Copilot" },
      { "nvim-telescope/telescope.nvim" },
      { "nvim-lua/plenary.nvim" },
    },
    opts = {},
    config = function(_, opts)
      local chat = require("CopilotChat")
      chat.setup(opts)
    end,
    keys = {
      -- Show prompts actions with telescope
      {
        "<Leader>ap",
        function()
          require("CopilotChat").select_prompt({
            context = {
              "buffers",
            },
          })
        end,
        desc = "CopilotChat - Prompt actions",
      },
      {
        "<Leader>ap",
        function()
          require("CopilotChat").select_prompt()
        end,
        mode = "x",
        desc = "CopilotChat - Prompt actions",
      },
      -- Code related commands
      { "<Leader>ae", "<Cmd>CopilotChatExplain<CR>", desc = "CopilotChat - Explain code" },
      { "<Leader>at", "<Cmd>CopilotChatTests<CR>", desc = "CopilotChat - Generate tests" },
      { "<Leader>ar", "<Cmd>CopilotChatReview<CR>", desc = "CopilotChat - Review code" },
      { "<Leader>aR", "<Cmd>CopilotChatRefactor<CR>", desc = "CopilotChat - Refactor code" },
      { "<Leader>an", "<Cmd>CopilotChatBetterNamings<CR>", desc = "CopilotChat - Better Naming" },
      -- Custom input for CopilotChat
      {
        "<Leader>ai",
        function()
          local input = vim.fn.input("Ask Copilot: ")
          if input ~= "" then
            vim.cmd("CopilotChat " .. input)
          end
        end,
        desc = "CopilotChat - Ask input",
      },
      -- Generate commit message based on the git diff
      {
        "<Leader>am",
        "<Cmd>CopilotChatCommit<CR>",
        desc = "CopilotChat - Generate commit message for all changes",
      },
      -- Quick chat with Copilot
      {
        "<Leader>aq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            vim.cmd("CopilotChatBuffer " .. input)
          end
        end,
        desc = "CopilotChat - Quick chat",
      },
      -- Fix the issue with diagnostic
      { "<Leader>af", "<Cmd>CopilotChatFixError<CR>", desc = "CopilotChat - Fix Diagnostic" },
      -- Clear buffer and chat history
      { "<Leader>al", "<Cmd>CopilotChatReset<CR>", desc = "CopilotChat - Clear buffer and chat history" },
      -- Toggle Copilot Chat Vsplit
      { "<Leader>av", "<Cmd>CopilotChatToggle<CR>", desc = "CopilotChat - Toggle" },
      -- Copilot Chat Models
      { "<Leader>a?", "<Cmd>CopilotChatModels<CR>", desc = "CopilotChat - Select Models" },
      -- Copilot Chat Agents
      { "<Leader>aa", "<Cmd>CopilotChatAgents<CR>", desc = "CopilotChat - Select Agents" },
    },
  }
