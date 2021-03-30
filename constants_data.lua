local data =
{
	base = "SPLazyMachine" ,
	autoLoad = true ,
	autoName = true ,
	
	levelCount = 10 ,
	levels = {}
}

for i = 1 , data.levelCount , 1 do
	data.levels["lazy"..i] = { speedMult = 1-i*0.05 , healthMult = 1-i*0.05 }
end

return data