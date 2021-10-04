local Spring = {}

local clock = time
local sqrt = math.sqrt
local exp = math.exp
local cos = math.cos
local sin = math.sin


local function getPV(d, s, t0, p0, v0, p1, w)
	local t = s*(w - t0)
	local d2 = d*d

	local h, si, co
	if d2 < 1 then
		h = sqrt(1 - d2)
		local e = exp(-d*t)/h
		co, si = e*cos(h*t), e*sin(h*t)
	elseif d2 == 1 then
		h = 1
		local e = exp(-d*t)/h
		co, si = e, e*t
	else
		h = sqrt(d2 - 1)
		local u = exp((-d + h)*t)/(2*h)
		local v = exp((-d - h)*t)/(2*h)
		co, si = u + v, u - v
	end

	local a0 = h*co + d*si
	local a1 = 1 - (h*co + d*si)
	local a2 = si/s

	local b0 = -s*si
	local b1 = s*si
	local b2 = h*co - d*si

	return a0*p0 + a1*p1 + a2*v0, b0*p0 + b1*p1 + b2*v0
end


function Spring.new(init, d, s)
	return setmetatable({
		_d = d or 1,
		_s = s or 1,
		_t0 = clock(),
		_p0 = init or 0,
		_v0 = 0*(init or 0),
		_p1 = init or 0,
		init = Spring.init,
		Update = Spring.Update
	}, Spring)
end


function Spring:init(p, v, t)
	self._t0 = clock()
	self._p0 = p or (0*self._p0)
	self._v0 = v or (0*self._v0)
	self._p1 = t or p or 0*self._p1
end


function Spring:Update(newG, newP, newV, newD)
	local w = clock()
	local p, v = getPV(self._d, self._s, self._t0, self._p0, self._v0, self._p1, w)
	self._t0 = w
	self._p0 = newP or p
	self._v0 = newV or v
	self._p1 = newG or self._p1
	self._d = newD or self._d
	self._s = newD or self._s
	return p, v
end


function Spring:__index(index)
	local w = clock()
	if index == "p" or index == "Position" then
		local p = getPV(self._d, self._s, self._t0, self._p0, self._v0, self._p1, w)
		return p
	elseif index == "v" or index == "Velocity" then
		local _, v = getPV(self._d, self._s, self._t0, self._p0, self._v0, self._p1, w)
		return v
	elseif index == "t" or index == "Target" then
		return self._p1
	elseif index == "d" or index == "Dampening" then
		return self._d
	elseif index == "s" or index == "Speed" then
		return self._s
	elseif index == "a" or index == "Acceleration" then
		local p, v = getPV(self._d, self._s, self._t0, self._p0, self._v0, self._p1, w)
		local a = self._s*self._s*(self._p1 - p) - 2*self._s*self._d*v
		return a
	end
end


function Spring:__newindex(index, value)
	local w = clock()
	self._p0, self._v0 = getPV(self._d, self._s, self._t0, self._p0, self._v0, self._p1, w)
	self._t0 = w
	if index == "p" or index == "Position" then
		self._p0 = value
	elseif index == "v" or index == "Velocity" then
		self._v0 = value
	elseif index == "t" or index == "Target" then
		self._p1 = value
	elseif index == "d" or index == "Dampening" then
		self._d = value
	elseif index == "s" or index == "Speed" then
		self._s = value
	end
end


return Spring