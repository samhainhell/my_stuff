-- Script that kills a tribe when all its units die, yet the Shaman is still inside a prison

import(Module_Players) -- to get tribe population
import(Module_Defines) -- for shaman state
import(Module_PopScript) -- to kill the inprisioned shaman
import(Module_Objects) -- to get the shaman object
import(Module_Map) -- to get shaman's position
import(Module_Globals) -- gsi()
import(Module_DataTypes)


for i = 0, 7 do

	SET_NO_REINC(i)

end

function OnTurn()

	if gsi().Counts.GameTurn % 24 == 0 then
		
		if gsi().Counts.GameTurn > 240 then

			local count = 0

			for i = 0, 7 do

				local tribe = gsi().Players[i].NumPeople

				if tribe == 1 then

					local shaman = getShaman(count)
					if shaman ~= nil then

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
