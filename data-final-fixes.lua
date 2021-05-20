-- ------------------------------------------------------------------------------------------------
-- -------- 新增设备分身 --------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local list = {}
for index , type in pairs{ SITypes.entity.furnace , SITypes.entity.machine } do
	for name , entity in pairs( SIGen.GetList( type ) ) do
		if entity then
			for level , code in pairs( SISPLM.levels ) do
				local new_machine = table.deepcopy( entity )
				new_machine.name = entity.name .. "-" .. level
				new_machine.crafting_speed = entity.crafting_speed * code.speedMult
				new_machine.max_health = entity.max_health * code.healthMult
				new_machine.placeable_by = { item = SIDataGetters.GetMiningResult( entity ) , count = 1 }
				if not entity.localised_name then new_machine.localised_name = { "entity-name."..entity.name } end
				if not entity.localised_description then new_machine.localised_description = { "entity-description."..entity.name } end
				if new_machine.flags then
					if not table.Has( new_machine.flags , SIFlags.entityFlags.hidden ) then table.insert( new_machine.flags , SIFlags.entityFlags.hidden ) end
				else new_machine.flags = { SIFlags.entityFlags.hidden } end
				table.insert( list , new_machine )
			end
		end
	end
end
SIGen.Extend( list )