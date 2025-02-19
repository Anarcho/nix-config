vim.api.nvim_create_user_command("OverseerRunFzf", function()
	local overseer = require("overseer")
	local fzf = require("fzf-lua")

	-- Create search options similar to overseer's internal logic
	local search_opts = {
		dir = vim.fn.getcwd(),
		filetype = vim.bo.filetype,
	}

	-- Use overseer's template.list() function directly
	overseer.template.list(search_opts, function(templates)
		-- Filter out hidden templates
		templates = vim.tbl_filter(function(tmpl)
			return not tmpl.hide
		end, templates)

		if #templates == 0 then
			vim.notify("No templates found", vim.log.levels.WARN)
			return
		end

		-- Create display entries for templates
		local template_entries = {}
		for i, template in ipairs(templates) do
			-- Format the template entry
			local name = template.name

			-- Add tags if present
			local tags = ""
			if template.tags and #template.tags > 0 then
				tags = " [" .. table.concat(template.tags, ", ") .. "]"
			end

			-- Add description if present
			local desc = ""
			if template.desc then
				desc = " - " .. template.desc
			end

			-- Show module/source info for built-in templates
			local source = ""

			if template.module then
				source = string.format(" (%s)", template.module)
			end

			template_entries[i] = {
				value = string.format("%d. %s%s%s%s", i, name, tags, desc, source),
				template = template,
			}
		end

		-- Show template selection menu

		fzf.fzf_exec(
			vim.tbl_map(function(entry)
				return entry.value
			end, template_entries),
			{
				prompt = "Select Template: ",
				winopts = {
					height = 0.4,
					width = 0.5,
					preview = { hidden = "hidden" },
				},
				actions = {
					["default"] = function(selected)
						if not selected or #selected == 0 then
							return
						end

						-- Extract index from the selected entry

						local index = tonumber(selected[1]:match("^(%d+)%."))
						if not index or not template_entries[index] then
							vim.notify("Invalid selection", vim.log.levels.WARN)
							return
						end

						local template = template_entries[index].template

						-- Run the selected template
						overseer.run_template({

							name = template.name,
							autostart = true,
						})
					end,
				},
			}
		)
	end)
end, {})

-- Command to restart the last task
vim.api.nvim_create_user_command("ZigLast", function()
	local overseer = require("overseer")
	local fzf = require("fzf-lua")
	local tasks = overseer.list_tasks({ recent_first = true })

	if vim.tbl_isempty(tasks) then
		vim.notify("No tasks found", vim.log.levels.WARN)

		return
	end

	local task_list = {}
	for _, task in ipairs(tasks) do
		table.insert(task_list, {
			display = string.format("%s (%s)", task.name, task.status),

			task = task,
		})
	end

	fzf.fzf_exec(

		vim.tbl_map(function(item)
			return item.display
		end, task_list),

		{

			prompt = "Select task to restart: ",
			winopts = {

				height = 0.4,
				width = 0.5,
				preview = { hidden = "hidden" },
			},
			actions = {
				["default"] = function(selected)
					if #selected == 0 then
						return
					end
					local selected_task = task_list[selected[1]:match("^(%d+)")].task
					overseer.run_action(selected_task, "restart")
				end,
			},
		}
	)
end, {})

-- Command to stop the last task
vim.api.nvim_create_user_command("ZigStopLast", function()
	local overseer = require("overseer")
	local fzf = require("fzf-lua")
	local tasks = overseer.list_tasks({ recent_first = true })

	if vim.tbl_isempty(tasks) then
		vim.notify("No tasks found", vim.log.levels.WARN)
		return
	end

	local task_list = {}
	for _, task in ipairs(tasks) do
		table.insert(task_list, {
			display = string.format("%s (%s)", task.name, task.status),
			task = task,
		})
	end

	fzf.fzf_exec(
		vim.tbl_map(function(item)
			return item.display
		end, task_list),
		{
			prompt = "Select task to stop: ",
			winopts = {
				height = 0.4,
				width = 0.5,
				preview = { hidden = "hidden" },
			},
			actions = {

				["default"] = function(selected)
					if #selected == 0 then
						return
					end
					local selected_task = task_list[selected[1]:match("^(%d+)")].task
					overseer.run_action(selected_task, "stop")
				end,
			},
		}
	)
end, {})

