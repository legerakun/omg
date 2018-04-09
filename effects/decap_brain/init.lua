/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )

	local ourang = data:GetAngles()
	
	self.Entity:SetModel( Fallout_GIBS[1] )
	self.Entity:SetAngles(ourang)
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	
	// Only collide with world/static
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	self.Entity:SetCollisionBounds( Vector( -128 -128, -128 ), Vector( 128, 128, 128 ) )
	
	local phys = self.Entity:GetPhysicsObject()
	if ( phys && phys:IsValid() ) then
	
		phys:Wake()
		phys:SetAngles( ourang )
		--phys:SetVelocity( ourang:Up() * math.random(200,250) )
		phys:SetVelocity( VectorRand() * math.random(100,200) )
	
	end
	
	self.LifeTime = CurTime() + math.Rand( 20, 30 )
	
end

/*---------------------------------------------------------
   THINK
   Returning false makes the entity die
---------------------------------------------------------*/
function EFFECT:Think( )

	return ( self.LifeTime > CurTime() ) 
	
end


/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()

	self.Entity:DrawModel()

end



