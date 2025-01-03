--- Usage:
---    eli patch.lua <path to project directory>

local function replace_strings(input)
    -- Define the replacement rules
    local replacements = {
        -- eli
        ["followRedirects"] = "follow_redirects",
        ["returnFullPaths"] = "return_full_paths",
        ["asDirEntries"] = "as_dir_entries",
        ["stdoutStream"] = "stdout_stream",
        ["stderrStream"] = "stderr_stream",
        ["exitcode"] = "exit_code",
        ["get_exitcode"] = "get_exit_code",
        ["progressFunction"] = "progress_function",
        ["flattenRootDir"] = "flatten_root_dir",

        -- ami
        ["no%-command"] = "namespace",
        ["customHelp"] = "custom_help",
        ["includeOptionsInUsage"] = "include_options_in_usage",
        ["shouldReturn"] = "should_return",
        ["errorMsg"] = "error_message",
        ["partialErrorMsg"] = "partial_error_message",
        ["contextFailExitCode"] = "context_fail_exit_code",
        ["injectArgs"] = "inject_args",
        ["injectArgsAfter"] = "inject_args_after",
        ["isAppAmiLoaded"] = "is_app_ami_loaded",
        ["customTitle"] = "use_custom_title",
        ["lastAmiCheck"] = "last_ami_check",
        ["replaceMustache"] = "replace_mustache",
        ["replaceArrow"] = "replace_arrow",
        ["commandRequired"] = "expects_command",

        -- plugins
        ["useOsExec"] = "use_os_exec",
        ["stdPassthrough"] = "std_passthrough",
        ["daemonReload"] = "daemon_reload",
        ["disableLogin"] = "disable_login",
        ["disablePassword"] = "disable_password"
    }

    -- Sort the keys by length in descending order
    local sorted_keys = {}
    for key in pairs(replacements) do
        table.insert(sorted_keys, key)
    end
    table.sort(sorted_keys, function(a, b) return #a > #b end)

    -- Perform the replacements
    local result = input
    for _, key in ipairs(sorted_keys) do
        local count
        result, count = result:gsub(key, replacements[key])
        if count > 0 then
            print("Replaced: " .. key .. " -> " .. replacements[key])
        end
    end

    return result
end

local args = { ... }
if #args < 1 then
    print("Usage: lua patch.lua <path>")
    os.exit(1)
end
local path = args[1]
if fs.file_type(path) ~= "directory" then
    print("Invalid path: " .. path)
    os.exit(1)
end


local candidates = fs.read_dir(path, { recurse = true, return_full_paths = true })
for _, candidate in ipairs(candidates) do
    if candidate:match(".*%.lua$") then
        --print("Patching: " .. candidate)
        local content = fs.read_file(candidate)
        local new_content = replace_strings(content)
        fs.write_file(candidate, new_content)
    end
end
