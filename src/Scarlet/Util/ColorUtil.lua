local ColorUtil = {}


local function fromPercent(p)
	return (p / 360)-- * 255
end


function ColorUtil.toRGB(color3)
	return Color3.fromRGB(color3.r * 255, color3.g * 255, color3.b * 255)
end


function ColorUtil.toColor3(rgb)
	return Color3.new(rgb.r / 255, rgb.g / 255, rgb.b / 255)
end

-- TODO: fix all color wheel implementations
function ColorUtil.Complementary(c0)
	local h, s, v = Color3.toHSV(c0)
	return Color3.fromHSV(math.abs((h + fromPercent(180)) - fromPercent(360)), s, v)
end


function ColorUtil.SplitComplementary(c0)
	local h, s, v = Color3.toHSV(c0)

	local c1 = Color3.fromHSV(math.abs((h + fromPercent(150)) - fromPercent(360)), s, v)
	local c2 = Color3.fromHSV(math.abs((h + fromPercent(210)) - fromPercent(360)), s, v)

	return c1, c2
end


function ColorUtil.Tridaic(c0)
	local h, s, v = Color3.toHSV(c0)

	local c1 = Color3.fromHSV(math.abs((h + fromPercent(120)) - fromPercent(360)), s, v)
	local c2 = Color3.fromHSV(math.abs((h + fromPercent(240)) - fromPercent(360)), s, v)

	return c0, c1, c2
end


function ColorUtil.Tetradic(c0)
	local h, s, v = Color3.toHSV(c0)

	local c1 = Color3.fromHSV(math.abs((h + fromPercent(90)) - fromPercent(360)), s, v)
	local c2 = Color3.fromHSV(math.abs((h + fromPercent(180)) - fromPercent(360)), s, v)
	local c3 = Color3.fromHSV(math.abs((h + fromPercent(270)) - fromPercent(360)), s, v)

	return c0, c1, c2, c3
end


function ColorUtil.Analogous(c0)
	local h, s, v = Color3.toHSV(c0)

	local c1 = Color3.fromHSV(math.abs((h + fromPercent(30)) - fromPercent(360)), s, v)
	local c3 = Color3.fromHSV(math.abs((h - fromPercent(60)) - fromPercent(360)), s, v)

	return c1, c0, c3
end


function ColorUtil.equals(colorA, colorB, epsilon)
	if typeof(colorA) ~= "Color3" or typeof(colorB) ~= "Color3" then
		return false
	end
	epsilon = epsilon or 0.001

	if math.abs(colorA.R - colorB.R) > epsilon then
		return false
	end

	if math.abs(colorA.G - colorB.G) > epsilon then
		return false
	end

	if math.abs(colorA.B - colorB.B) > epsilon then
		return false
	end

	return true
end


return ColorUtil