-- Command to run Zig tests
vim.api.nvim_create_user_command("ZigTest", function()
	local overseer = require("overseer")
	local fzf = require("fzf-lua")
	local test_names = {}
	local buf_content = vim.api.nvim_buf_get_lines(0, 0, -1, false)

	for _, l in ipairs(buf_content) do
		local test_name = string.match(l, '^%s*test%s+"([%w_%s]+)"%s*{$')
		if test_name ~= nil then
			table.insert(test_names, test_name)
		end
	end
	table.insert(test_names, "all")

	local file = vim.fn.expand("%:p")

	fzf.fzf_exec(test_names, {
		prompt = "Select Test: ",
		winopts = {
			height = 0.4,
			width = 0.5,
			preview = { hidden = "hidden" },
		},
		actions = {
			["default"] = function(selected)
				if #selected == 0 then
					return
				end
				local choice = selected[1]
				local filter = choice == "all" and '""' or string.format('"%s"', choice)
				local args = { "test", "--test-filter", filter, file, "-femit-bin=test" }

				overseer.run_template({
					name = "zig_test",
					params = { args = args },
				})
			end,
		},
	})
end, {})

vim.api.nvim_create_user_command("ZigBuild", function()
	local overseer = require("overseer")
	local fzf = require("fzf-lua")
	local file = vim.fn.expand("%:p")
	local dir = vim.fn.expand("%:p:h")

	-- Helper function to find project root (where build.zig is located)

	local function find_project_root(start_path)
		local path = start_path
		while path ~= "/" do
			if vim.fn.filereadable(path .. "/build.zig") == 1 then
				return path
			end
			path = vim.fn.fnamemodify(path, ":h")
		end
		return nil
	end

	local project_root = find_project_root(dir)

	local is_project = project_root ~= nil

	local build_options = is_project
			and {
				"Default build",
				"Release Safe",
				"Release Fast",
				"Release Small",
				"Debug build",
				"Custom flags",
			}
		or {
			"Build executable",
			"Release Safe",
			"Release Fast",
			"Release Small",
			"Debug build",
			"Custom flags",
		}

	fzf.fzf_exec(build_options, {
		prompt = "Select Build Type: ",
		winopts = {
			height = 0.4,
			width = 0.5,
			preview = { hidden = "hidden" },
		},
		actions = {
			["default"] = function(selected)
				if #selected == 0 then
					return
				end
				local choice = selected[1]
				local args = {}

				if is_project then
					-- Change to project root directory for the command
					vim.cmd("lcd " .. project_root)

					-- Project build with build.zig
					args = { "build" }

					if choice == "Release Safe" then
						table.insert(args, "-Doptimize=ReleaseSafe")
					elseif choice == "Release Fast" then
						table.insert(args, "-Doptimize=ReleaseFast")
					elseif choice == "Release Small" then
						table.insert(args, "-Doptimize=ReleaseSmall")
					elseif choice == "Debug build" then
						table.insert(args, "-Doptimize=Debug")
					elseif choice == "Custom flags" then
						vim.ui.input({ prompt = "Enter build flags: " }, function(input)
							if input then
								for flag in input:gmatch("%S+") do
									table.insert(args, flag)
								end
							end
						end)
					end
				else
					-- Single file build
					args = { "build-exe", file }

					if choice == "Release Safe" then
						table.insert(args, "-OReleaseSafe")
					elseif choice == "Release Fast" then
						table.insert(args, "-OReleaseFast")
					elseif choice == "Release Small" then
						table.insert(args, "-OReleaseSmall")
					elseif choice == "Debug build" then
						table.insert(args, "-ODebug")
					elseif choice == "Custom flags" then
						vim.ui.input({ prompt = "Enter build flags: " }, function(input)
							if input then
								for flag in input:gmatch("%S+") do
									table.insert(args, flag)
								end
							end
						end)
					end
				end

				overseer.run_template({
					name = "zig_build",
					params = { args = args },
				})
			end,
		},
	})
end, {})

