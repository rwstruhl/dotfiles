local function parrot_status()
    local status_info = require("parrot.config").get_status_info()
    local status = ""
    if status_info.is_chat then
      status = status_info.prov.chat.name
    else
      status = status_info.prov.command.name
    end
    return string.format("%s(%s)", status, status_info.model)
  end

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = {
    { "nvim-tree/nvim-web-devicons" }
  },
  opts = function ()
    return {
      options = {
        theme = "auto",
        globalstatus = false,
      },
      winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename', function()
          return require('nvim-navic').get_location()
        end},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
      },
      inactive_winbar = {
        lualine_a = {},
        lualine_b = {'filename'},
        lualine_c = {},
        lualine_x = {parrot_status},
        lualine_y = {},
        lualine_z = {}
      },
      extensions = { 'fugitive', 'quickfix' }
    }
  end
}
