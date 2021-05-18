require( "__SICoreFunctionLibrary__/util" )

needlist( "__SICoreFunctionLibrary__" , "define/load" , "function/load" )
needlist( "__SICoreFunctionLibrary__/runtime/structure" , "sievent_bus" , "siglobal" )

load()

-- ------------------------------------------------------------------------------------------------
-- ---------- 装载数据 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SINoise = need( "__SICoreFunctionLibrary__/library/sinoise" )

LazyReg = "%-lazy[0-9]+$"
LevelCount = ( SISPLM.levelCount + 8 ) / 2

-- ------------------------------------------------------------------------------------------------
-- ---------- 更新机器 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

function Build( event )
	local entity = event.created_entity or event.entity
	local type = entity.type
	if type == SITypes.entity.furnace or type == SITypes.entity.machine then
		local surface = entity.surface
		local pos = entity.position
		local noise = SINoise.New( surface.map_gen_settings.seed , 4 , 0.7 , 25 )
		local level = math.floor( (noise:Get( pos.x , pos.y )+1)*LevelCount ) - 7
		level = math.fmod( level , SISPLM.levelCount+1 )
		--sip( "pos : {"..pos.x..","..pos.y.."} , source : "..noise:Get( pos.x , pos.y ).." , level : "..level ) -- 输出控制台
		
		local flag = true
		local name = entity.name
		local ind = name:find( LazyReg )
		if ind then
			local oldLevel = tonumber( name:sub( ind+5 ) )
			if oldLevel == level then return
			else
				flag = false
				name = name:sub( 1 , ind-1 )
			end
		end
		if level < 1 and flag then return end
		
		if level > 0 then name = name .. "-lazy" .. level end
		local new_entity = surface.create_entity{ name = name , position = pos , direction = entity.direction , force = entity.force , raise_built = false }
		if not new_entity then return end
		new_entity.copy_settings( entity )
		entity.destroy{ raise_destroy = true }
	end
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 事件注册 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIEventBus
.Add( SIEvents.on_built_entity , Build )
.Add( SIEvents.on_robot_built_entity , Build )
.Add( SIEvents.script_raised_built , Build )