-- Command to run Zig file
vim.api.nvim_create_user_command("ZigRun", function()
	local overseer = require("overseer")
	local fzf = require("fzf-lua")
	local file = vim.fn.expand("%:p")

	fzf.fzf_exec({ "Run", "Run with args" }, {

		prompt = "Run Options: ",
		winopts = {
			height = 0.4,
			width = 0.5,
			preview = { hidden = "hidden" },
		},
		actions = {
			["default"] = function(selected)
				if #selected == 0 then
					return
				end
				local choice = selected[1]
				local args = { file }

				if choice == "Run with args" then
					vim.ui.input({ prompt = "Enter run arguments: " }, function(input)
						if input then
							for arg in input:gmatch("%S+") do
								table.insert(args, arg)
							end
						end
					end)
				end

				overseer.run_template({
					name = "zig_run",
					params = { args = args },
				})
			end,
		},
	})
end, {})
vim.api.nvim_create_user_command("OverseerToggleFzf", function()
	local overseer = require("overseer")
	local fzf = require("fzf-lua")

	-- Get all tasks

	local tasks = overseer.list_tasks({ recent_first = true })
	if vim.tbl_isempty(tasks) then
		vim.notify("No tasks found", vim.log.levels.WARN)

		return
	end

	-- Create display entries for tasks
	local task_entries = {}
	for i, task in ipairs(tasks) do
		task_entries[i] = {
			value = string.format("%d. [%s] %s", i, task.status, task.name),
			task = task,
		}
	end

	-- Show task selection menu
	fzf.fzf_exec(
		vim.tbl_map(function(entry)
			return entry.value
		end, task_entries),
		{
			prompt = "Select Task: ",
			actions = {
				["default"] = function(selected)
					if not selected or #selected == 0 then
						return
					end

					-- Extract index from the selected entry (format: "N. [status] name")
					local index = tonumber(selected[1]:match("^(%d+)%."))
					if not index or not task_entries[index] then
						vim.notify("Invalid selection", vim.log.levels.WARN)

						return
					end

					local selected_task = task_entries[index].task

					-- List of available actions based on the task's status
					local actions = {
						start = {
							name = "start",
							desc = "Start the task",
							condition = function(task)
								return task.status == "PENDING"
							end,
						},
						stop = {
							name = "stop",
							desc = "Stop the task",
							condition = function(task)
								return task.status == "RUNNING"
							end,
						},
						restart = {
							name = "restart",
							desc = "Restart the task",
							condition = function(task)
								return task.status ~= "PENDING"
							end,
						},
						open = {
							name = "open",
							desc = "Open terminal in current window",
							condition = function(task)
								return task:get_bufnr()
							end,
						},
						dispose = {

							name = "dispose",
							desc = "Dispose the task",
						},

						edit = {
							name = "edit",

							desc = "Edit the task",
						},
					}

					-- Filter actions based on conditions
					local available_actions = {}
					for action_name, action in pairs(actions) do
						if not action.condition or action.condition(selected_task) then
							table.insert(available_actions, {
								name = action_name,
								desc = action.desc or action_name,
							})
						end
					end

					-- Sort actions alphabetically
					table.sort(available_actions, function(a, b)
						return a.name < b.name
					end)

					-- Show action selection menu
					fzf.fzf_exec(
						vim.tbl_map(function(action)
							return string.format("%s - %s", action.name, action.desc)
						end, available_actions),
						{
							prompt = "Select Action: ",
							actions = {
								["default"] = function(action_selected)
									if not action_selected or #action_selected == 0 then
										return
									end

									local action_name = action_selected[1]:match("^([^%s-]+)")
									if not action_name then
										vim.notify("Invalid action selection", vim.log.levels.WARN)
										return
									end

									overseer.run_action(selected_task, action_name)
								end,
							},
						}
					)
				end,
			},
		}
	)
end, {})

-- Optional: Add a keymap
vim.keymap.set("n", "<leader>or", ":OverseerRunFzf<CR>", { silent = true, desc = "Overseer Run (FZF)" })
