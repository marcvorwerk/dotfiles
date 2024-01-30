local wezterm = require("wezterm")

-- Use some simple heuristics to determine if we should open it
-- with a text editor in the terminal.
-- Take note! The code in this file runs on your local machine,
-- but a URI can appear for a remote, multiplexed session.
-- WezTerm can spawn the editor in that remote session, but doesn't
-- have access to the file locally, so we can't probe inside the
-- file itself, so we are limited to simple heuristics based on
-- the filename appearance.
function Editable(filename)
	-- "foo.bar" -> ".bar"
	local extension = filename:match("^.+(%..+)$")
	if extension then
		-- ".bar" -> "bar"
		extension = extension:sub(2)
		wezterm.log_info(string.format("extension is [%s]", extension))
		local binary_extensions = {
			jpg = true,
			jpeg = true,
			-- and so on
		}
		if binary_extensions[extension] then
			-- can't edit binary files
			return false
		end
	end

	-- if there is no, or an unknown, extension, then assume
	-- that our trusty editor will do something reasonable

	return true
end

function Extract_filename(uri)
	-- `file://hostname/path/to/file`
	local start, match_end = uri:find("file:")
	if start == 1 then
		-- skip "file://", -> `hostname/path/to/file`
		local host_and_path = uri:sub(match_end + 3)
		local start, match_end = host_and_path:find("/")
		if start then
			-- -> `/path/to/file`
			return host_and_path:sub(match_end)
		end
	end

	return nil
end

wezterm.on("open-uri", function(window, pane, uri)
	local name = Extract_filename(uri)
	if name and Editable(name) then
		local editor = "vim"

		local action = wezterm.action({ SplitVertical = {
			args = { editor, name },
		} })

		-- and spawn it!
		window:perform_action(action, pane)

		-- prevent the default action from opening in a browser
		return false
	end
end)
