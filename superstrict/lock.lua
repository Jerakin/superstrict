local superstrict = require("superstrict.superstrict")

local builtins = {
	"__script_context", "assert", "tostring", "tonumber", "msg", "rawget", "ipairs", "go", "print", 
	"particlefx", "json", "pcall", "gcinfo", "module", "sprite", "rawset", "vector", "resource", 
	"rawequal", "spine", "sys", "zlib", "_VERSION", "next", "timer", "_G", "os", "load", "RenderScriptInstance", 
	"string", "debug", "vmath", "GuiScriptInstance", "socket", "sound", "collectionfactory", "coroutine", "loadstring", 
	"NodeProxy", "pairs", "bufferstream", "physics", "tilemap", "label", "type", "url", "GOScriptInstance", "xpcall", 
	"__dm_script_instance__", 3700146495, "jit", "gui", "buffer", "model", "GuiScript", "GOScript", "render", "newproxy", "bit", 
	"matrix4", "window", "__script_main_thread", "__script_hash_table", "RenderScript", "__random_seed", "profiler", 
	"crash", "http", "hash_to_hex", "hash", "setfenv", "package", "error", "pprint", "image", "dofile", "hashmd5", 
	"getmetatable", "__PhysicsContext", "collectionproxy", "table", "collectgarbage", "quat", "RenderScriptConstantBuffer", 
	"require", "math", "loadfile", "vector3", "setmetatable", "select", "factory", "unpack", "getfenv", "vector4", "io",
	"init", "update", "on_input", "on_message", "final", "on_reload", "html5"
}

superstrict.lock(_G, builtins)

local M = {}

local whitelist = builtins

function M.add(table_of_additions)
	assert(type(table_of_additions) == "table")
	superstrict.unlock(_G)
	for _, w in pairs(table_of_additions) do
		table.insert(whitelist, w)
	end
	superstrict.lock(whitelist)
end

function M.unlock()
	superstrict.unlock(_G)
end

return M
