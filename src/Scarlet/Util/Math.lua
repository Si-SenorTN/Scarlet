--!strict
local Math = {}

local function cSquared(pointA: Vector3 | Vector2, pointB: Vector3 | Vector2): number
	return (pointA.X - pointB.X)^2 + (pointA.Y - pointB.Y)^2
end

--- Interpolates between two numbers based off percentage given
-- <number> num0
-- <number> num1
-- <number> percent
--
--- @return number x interpolated num0 towards num1 based off percent
function Math.lerp(num0: number, num1: number, percent: number): number
	math.clamp(percent, 0, 1)
	return num0 + ((num1 - num0) * percent)
end

--- Determines the distance between two Vector points
-- <Vector3> | <Vector2> pointA
-- <Vector3> | <Vector2> pointB
--
--- @return number dist distace/magnitude
function Math.distance(pointA: Vector3 | Vector2, pointB: Vector3 | Vector2): number
	return math.sqrt(cSquared(pointA, pointB))
end

--- Determines if pointA is within pointB by given radius
-- <Vector3> | <Vector2> pointA
-- <Vector3> | <Vector2> pointB
-- <number> radius
--
--- @return boolean isWithin pointA is within radius of pointB
 function Math.within(pointA: Vector3 | Vector2, pointB: Vector3 | Vector2, radius: number): boolean
	return Math.distance(pointA, pointB) <= radius
end

--- Returns the inverse of x, where min is the Minimum range and max the Maximum range
-- <number> min
-- <number> max
-- <number> x
--
--- @return number inversed inverse of x within range min/max
function Math.inverse(min: number, max: number, x: number): number
	return (max + min) - x
end

-- EgoMoose
 function Math.deltaAngle(a: number, b: number): number
	local A, B = (math.deg(a) + 360)%360, (math.deg(b) + 360)%360;

	local d = math.abs(B - A);
	local r = d > 180 and 360 - d or d;

	local ab = A - B;
	local sign = ((ab >= 0 and ab <= 180) or (ab <= -180 and ab >= -360)) and 1 or -1;

	return math.rad(r*sign);
end

--- Determins if pointB is infront pointA given the target angle
-- <number> targAngle
-- <Vector3> facing
-- <CFrame> pointA
-- <CFrame> pointB
--
--- @return boolean isFront pointB is infront of pointA
function Math.isFront(targAngle: number, pointA: CFrame, pointB: CFrame)
	local facing = pointA.LookVector
	local vectorUnit = (pointA.Position - pointB.Position).Unit
	local angle = math.acos(facing:Dot(vectorUnit))

	return angle >= targAngle
end


function Math.isNaN(num: (number?) | (string?))
	return type(num) ~= "number" or not tonumber(num)
end


return Math