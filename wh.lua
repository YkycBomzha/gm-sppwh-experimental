if CLIENT then
	print( "-- SPP WhTest V1 --" )
	
	surface.CreateFont( "SUKAEBATNAHUI", {
	font = "Arial",
	extended = false,
	size = 13,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true,
	} )

	surface.CreateFont( "MELKOECHMO", {
	font = "GModToolScreen",
	extended = false,
	size = 16,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
	} )
	
	CreateConVar( "eyeline", 1, { FCVAR_CLIENTCMD_CAN_EXECUTE } )
	CreateConVar( "halos", 1, { FCVAR_CLIENTCMD_CAN_EXECUTE } )
	CreateConVar( "info", 1, { FCVAR_CLIENTCMD_CAN_EXECUTE } )
	CreateConVar( "thruwall", 1, { FCVAR_CLIENTCMD_CAN_EXECUTE } )
	CreateConVar( "aim", 0, { FCVAR_CLIENTCMD_CAN_EXECUTE } ) -- That is what i need to work for.
	
	hook.Add( "HUDPaint", "cock", function()
		local function GetTextSize( font, text ) surface.SetFont( font ) return surface.GetTextSize( text ) end

		for id, ply in pairs( player.GetAll() ) do
			local wpos
			local state
			local state_color
			local poss = ply:GetPos():ToScreen()
	        
	    	if ply:LookupAttachment("eyes") ~= 0 then
				wpos = (ply:GetAttachment(me:LookupAttachment("eyes")).Pos + Vector(0,0,0))
			else
				wpos = ply:GetPos()
			end
			
			curcolor = color_white
			position = ply:GetEyeTrace().HitPos
			pos = wpos:ToScreen()
			distance =  ply:GetPos()-LocalPlayer():GetPos()
			
			if ply ~= LocalPlayer() && ply:Alive() && !ply:IsBot() && GetConVar( "eyeline" ):GetBool() == true then -- Eye Line
				cam.Start3D( EyePos(), EyeAngles() )
					cam.IgnoreZ( true )
		    		render.DrawLine( wpos, position, Color( 255, 0, 0, 255 ), true )
		    		cam.IgnoreZ( false )
		    	cam.End3D()
			end
			
			if ply ~= LocalPlayer() && GetConVar( "info" ):GetBool() == true then	-- Name
				local curcolor = team.GetColor( ply:Team() )
				
				local text1_w = GetTextSize( "SUKAEBATNAHUI", "PLAYER: " )
				local text2_w = GetTextSize( "SUKAEBATNAHUI", ply:Name() )
				
		    	draw.SimpleText( "PLAYER: ", 'SUKAEBATNAHUI', poss.x-text2_w, poss.y, curcolor )
		    	draw.SimpleText( ply:Name(), 'SUKAEBATNAHUI', poss.x+text2_w, poss.y, color_white )
				if !ply:IsBot() then draw.SimpleText( "DISTANCE: ", 'SUKAEBATNAHUI', poss.x-text2_w, poss.y+15, curcolor )
		    	draw.SimpleText( math.floor( math.abs( distance.x + distance.y + distance.z ) ) .. " units", 'SUKAEBATNAHUI', poss.x+text2_w, poss.y+15, color_white )
		    	draw.SimpleText( "RANK: ", 'SUKAEBATNAHUI', poss.x-text2_w, poss.y+30, curcolor )
		    	draw.SimpleText( ply:GetUserGroup() .. " (" .. team.GetName( ply:Team() ) .. ")", 'SUKAEBATNAHUI', poss.x+text2_w, poss.y+30, color_white )
		    	draw.SimpleText( ply:Health(), 'MELKOECHMO', poss.x-text2_w, poss.y+45, Color( 0, 255, 0 ) )
		    	draw.SimpleText( ply:Armor(), 'MELKOECHMO', poss.x+text2_w, poss.y+45, Color( 12, 32, 229 ) ) end
				if ply:Alive() then state = "ALIVE" state_color = Color( 0, 222, 0, 88 ) else state = "DEAD" state_color = Color( 255, 0, 0, 255 ) end
				if ply:IsTyping() then state = "TYPING" state_color = Color( 0, 161, 255, 255 ) end
				draw.SimpleText( state, 'MELKOECHMO', poss.x-15, poss.y+45, state_color )
			end
		end
		
		if GetConVar( "thruwall" ):GetBool() == true then
			cam.Start3D()
			for _, ply in ipairs( player.GetAll() ) do
				if ply ~= LocalPlayer() && ply:Alive() then
					local health = math.Min( 100, ply:Health() )
					ply:DrawModel()
					ply:SetRenderMode( RENDERMODE_TRANSCOLOR )
				end
			end
			cam.End3D()
		end
	end )

	hook.Add( "PreDrawHalos", "cumchatka", function ()
		if GetConVar( "halos" ):GetBool() == true then
			local players = {}
				for _, ply in ipairs( player.GetAll() ) do
					if ply ~= LocalPlayer() && ply:Alive() || ply:IsBot() then
						players[ #players + 1 ] = ply
					end
				end
				halo.Add( players, Color( 255, 0, 0, 255 ), 4, 4, 1, true, true )
			end
	end )

	hook.Add( "PlayerButtonDown", "CockMoveTracker", function( ply )
		if ply == LocalPlayer() then
			if input.WasKeyPressed( 38 ) then
				GetConVar( "eyeline" ):SetBool( !GetConVar( "eyeline" ):GetBool() ) GetConVar( "halos" ):SetBool( !GetConVar( "halos" ):GetBool() )
			elseif input.WasKeyPressed( 39 ) then
				GetConVar( "info" ):SetBool( !GetConVar( "info" ):GetBool() ) GetConVar( "thruwall" ):SetBool( !GetConVar( "thruwall" ):GetBool() )
			elseif input.WasKeyPressed( 40 ) then
				GetConVar( "aim" ):SetBool( !GetConVar( "aim" ):GetBool() )
			end
		end
	end )
	
end 
