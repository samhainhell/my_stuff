-- Script that sets up the map allies!
-- NOTE: Using this script will make it so that independently of your team choices in the pre-game lobby, you won't have any control over who allies who!

import(Module_Map) -- For map functions
import(Module_Defines) -- For shaman identifier
import(Module_Table) -- For tables
import(Module_Objects) -- For searching map element objects
import(Module_Players) -- For allying players

-- Put the locations of the shamans from the teams you want to ally
-- First value is X, second is Z.. You can see those values in the World Editor
local ReincPos = {
  MAP_XZ_2_WORLD_XYZ(0, 0), -- Team 1
  MAP_XZ_2_WORLD_XYZ(0, 0), -- Team 1
  MAP_XZ_2_WORLD_XYZ(0, 0), -- Team 1
  MAP_XZ_2_WORLD_XYZ(0, 0), -- Team 1

  MAP_XZ_2_WORLD_XYZ(0, 0), -- Team 2
  MAP_XZ_2_WORLD_XYZ(0, 0), -- Team 2
  MAP_XZ_2_WORLD_XYZ(0, 0), -- Team 2
  MAP_XZ_2_WORLD_XYZ(0, 0)  -- Team 2
}

-- Team One and Two
local teamOne = {}
local teamTwo = {}

-- Setting up both teams
for i,k in ipairs(ReincPos) do
  local me = world_coord3d_to_map_ptr(k)
  me.MapWhoList:processList(function(t)
    if (t.Type == T_PERSON) then
      if (t.Model == M_PERSON_MEDICINE_MAN) then
        if (i <= 4) then
          table.insert(teamOne, t.Owner)
        else
          table.insert(teamTwo, t.Owner)
        end
      end
    end
    return true
  end)
end

-- Allying Team 1
for i, v in ipairs(teamOne) do
    for k, t in ipairs(teamOne) do
        set_players_allied(v, t)
    end
end

-- Allying Team 2
for i, v in ipairs(teamTwo) do
    for k, t in ipairs(teamTwo) do
        set_players_allied(v, t)
    end
end