local c = { }

c.__index = c

if not file.IsDir( "tex", "DATA" ) then
	file.CreateDir( "tex" )
end

function c:Download( )
	if self:IsDownloading( ) or self:IsReady( ) then
		return
	end
	
	local uid = util.CRC( self.Path ) .. ".jpg"
	
	self.UID = uid
	
	http.Fetch( self.Path,
		function( body, len, headers, code )
			file.Write( "tex/" .. self.UID, body )
			self.Downloading = false
			self.Ready = true
		end,
		function ( err )
			ErrorNoHalt( "Error fetching texture '" .. self.Path .. "': " .. err .. "\n" )
		end
	)
end

function c:IsReady( )
	return self.Ready
end

function c:IsDownloading( )
	return self.Downloading
end

function c:GetMaterial( )
	if self:IsDownloading( ) or not self:IsReady( ) then
		return
	end
	
	local x = Material( "../data/tex/" .. self.UID, self.Flags )
	return x
end


function WebMaterial( path, flags )
	return setmetatable( { Path = path, Flags = flags, Ready = false, Downloading = false }, c )
end

hook.Add( "Think", "PW_URLMat", Think )