require('dashboard').setup {
    theme = 'doom',
    config = {
        week_header = { enable = true },
        vertical_center = true,
        hide = { statusline = false },
        center = {
            {
                icon = '󰇥  ',
                icon_hl = 'Title',
                desc = 'Yazi                         ',
                desc_hl = 'Title',
                key = 'y',
                key_hl = 'Number',
                action = ':Yazi'
            }, {
                icon = '  ',
                icon_hl = 'Title',
                desc = 'Recent',
                desc_hl = 'Title',
                key = 'r',
                key_hl = 'Number',
                action = ':Telescope oldfiles'
            }, {
                icon = '  ',
                icon_hl = 'Title',
                desc = 'New file',
                desc_hl = 'Title',
                key = 'n',
                key_hl = 'Number',
                action = 'ene | startinsert'
            }, {
                icon = '  ',
                icon_hl = 'Title',
                desc = 'Lazy',
                desc_hl = 'Title',
                key = 'l',
                key_hl = 'Number',
                action = ':Lazy'
            }, {
                icon = '  ',
                icon_hl = 'Title',
                desc = 'Quit',
                desc_hl = 'Title',
                key = 'q',
                key_hl = 'Number',
                action = ':qa'
            },

        },
        footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { " Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
        end
    }
}
