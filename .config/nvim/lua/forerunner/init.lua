require("forerunner.config")
require("forerunner.lazy")

require("lazy").setup({
	{import = "forerunner.plugins"},
}, {
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
})

require("forerunner.remap")
