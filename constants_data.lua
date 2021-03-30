local data =
{
	base = "SPLazyMachine" ,
	autoLoad = true ,
	autoName = true ,
	
	levels = {}
}

for i = 1 , 10 , 1 do
	data.levels["lazy"..i] = { speedMult = 1-i*0.05 , healthMult = 1-i*0.05 }
end
data.levelCount = #data.levels

return data