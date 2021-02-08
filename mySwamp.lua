-- Changed Swamp (Based on Kosjak's)

import(Module_DataTypes)
import(Module_Defines)
import(Module_Objects)
import(Module_Map)
import(Module_Game)
import(Module_Table)
import(Module_Globals)
import(Module_Person)
import(Module_Players)

mySwamp = {}

mySwamp.new = function(...)
	
	local args = {...}
	local data = {}
	data.sOwner = nil
	data.sCoord3D = nil
	data.sDuration = nil
	data.sDamage = nil
	data.sDecayed = false

	data.sMapElement = {}
	data.sMistEffect = {}
	data.sReedyGrass = {}

	function data:sInit(arg1, arg2, arg3, arg4)
		data.sOwner = arg1
		data.sCoord3D = arg2
		data.sDuration = gsi().Counts.GameTurn + arg3
		data.sDamage = arg4
		
		local mp = MapPosXZ.new()
		mp.Pos = world_coord3d_to_map_idx(data.sCoord3D)
		mp.XZ.X = mp.XZ.X-4
		mp.XZ.Z = mp.XZ.Z-4
		local x = 0
		local z = 0

		for i = 0,8,2 do
			x = mp.XZ.X+i
			for i = 0,8,2 do
				z = mp.XZ.Z+i

				local cC3D = MAP_XZ_2_WORLD_XYZ(x,z)
				local me = world_coord3d_to_map_ptr(cC3D)

				if is_map_elem_land_or_coast(me) > 0 then
					table.insert(data.sMapElement, me.MapWhoList)

					local c2D = Coord2D.new()
					map_ptr_to_world_coord2d(me, c2D)
					local c3D = Coord3D.new()
					coord2D_to_coord3D(c2D, c3D)
					centre_coord3d_on_block(c3D)
			
					local mist = createThing(T_EFFECT, M_EFFECT_SWAMP_MIST, data.sOwner, c3D, false, false)
					table.insert(data.sMistEffect, mist)

					if G_RANDOM(4) > 0 then
						local grass = createThing(T_EFFECT, M_EFFECT_REEDY_GRASS, data.sOwner, c3D, false, false)
						table.insert(data.sReedyGrass, grass)
					end
				end
			end
		end
	end


	function data:sProcess(turn)

		if turn < data.sDuration then
			for i, object in ipairs(data.sMapElement) do
				local count = 0
				object:processList(function(t)
					if count < 9 then
						count = count + 1
						if t.Type == T_PERSON then
							if t.Model > 1 and t.Model < 8 then 
								if t.Owner ~= data.sOwner then 
									if is_thing_on_ground(t) == 1 and is_person_in_any_vehicle(t) == 0 and is_person_in_drum_tower(t) and are_players_allied(data.sOwner, t.Owner) then
										damage_person(t, data.sOwner, data.sDamage, 1)
									end
								end
							end
						end
						return true
					else
						return false
					end
				end)
			end
		else
			data:sDeath()
		end

	end


	function data:sDeath()
		data.sDecayed = true
		for i, t in ipairs(data.sMistEffect) do
			DestroyThing(t)
		end
		for i, t in ipairs(data.sReedyGrass) do
			DestroyThing(t)
		end
		for i in ipairs(data.sMapElement) do
			table.remove(data.sMapElement, i)
		end
	end


	function data:isDecayed()
		return data.sDecayed
	end


	data:sInit(args[1],args[2],args[3],args[4])

	return data

end

swamps = {}

function OnTurn()

	if gsi().Counts.GameTurn % 8 == 0 then
		local turn = gsi().Counts.GameTurn
		for i in ipairs(swamps) do
			if swamps[i].isDecayed() then
				table.remove(swamps, i)
			else
				swamps[i]:sProcess(turn)
			end
		end
	end

end


function OnCreateThing(t)

	if t.Type == T_EFFECT then
		if t.Model == M_EFFECT_SWAMP then
			if t.Owner ~= TRIBE_HOSTBOT or TRIBE_NEUTRAL then
				if is_map_elem_land_or_coast(world_coord2d_to_map_ptr(t.Pos.D2)) > 0 then
					local swamp = mySwamp.new(t.Owner, t.Pos.D3, 1440, 180)
					table.insert(swamps, swamp)
				end
				DestroyThing(t)
			end
		end
	end

end
