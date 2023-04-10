return {
  {
    "ThePrimeagen/vim-be-good",
    cmd = "VimBeGood",
  },
  {
    "eandrju/cellular-automaton.nvim",
    cmd = "CellularAutomaton",
    config = function()
      -- setup randomizer
      math.randomseed(os.time())

      local animations = {
        {
          name = "race",
          update = function(grid)
            for i = 1, #grid do
              local prev = grid[i][#grid[i]]
              if math.random(10) % 7 ~= 0 then
                for j = 1, #grid[i] do
                  grid[i][j], prev = prev, grid[i][j]
                end
              end
            end
            return true
          end,
        },
        {
          name = "slide",
          update = function(grid)
            for i = 1, #grid do
              local prev = grid[i][#grid[i]]
              for j = 1, #grid[i] do
                grid[i][j], prev = prev, grid[i][j]
              end
            end
            return true
          end,
        },
        {
          name = "shuffle",
          update = function(grid)
            for i = 1, #grid do
              local idx1 = math.random(#grid[i])
              local idx2 = math.random(#grid[i])
              grid[i][idx1], grid[i][idx2] = grid[i][idx2], grid[i][idx1]
            end
            return true
          end,
        },
        {
          name = "screensaver",
          fps = 20,
          update = function(grid)
            local get_character_cols = function(row)
              local cols = {}
              for i = 1, #row do
                if row[i].char ~= " " then
                  table.insert(cols, i)
                end
              end

              return cols
            end

            for i = 1, #grid do
              local cols = get_character_cols(grid[i])
              if #cols > 0 then
                local last_col = cols[#cols]
                local prev = grid[i][last_col]
                for _, j in ipairs(cols) do
                  grid[i][j], prev = prev, grid[i][j]
                end
              end
            end
            return true
          end,
        },
      }

      -- register all animations
      for i = 1, #animations do
        require("cellular-automaton").register_animation(animations[i])
      end
    end,
  },
}
