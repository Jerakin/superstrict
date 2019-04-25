--- A module for guarding tables from new indices. Typical use is to guard the global scope.
-- Get the latest version from https://gist.github.com/britzl/546d2a7e32a3d75bab45
-- @module superstrict
-- @usage
--
--	-- Defold specific example. Allow the gameobject and gui script lifecycle functions. Also allow assignment of
--	-- facebook and iap modules for dummy implementations on desktop. The whitelist handles pattern matching and in the
--	-- example all functions prefixed with '__' will also be allowed in the global scope
-- 	local superstrict = require("superstrict")
-- 	superstrict.lock(_G, { "go", "gui", "msg", "url", "sys", "render", "factory", "particlefx", "physics", "sound", "sprite", "image", "tilemap", "vmath", "matrix4", "vector3", "vector4", "quat", "hash", "hash_to_hex", "hashmd5", "pprint", "iap", "facebook", "push", "http", "json", "spine", "zlib", "init", "final", "update", "on_input", "on_message", "on_reload", "__*" })
--
--	-- this will be allowed
--	__allowed = "abc"
--
--	-- and this
--	facebook = dummy_fb
--
--	-- this is ok
--	function init(self)
--	end
--
--	-- this will throw an error
--	if foo == "bar" then
--	end
--
--	-- this will also throw an error
--	function global_function_meant_to_be_local()
--	end
--
local M = {}

-- mapping between tables and whitelisted names 
local whitelisted_names = {}

-- make sure that no one messes with the error function since we need it to communicate illegal access to locked tables
local _error = error


--- Check if a key in a table is whitelisted or not
-- @param t The table to check for a whitelisted name
-- @param n Name of the variable to check
-- @return true if n is whitelisted on t
local function is_whitelisted(t, n)
	for _,whitelisted_name in pairs(whitelisted_names[t] or {}) do
		if n:find(whitelisted_name) then
			return true
		end
	end
	return false
end

--- Guarded newindex
-- Will check if the specified name is whitelisted for the table. If the name isn't whitelisted
-- an error will be thrown.
-- @param t The table on which a new index is being set
-- @param n Name of the variable to set on the table
-- @param v The value to set
local function lock_newindex(t, n, v)
	if is_whitelisted(t, n) then
		rawset(t, n, v)
		return
	end

	_error("Table [" .. tostring(t) .. "] is locked. Attempting to write value to '" .. n .. "'. You must declare '" .. n .. "' as local or added it to the whitelist.", 2)
end

--- Guarded __index
-- Will throw an error if trying to read undefined value
-- @param t The table on which a new index is being set
-- @param n Name of the variable to set on the table
local function lock_index(t, n)
	if is_whitelisted(t, n) then
		return rawget(t, n)
	end

	_error("Table [" .. tostring(t) .. "] is locked. Attempting to read undefined value '" .. n .. "'.", 2)
end

--- Lock a table. This will prevent the table from being assigned new values (functions and variables)
-- Typical use is to call lock(_G) to guard the global scope from accidental assignments
-- @param t Table to lock
-- @param whitelist List of names that are allowed on the table
function M.lock(t, whitelist)
	assert(t, "You must pass a table to lock")
	whitelisted_names[t] = whitelist or {}
	local mt = getmetatable(t) or {}
	mt.__newindex = lock_newindex
	mt.__index = lock_index
	setmetatable(t, mt)
end

---
-- Unlock a table
-- @param t Table to unlock
function M.unlock(t)
	assert(t, "You must pass a table to unlock")
	local mt = getmetatable(t) or {}
	mt.__newindex = rawset
	mt.__index = rawget
	setmetatable(t, mt)
end

return M