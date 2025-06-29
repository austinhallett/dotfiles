return {
	{
		"mfussenegger/nvim-dap",
		keys = {
			{ "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
			{ "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
			{ "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
			{ "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
			{ "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
			{ "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
			{ "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
			{ "<leader>du", function() require("dapui").toggle() end, desc = "Toggle UI" },
			{ "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
		},
		config = function()
			local dap = require("dap")
			---@diagnostic disable-next-line: undefined-field
			dap.adapters.go = {
				type = "server",
				port = "${port}",
				executable = {
					command = vim.fn.stdpath("data") .. "/mason/bin/dlv",
					args = { "dap", "-l", "127.0.0.1:${port}" },
				},
			}
			---@diagnostic disable-next-line: undefined-field
			dap.configurations.rust = {
				{
					name = "LLDB: Launch",
					type = "codelldb",
					request = "launch",
					program = function()
						local output = vim.fn.systemlist("cargo build -q --message-format=json 2>1")
						for _, l in ipairs(output) do
							local json = vim.json.decode(l)
							if json == nil then
								error("error parsing json")
							end
							if json.success == false then
								return error("error building package")
							end
							if json.executable ~= nil then
								return json.executable
							end
						end
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = {},
				},
			}
		end,
	},
	{
		"folke/neodev.nvim",
		config = function()
			require("neodev").setup({
				library = { plugins = { "nvim-dap-ui", "neotest" }, types = true },
			})
		end,
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		config = function()
			require("nvim-dap-virtual-text").setup({})
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"theHamsta/nvim-dap-virtual-text",
			"folke/neodev.nvim",
		},
		config = function()
			require("dapui").setup()
			local dap, dapui = require("dap"), require("dapui")
			---@diagnostic disable-next-line: undefined-field
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			---@diagnostic disable-next-line: undefined-field
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			---@diagnostic disable-next-line: undefined-field
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			---@diagnostic disable-next-line: undefined-field
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
		end,
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = {
			"mfussenegger/nvim-dap",
			"williamboman/mason.nvim",
		},
		config = function()
			require("mason-nvim-dap").setup({
				ensure_installed = { "delve", "python", "codelldb" },
				automatic_installation = true,
				automatic_setup = true,
				handlers = {
					function(config)
						-- all sources with no handler get passed here
						-- Keep original functionality
						require("mason-nvim-dap").default_setup(config)
					end,
					python = function(config)
						config.adapters = {
							type = "executable",
							command = "python",
							args = {
								"-m",
								"debugpy.adapter",
							},
						}
						require("mason-nvim-dap").default_setup(config) -- don't forget this!
					end,
					delve = function(config)
						config.adapters = {
							type = "server",
							port = "${port}",
							executable = {
								command = vim.fn.stdpath("data") .. "/mason/bin/dlv",
								args = { "dap", "-l", "127.0.0.1:${port}" },
							},
						}
						require("mason-nvim-dap").default_setup(config) -- don't forget this!
					end,
				},
			})
		end,
	},
}