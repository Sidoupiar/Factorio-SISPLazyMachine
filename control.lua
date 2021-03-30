require( "__SICoreFunctionLibrary__/util" )

needlist( "__SICoreFunctionLibrary__" , "define/load" , "function/load" )
needlist( "__SICoreFunctionLibrary__/runtime/structure" , "sievent_bus" , "siglobal" )

load()

-- ------------------------------------------------------------------------------------------------
-- ---------- 装载数据 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SINoise = need( "__SICoreFunctionLibrary__/function/lib/sinoise" )
LevelCount = ( SISPLM.levelCount + 1 ) / 2

-- ------------------------------------------------------------------------------------------------
-- ---------- 更新机器 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

function Build( event )
	local entity = event.created_entity or event.entity
	if entity.type == SITypes.entity.furnace or entity.type == SITypes.entity.machine then
		local name = entity.name
		if not name:find( "-lazy[0-9]+$" ) then
			local surface = entity.surface
			local pos = entity.position
			local noise = SINoise.New( surface.map_gen_settings.seed , 4 , 0.7 , 25 )
			local level = math.floor( (noise:Get( pos.x , pos.y )+1)*LevelCount )
			level =  math.fmod( level , SISPLM.levelCount+1 )
			--sip( "pos : {"..pos.x..","..pos.y.."} , source : "..noise:Get( pos.x , pos.y ).." , level : "..level ) -- 输出控制台
			if level < 1 then return end
			name = name .. "-lazy" .. level
			local new_entity = surface.create_entity{ name = name , position = pos , direction = entity.direction , force = entity.force , raise_built = true }
			if not new_entity then return end
			new_entity.copy_settings( entity )
			entity.destroy{ raise_destroy = true }
		end
	end
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 事件注册 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIEventBus
.Add( SIEvents.on_built_entity , Build )
.Add( SIEvents.on_robot_built_entity , Build )
.Add( SIEvents.script_raised_built , Build )