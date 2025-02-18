{
  "lua/overseer/template/user/zig_test.lua".text = ''
    return {
      name = "zig_test",
      params = {
        args = {},
      },
      builder = function(params)
        return {
          cmd = { "zig" },
          args = params.args,

          components = {
            { "on_output_quickfix",

              open = false,
              tail = false,
              open_on_exit = "never",
              items_only = true,
              set_diagnostics = true
            },
            { "on_complete_dispose", timeout = 1000 },
            "default",
          },
        }
      end,
      condition = {
        filetype = { "zig" },
      },
    }
  '';

  "lua/overseer/template/user/zig_build.lua".text = ''
    return {
      name = "zig_build",
      params = {
        args = {},
      },
      builder = function(params)
        return {
          cmd = { "zig" },
          args = params.args or {},
          components = {
            { "on_output_quickfix",
              open = false,
              tail = false,

              open_on_exit = "never",

              items_only = true,

              set_diagnostics = true
            },
            { "on_complete_dispose", timeout = 1000 },
            "default",
          },

        }
      end,
      condition = {
        filetype = { "zig" },
      },
    }

  '';

  "lua/overseer/template/user/zig_run.lua".text = ''
    return {
      name = "zig_run",
      params = {
        args = {},
      },
      builder = function(params)
        return {
          cmd = { "zig" },
          args = vim.list_extend({"run"}, params.args or {}),
          components = {

            { "on_output_quickfix",
              open = false,
              tail = false,

              open_on_exit = "never",
              items_only = true,

              set_diagnostics = true
            },
            { "on_complete_dispose", timeout = 1000 },
            "default",
          },
        }
      end,
      condition = {
        filetype = { "zig" },
      },
    }
  '';

  "lua/overseer/template/user/zig_test_build.lua".text = ''
    return {
      name = "zig_test_build",
      params = {
        test_args = {},
        build_args = {},

      },
      builder = function(params)
        return {
          cmd = { "bash" },
          args = {"-c", string.format(
            "zig test %s && zig build %s",
            table.concat(params.test_args or {}, " "),
            table.concat(params.build_args or {}, " ")
          )},
          components = {
            { "on_output_quickfix",
              open = false,
              tail = false,
              open_on_exit = "never",
              items_only = true,
              set_diagnostics = true
            },
            { "on_complete_dispose", timeout = 1000 },
            "default",
          },
        }
      end,
      condition = {
        filetype = { "zig" },
      },
    }
  '';
}
