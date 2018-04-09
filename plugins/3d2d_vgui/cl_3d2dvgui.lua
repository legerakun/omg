local Plugin = {}
--[[
	
3D2D VGUI Wrapper
Copyright (c) 2015 Alexander Overvoorde, Matt Stevens

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.



local origin = Vector(0, 0, 0)
local angle = Vector(0, 0, 0)
local normal = Vector(0, 0, 0)
local scale = 0
local c_angle = Angle(0,0,0)

-- Helper functions

local function getCursorPos()
    local eyepos = EyePos()
	local eyenormal = gui.ScreenToVector(gui.MousePos())

	local p = util.IntersectRayWithPlane(eyepos, eyenormal, origin, normal)
	-- if there wasn't an intersection, don't calculate anything.
	if not p then return 0, 0 end


	local offset = origin - p
	
	local offsetp = Vector(offset.x, offset.y, offset.z)
	offsetp:Rotate(-normal:Angle())
	
		--local x = offset:Dot(-c_angle:Forward()) / scale
		--local y = offset:Dot(-c_angle:Right()) / scale
	
	local x,y = nil--WorldToLocal(p, Angle(0,0,0), origin, angle)
    x = (-offsetp.y)--*(scale*80)
    y = (offsetp.z)--*(scale*80)

	return x, y
end

local function getParents( pnl )
	local parents = {}
	local parent = pnl:GetParent()
	while ( parent ) do
		table.insert( parents, parent )
		parent = parent:GetParent()
	end
	return parents
end

local function absolutePanelPos( pnl )
	local x, y = pnl:GetPos()
	local parents = getParents( pnl )
	
	for _, parent in ipairs( parents ) do
		local px, py = parent:GetPos()
		x = x + px
		y = y + py
	end
	
	return x, y
end

local function pointInsidePanel( pnl, x, y )
	local px, py = absolutePanelPos( pnl )
	local sx, sy = pnl:GetSize()

	x = x / scale
	y = y / scale

	return x >= px and y >= py and x <= px + sx and y <= py + sy
end

-- Input

local inputWindows = {}
local usedpanel = {}

function InputWindowsTbl()
return inputWindows
end

local function isMouseOver( pnl )
	return pointInsidePanel( pnl, getCursorPos() )
end

local function postPanelEvent( pnl, event, ... )
	if ( not IsValid( pnl ) or not pnl:IsVisible() or not pointInsidePanel(pnl, getCursorPos()) ) then return false end

	local handled = false
	
	for i, child in pairs( pnl:GetChildren() ) do
		if ( postPanelEvent( child, event, ... ) ) then
			handled = true
			break
		end
	end
	
	if ( not handled and pnl[ event ] ) then
		pnl[ event ]( pnl, ... )
		usedpanel[pnl] = {...}
		return true
	else
		return false
	end
end

function WindowPostPanelEvent(pnl, event, ...)
postPanelEvent(pnl, event, ...)
end

local function checkHover( pnl, x, y )
	if not (x and y) then
		x,y=getCursorPos()
	end
	pnl.WasHovered = pnl.Hovered
	pnl.Hovered = pointInsidePanel( pnl, x, y )
	
	if not pnl.WasHovered and pnl.Hovered then
		if pnl.OnCursorEntered then pnl:OnCursorEntered() end
	elseif pnl.WasHovered and not pnl.Hovered then
		if pnl.OnCursorExited then pnl:OnCursorExited() end
	end

	for i, child in pairs( pnl:GetChildren() ) do
		if ( child:IsValid() and child:IsVisible() ) then checkHover( child, x, y ) end
	end
end

-- Mouse input

function Plugin:KeyPress( _, key )
	if ( key == IN_USE ) then
		for pnl in pairs( inputWindows ) do
			if ( IsValid( pnl ) ) then
				origin = pnl.Origin
				scale = pnl.Scale
				angle = pnl.Angle
				c_angle = pnl.C_Angle
				normal = pnl.Normal

				local key = input.IsKeyDown(KEY_LSHIFT) and MOUSE_RIGHT or MOUSE_LEFT
				
				postPanelEvent( pnl, "OnMousePressed", key )
			end
		end
	end
end

function Plugin:KeyRelease( _, key )
	if ( key == IN_USE ) then
		for pnl, key in pairs( usedpanel ) do
			if ( IsValid(pnl) ) then
				origin = pnl.Origin
				scale = pnl.Scale
				angle = pnl.Angle
				c_angle = pnl.C_Angle
				normal = pnl.Normal

				if ( pnl[ "OnMouseReleased" ] ) then
					pnl[ "OnMouseReleased" ]( pnl, key[ 1 ] )
				end

				usedpanel[ pnl ] = nil
			end
		end
	end
end
-- Key input

-- TODO, OH DEAR.
-- Drawing:

function vgui.Start3D2D( pos, ang, res )
	origin = pos
	scale = res
	angle = ang:Forward()
	c_angle = Angle(ang.p, ang.y, ang.r)
	
	normal = Angle( ang.p, ang.y, ang.r )
	normal:RotateAroundAxis( ang:Forward(), -90 )
	normal:RotateAroundAxis( ang:Right(), 90 )
	normal = normal:Forward()
	
	cam.Start3D2D( pos, ang, res )
end

local Panel = FindMetaTable("Panel")
function Panel:Paint3D2D()
	if not self:IsValid() then return end
	
	-- Add it to the list of windows to receive input
	inputWindows[ self ] = true

	-- Override gui.MouseX and gui.MouseY for certain stuff
	local oldMouseX = gui.MouseX
	local oldMouseY = gui.MouseY
	local cx, cy = getCursorPos()

	function gui.MouseX()
		return cx / scale
	end
	function gui.MouseY()	
		return cy / scale
	end
	
	-- Override think of DFrame's to correct the mouse pos by changing the active orientation
	if self.Think then
		if not self.OThink then
			self.OThink = self.Think
			
			self.Think = function()
				origin = self.Origin
				scale = self.Scale
				angle = self.Angle
				c_angle = self.C_Angle
				normal = self.Normal
				
				self:OThink()
			end
		end
	end
	
	-- Update the hover state of controls
	checkHover( self )
	
	-- Store the orientation of the window to calculate the position outside the render loop
	self.Origin = origin
	self.Scale = scale
	self.Angle = angle
	self.C_Angle = c_angle
	self.Normal = normal
	
	-- Draw it manually
	self:SetPaintedManually( false )
		self:PaintManual()
	self:SetPaintedManually( true )

	gui.MouseX = oldMouseX
	gui.MouseY = oldMouseY
end

function vgui.End3D2D()
	cam.End3D2D()
end

function Plugin:PostDrawOpaqueRenderables()
/*
local vm = LocalPlayer():GetViewModel()
local vang = vm:GetAngles()
--
local startPos = vm:GetPos()+vang:Forward()*-4
local dir = gui.ScreenToVector(input.GetCursorPos())
local trace = util.QuickTrace(startPos, dir*1e9, LocalPlayer())
local endPos = trace.HitPos
PrintTable(trace)
render.DrawLine( startPos, endPos, Color(204,204,0))
*/
end

-- Keep track of child controls

-- It's now useless
-- http://wiki.garrysmod.com/page/Panel/GetChildren
-- http://wiki.garrysmod.com/page/Panel/GetParent
--[[ 
if not vguiCreate then vguiCreate = vgui.Create end
function vgui.Create( class, parent )
	local pnl = vguiCreate( class, parent )
	if not pnl then return end
	
	pnl.Parent = parent
	pnl.Class = class
	
	if parent and type(parent) == "Panel" and IsValid(parent) then
		if not parent.Childs then parent.Childs = {} end
		parent.Childs[ pnl ] = true
	end
	return pnl
end
--]] 


local origin = Vector(0, 0, 0)
local angle = Angle(0, 0, 0)
local normal = Vector(0, 0, 0)
local scale = 0
local maxrange = 0
local scrolling = false

-- Helper functions

local function getCursorPos()
    local dir =  gui.ScreenToVector(gui.MousePos()) 
	dir = dir:GetNormal()*1e9
	local p = util.IntersectRayWithPlane(EyePos(), dir, origin, normal)

	-- if there wasn't an intersection, don't calculate anything.
	if not p then return end
	if WorldToLocal(LocalPlayer():GetShootPos(), Angle(0,0,0), origin, angle).z < 0 then return end

	if maxrange > 0 then
		if p:Distance(EyePos()) > maxrange then
			return
		end
	end

	local pos = WorldToLocal(p, Angle(0,0,0), origin, angle)

	return pos.x, -pos.y
end

local function getParents(pnl)
	local parents = {}
	local parent = pnl:GetParent()
	while parent do
		table.insert(parents, parent)
		parent = parent:GetParent()
	end
	return parents
end

local function absolutePanelPos(pnl)
	local x, y = pnl:GetPos()
	local parents = getParents(pnl)
	
	for _, parent in ipairs(parents) do
		local px, py = parent:GetPos()
		x = x + px
		y = y + py
	end
	
	return x, y
end

local function pointInsidePanel(pnl, x, y)
	local px, py = absolutePanelPos(pnl)
	local sx, sy = pnl:GetSize()

	if not x or not y then return end

	x = x / scale
	y = y / scale

	return pnl:IsVisible() and x >= px and y >= py and x <= px + sx and y <= py + sy
end

-- Input

local inputWindows = {}
local usedpanel = {}

local function isMouseOver(pnl)
	return pointInsidePanel(pnl, getCursorPos())
end

function InputWindowsTbl()
    return inputWindows
end

local function postPanelEvent( pnl, event, ... )
	if ( not IsValid( pnl ) or not pnl:IsVisible() or not pointInsidePanel(pnl, getCursorPos()) ) then return false end
    if scrolling and event == "OnMousePressed" or scrolling and event == "OnMouseReleased" then return end
	
	local handled = false
	
	for i, child in pairs( pnl:GetChildren() ) do
		if ( postPanelEvent( child, event, ... ) ) then
			handled = true
			break
		end
	end
	
	if ( not handled and pnl[ event ] ) then
		pnl[ event ]( pnl, ... )
		usedpanel[pnl] = {...}
		return true
	else
		return false
	end
end

function WindowPostPanelEvent(pnl, event, ...)
    postPanelEvent(pnl, event, ...)
end

-- Always have issue, but less
local function checkHover(pnl, x, y, found)
	if not (x and y) then
		x, y = getCursorPos()
	end

	local validchild = false
	for c, child in pairs(table.Reverse(pnl:GetChildren())) do
		local check = checkHover(child, x, y, found or validchild)

		if check then
			validchild = true
		end
	end

	if found then
		if pnl.Hovered and !scrolling then
			if pnl.OnCursorExited then pnl:OnCursorExited() end
			pnl.Hovered = false
		end
	else
		if not validchild and pointInsidePanel(pnl, x, y) then
		    if not pnl.Hovered and !scrolling then
			  if pnl.OnCursorEntered then pnl:OnCursorEntered() end
			end
			pnl.Hovered = true
			return true
		else
		  if pnl.Hovered and !scrolling then
		    if pnl.OnCursorExited then pnl:OnCursorExited() end
		  end
			pnl.Hovered = false
		end
	end

	return false
end

-- Mouse input

function Plugin:KeyPress( _, key )
	if ( key == IN_USE ) then
		for pnl in pairs( inputWindows ) do
			if ( IsValid( pnl ) ) then
				origin = pnl.Origin
				scale = pnl.Scale
				angle = pnl.Angle
				c_angle = pnl.C_Angle
				normal = pnl.Normal

				local key = input.IsKeyDown(KEY_LSHIFT) and MOUSE_RIGHT or MOUSE_LEFT or MOUSE_RIGHT
				
				postPanelEvent( pnl, "OnMousePressed", key )
			end
		end
	end
end

function Plugin:KeyRelease( _, key )
	if ( key == IN_USE ) then
		for pnl, key in pairs( usedpanel ) do
			if ( IsValid(pnl) ) then
				origin = pnl.Origin
				scale = pnl.Scale
				angle = pnl.Angle
				c_angle = pnl.C_Angle
				normal = pnl.Normal

				if ( pnl[ "OnMouseReleased" ] ) then
					pnl[ "OnMouseReleased" ]( pnl, key[ 1 ] )
				end

				usedpanel[ pnl ] = nil
			end
		end
	end
end

function vgui.Start3D2D(pos, ang, res)
	origin = pos
	scale = res
	angle = ang
	normal = ang:Up()
	maxrange = 0
	
	cam.Start3D2D(pos, ang, res)
end

function vgui.MaxRange3D2D(range)
	maxrange = isnumber(range) and range or 0
end

function vgui.IsPointingPanel(pnl)
	origin = pnl.Origin
	scale = pnl.Scale
	angle = pnl.Angle
	normal = pnl.Normal

	return pointInsidePanel(pnl, getCursorPos())
end

local Panel = FindMetaTable("Panel")
function Panel:Paint3D2D()
	if not self:IsValid() then return end
	
	-- Add it to the list of windows to receive input
	inputWindows[self] = true

	-- Override gui.MouseX and gui.MouseY for certain stuff
	local oldMouseX = gui.MouseX
	local oldMouseY = gui.MouseY
	local cx, cy = getCursorPos()

	function gui.MouseX()
		return (cx or 0) / scale
	end
	function gui.MouseY()
		return (cy or 0) / scale
	end
	
	-- Override think of DFrame's to correct the mouse pos by changing the active orientation
	if self.Think then
		if not self.OThink then
			self.OThink = self.Think
			
			self.Think = function()
				origin = self.Origin
				scale = self.Scale
				angle = self.Angle
				normal = self.Normal
				
				self:OThink()
			end
		end
	end
	
	-- Update the hover state of controls
	local _, tab = checkHover(self)
	
	-- Store the orientation of the window to calculate the position outside the render loop
	self.Origin = origin
	self.Scale = scale
	self.Angle = angle
	self.Normal = normal
	
	-- Draw it manually
	self:SetPaintedManually(false)
		self:PaintManual()
	self:SetPaintedManually(true)

	gui.MouseX = oldMouseX
	gui.MouseY = oldMouseY
end

function vgui.End3D2D()
	cam.End3D2D()
end

return Plugin