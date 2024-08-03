return {
    'tpope/vim-dadbod',
    dependencies = {
      "kristijanhusak/vim-dadbod-completion",
      "kristijanhusak/vim-dadbod-ui",
  	},
    config = function()
        --rest of cmp definition in lsp.lua
        local cmp = require('cmp')
        cmp.setup.filetype({ "sql" }, {
          sources = {
            { name = "vim-dadbod-completion" },
            { name = "buffer" },
          },
        })
	end
}
