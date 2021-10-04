-- Error
-- evaera - Senor
-- 3/21/2021

--[[

	Error.new(options: table, parent: Error?) ->
		-- creates a new instance of an Error object

	Error.createAdvancer(callback: (...), args: tuple) -> boolean, tuple
		-- wraps the callback in an xpcall executor returns the results, warns on error

	Error.Is(object: Error?) -> boolean
		-- compares the current object to an error instance

	Error:Extend(options) -> Error
		-- returns an error instance whos parent is the instance that called the method

	Error:GetErrorChain() -> string
		-- returns a stringified version of the current Error chain

--]]

local Enum = require(script.Parent.Enum)

local Error = {}
Error.__index = Error
Error.Kind = Enum.new("ErrorKind", {
	"ExecutionError",
})


local function makeErrorHandler(traceback)
	assert(traceback ~= nil, "No traceback")

	return function(err)
		if type(err) == "table" then
			return err
		end

		return Error.new({
			error = err,
			kind = Error.Kind.ExecutionError,
			trace = debug.traceback(tostring(err), 2),
			context = "Error created at:\n\n" .. traceback,
		})
	end
end


local function packResults(success, ...)
	return success, select("#", ...), table.pack(...)
end


local function runExecutor(callback, ...)
	return packResults(xpcall(callback, makeErrorHandler(debug.traceback(nil, 2)), ...))
end


function Error.createAdvancer(callback, ...)
	local ok, resultLength, result = runExecutor(callback, ...)

	if not ok then
		warn(result[1])
	end

	return unpack(result, 1, resultLength)
end


function Error.new(options, parent)
	assert(parent == nil or Error.Is(parent), "Parent parameter must be an Error instance")

	options = options or {}

	return setmetatable({
		error = tostring(options.error) or "[This error has no error text.]",
		trace = options.trace,
		context = options.context,
		kind = options.kind,
		Parent = parent,
	}, Error)
end


function Error.Is(err)
	return type(err) == "table" and getmetatable(err) == Error
end


function Error:Extend(options)
	options = options or {}
	options.kind = options.kind or self.kind

	return Error.new(options, self)
end


function Error:GetErrorChain()
	local runtimeErrors = { self }

	while runtimeErrors[#runtimeErrors].Parent do
		table.insert(runtimeErrors, runtimeErrors[#runtimeErrors].Parent)
	end

	return runtimeErrors
end


function Error:__tostring()
	local errorStrings = {
		string.format("Error(%s)", self.kind or "?"),
	}

	for _, runtimeError in ipairs(self:GetErrorChain()) do
		table.insert(errorStrings, table.concat({
			runtimeError.trace or runtimeError.error,
			runtimeError.context,
		}, "\n"))
	end

	return table.concat(errorStrings, "\n")
end


return Error