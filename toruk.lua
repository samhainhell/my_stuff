-- Script that kills a tribe when all its units die, yet the Shaman is still inside a prison

import(Module_System)
import(Module_Players)
import(Module_Defines)
import(Module_PopScript)
import(Module_Game)
import(Module_Objects)
import(Module_Map)
import(Module_DataTypes)

include("UtilPThings.lua")
include("UtilRefs.lua")

for i = 0, 7 do
	SET_NO_REINC(i)
end

function OnTurn()
	
	if everyPow(24, 1) then
		if _gsi.Counts.GameTurn > 240 then
			local count = 0
			for i = 0, 7 do
				local tribe = _gsi.Players[i].NumPeople
				if tribe == 1 then
					local shaman = getShaman(count)
					if (shaman ~= nil) then
						if shaman.State == S_PERSON_SHAMAN_IN_PRISON then
							local mp = MapPosXZ.new()
							mp.Pos = world_coord2d_to_map_idx(shaman.Pos.D2)
							KILL_TEAM_IN_AREA(mp.XZ.X, mp.XZ.Z, 0)
							count = count + 1
						else
							count = count + 1
						end
					else
						count = count + 1
					end
				else
					count = count + 1
				end
			end
		end
	end
	
end
