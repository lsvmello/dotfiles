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

      local race_animation = {
        fps = 10,
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
      }
      local slide_animation = {
        fps = 50,
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
      }

      local cellular_automaton = require("cellular-automaton")
      cellular_automaton.register_animation(race_animation)
      cellular_automaton.register_animation(slide_animation)
    end,
  },
}
