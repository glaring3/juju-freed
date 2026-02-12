if not LPH_OBFUSCATED then
	getfenv().LPH_NO_VIRTUALIZE = function(...) return ... end
	getfenv().LPH_NO_UPVALUES = function(...) return ... end
	getfenv().LPH_JIT_MAX = function(...) return ... end
	getfenv().LPH_ENCSTR = function(...) return ... end
	getfenv().LPH_JIT = function(...) return ... end
end

if getgenv().unload_juju then
	getgenv().unload_juju()
	task.wait(1)
end

if game["GameId"] ~= 1008451066 then
	game:GetService("Players")["LocalPlayer"]:Kick("hi")
	while true do end
	return
end

local is_solara = hookmetamethod == nil or getgenv().Xeno

if not is_solara then
	loadstring(LPH_ENCSTR([[
		for _, func in getconnections(game:GetService("ScriptContext").Error) do
			if func.Function then
				hookfunction(func.Function, function() end)
			end
		end

		for _, func in getconnections(game:GetService("LogService").MessageOut) do
			if func.Function then
				hookfunction(func.Function, function() end)
			end
		end

		local send_packet_upvalues

		for _, obj in getgc() do
			if typeof(obj) ~= "function" then
				continue
			end
			if not islclosure(obj) then
				continue
			end
			if not debug.getinfo(obj).source:find("=CorePackages.") then
				continue
			end

			if send_packet_upvalues then
				break
			end

			local upvalues = debug.getupvalues(obj)
			for _, upvalue in upvalues do
				if typeof(upvalue) ~= "table" then
					continue
				end
				for _, v1 in upvalue do
					if type(v1) ~= "table" then
						continue
					end
					if rawget(v1, "__tostring") then
						continue
					end
					for _, v2 in v1 do
						if type(v2) == "string" and v2 == "InvokeServer" then
							send_packet_upvalues = upvalues
							break
						end
					end
				end
			end
		end

		if send_packet_upvalues then
			local ac_threads = {};

			for _, upvalue in send_packet_upvalues do
				if type(upvalue) ~= "table" then
					continue
				end
				for _, v in upvalue do
					if type(v) ~= "table" then
						continue
					end
					for k, thread in v do
						if type(thread) == "thread" then
							ac_threads[k] = thread
							print(k)
						end
					end
				end
			end
			
			hookfunction(coroutine.status, newcclosure(function(...)
				return "suspended";
			end));

			local count = 0
			for i,v in ac_threads do
				count+=1
				coroutine.close(v);
			end;

			if count < 2 then
				game:GetService("Players")["LocalPlayer"]:Kick("juju > anticheat has updated, please wait for an update. this is for your safety <3 (TC)")
				return
			end

			getgenv().done = true
		end;
	]]))()

	task.wait(1)

	if not getgenv().done then
		game:GetService("Players")["LocalPlayer"]:Kick("juju > anticheat has updated, please wait for an update. this is for your safety <3 (D)")
		return
	end
end

if is_solara then
	game:GetService("Players")["LocalPlayer"]:Kick("Your executor is not supported.")
	return
end

task.wait(1)

local require = not is_solara and require or LPH_NO_VIRTUALIZE(function()local a=game.ReplicatedStorage.SkinModules;local b={Color3.new(1,0.560784,0.956863),ColorSequence.new(Color3.new(1,0.560784,0.956863),Color3.new(1,0.027451,0.839216))}local c={Color3.new(1,0.027451,0.839216),ColorSequence.new(Color3.new(0.0588235,0.0313725,0.054902),Color3.new(1,0.027451,0.839216))}local d={Color3.new(1,0,0.4),ColorSequence.new(Color3.new(0.0588235,0.0313725,0.054902),Color3.new(1,0.027451,0.839216))}local e={Color3.new(0.560784,0.470588,1),ColorSequence.new(Color3.new(0.560784,0.470588,1),Color3.new(0.576471,0.380392,1))}local f={Color3.new(0.113725,0.113725,0.113725),ColorSequence.new(Color3.new(0.113725,0.113725,0.113725),Color3.new(0,0,0))}local g={Color3.new(0.164706,0.333333,0.0862745),ColorSequence.new(Color3.new(1,0.94902,0.862745),Color3.new(0.196078,0.333333,0.0823529))}local h={Color3.new(0,0.47451,0.709804),ColorSequence.new(Color3.new(1,0.94902,0.862745),Color3.new(0,0.47451,0.713725))}local i={Color3.new(1,0.329412,0.741176),ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,0,0)),ColorSequenceKeypoint.new(0.14285714285714285,Color3.new(1,0.666667,0)),ColorSequenceKeypoint.new(0.2857142857142857,Color3.new(1,1,0)),ColorSequenceKeypoint.new(0.42857142857142855,Color3.new(0.333333,1,0)),ColorSequenceKeypoint.new(0.5714285714285714,Color3.new(0,0.333333,1)),ColorSequenceKeypoint.new(0.7142857142857143,Color3.new(0.666667,0.333333,1)),ColorSequenceKeypoint.new(1,Color3.new(1,0.333333,1))})}local j={Color3.new(0,1,1),ColorSequence.new(Color3.new(0,1,1),Color3.new(0.666667,1,1))}local k={Color3.new(0.282353,0.792157,0.945098),ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0.164706,0.890196,1)),ColorSequenceKeypoint.new(0.25,Color3.new(0.27451,1,0.164706)),ColorSequenceKeypoint.new(0.5,Color3.new(0.658824,0.219608,0.658824)),ColorSequenceKeypoint.new(1,Color3.new(0.341176,1,0.976471))})}local l={Color3.new(0.917647,0,0),ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,0,0)),ColorSequenceKeypoint.new(0.25,Color3.new(0.615686,0,0)),ColorSequenceKeypoint.new(0.5,Color3.new(0.32549,0,0)),ColorSequenceKeypoint.new(1,Color3.new(0.196078,0,0))})}local m={Color3.new(1,0.690196,0.882353),ColorSequence.new(Color3.new(1,0.690196,0.882353),Color3.new(1,0.929412,0.964706))}local n={Color3.new(1,0.666667,0),ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0,1,0)),ColorSequenceKeypoint.new(0.5,Color3.new(0.666667,0.333333,1)),ColorSequenceKeypoint.new(1,Color3.new(1,0.666667,0))})}local o={Color3.new(1,0,0),ColorSequence.new(Color3.new(1,0,0),Color3.new(1,1,1))}local p={Color3.new(1,0,0),ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0.74902,0,0)),ColorSequenceKeypoint.new(0.25,Color3.new(0.133333,0.133333,0.133333)),ColorSequenceKeypoint.new(0.5,Color3.new(0.486275,0.243137,0.729412)),ColorSequenceKeypoint.new(1,Color3.new(1,1,0))})}local q={Color3.new(1,0.666667,0),ColorSequence.new(Color3.new(1,1,0),Color3.new(0.109804,0.317647,1))}local r={Color3.new(0.752941,0.294118,0.796078),ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0.501961,0.760784,0.862745)),ColorSequenceKeypoint.new(0.5,Color3.new(0.823529,0.839216,0.870588)),ColorSequenceKeypoint.new(1,Color3.new(0.776471,0.458824,0.584314))})}local s={Color3.new(0.333333,1,0.498039),ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0.333333,1,0.498039)),ColorSequenceKeypoint.new(0.5,Color3.new(1,1,0)),ColorSequenceKeypoint.new(1,Color3.new(1,0,1))})}local t={Color3.new(1,1,0),ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,1,0)),ColorSequenceKeypoint.new(0.5,Color3.new(1,0.333333,1)),ColorSequenceKeypoint.new(1,Color3.new(0.333333,0.666667,1))})}local u={Color3.new(0.666667,0.666667,1),ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(0.666667,0.666667,1)),ColorSequenceKeypoint.new(0.5,Color3.new(0.666667,0.333333,1)),ColorSequenceKeypoint.new(1,Color3.new(0.333333,0.333333,1))})}local v={Color3.new(1,0.372549,0.0588235),ColorSequence.new(Color3.new(1,0.333333,0),Color3.new(0.8,0.690196,0.0666667))}local w={Color3.new(0.831373,1,0),ColorSequence.new(Color3.new(0.831373,1,0),Color3.new(0.945098,0.839216,0.231373))}local x={Color3.new(0.643137,0.952941,1),ColorSequence.new(Color3.new(0.752941,0.976471,1),Color3.new(0.196078,0.945098,0.882353))}local y={}local z={["Valentine"]={["TextureID"]="rbxassetid://12110413906",["Rarity"]="Exclusive",["BorderColor"]=b},["Testing"]={["DisplayName"]="N/A",["TextureID"]=a.Meshes.Testing,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0,0,0),["BorderColor"]={Color3.new(0.945098,1,0.882353),ColorSequence.new(Color3.new(0.831373,1,0.756863),Color3.new(0.890196,0.737255,0.431373))}},["Shadow"]={["TextureID"]=a.Meshes.Shadow.RevolverGhost,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0000152587891,0,0,1,0,8.74227766e-8,0,1,0,-8.74227766e-8,0,1),["BorderColor"]=e},["Battleworn Green"]={["TextureID"]="rbxassetid://8174665752",["Rarity"]="Common"},["Battleworn Lilac"]={["TextureID"]="rbxassetid://8175141275",["Rarity"]="Common"},["Battleworn Red"]={["TextureID"]="rbxassetid://8175126370",["Rarity"]="Common"},["Battleworn Yellowish"]={["TextureID"]="rbxassetid://8175111007",["Rarity"]="Common"},["Battleworn Purple"]={["TextureID"]="rbxassetid://8174703251",["Rarity"]="Common"},["Battleworn Pink"]={["TextureID"]="rbxassetid://8174725170",["Rarity"]="Common"},["Danger"]={["TextureID"]="rbxassetid://8174602579",["Rarity"]="Rare"},["Black & White"]={["TextureID"]="rbxassetid://8174185468",["Rarity"]="Rare"},["Future"]={["TextureID"]="rbxassetid://8174245185",["Rarity"]="Rare"},["Icey"]={["TextureID"]="rbxassetid://8174472966",["Rarity"]="Epic"},["Biohazard"]={["TextureID"]="rbxassetid://8174086219",["Rarity"]="Epic"},["Red Death"]={["TextureID"]="rbxassetid://8173928665",["Rarity"]="Legendary"},["Gold Glory"]={["TextureID"]="rbxassetid://8173955378",["Rarity"]="Legendary"},["Jungle Blaster"]={["TextureID"]="rbxassetid://9370252940",["Rarity"]="Common",["Crate"]=1},["1984"]={["TextureID"]="rbxassetid://9370759030",["Rarity"]="Common",["Crate"]=1},["White Stripes"]={["TextureID"]="rbxassetid://9378802766",["Rarity"]="Common",["Crate"]=1},["Venom"]={["TextureID"]="rbxassetid://9370655779",["Rarity"]="Rare",["Crate"]=1},["Red Tiger"]={["TextureID"]="rbxassetid://9370881350",["Rarity"]="Rare",["Crate"]=1},["Premium Red"]={["TextureID"]="rbxassetid://9381169424",["Rarity"]="Rare",["Crate"]=1},["Premium Yellow"]={["TextureID"]="rbxassetid://9381205789",["Rarity"]="Rare",["Crate"]=1},["Pink Fuchsia"]={["TextureID"]="rbxassetid://9379588832",["Rarity"]="Epic",["Crate"]=1},["Patriot"]={["TextureID"]="rbxassetid://9381087467",["Rarity"]="Epic",["Crate"]=1},["Glassy"]={["TextureID"]="rbxassetid://9381241993",["Rarity"]="Epic",["Crate"]=1},["Red Hot"]={["TextureID"]="rbxassetid://9367918526",["Rarity"]="Epic",["Crate"]=1},["Matrix"]={["TextureID"]="rbxassetid://9380928144",["Rarity"]="Legendary",["Crate"]=1},["Galaxy"]={["TextureID"]="rbxassetid://9370936730",["Rarity"]="Legendary",["Crate"]=999},["Inferno"]={["TextureID"]="rbxassetid://9370404463",["Rarity"]="Legendary",["Crate"]=999},["Luck"]={["TextureID"]="rbxassetid://12804964131",["Rarity"]="Legendary",["Crate"]=1},["Golden Age"]={["TextureID"]=a.Meshes.GoldenAge.Revolver,["Rarity"]="Legendary",["CFrame"]=CFrame.new(0.0295257568,0.0725820661,-0.000946044922,1,-4.89858741e-16,-7.98081238e-23,4.89858741e-16,1,3.2584137e-7,-7.98081238e-23,-3.2584137e-7,1),["Crate"]=999},["Web-Hero II"]={["TextureID"]=a.Meshes.HERO.HeroWeb2,["Rarity"]="Legendary",["CFrame"]=CFrame.new(-0.0891418457,-0.0215809345,-0.0041809082,-1.99520325e-23,-1.62920685e-7,1,2.44929371e-16,1,1.62920685e-7,-1,2.44929371e-16,1.99520294e-23),["BorderColor"]=p,["Crate"]=999},["Web-Hero III"]={["TextureID"]=a.Meshes.HERO.HeroWeb3,["Rarity"]="Legendary",["CFrame"]=CFrame.new(-0.0891418457,-0.0215809345,-0.0041809082,-1.99520325e-23,-1.62920685e-7,1,2.44929371e-16,1,1.62920685e-7,-1,2.44929371e-16,1.99520294e-23),["BorderColor"]=p,["Crate"]=999},["Dragon"]={["TextureID"]=a.Meshes.Dragon.DragonRev,["Rarity"]="Legendary",["CFrame"]=CFrame.new(0.0384216309,0.0450432301,-0.000671386719,1.87045402e-31,4.21188801e-16,-0.99999994,1.77635684e-15,1,-4.21188827e-16,1,1.77635684e-15,-1.87045413e-31),["Crate"]=999},["Heaven"]={["TextureID"]=a.Meshes.Heaven.Revolver,["Rarity"]="Legendary",["CFrame"]=CFrame.new(-0.0829315186,-0.0831851959,-0.00296020508,-0.999999881,2.94089277e-17,8.27179774e-25,-2.94089277e-17,0.999999881,6.85215614e-16,8.27179922e-25,-6.85215667e-16,-1),["Crate"]=999},["Thunder II"]={["TextureID"]=a.Meshes.Stars.RevolverII,["Rarity"]="Legendary",["CFrame"]=CFrame.new(-0.0765533447,0.0790345669,0.00277709961,1.99520325e-23,1.62920685e-7,-1,2.44929371e-16,1,1.62920685e-7,1,-2.44929371e-16,-1.99520294e-23),["Crate"]=999},["Void"]={["TextureID"]=a.Meshes.Void.rev,["Rarity"]="Legendary",["CFrame"]=CFrame.new(-0.00503540039,0.0082899332,-0.00164794922,0,0,-1,0,1,0,1,0,0),["Crate"]=999},["Raygun"]={["TextureID"]=a.Meshes.Raygun.rev,["Rarity"]="Legendary",["CFrame"]=CFrame.new(-0.130737305,-0.0714715123,0.00900268555,-1,0,0,0,1,0,0,0,-1),["Crate"]=999},["Purple Yellow Wrap"]={["TextureID"]="rbxassetid://11691734370",["Rarity"]="Common",["Crate"]=3},["Blue Wrap"]={["TextureID"]="rbxassetid://11691558717",["Rarity"]="Rare",["Crate"]=3},["Christmas Wrap"]={["TextureID"]="rbxassetid://11691406715",["Rarity"]="Epic",["Crate"]=3},["Snow Wrap"]={["TextureID"]="rbxassetid://11698051393",["Rarity"]="Legendary",["Crate"]=3}}y["[Revolver]"]=z;local A={["Valentine"]={["TextureID"]="rbxassetid://12110731451",["Rarity"]="Exclusive",["BorderColor"]=b},["Shadow"]={["TextureID"]=a.Meshes.Shadow.DrumgunGhost,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0000114440918,0,0,1,0,8.74227766e-8,0,1,0,-8.74227766e-8,0,1),["BorderColor"]=e},["Battleworn Green"]={["TextureID"]="rbxassetid://8185356861",["Rarity"]="Common"},["Battleworn Silver"]={["TextureID"]="rbxassetid://8185395568",["Rarity"]="Common"},["Battleworn Red"]={["TextureID"]="rbxassetid://8185380857",["Rarity"]="Common"},["Battleworn Orange"]={["TextureID"]="rbxassetid://8185410368",["Rarity"]="Common"},["Battleworn Purple"]={["TextureID"]="rbxassetid://8185370548",["Rarity"]="Common"},["Battleworn Pink"]={["TextureID"]="rbxassetid://8200161894",["Rarity"]="Common"},["Danger"]={["TextureID"]="rbxassetid://8185515967",["Rarity"]="Rare"},["Black & White"]={["TextureID"]="rbxassetid://8185562852",["Rarity"]="Rare"},["Future"]={["TextureID"]="rbxassetid://8185721916",["Rarity"]="Rare"},["Icey"]={["TextureID"]="rbxassetid://8185793923",["Rarity"]="Epic"},["Biohazard"]={["TextureID"]="rbxassetid://8185845811",["Rarity"]="Epic"},["Red Death"]={["TextureID"]="rbxassetid://8186385983",["Rarity"]="Legendary"},["Gold Glory"]={["TextureID"]="rbxassetid://8186168230",["Rarity"]="Legendary"},["Jungle Blaster"]={["TextureID"]="rbxassetid://9381458764",["Rarity"]="Common",["Crate"]=1},["1984"]={["TextureID"]="rbxassetid://9381540698",["Rarity"]="Common",["Crate"]=1},["White Stripes"]={["TextureID"]="rbxassetid://9381571514",["Rarity"]="Common",["Crate"]=1},["Venom"]={["TextureID"]="rbxassetid://9381523079",["Rarity"]="Rare",["Crate"]=1},["Red Tiger"]={["TextureID"]="rbxassetid://9381562454",["Rarity"]="Rare",["Crate"]=1},["Premium Red"]={["TextureID"]="rbxassetid://9381636386",["Rarity"]="Rare",["Crate"]=1},["Premium Yellow"]={["TextureID"]="rbxassetid://9381646935",["Rarity"]="Rare",["Crate"]=1},["Pink Fuchsia"]={["TextureID"]="rbxassetid://9381588907",["Rarity"]="Epic",["Crate"]=1},["Patriot"]={["TextureID"]="rbxassetid://9381609962",["Rarity"]="Epic",["Crate"]=1},["Glassy"]={["TextureID"]="rbxassetid://9381654654",["Rarity"]="Epic",["Crate"]=1},["Red Hot"]={["TextureID"]="rbxassetid://9381379210",["Rarity"]="Epic",["Crate"]=1},["Matrix"]={["TextureID"]="rbxassetid://9381601709",["Rarity"]="Legendary",["Crate"]=1},["Galaxy"]={["TextureID"]="rbxassetid://9381577172",["Rarity"]="Legendary",["Crate"]=999},["Inferno"]={["TextureID"]="rbxassetid://9381496666",["Rarity"]="Legendary",["Crate"]=999},["Luck"]={["TextureID"]="rbxassetid://12805073311",["Rarity"]="Legendary",["Crate"]=1},["Purple Yellow Wrap"]={["TextureID"]="rbxassetid://11698166618",["Rarity"]="Common",["Crate"]=3},["Blue Wrap"]={["TextureID"]="rbxassetid://11698163446",["Rarity"]="Rare",["Crate"]=3},["Christmas Wrap"]={["TextureID"]="rbxassetid://11698156920",["Rarity"]="Epic",["Crate"]=3},["Snow Wrap"]={["TextureID"]="rbxassetid://11698171250",["Rarity"]="Legendary",["Crate"]=3}}y["[DrumGun]"]=A;local B={["Valentine"]={["TextureID"]="rbxassetid://12110803753",["Rarity"]="Exclusive",["BorderColor"]=b},["Shadow"]={["TextureID"]=a.Meshes.Shadow.SMGGhost,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0000114440918,1.78813934e-7,-0.0263671875,1,0,0,0,1,0,0,0,1),["BorderColor"]=e},["Battleworn Green"]={["TextureID"]="rbxassetid://8199419655",["Rarity"]="Common"},["Battleworn Silver"]={["TextureID"]="rbxassetid://8199458294",["Rarity"]="Common"},["Battleworn Red"]={["TextureID"]="rbxassetid://8199451863",["Rarity"]="Common"},["Battleworn Orange"]={["TextureID"]="rbxassetid://8199473055",["Rarity"]="Common"},["Battleworn Purple"]={["TextureID"]="rbxassetid://8199431005",["Rarity"]="Common"},["Battleworn Pink"]={["TextureID"]="rbxassetid://8199477007",["Rarity"]="Common"},["Danger"]={["TextureID"]="rbxassetid://8199481436",["Rarity"]="Rare"},["Black & White"]={["TextureID"]="rbxassetid://8199502936",["Rarity"]="Rare"},["Future"]={["TextureID"]="rbxassetid://8199514095",["Rarity"]="Rare"},["Icey"]={["TextureID"]="rbxassetid://8199653818",["Rarity"]="Epic"},["Biohazard"]={["TextureID"]="rbxassetid://8199866150",["Rarity"]="Epic"},["Red Death"]={["TextureID"]="rbxassetid://8199875638",["Rarity"]="Legendary"},["Gold Glory"]={["TextureID"]="rbxassetid://8199883519",["Rarity"]="Legendary"},["Jungle Blaster"]={["TextureID"]="rbxassetid://9383258180",["Rarity"]="Common",["Crate"]=1},["1984"]={["TextureID"]="rbxassetid://9387602769",["Rarity"]="Common",["Crate"]=1},["White Stripes"]={["TextureID"]="rbxassetid://9387673853",["Rarity"]="Common",["Crate"]=1},["Venom"]={["TextureID"]="rbxassetid://9387598203",["Rarity"]="Rare",["Crate"]=1},["Red Tiger"]={["TextureID"]="rbxassetid://9387607679",["Rarity"]="Rare",["Crate"]=1},["Premium Red"]={["TextureID"]="rbxassetid://9387692876",["Rarity"]="Rare",["Crate"]=1},["Premium Yellow"]={["TextureID"]="rbxassetid://9387695275",["Rarity"]="Rare",["Crate"]=1},["Pink Fuchsia"]={["TextureID"]="rbxassetid://9387676494",["Rarity"]="Epic",["Crate"]=1},["Patriot"]={["TextureID"]="rbxassetid://9387686285",["Rarity"]="Epic",["Crate"]=1},["Glassy"]={["TextureID"]="rbxassetid://9387705178",["Rarity"]="Epic",["Crate"]=1},["Red Hot"]={["TextureID"]="rbxassetid://9383235024",["Rarity"]="Epic",["Crate"]=1},["Matrix"]={["TextureID"]="rbxassetid://9387681455",["Rarity"]="Legendary",["Crate"]=1},["Galaxy"]={["TextureID"]="rbxassetid://9387614760",["Rarity"]="Legendary",["Crate"]=999},["Inferno"]={["TextureID"]="rbxassetid://9387593777",["Rarity"]="Legendary",["Crate"]=999},["Luck"]={["TextureID"]="rbxassetid://12805137874",["Rarity"]="Legendary",["Crate"]=1},["Purple Yellow Wrap"]={["TextureID"]="rbxassetid://11698181071",["Rarity"]="Common",["Crate"]=3},["Blue Wrap"]={["TextureID"]="rbxassetid://11698185046",["Rarity"]="Rare",["Crate"]=3},["Christmas Wrap"]={["TextureID"]="rbxassetid://11698177379",["Rarity"]="Epic",["Crate"]=3},["Snow Wrap"]={["TextureID"]="rbxassetid://11698207341",["Rarity"]="Legendary",["Crate"]=3}}y["[SMG]"]=B;local C={["Valentine"]={["TextureID"]="rbxassetid://12111111962",["Rarity"]="Exclusive",["BorderColor"]=b},["Fish"]={["TextureID"]="rbxassetid://11990563033",["Rarity"]="Exclusive"},["Shadow"]={["TextureID"]=a.Meshes.Shadow.ShotgunGhost,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0000305175781,0.199999928,3.81469727e-6,-1,0,-4.37113883e-8,0,1,0,4.37113883e-8,0,-1),["BorderColor"]=e},["Battleworn Green"]={["TextureID"]="rbxassetid://8200212723",["Rarity"]="Common"},["Battleworn Red"]={["TextureID"]="rbxassetid://8200231458",["Rarity"]="Common"},["Battleworn Orange"]={["TextureID"]="rbxassetid://8200235920",["Rarity"]="Common"},["Battleworn Purple"]={["TextureID"]="rbxassetid://8200227785",["Rarity"]="Common"},["Battleworn Pink"]={["TextureID"]="rbxassetid://8200239202",["Rarity"]="Common"},["Danger"]={["TextureID"]="rbxassetid://8200263229",["Rarity"]="Rare"},["Black & White"]={["TextureID"]="rbxassetid://8200281207",["Rarity"]="Rare"},["Future"]={["TextureID"]="rbxassetid://8200452630",["Rarity"]="Rare"},["Icey"]={["TextureID"]="rbxassetid://8200567741",["Rarity"]="Epic"},["Biohazard"]={["TextureID"]="rbxassetid://8200611946",["Rarity"]="Epic"},["Red Death"]={["TextureID"]="rbxassetid://8200647420",["Rarity"]="Legendary"},["Gold Glory"]={["TextureID"]="rbxassetid://8200657428",["Rarity"]="Legendary"},["Jungle Blaster"]={["TextureID"]="rbxassetid://9387823994",["Rarity"]="Common",["Crate"]=1},["1984"]={["TextureID"]="rbxassetid://9387838948",["Rarity"]="Common",["Crate"]=1},["White Stripes"]={["TextureID"]="rbxassetid://9387936870",["Rarity"]="Common",["Crate"]=1},["Venom"]={["TextureID"]="rbxassetid://9387835160",["Rarity"]="Rare",["Crate"]=1},["Red Tiger"]={["TextureID"]="rbxassetid://9387930616",["Rarity"]="Rare",["Crate"]=1},["Premium Red"]={["TextureID"]="rbxassetid://9387966449",["Rarity"]="Rare",["Crate"]=1},["Premium Yellow"]={["TextureID"]="rbxassetid://9387971280",["Rarity"]="Rare",["Crate"]=1},["Pink Fuchsia"]={["TextureID"]="rbxassetid://9387941195",["Rarity"]="Epic",["Crate"]=1},["Patriot"]={["TextureID"]="rbxassetid://9387953763",["Rarity"]="Epic",["Crate"]=1},["Glassy"]={["TextureID"]="rbxassetid://9387975634",["Rarity"]="Epic",["Crate"]=1},["Red Hot"]={["TextureID"]="rbxassetid://9387819403",["Rarity"]="Epic",["Crate"]=1},["Matrix"]={["TextureID"]="rbxassetid://9387945198",["Rarity"]="Legendary",["Crate"]=1},["Galaxy"]={["TextureID"]="rbxassetid://9387933478",["Rarity"]="Legendary",["Crate"]=999},["Inferno"]={["TextureID"]="rbxassetid://9387831940",["Rarity"]="Legendary",["Crate"]=999},["Luck"]={["TextureID"]="rbxassetid://12805506654",["Rarity"]="Legendary",["Crate"]=1},["Purple Yellow Wrap"]={["TextureID"]="rbxassetid://11698286812",["Rarity"]="Common",["Crate"]=3},["Blue Wrap"]={["TextureID"]="rbxassetid://11698229652",["Rarity"]="Rare",["Crate"]=3},["Christmas Wrap"]={["TextureID"]="rbxassetid://11698222649",["Rarity"]="Epic",["Crate"]=3},["Snow Wrap"]={["TextureID"]="rbxassetid://11698280015",["Rarity"]="Legendary",["Crate"]=3}}y["[Shotgun]"]=C;local D={["Valentine"]={["TextureID"]="rbxassetid://12115564779",["Rarity"]="Exclusive",["BorderColor"]=b},["Shadow"]={["TextureID"]=a.Meshes.Shadow.RifleGhost,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.000244140625,-0.100267321,-0.0000915527344,1,0,0,0,1,0,0,0,1),["BorderColor"]=e},["Battleworn Green"]={["TextureID"]="rbxassetid://11005121335",["Rarity"]="Common"},["Battleworn Red"]={["TextureID"]="rbxassetid://11004990352",["Rarity"]="Common"},["Battleworn Orange"]={["TextureID"]="rbxassetid://11005088938",["Rarity"]="Common"},["Battleworn Purple"]={["TextureID"]="rbxassetid://11005107116",["Rarity"]="Common"},["Battleworn Pink"]={["TextureID"]="rbxassetid://11005005067",["Rarity"]="Common"},["Danger"]={["TextureID"]="rbxassetid://11004865054",["Rarity"]="Rare"},["Black & White"]={["TextureID"]="rbxassetid://11003890838",["Rarity"]="Rare"},["Future"]={["TextureID"]="rbxassetid://11003588453",["Rarity"]="Rare"},["Icey"]={["TextureID"]="rbxassetid://11003474703",["Rarity"]="Epic"},["Biohazard"]={["TextureID"]="rbxassetid://11002735610",["Rarity"]="Epic"},["Red Death"]={["TextureID"]="rbxassetid://11002464706",["Rarity"]="Legendary"},["Gold Glory"]={["TextureID"]="rbxassetid://11002383233",["Rarity"]="Legendary"},["Jungle Blaster"]={["TextureID"]="rbxassetid://11005316501",["Rarity"]="Common",["Crate"]=1},["1984"]={["TextureID"]="rbxassetid://11005598085",["Rarity"]="Common",["Crate"]=1},["White Stripes"]={["TextureID"]="rbxassetid://11005666467",["Rarity"]="Common",["Crate"]=1},["Venom"]={["TextureID"]="rbxassetid://11005542274",["Rarity"]="Rare",["Crate"]=1},["Red Tiger"]={["TextureID"]="rbxassetid://11005631418",["Rarity"]="Rare",["Crate"]=1},["Premium Red"]={["TextureID"]="rbxassetid://11005808616",["Rarity"]="Rare",["Crate"]=1},["Premium Yellow"]={["TextureID"]="rbxassetid://11005835348",["Rarity"]="Rare",["Crate"]=1},["Pink Fuchsia"]={["TextureID"]="rbxassetid://11005735080",["Rarity"]="Epic",["Crate"]=1},["Patriot"]={["TextureID"]="rbxassetid://11005714634",["Rarity"]="Epic",["Crate"]=1},["Glassy"]={["TextureID"]="rbxassetid://11005857694",["Rarity"]="Epic",["Crate"]=1},["Red Hot"]={["TextureID"]="rbxassetid://11005271062",["Rarity"]="Epic",["Crate"]=1},["Matrix"]={["TextureID"]="rbxassetid://11005757368",["Rarity"]="Legendary",["Crate"]=1},["Galaxy"]={["TextureID"]="rbxassetid://11005648299",["Rarity"]="Legendary",["Crate"]=999},["Inferno"]={["TextureID"]="rbxassetid://11005464864",["Rarity"]="Legendary",["Crate"]=999},["Luck"]={["TextureID"]="rbxassetid://12806251553",["Rarity"]="Legendary",["Crate"]=1},["Purple Yellow Wrap"]={["TextureID"]="rbxassetid://11698600572",["Rarity"]="Common",["Crate"]=3},["Blue Wrap"]={["TextureID"]="rbxassetid://11698597549",["Rarity"]="Rare",["Crate"]=3},["Christmas Wrap"]={["TextureID"]="rbxassetid://11698595906",["Rarity"]="Epic",["Crate"]=3},["Snow Wrap"]={["TextureID"]="rbxassetid://11698603515",["Rarity"]="Legendary",["Crate"]=3}}y["[Rifle]"]=D;local E={["Valentine"]={["TextureID"]="rbxassetid://12115525020",["Rarity"]="Exclusive",["BorderColor"]=b},["Shadow"]={["TextureID"]=a.Meshes.Shadow.TacticalShotgunGhost,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.148262024,0,0,1,0,8.74227766e-8,0,1,0,-8.74227766e-8,0,1),["BorderColor"]=e},["Battleworn Green"]={["TextureID"]="rbxassetid://9202807512",["Rarity"]="Common"},["Battleworn Red"]={["TextureID"]="rbxassetid://9202860371",["Rarity"]="Common"},["Battleworn Orange"]={["TextureID"]="rbxassetid://9202877794",["Rarity"]="Common"},["Battleworn Purple"]={["TextureID"]="rbxassetid://9202833643",["Rarity"]="Common"},["Battleworn Pink"]={["TextureID"]="rbxassetid://9202903532",["Rarity"]="Common"},["Danger"]={["TextureID"]="rbxassetid://9203188586",["Rarity"]="Rare"},["Black & White"]={["TextureID"]="rbxassetid://9203220557",["Rarity"]="Rare"},["Future"]={["TextureID"]="rbxassetid://9203241308",["Rarity"]="Rare"},["Icey"]={["TextureID"]="rbxassetid://9203412138",["Rarity"]="Epic"},["Biohazard"]={["TextureID"]="rbxassetid://9203513612",["Rarity"]="Epic"},["Red Death"]={["TextureID"]="rbxassetid://9203641766",["Rarity"]="Legendary"},["Gold Glory"]={["TextureID"]="rbxassetid://9203647967",["Rarity"]="Legendary"},["Jungle Blaster"]={["TextureID"]="rbxassetid://9402233425",["Rarity"]="Common",["Crate"]=1},["1984"]={["TextureID"]="rbxassetid://9402269596",["Rarity"]="Common",["Crate"]=1},["White Stripes"]={["TextureID"]="rbxassetid://9402283247",["Rarity"]="Common",["Crate"]=1},["Venom"]={["TextureID"]="rbxassetid://9402258939",["Rarity"]="Rare",["Crate"]=1},["Red Tiger"]={["TextureID"]="rbxassetid://9402275753",["Rarity"]="Rare",["Crate"]=1},["Premium Red"]={["TextureID"]="rbxassetid://9402318974",["Rarity"]="Rare",["Crate"]=1},["Premium Yellow"]={["TextureID"]="rbxassetid://9402324986",["Rarity"]="Rare",["Crate"]=1},["Pink Fuchsia"]={["TextureID"]="rbxassetid://9402291717",["Rarity"]="Epic",["Crate"]=1},["Patriot"]={["TextureID"]="rbxassetid://9402301039",["Rarity"]="Epic",["Crate"]=1},["Glassy"]={["TextureID"]="rbxassetid://9402335893",["Rarity"]="Epic",["Crate"]=1},["Red Hot"]={["TextureID"]="rbxassetid://9402226585",["Rarity"]="Epic",["Crate"]=1},["Matrix"]={["TextureID"]="rbxassetid://9402295362",["Rarity"]="Legendary",["Crate"]=1},["Galaxy"]={["TextureID"]="rbxassetid://9402279010",["Rarity"]="Legendary",["Crate"]=999},["Inferno"]={["TextureID"]="rbxassetid://9402244359",["Rarity"]="Legendary",["Crate"]=999},["Luck"]={["TextureID"]="rbxassetid://12806214848",["Rarity"]="Legendary",["Crate"]=1},["Void"]={["TextureID"]=a.Meshes.Void.tact,["Rarity"]="Legendary",["CFrame"]=CFrame.new(0.0505371094,-0.0487936139,0.00158691406,0,0,1,0,1,0,-1,0,0),["Crate"]=999},["Purple Yellow Wrap"]={["TextureID"]="rbxassetid://11698587778",["Rarity"]="Common",["Crate"]=3},["Blue Wrap"]={["TextureID"]="rbxassetid://11698585498",["Rarity"]="Rare",["Crate"]=3},["Christmas Wrap"]={["TextureID"]="rbxassetid://11698582341",["Rarity"]="Epic",["Crate"]=3},["Snow Wrap"]={["TextureID"]="rbxassetid://11698590246",["Rarity"]="Legendary",["Crate"]=3}}y["[TacticalShotgun]"]=E;local F={["Valentine"]={["TextureID"]="rbxassetid://12114648605",["Rarity"]="Exclusive",["BorderColor"]=b},["Shadow"]={["TextureID"]=a.Meshes.Shadow.RPGGhost,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.000122070312,0.0625389814,0.00672149658,1,0,-8.74227766e-8,5.00610797e-21,1,5.72632016e-14,8.74227766e-8,5.72632016e-14,1),["BorderColor"]=e},["Battleworn Green"]={["TextureID"]="rbxassetid://8200732479",["Rarity"]="Common"},["Battleworn Red"]={["TextureID"]="rbxassetid://8200751938",["Rarity"]="Common"},["Battleworn Orange"]={["TextureID"]="rbxassetid://8200757388",["Rarity"]="Common"},["Battleworn Purple"]={["TextureID"]="rbxassetid://8200745198",["Rarity"]="Common"},["Battleworn Pink"]={["TextureID"]="rbxassetid://8200764100",["Rarity"]="Common"},["Danger"]={["TextureID"]="rbxassetid://8200822253",["Rarity"]="Rare"},["Black & White"]={["TextureID"]="rbxassetid://8200850424",["Rarity"]="Rare"},["Future"]={["TextureID"]="rbxassetid://8200866435",["Rarity"]="Rare"},["Icey"]={["TextureID"]="rbxassetid://8200890494",["Rarity"]="Epic"},["Biohazard"]={["TextureID"]="rbxassetid://8201028034",["Rarity"]="Epic"},["Red Death"]={["TextureID"]="rbxassetid://8201055935",["Rarity"]="Legendary"},["Gold Glory"]={["TextureID"]="rbxassetid://8201059812",["Rarity"]="Legendary"},["Jungle Blaster"]={["TextureID"]="rbxassetid://9399823174",["Rarity"]="Common",["Crate"]=1},["1984"]={["TextureID"]="rbxassetid://9399837867",["Rarity"]="Common",["Crate"]=1},["White Stripes"]={["TextureID"]="rbxassetid://9399845630",["Rarity"]="Common",["Crate"]=1},["Venom"]={["TextureID"]="rbxassetid://9399835270",["Rarity"]="Rare",["Crate"]=1},["Red Tiger"]={["TextureID"]="rbxassetid://9399840628",["Rarity"]="Rare",["Crate"]=1},["Premium Red"]={["TextureID"]="rbxassetid://9399855314",["Rarity"]="Rare",["Crate"]=1},["Premium Yellow"]={["TextureID"]="rbxassetid://9399857061",["Rarity"]="Rare",["Crate"]=1},["Pink Fuchsia"]={["TextureID"]="rbxassetid://9399847783",["Rarity"]="Epic",["Crate"]=1},["Patriot"]={["TextureID"]="rbxassetid://9399852838",["Rarity"]="Epic",["Crate"]=1},["Glassy"]={["TextureID"]="rbxassetid://9399859827",["Rarity"]="Epic",["Crate"]=1},["Red Hot"]={["TextureID"]="rbxassetid://9399820193",["Rarity"]="Epic",["Crate"]=1},["Matrix"]={["TextureID"]="rbxassetid://9399850204",["Rarity"]="Legendary",["Crate"]=1},["Galaxy"]={["TextureID"]="rbxassetid://9399842353",["Rarity"]="Legendary",["Crate"]=999},["Inferno"]={["TextureID"]="rbxassetid://9399831924",["Rarity"]="Legendary",["Crate"]=999},["Luck"]={["TextureID"]="rbxassetid://12805600861",["Rarity"]="Legendary",["Crate"]=1},["Purple Yellow Wrap"]={["TextureID"]="rbxassetid://11698310571",["Rarity"]="Common",["Crate"]=3},["Blue Wrap"]={["TextureID"]="rbxassetid://11698306888",["Rarity"]="Rare",["Crate"]=3},["Christmas Wrap"]={["TextureID"]="rbxassetid://11698303361",["Rarity"]="Epic",["Crate"]=3},["Snow Wrap"]={["TextureID"]="rbxassetid://11698313175",["Rarity"]="Legendary",["Crate"]=3}}y["[RPG]"]=F;local G={["Valentine"]={["TextureID"]="rbxassetid://12114736740",["Rarity"]="Exclusive",["BorderColor"]=b},["Shadow"]={["TextureID"]=a.Meshes.Shadow.P90Ghost,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0000686645508,0.000218153,0.0000305175781,1,0,0,0,1,0,0,0,1),["BorderColor"]=e},["Battleworn Green"]={["TextureID"]="rbxassetid://8205069485",["Rarity"]="Common"},["Battleworn Red"]={["TextureID"]="rbxassetid://8205089535",["Rarity"]="Common"},["Battleworn Orange"]={["TextureID"]="rbxassetid://8205123590",["Rarity"]="Common"},["Battleworn Purple"]={["TextureID"]="rbxassetid://8205076879",["Rarity"]="Common"},["Battleworn Pink"]={["TextureID"]="rbxassetid://8205144857",["Rarity"]="Common"},["Danger"]={["TextureID"]="rbxassetid://8205219107",["Rarity"]="Rare"},["Black & White"]={["TextureID"]="rbxassetid://8205257625",["Rarity"]="Rare"},["Future"]={["TextureID"]="rbxassetid://8205265666",["Rarity"]="Rare"},["Icey"]={["TextureID"]="rbxassetid://8205325456",["Rarity"]="Epic"},["Biohazard"]={["TextureID"]="rbxassetid://8205367433",["Rarity"]="Epic"},["Red Death"]={["TextureID"]="rbxassetid://8205381104",["Rarity"]="Legendary"},["Gold Glory"]={["TextureID"]="rbxassetid://8205397990",["Rarity"]="Legendary"},["Jungle Blaster"]={["TextureID"]="rbxassetid://9399869525",["Rarity"]="Common",["Crate"]=1},["1984"]={["TextureID"]="rbxassetid://9399883452",["Rarity"]="Common",["Crate"]=1},["White Stripes"]={["TextureID"]="rbxassetid://9399890039",["Rarity"]="Common",["Crate"]=1},["Venom"]={["TextureID"]="rbxassetid://9399880968",["Rarity"]="Rare",["Crate"]=1},["Red Tiger"]={["TextureID"]="rbxassetid://9399886010",["Rarity"]="Rare",["Crate"]=1},["Premium Red"]={["TextureID"]="rbxassetid://9399899904",["Rarity"]="Rare",["Crate"]=1},["Premium Yellow"]={["TextureID"]="rbxassetid://9399901738",["Rarity"]="Rare",["Crate"]=1},["Pink Fuchsia"]={["TextureID"]="rbxassetid://9399892203",["Rarity"]="Epic",["Crate"]=1},["Patriot"]={["TextureID"]="rbxassetid://9399897656",["Rarity"]="Epic",["Crate"]=1},["Glassy"]={["TextureID"]="rbxassetid://9399907224",["Rarity"]="Epic",["Crate"]=1},["Red Hot"]={["TextureID"]="rbxassetid://9399866877",["Rarity"]="Epic",["Crate"]=1},["Matrix"]={["TextureID"]="rbxassetid://9399894480",["Rarity"]="Legendary",["Crate"]=1},["Galaxy"]={["TextureID"]="rbxassetid://9399887933",["Rarity"]="Legendary",["Crate"]=999},["Inferno"]={["TextureID"]="rbxassetid://9399878713",["Rarity"]="Legendary",["Crate"]=999},["Luck"]={["TextureID"]="rbxassetid://12805653252",["Rarity"]="Legendary",["Crate"]=1},["Purple Yellow Wrap"]={["TextureID"]="rbxassetid://11698324470",["Rarity"]="Common",["Crate"]=3},["Blue Wrap"]={["TextureID"]="rbxassetid://11698322674",["Rarity"]="Rare",["Crate"]=3},["Christmas Wrap"]={["TextureID"]="rbxassetid://11698320640",["Rarity"]="Epic",["Crate"]=3},["Snow Wrap"]={["TextureID"]="rbxassetid://11698328153",["Rarity"]="Legendary",["Crate"]=3}}y["[P90]"]=G;local H={["Valentine"]={["TextureID"]="rbxassetid://12114906111",["Rarity"]="Exclusive",["BorderColor"]=b},["Shadow"]={["TextureID"]=a.Meshes.Shadow.LMGGhost,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.374502182,-0.25,-0.25,-1,0,-1.31134158e-7,0,1,0,1.31134158e-7,0,-1),["BorderColor"]=e},["Battleworn Green"]={["TextureID"]="rbxassetid://8205498477",["Rarity"]="Common"},["Battleworn Red"]={["TextureID"]="rbxassetid://8205510598",["Rarity"]="Common"},["Battleworn Orange"]={["TextureID"]="rbxassetid://8205517033",["Rarity"]="Common"},["Battleworn Purple"]={["TextureID"]="rbxassetid://8205505332",["Rarity"]="Common"},["Battleworn Pink"]={["TextureID"]="rbxassetid://8205523035",["Rarity"]="Common"},["Danger"]={["TextureID"]="rbxassetid://8205558639",["Rarity"]="Rare"},["Black & White"]={["TextureID"]="rbxassetid://8205575208",["Rarity"]="Rare"},["Future"]={["TextureID"]="rbxassetid://8205585472",["Rarity"]="Rare"},["Icey"]={["TextureID"]="rbxassetid://8205620131",["Rarity"]="Epic"},["Biohazard"]={["TextureID"]="rbxassetid://8205697183",["Rarity"]="Epic"},["Red Death"]={["TextureID"]="rbxassetid://8205713344",["Rarity"]="Legendary"},["Gold Glory"]={["TextureID"]="rbxassetid://8205719479",["Rarity"]="Legendary"},["Jungle Blaster"]={["TextureID"]="rbxassetid://9400157516",["Rarity"]="Common",["Crate"]=1},["1984"]={["TextureID"]="rbxassetid://9400165161",["Rarity"]="Common",["Crate"]=1},["White Stripes"]={["TextureID"]="rbxassetid://9400173576",["Rarity"]="Common",["Crate"]=1},["Venom"]={["TextureID"]="rbxassetid://9400162704",["Rarity"]="Rare",["Crate"]=1},["Red Tiger"]={["TextureID"]="rbxassetid://9400167413",["Rarity"]="Rare",["Crate"]=1},["Premium Red"]={["TextureID"]="rbxassetid://9400184078",["Rarity"]="Rare",["Crate"]=1},["Premium Yellow"]={["TextureID"]="rbxassetid://9400186284",["Rarity"]="Rare",["Crate"]=1},["Pink Fuchsia"]={["TextureID"]="rbxassetid://9400176153",["Rarity"]="Epic",["Crate"]=1},["Patriot"]={["TextureID"]="rbxassetid://9400182123",["Rarity"]="Epic",["Crate"]=1},["Glassy"]={["TextureID"]="rbxassetid://9400188666",["Rarity"]="Epic",["Crate"]=1},["Red Hot"]={["TextureID"]="rbxassetid://9399928853",["Rarity"]="Epic",["Crate"]=1},["Matrix"]={["TextureID"]="rbxassetid://9400178599",["Rarity"]="Legendary",["Crate"]=1},["Galaxy"]={["TextureID"]="rbxassetid://9400170566",["Rarity"]="Legendary",["Crate"]=999},["Inferno"]={["TextureID"]="rbxassetid://9400160302",["Rarity"]="Legendary",["Crate"]=999},["Luck"]={["TextureID"]="rbxassetid://12805709973",["Rarity"]="Legendary",["Crate"]=1},["Purple Yellow Wrap"]={["TextureID"]="rbxassetid://11698342231",["Rarity"]="Common",["Crate"]=3},["Blue Wrap"]={["TextureID"]="rbxassetid://11698339260",["Rarity"]="Rare",["Crate"]=3},["Christmas Wrap"]={["TextureID"]="rbxassetid://11698336424",["Rarity"]="Epic",["Crate"]=3},["Snow Wrap"]={["TextureID"]="rbxassetid://11698345931",["Rarity"]="Legendary",["Crate"]=3}}y["[LMG]"]=H;local I={["Valentine"]={["TextureID"]="rbxassetid://12114451976",["Rarity"]="Exclusive",["BorderColor"]=b},["Shadow"]={["TextureID"]=a.Meshes.Shadow.FlamethrowerGhost,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.219947815,0.339559376,0.000274658203,1,0,0,0,1,0,0,0,1),["BorderColor"]=e},["Battleworn Green"]={["TextureID"]="rbxassetid://8205935393",["Rarity"]="Common"},["Battleworn Silver"]={["TextureID"]="rbxassetid://8205943484",["Rarity"]="Common"},["Battleworn Orange"]={["TextureID"]="rbxassetid://8205948312",["Rarity"]="Common"},["Battleworn Purple"]={["TextureID"]="rbxassetid://8205939544",["Rarity"]="Common"},["Battleworn Pink"]={["TextureID"]="rbxassetid://8206047590",["Rarity"]="Common"},["Danger"]={["TextureID"]="rbxassetid://8206051335",["Rarity"]="Rare"},["Black & White"]={["TextureID"]="rbxassetid://8213235948",["Rarity"]="Rare"},["Future"]={["TextureID"]="rbxassetid://8206268974",["Rarity"]="Rare"},["Icey"]={["TextureID"]="rbxassetid://8206347935",["Rarity"]="Epic"},["Biohazard"]={["TextureID"]="rbxassetid://8206488418",["Rarity"]="Epic"},["Red Death"]={["TextureID"]="rbxassetid://8206707126",["Rarity"]="Legendary"},["Gold Glory"]={["TextureID"]="rbxassetid://8208010648",["Rarity"]="Legendary"},["Jungle Blaster"]={["TextureID"]="rbxassetid://9400231739",["Rarity"]="Common",["Crate"]=1},["1984"]={["TextureID"]="rbxassetid://9400536953",["Rarity"]="Common",["Crate"]=1},["White Stripes"]={["TextureID"]="rbxassetid://9400569162",["Rarity"]="Common",["Crate"]=1},["Venom"]={["TextureID"]="rbxassetid://9400520290",["Rarity"]="Rare",["Crate"]=1},["Red Tiger"]={["TextureID"]="rbxassetid://9400550556",["Rarity"]="Rare",["Crate"]=1},["Premium Red"]={["TextureID"]="rbxassetid://9400770169",["Rarity"]="Rare",["Crate"]=1},["Premium Yellow"]={["TextureID"]="rbxassetid://9400778632",["Rarity"]="Rare",["Crate"]=1},["Pink Fuchsia"]={["TextureID"]="rbxassetid://9400576948",["Rarity"]="Epic",["Crate"]=1},["Patriot"]={["TextureID"]="rbxassetid://9400735643",["Rarity"]="Epic",["Crate"]=1},["Glassy"]={["TextureID"]="rbxassetid://9400780662",["Rarity"]="Epic",["Crate"]=1},["Red Hot"]={["TextureID"]="rbxassetid://9400200285",["Rarity"]="Epic",["Crate"]=1},["Matrix"]={["TextureID"]="rbxassetid://9400582867",["Rarity"]="Legendary",["Crate"]=1},["Galaxy"]={["TextureID"]="rbxassetid://9400558000",["Rarity"]="Legendary",["Crate"]=999},["Inferno"]={["TextureID"]="rbxassetid://9400503673",["Rarity"]="Legendary",["Crate"]=999},["Luck"]={["TextureID"]="rbxassetid://12805759408",["Rarity"]="Legendary",["Crate"]=1},["Purple Yellow Wrap"]={["TextureID"]="rbxassetid://11698374020",["Rarity"]="Common",["Crate"]=3},["Blue Wrap"]={["TextureID"]="rbxassetid://11698368556",["Rarity"]="Rare",["Crate"]=3},["Christmas Wrap"]={["TextureID"]="rbxassetid://11698359790",["Rarity"]="Epic",["Crate"]=3},["Snow Wrap"]={["TextureID"]="rbxassetid://11698381683",["Rarity"]="Legendary",["Crate"]=3}}y["[Flamethrower]"]=I;local J={["Valentine"]={["TextureID"]="rbxassetid://12114956009",["Rarity"]="Exclusive",["BorderColor"]=b},["Shadow"]={["TextureID"]=a.Meshes.Shadow.DoubleBGhost,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0250015259,-0.077037394,0,1,0,0,0,0.999998331,0,0,0,1),["BorderColor"]=e},["DH-Stars"]={["TextureID"]="rbxassetid://9379871038",["Rarity"]="Exclusive"},["Battleworn Green"]={["TextureID"]="rbxassetid://8212275962",["Rarity"]="Common"},["Battleworn Silver"]={["TextureID"]="rbxassetid://8212286567",["Rarity"]="Common"},["Battleworn Orange"]={["TextureID"]="rbxassetid://8212282697",["Rarity"]="Common"},["Battleworn Purple"]={["TextureID"]="rbxassetid://8212279414",["Rarity"]="Common"},["Battleworn Pink"]={["TextureID"]="rbxassetid://8212290557",["Rarity"]="Common"},["Danger"]={["TextureID"]="rbxassetid://8212316849",["Rarity"]="Rare"},["Black & White"]={["TextureID"]="rbxassetid://8213280304",["Rarity"]="Rare"},["Future"]={["TextureID"]="rbxassetid://8212323155",["Rarity"]="Rare"},["Icey"]={["TextureID"]="rbxassetid://8212348203",["Rarity"]="Epic"},["Biohazard"]={["TextureID"]="rbxassetid://8212375936",["Rarity"]="Epic"},["Red Death"]={["TextureID"]="rbxassetid://8212384179",["Rarity"]="Legendary"},["Gold Glory"]={["TextureID"]="rbxassetid://8212394280",["Rarity"]="Legendary"},["Jungle Blaster"]={["TextureID"]="rbxassetid://9401115062",["Rarity"]="Common",["Crate"]=1},["1984"]={["TextureID"]="rbxassetid://9401429541",["Rarity"]="Common",["Crate"]=1},["White Stripes"]={["TextureID"]="rbxassetid://9401449568",["Rarity"]="Common",["Crate"]=1},["Venom"]={["TextureID"]="rbxassetid://9401418244",["Rarity"]="Rare",["Crate"]=1},["Red Tiger"]={["TextureID"]="rbxassetid://9401436298",["Rarity"]="Rare",["Crate"]=1},["Premium Red"]={["TextureID"]="rbxassetid://9401505985",["Rarity"]="Rare",["Crate"]=1},["Premium Yellow"]={["TextureID"]="rbxassetid://9401510373",["Rarity"]="Rare",["Crate"]=1},["Pink Fuchsia"]={["TextureID"]="rbxassetid://9401454599",["Rarity"]="Epic",["Crate"]=1},["Patriot"]={["TextureID"]="rbxassetid://9401462565",["Rarity"]="Epic",["Crate"]=1},["Glassy"]={["TextureID"]="rbxassetid://9401514811",["Rarity"]="Epic",["Crate"]=1},["Red Hot"]={["TextureID"]="rbxassetid://9400904953",["Rarity"]="Epic",["Crate"]=1},["Matrix"]={["TextureID"]="rbxassetid://9401457713",["Rarity"]="Legendary",["Crate"]=1},["Galaxy"]={["TextureID"]="rbxassetid://9401441647",["Rarity"]="Legendary",["Crate"]=999},["Inferno"]={["TextureID"]="rbxassetid://9401416743",["Rarity"]="Legendary",["Crate"]=999},["Fish"]={["TextureID"]="rbxassetid://11982219253",["Rarity"]="Legendary",["Crate"]=1},["Luck"]={["TextureID"]="rbxassetid://12805836044",["Rarity"]="Legendary",["Crate"]=1},["Golden Age"]={["TextureID"]=a.Meshes.GoldenAge["Double Barrel"],["Rarity"]="Legendary",["CFrame"]=CFrame.new(-0.00664520264,0.0538104773,0.0124816895,-1,4.89858741e-16,7.98081238e-23,4.89858741e-16,1,3.2584137e-7,7.98081238e-23,3.2584137e-7,-1),["Crate"]=999},["Dragon"]={["TextureID"]=a.Meshes.Dragon.DBDragon,["Rarity"]="Legendary",["CFrame"]=CFrame.new(-0.123794556,0.0481165648,0.00048828125,7.14693442e-7,3.13283705e-10,1,-4.56658222e-9,1,-3.13281678e-10,-1,-4.56658533e-9,7.14693442e-7),["Crate"]=999},["Heaven"]={["TextureID"]=a.Meshes.Heaven.DB,["Rarity"]="Legendary",["CFrame"]=CFrame.new(-0.0303955078,0.022110641,0.00296020508,-0.999997139,-7.05812226e-16,7.85568618e-30,7.05812226e-16,0.999997139,-2.06501178e-14,6.44518474e-30,2.06501042e-14,-0.999999046),["Crate"]=999},["Purple Yellow Wrap"]={["TextureID"]="rbxassetid://11698405675",["Rarity"]="Common",["Crate"]=3},["Blue Wrap"]={["TextureID"]="rbxassetid://11698398802",["Rarity"]="Rare",["Crate"]=3},["Christmas Wrap"]={["TextureID"]="rbxassetid://11698395299",["Rarity"]="Epic",["Crate"]=3},["Snow Wrap"]={["TextureID"]="rbxassetid://11698411164",["Rarity"]="Legendary",["Crate"]=3}}y["[Double-Barrel SG]"]=J;local K={["Jungle Blaster"]={["TextureID"]="rbxassetid://16689483120",["Rarity"]="Common",["Crate"]=1},["1984"]={["TextureID"]="rbxassetid://16689465255",["Rarity"]="Common",["Crate"]=1},["Light Camo"]={["TextureID"]="rbxassetid://16689491845",["Rarity"]="Common",["Crate"]=1},["Battleworn Green"]={["TextureID"]="rbxassetid://16677029205",["Rarity"]="Common",["Crate"]=1},["Battleworn Blue"]={["TextureID"]="rbxassetid://16677041651",["Rarity"]="Common",["Crate"]=1},["Battleworn Orange"]={["TextureID"]="rbxassetid://16677121846",["Rarity"]="Common",["Crate"]=1},["Battleworn Purple"]={["TextureID"]="rbxassetid://16677050965",["Rarity"]="Common",["Crate"]=1},["Battleworn Pink"]={["TextureID"]="rbxassetid://16677013306",["Rarity"]="Common",["Crate"]=1},["Battleworn Red"]={["TextureID"]="rbxassetid://16677055685",["Rarity"]="Common",["Crate"]=1},["Black White"]={["TextureID"]="rbxassetid://16677918724",["Rarity"]="Rare",["Crate"]=1},["Rainbow"]={["TextureID"]="rbxassetid://16677272911",["Rarity"]="Rare",["Crate"]=1},["Red Death"]={["TextureID"]="rbxassetid://16677149439",["Rarity"]="Rare",["Crate"]=1},["Purple Yellow Wrap"]={["TextureID"]="rbxassetid://16677910627",["Rarity"]="Common",["Crate"]=1},["Icey"]={["TextureID"]="rbxassetid://16677229978",["Rarity"]="Epic",["Crate"]=1},["Patriot"]={["TextureID"]="rbxassetid://16689431385",["Rarity"]="Epic",["Crate"]=1},["Pink Fuchsia"]={["TextureID"]="rbxassetid://16689527835",["Rarity"]="Epic",["Crate"]=1},["Gold Glory"]={["TextureID"]="rbxassetid://16677186951",["Rarity"]="Epic",["Crate"]=1},["Galaxy"]={["TextureID"]="rbxassetid://16677641392",["Rarity"]="Legendary",["Crate"]=1},["Inferno"]={["TextureID"]="rbxassetid://16689348102",["Rarity"]="Legendary",["Crate"]=1},["Luck"]={["TextureID"]="rbxassetid://16689728694",["Rarity"]="Legendary",["Crate"]=1}}y["[Drum-Shotgun]"]=K;local L={["Valentine"]={["TextureID"]="rbxassetid://12115024879",["Rarity"]="Exclusive",["BorderColor"]=b},["Shadow"]={["TextureID"]=a.Meshes.Shadow.GlockGhost,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0,0,-0.200004578,1,0,4.37113883e-8,0,1,0,-4.37113883e-8,0,1),["BorderColor"]=e},["Battleworn Green"]={["TextureID"]="rbxassetid://8212444417",["Rarity"]="Common"},["Battleworn Lilac"]={["TextureID"]="rbxassetid://8212451534",["Rarity"]="Common"},["Battleworn Orange"]={["TextureID"]="rbxassetid://8212455391",["Rarity"]="Common"},["Battleworn Purple"]={["TextureID"]="rbxassetid://8212448336",["Rarity"]="Common"},["Battleworn Pink"]={["TextureID"]="rbxassetid://8212459430",["Rarity"]="Common"},["Danger"]={["TextureID"]="rbxassetid://8212481264",["Rarity"]="Rare"},["Black & White"]={["TextureID"]="rbxassetid://8213282241",["Rarity"]="Rare"},["Future"]={["TextureID"]="rbxassetid://8212487510",["Rarity"]="Rare"},["Icey"]={["TextureID"]="rbxassetid://8212534706",["Rarity"]="Epic"},["Biohazard"]={["TextureID"]="rbxassetid://8212630941",["Rarity"]="Epic"},["Red Death"]={["TextureID"]="rbxassetid://8212637463",["Rarity"]="Legendary"},["Gold Glory"]={["TextureID"]="rbxassetid://8212667115",["Rarity"]="Legendary"},["Jungle Blaster"]={["TextureID"]="rbxassetid://9401623473",["Rarity"]="Common",["Crate"]=1},["1984"]={["TextureID"]="rbxassetid://9401696528",["Rarity"]="Common",["Crate"]=1},["White Stripes"]={["TextureID"]="rbxassetid://9401719450",["Rarity"]="Common",["Crate"]=1},["Venom"]={["TextureID"]="rbxassetid://9401683246",["Rarity"]="Rare",["Crate"]=1},["Red Tiger"]={["TextureID"]="rbxassetid://9401714006",["Rarity"]="Rare",["Crate"]=1},["Premium Red"]={["TextureID"]="rbxassetid://9401747845",["Rarity"]="Rare",["Crate"]=1},["Premium Yellow"]={["TextureID"]="rbxassetid://9401750648",["Rarity"]="Rare",["Crate"]=1},["Pink Fuchsia"]={["TextureID"]="rbxassetid://9401723658",["Rarity"]="Epic",["Crate"]=1},["Patriot"]={["TextureID"]="rbxassetid://9401734730",["Rarity"]="Epic",["Crate"]=1},["Glassy"]={["TextureID"]="rbxassetid://9401756373",["Rarity"]="Epic",["Crate"]=1},["Red Hot"]={["TextureID"]="rbxassetid://9401611034",["Rarity"]="Epic",["Crate"]=1},["Matrix"]={["TextureID"]="rbxassetid://9401727978",["Rarity"]="Legendary",["Crate"]=1},["Galaxy"]={["TextureID"]="rbxassetid://9401709916",["Rarity"]="Legendary",["Crate"]=999},["Inferno"]={["TextureID"]="rbxassetid://9401670081",["Rarity"]="Legendary",["Crate"]=999},["Luck"]={["TextureID"]="rbxassetid://12805896214",["Rarity"]="Legendary",["Crate"]=1},["Purple Yellow Wrap"]={["TextureID"]="rbxassetid://11698428136",["Rarity"]="Common",["Crate"]=3},["Blue Wrap"]={["TextureID"]="rbxassetid://11698455542",["Rarity"]="Rare",["Crate"]=3},["Christmas Wrap"]={["TextureID"]="rbxassetid://11698421659",["Rarity"]="Epic",["Crate"]=3},["Snow Wrap"]={["TextureID"]="rbxassetid://11698450494",["Rarity"]="Legendary",["Crate"]=3}}y["[Glock]"]=L;local M={["Valentine"]={["TextureID"]="rbxassetid://12115024879",["Rarity"]="Exclusive",["BorderColor"]=b},["Shadow"]={["TextureID"]=a.Meshes.Shadow.GlockGhost,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0,0,-0.200004578,1,0,4.37113883e-8,0,1,0,-4.37113883e-8,0,1),["BorderColor"]=e},["Battleworn Green"]={["TextureID"]="rbxassetid://8212444417",["Rarity"]="Common"},["Battleworn Lilac"]={["TextureID"]="rbxassetid://8212451534",["Rarity"]="Common"},["Battleworn Orange"]={["TextureID"]="rbxassetid://8212455391",["Rarity"]="Common"},["Battleworn Purple"]={["TextureID"]="rbxassetid://8212448336",["Rarity"]="Common"},["Battleworn Pink"]={["TextureID"]="rbxassetid://8212459430",["Rarity"]="Common"},["Danger"]={["TextureID"]="rbxassetid://8212481264",["Rarity"]="Rare"},["Black & White"]={["TextureID"]="rbxassetid://8213282241",["Rarity"]="Rare"},["Future"]={["TextureID"]="rbxassetid://8212487510",["Rarity"]="Rare"},["Icey"]={["TextureID"]="rbxassetid://8212534706",["Rarity"]="Epic"},["Biohazard"]={["TextureID"]="rbxassetid://8212630941",["Rarity"]="Epic"},["Red Death"]={["TextureID"]="rbxassetid://8212637463",["Rarity"]="Legendary"},["Gold Glory"]={["TextureID"]="rbxassetid://8212667115",["Rarity"]="Legendary"},["Jungle Blaster"]={["TextureID"]="rbxassetid://9401623473",["Rarity"]="Common",["Crate"]=1},["1984"]={["TextureID"]="rbxassetid://9401696528",["Rarity"]="Common",["Crate"]=1},["White Stripes"]={["TextureID"]="rbxassetid://9401719450",["Rarity"]="Common",["Crate"]=1},["Venom"]={["TextureID"]="rbxassetid://9401683246",["Rarity"]="Rare",["Crate"]=1},["Red Tiger"]={["TextureID"]="rbxassetid://9401714006",["Rarity"]="Rare",["Crate"]=1},["Premium Red"]={["TextureID"]="rbxassetid://9401747845",["Rarity"]="Rare",["Crate"]=1},["Premium Yellow"]={["TextureID"]="rbxassetid://9401750648",["Rarity"]="Rare",["Crate"]=1},["Pink Fuchsia"]={["TextureID"]="rbxassetid://9401723658",["Rarity"]="Epic",["Crate"]=1},["Patriot"]={["TextureID"]="rbxassetid://9401734730",["Rarity"]="Epic",["Crate"]=1},["Glassy"]={["TextureID"]="rbxassetid://9401756373",["Rarity"]="Epic",["Crate"]=1},["Red Hot"]={["TextureID"]="rbxassetid://9401611034",["Rarity"]="Epic",["Crate"]=1},["Matrix"]={["TextureID"]="rbxassetid://9401727978",["Rarity"]="Legendary",["Crate"]=1},["Galaxy"]={["TextureID"]="rbxassetid://9401709916",["Rarity"]="Legendary",["Crate"]=999},["Inferno"]={["TextureID"]="rbxassetid://9401670081",["Rarity"]="Legendary",["Crate"]=999},["Luck"]={["TextureID"]="rbxassetid://12805896214",["Rarity"]="Legendary",["Crate"]=1},["Purple Yellow Wrap"]={["TextureID"]="rbxassetid://11698428136",["Rarity"]="Common",["Crate"]=3},["Blue Wrap"]={["TextureID"]="rbxassetid://11698455542",["Rarity"]="Rare",["Crate"]=3},["Christmas Wrap"]={["TextureID"]="rbxassetid://11698421659",["Rarity"]="Epic",["Crate"]=3},["Snow Wrap"]={["TextureID"]="rbxassetid://11698450494",["Rarity"]="Legendary",["Crate"]=3}}y["[Silencer]"]=M;local N={["Valentine"]={["TextureID"]="rbxassetid://12115122137",["Rarity"]="Exclusive",["BorderColor"]=b},["Shadow"]={["TextureID"]=a.Meshes.Shadow.AUGGhost,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-7.62939453e-6,0.0499991775,0,1,0,0,0,1,0,0,0,1),["BorderColor"]=e},["Battleworn Green"]={["TextureID"]="rbxassetid://8212698585",["Rarity"]="Common"},["Battleworn Red"]={["TextureID"]="rbxassetid://8212702975",["Rarity"]="Common"},["Battleworn Orange"]={["TextureID"]="rbxassetid://8212708853",["Rarity"]="Common"},["Battleworn Silver"]={["TextureID"]="rbxassetid://8212718221",["Rarity"]="Common"},["Battleworn Purple"]={["TextureID"]="rbxassetid://8212740914",["Rarity"]="Common"},["Battleworn Pink"]={["TextureID"]="rbxassetid://8212725557",["Rarity"]="Common"},["Danger"]={["TextureID"]="rbxassetid://8212747403",["Rarity"]="Rare"},["Black & White"]={["TextureID"]="rbxassetid://8213284596",["Rarity"]="Rare"},["Future"]={["TextureID"]="rbxassetid://8212749719",["Rarity"]="Rare"},["Icey"]={["TextureID"]="rbxassetid://8212763285",["Rarity"]="Epic"},["Biohazard"]={["TextureID"]="rbxassetid://8212784351",["Rarity"]="Epic"},["Red Death"]={["TextureID"]="rbxassetid://8212802637",["Rarity"]="Legendary"},["Gold Glory"]={["TextureID"]="rbxassetid://8212809463",["Rarity"]="Legendary"},["Jungle Blaster"]={["TextureID"]="rbxassetid://9401790525",["Rarity"]="Common",["Crate"]=1},["1984"]={["TextureID"]="rbxassetid://9401825845",["Rarity"]="Common",["Crate"]=1},["White Stripes"]={["TextureID"]="rbxassetid://9401844534",["Rarity"]="Common",["Crate"]=1},["Venom"]={["TextureID"]="rbxassetid://9401812015",["Rarity"]="Rare",["Crate"]=1},["Red Tiger"]={["TextureID"]="rbxassetid://9401836335",["Rarity"]="Rare",["Crate"]=1},["Premium Red"]={["TextureID"]="rbxassetid://9401873003",["Rarity"]="Rare",["Crate"]=1},["Premium Yellow"]={["TextureID"]="rbxassetid://9401877388",["Rarity"]="Rare",["Crate"]=1},["Pink Fuchsia"]={["TextureID"]="rbxassetid://9401850278",["Rarity"]="Epic",["Crate"]=1},["Patriot"]={["TextureID"]="rbxassetid://9401860175",["Rarity"]="Epic",["Crate"]=1},["Glassy"]={["TextureID"]="rbxassetid://9401880668",["Rarity"]="Epic",["Crate"]=1},["Red Hot"]={["TextureID"]="rbxassetid://9401784838",["Rarity"]="Epic",["Crate"]=1},["Matrix"]={["TextureID"]="rbxassetid://9401855319",["Rarity"]="Legendary",["Crate"]=1},["Galaxy"]={["TextureID"]="rbxassetid://9401832956",["Rarity"]="Legendary",["Crate"]=999},["Inferno"]={["TextureID"]="rbxassetid://9401802930",["Rarity"]="Legendary",["Crate"]=999},["Luck"]={["TextureID"]="rbxassetid://12806062046",["Rarity"]="Legendary",["Crate"]=1},["Purple Yellow Wrap"]={["TextureID"]="rbxassetid://11698517061",["Rarity"]="Common",["Crate"]=3},["Blue Wrap"]={["TextureID"]="rbxassetid://11698514224",["Rarity"]="Rare",["Crate"]=3},["Christmas Wrap"]={["TextureID"]="rbxassetid://11698511107",["Rarity"]="Epic",["Crate"]=3},["Snow Wrap"]={["TextureID"]="rbxassetid://11698520432",["Rarity"]="Legendary",["Crate"]=3}}y["[AUG]"]=N;local O={["Valentine"]={["TextureID"]="rbxassetid://12115236401",["Rarity"]="Exclusive",["BorderColor"]=b},["Shadow"]={["TextureID"]=a.Meshes.Shadow.ARGhost,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.116256714,0.0750004649,0.0000610351562,1,0,0,0,1,0,0,0,1),["BorderColor"]=e},["Halloween"]={["TextureID"]="rbxassetid://11241216355",["Rarity"]="Exclusive"},["Battleworn Green"]={["TextureID"]="rbxassetid://8212952678",["Rarity"]="Common"},["Battleworn Red"]={["TextureID"]="rbxassetid://8212959581",["Rarity"]="Common"},["Battleworn Orange"]={["TextureID"]="rbxassetid://8212975065",["Rarity"]="Common"},["Battleworn Blue"]={["TextureID"]="rbxassetid://8212972476",["Rarity"]="Common"},["Battleworn Purple"]={["TextureID"]="rbxassetid://8212955941",["Rarity"]="Common"},["Battleworn Pink"]={["TextureID"]="rbxassetid://8212991595",["Rarity"]="Common"},["Danger"]={["TextureID"]="rbxassetid://8213019535",["Rarity"]="Rare"},["Black & White"]={["TextureID"]="rbxassetid://8213155212",["Rarity"]="Rare"},["Future"]={["TextureID"]="rbxassetid://8213025576",["Rarity"]="Rare"},["Icey"]={["TextureID"]="rbxassetid://8213028694",["Rarity"]="Epic"},["Biohazard"]={["TextureID"]="rbxassetid://8213165917",["Rarity"]="Epic"},["Red Death"]={["TextureID"]="rbxassetid://8213168054",["Rarity"]="Legendary"},["Gold Glory"]={["TextureID"]="rbxassetid://8213175568",["Rarity"]="Legendary"},["Jungle Blaster"]={["TextureID"]="rbxassetid://9401951892",["Rarity"]="Common",["Crate"]=1},["1984"]={["TextureID"]="rbxassetid://9401997867",["Rarity"]="Common",["Crate"]=1},["White Stripes"]={["TextureID"]="rbxassetid://9402011516",["Rarity"]="Common",["Crate"]=1},["Venom"]={["TextureID"]="rbxassetid://9401985175",["Rarity"]="Rare",["Crate"]=1},["Red Tiger"]={["TextureID"]="rbxassetid://9402003717",["Rarity"]="Rare",["Crate"]=1},["Premium Red"]={["TextureID"]="rbxassetid://9402044786",["Rarity"]="Rare",["Crate"]=1},["Premium Yellow"]={["TextureID"]="rbxassetid://9402049161",["Rarity"]="Rare",["Crate"]=1},["Pink Fuchsia"]={["TextureID"]="rbxassetid://9402014215",["Rarity"]="Epic",["Crate"]=1},["Patriot"]={["TextureID"]="rbxassetid://9402025791",["Rarity"]="Epic",["Crate"]=1},["Glassy"]={["TextureID"]="rbxassetid://9402055602",["Rarity"]="Epic",["Crate"]=1},["Red Hot"]={["TextureID"]="rbxassetid://9401937265",["Rarity"]="Epic",["Crate"]=1},["Matrix"]={["TextureID"]="rbxassetid://9402023983",["Rarity"]="Legendary",["Crate"]=1},["Galaxy"]={["TextureID"]="rbxassetid://9402007158",["Rarity"]="Legendary",["Crate"]=999},["Inferno"]={["TextureID"]="rbxassetid://9401972413",["Rarity"]="Legendary",["Crate"]=999},["Luck"]={["TextureID"]="rbxassetid://12806134043",["Rarity"]="Legendary",["Crate"]=1},["Purple Yellow Wrap"]={["TextureID"]="rbxassetid://11698536498",["Rarity"]="Common",["Crate"]=3},["Blue Wrap"]={["TextureID"]="rbxassetid://11698534667",["Rarity"]="Rare",["Crate"]=3},["Christmas Wrap"]={["TextureID"]="rbxassetid://11698532205",["Rarity"]="Epic",["Crate"]=3},["Snow Wrap"]={["TextureID"]="rbxassetid://11698542283",["Rarity"]="Legendary",["Crate"]=3}}y["[AR]"]=O;local P={["Valentine"]={["TextureID"]="rbxassetid://12115236401",["Rarity"]="Exclusive",["BorderColor"]=b},["Shadow"]={["TextureID"]=a.Meshes.Shadow.ARGhost,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.116256714,0.0750004649,0.0000610351562,1,0,0,0,1,0,0,0,1),["BorderColor"]=e},["Battleworn Green"]={["TextureID"]="rbxassetid://8212952678",["Rarity"]="Common"},["Battleworn Red"]={["TextureID"]="rbxassetid://8212959581",["Rarity"]="Common"},["Battleworn Orange"]={["TextureID"]="rbxassetid://8212975065",["Rarity"]="Common"},["Battleworn Blue"]={["TextureID"]="rbxassetid://8212972476",["Rarity"]="Common"},["Battleworn Purple"]={["TextureID"]="rbxassetid://8212955941",["Rarity"]="Common"},["Battleworn Pink"]={["TextureID"]="rbxassetid://8212991595",["Rarity"]="Common"},["Danger"]={["TextureID"]="rbxassetid://8213019535",["Rarity"]="Rare"},["Black & White"]={["TextureID"]="rbxassetid://8213155212",["Rarity"]="Rare"},["Future"]={["TextureID"]="rbxassetid://8213025576",["Rarity"]="Rare"},["Icey"]={["TextureID"]="rbxassetid://8213028694",["Rarity"]="Epic"},["Biohazard"]={["TextureID"]="rbxassetid://8213165917",["Rarity"]="Epic"},["Red Death"]={["TextureID"]="rbxassetid://8213168054",["Rarity"]="Legendary"},["Gold Glory"]={["TextureID"]="rbxassetid://8213175568",["Rarity"]="Legendary"},["Jungle Blaster"]={["TextureID"]="rbxassetid://9401951892",["Rarity"]="Common",["Crate"]=1},["1984"]={["TextureID"]="rbxassetid://9401997867",["Rarity"]="Common",["Crate"]=1},["White Stripes"]={["TextureID"]="rbxassetid://9402011516",["Rarity"]="Common",["Crate"]=1},["Venom"]={["TextureID"]="rbxassetid://9401985175",["Rarity"]="Rare",["Crate"]=1},["Red Tiger"]={["TextureID"]="rbxassetid://9402003717",["Rarity"]="Rare",["Crate"]=1},["Premium Red"]={["TextureID"]="rbxassetid://9402044786",["Rarity"]="Rare",["Crate"]=1},["Premium Yellow"]={["TextureID"]="rbxassetid://9402049161",["Rarity"]="Rare",["Crate"]=1},["Pink Fuchsia"]={["TextureID"]="rbxassetid://9402014215",["Rarity"]="Epic",["Crate"]=1},["Patriot"]={["TextureID"]="rbxassetid://9402025791",["Rarity"]="Epic",["Crate"]=1},["Glassy"]={["TextureID"]="rbxassetid://9402055602",["Rarity"]="Epic",["Crate"]=1},["Red Hot"]={["TextureID"]="rbxassetid://9401937265",["Rarity"]="Epic",["Crate"]=1},["Matrix"]={["TextureID"]="rbxassetid://9402023983",["Rarity"]="Legendary",["Crate"]=1},["Galaxy"]={["TextureID"]="rbxassetid://9402007158",["Rarity"]="Legendary",["Crate"]=999},["Inferno"]={["TextureID"]="rbxassetid://9401972413",["Rarity"]="Legendary",["Crate"]=999},["Luck"]={["TextureID"]="rbxassetid://12806134043",["Rarity"]="Legendary",["Crate"]=1},["Purple Yellow Wrap"]={["TextureID"]="rbxassetid://11698536498",["Rarity"]="Common",["Crate"]=3},["Blue Wrap"]={["TextureID"]="rbxassetid://11698534667",["Rarity"]="Rare",["Crate"]=3},["Christmas Wrap"]={["TextureID"]="rbxassetid://11698532205",["Rarity"]="Epic",["Crate"]=3},["Snow Wrap"]={["TextureID"]="rbxassetid://11698542283",["Rarity"]="Legendary",["Crate"]=3}}y["[SilencerAR]"]=P;local Q={["Valentine"]={["TextureID"]="rbxassetid://12115438326",["Rarity"]="Exclusive",["BorderColor"]=b},["Shadow"]={["TextureID"]=a.Meshes.Shadow.AK47Ghost,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.750015259,4.76837158e-7,-0.0000305175781,1,0,0,0,1,0,0,0,1),["BorderColor"]=e},["Battleworn Green"]={["TextureID"]="rbxassetid://8213540594",["Rarity"]="Common"},["Battleworn Red"]={["TextureID"]="rbxassetid://8213544761",["Rarity"]="Common"},["Battleworn Orange"]={["TextureID"]="rbxassetid://8213558744",["Rarity"]="Common"},["Battleworn Blue"]={["TextureID"]="rbxassetid://8213551140",["Rarity"]="Common"},["Battleworn Purple"]={["TextureID"]="rbxassetid://8213553838",["Rarity"]="Common"},["Battleworn Pink"]={["TextureID"]="rbxassetid://8213556073",["Rarity"]="Common"},["Danger"]={["TextureID"]="rbxassetid://8213561927",["Rarity"]="Rare"},["Black & White"]={["TextureID"]="rbxassetid://8213564638",["Rarity"]="Rare"},["Icey"]={["TextureID"]="rbxassetid://8213567693",["Rarity"]="Epic"},["Biohazard"]={["TextureID"]="rbxassetid://8213570295",["Rarity"]="Epic"},["Red Death"]={["TextureID"]="rbxassetid://8213572965",["Rarity"]="Legendary"},["Gold Glory"]={["TextureID"]="rbxassetid://8213606202",["Rarity"]="Legendary"},["Jungle Blaster"]={["TextureID"]="rbxassetid://9402075015",["Rarity"]="Common",["Crate"]=1},["1984"]={["TextureID"]="rbxassetid://9402123344",["Rarity"]="Common",["Crate"]=1},["White Stripes"]={["TextureID"]="rbxassetid://9402137566",["Rarity"]="Common",["Crate"]=1},["Venom"]={["TextureID"]="rbxassetid://9402109360",["Rarity"]="Rare",["Crate"]=1},["Red Tiger"]={["TextureID"]="rbxassetid://9402128607",["Rarity"]="Rare",["Crate"]=1},["Premium Red"]={["TextureID"]="rbxassetid://9402165796",["Rarity"]="Rare",["Crate"]=1},["Premium Yellow"]={["TextureID"]="rbxassetid://9402168602",["Rarity"]="Rare",["Crate"]=1},["Pink Fuchsia"]={["TextureID"]="rbxassetid://9402143081",["Rarity"]="Epic",["Crate"]=1},["Patriot"]={["TextureID"]="rbxassetid://9402153356",["Rarity"]="Epic",["Crate"]=1},["Glassy"]={["TextureID"]="rbxassetid://9402177431",["Rarity"]="Epic",["Crate"]=1},["Red Hot"]={["TextureID"]="rbxassetid://9368888318",["Rarity"]="Epic",["Crate"]=1},["Matrix"]={["TextureID"]="rbxassetid://9402147406",["Rarity"]="Legendary",["Crate"]=1},["Galaxy"]={["TextureID"]="rbxassetid://9402132929",["Rarity"]="Legendary",["Crate"]=999},["Inferno"]={["TextureID"]="rbxassetid://9402094255",["Rarity"]="Legendary",["Crate"]=999},["Luck"]={["TextureID"]="rbxassetid://12806176107",["Rarity"]="Legendary",["Crate"]=1},["Purple Yellow Wrap"]={["TextureID"]="rbxassetid://11698565005",["Rarity"]="Common",["Crate"]=3},["Blue Wrap"]={["TextureID"]="rbxassetid://11698561489",["Rarity"]="Rare",["Crate"]=3},["Christmas Wrap"]={["TextureID"]="rbxassetid://11698558392",["Rarity"]="Epic",["Crate"]=3},["Snow Wrap"]={["TextureID"]="rbxassetid://11698567925",["Rarity"]="Legendary",["Crate"]=3}}y["[AK47]"]=Q;local R={["Love Kukri"]={["CFrame"]=CFrame.new(0.650018692,0.419342041,-0.0283660889,0,1,0,0,0,-1,-1,0,0),["Rarity"]="Exclusive",["BorderColor"]=b},["Shadow"]={["CFrame"]=CFrame.new(1.1250186,0.0000305175781,0.000396728516,0,1,0,1,0,-4.37113883e-8,-4.37113883e-8,0,-1),["Rarity"]="Exclusive",["BorderColor"]=e},["Katar"]={["CFrame"]=CFrame.new(-0.555824697,-0.533429861,0.0668983459,0,1,0,0,0,1,1,0,0),["Rarity"]="Common",["Crate"]=2},["Kunai"]={["CFrame"]=CFrame.new(0.0728008747,0.0431479923,0.0373959541,0,-1,0,-0.99999994,0,0,0,0,-1),["Rarity"]="Common",["Crate"]=2},["Pink"]={["CFrame"]=CFrame.new(-0.200906992,-0.0210727006,-0.00665473938,0,1,0,-0.99999994,0,0,0,0,1),["Rarity"]="Common",["Crate"]=2},["Screw Driver"]={["CFrame"]=CFrame.new(0.109568655,-0.0280584544,0.000621795654,0,1,0,0,0,-0.99999994,-1,0,0),["Rarity"]="Common",["Crate"]=2},["Kitchen"]={["CFrame"]=CFrame.new(0.0464496613,-0.208359778,-0.0175123215,0,0,-1,0,1,0,1,0,0),["Rarity"]="Common",["Crate"]=2},["Buster"]={["CFrame"]=CFrame.new(0.284334183,-0.00799623132,0.0138845444,0,1,0,0,0,1,1,0,0),["Rarity"]="Rare",["Crate"]=2},["Scissor"]={["CFrame"]=CFrame.new(0.0672817826,0.0748512968,-0.0330171585,-1,0,0,0,-0.99999994,0,0,0,1),["Rarity"]="Rare",["Crate"]=2},["Boxcutter"]={["CFrame"]=CFrame.new(0.133508801,-0.0368869603,0.0361539125,1,0,0,0,-1,0,0,0,-1),["Rarity"]="Rare",["Crate"]=2},["Bat Sharp"]={["CFrame"]=CFrame.new(0.0205659866,0.0712812394,-0.0301570892,1,0,0,0,-0.99999994,0,0,0,-1),["Rarity"]="Epic",["Crate"]=2},["Red Tiger"]={["CFrame"]=CFrame.new(0.176477551,0.0276881456,0.0265624225,0,1,0,-1,0,0,0,0,1),["Rarity"]="Epic",["Crate"]=2},["Golden Age Tanto"]={["CFrame"]=CFrame.new(0.395452857,-0.00876617432,-0.0173950195,4.89857682e-16,1,1.62920671e-7,1,-2.70329972e-14,1.62920628e-7,1.62920628e-7,1.62920671e-7,-1),["Rarity"]="Legendary",["Crate"]=999},["Emerald"]={["CFrame"]=CFrame.new(0.154518723,0.116676092,0.000304222107,0,1,0,-1,0,0,0,0,1),["Rarity"]="Legendary",["Crate"]=999},["Golden"]={["CFrame"]=CFrame.new(0.269160748,0.00606650487,-0.00481987,0,1,0,0,0,-1,-1,0,0),["Rarity"]="Legendary",["Crate"]=2},["Galactic-Red"]={["CFrame"]=CFrame.new(-0.261539459,0.0143127441,0.0307006836,0,1,0,0,0,1,1,0,0),["Rarity"]="Legendary",["Crate"]=999},["Dragon"]={["CFrame"]=CFrame.new(0.171493769,-0.0721282959,-0.0171813965,8.15480348e-7,0.99999994,4.55676854e-7,-1.00000203,6.4963109e-7,2.51534473e-8,2.88709696e-8,-4.56442649e-7,1.00000012),["Rarity"]="Legendary",["Crate"]=999},["Heaven"]={["CFrame"]=CFrame.new(0.147634387,0.286956787,-0.00314331055,8.88577406e-14,0.798631966,0.601811886,1.75618051e-14,-0.601811886,0.798631966,1,6.03960173e-14,6.75013837e-14),["Rarity"]="Legendary",["Crate"]=999},["Void"]={["CFrame"]=CFrame.new(0.0116134882,0.0246582031,0.00231933594,1,0,0,0,1,0,0,0,1),["Rarity"]="Legendary",["Crate"]=999},["Raygun"]={["CFrame"]=CFrame.new(-0.406901479,0.0661621094,0.0101928711,1,0,0,0,-1,0,0,0,-1),["Rarity"]="Legendary",["Crate"]=999},["RGB Butterfly"]={["CFrame"]=CFrame.new(0.129888415,0.0243530273,-0.0148620605,1,0,0,0,-1,0,0,0,-1),["Rarity"]="Legendary",["Crate"]=2},["Black Marker"]={["CFrame"]=CFrame.new(0.0356717706,0.0152872801,0.023607254,0,1,0,0,0,1,1,0,0),["Rarity"]="Exclusive"},["Red Marker"]={["CFrame"]=CFrame.new(0.0356717706,0.0152872801,0.023607254,0,1,0,0,0,1,1,0,0),["Rarity"]="Exclusive"},["Purple Marker"]={["CFrame"]=CFrame.new(0.0356717706,0.0152872801,0.023607254,0,1,0,0,0,1,1,0,0),["Rarity"]="Exclusive"},["Pink Marker"]={["CFrame"]=CFrame.new(0.0356717706,0.0152872801,0.023607254,0,1,0,0,0,1,1,0,0),["Rarity"]="Exclusive"},["Orange Marker"]={["CFrame"]=CFrame.new(0.0356717706,0.0152872801,0.023607254,0,1,0,0,0,1,1,0,0),["Rarity"]="Exclusive"},["Green Marker"]={["CFrame"]=CFrame.new(0.0356717706,0.0152872801,0.023607254,0,1,0,0,0,1,1,0,0),["Rarity"]="Exclusive"},["Brown Marker"]={["CFrame"]=CFrame.new(0.0356717706,0.0152872801,0.023607254,0,1,0,0,0,1,1,0,0),["Rarity"]="Exclusive"},["Blue Marker"]={["CFrame"]=CFrame.new(0.0356717706,0.0152872801,0.023607254,0,1,0,0,0,1,1,0,0),["Rarity"]="Exclusive"}}y["[Knife]"]=R;local S={["House 2"]={["Rarity"]="Common",["Crate"]=1},["Brick"]={["Rarity"]="Rare",["Crate"]=1},["Town"]={["Rarity"]="Epic",["Crate"]=1},["Modern"]={["Rarity"]="Legendary",["Crate"]=1}}y["[House]"]=S;local T={["Moped"]={["Rarity"]="Common",["Crate"]=999},["Motorcycle"]={["Rarity"]="Common",["Crate"]=999},["Motorcycle Side Seat"]={["Rarity"]="Rare",["Crate"]=1},["Car"]={["Rarity"]="Exclusive"},["Kart"]={["Rarity"]="Rare",["Crate"]=1},["Golf Cart"]={["Rarity"]="Rare",["Crate"]=1},["Burger"]={["Rarity"]="Exclusive",["NoTrade"]=true},["Luxe"]={["Rarity"]="Exclusive"},["School Bus"]={["Rarity"]="Exclusive",["NoTrade"]=true},["Dirt Bike"]={["Rarity"]="Exclusive"},["ATV"]={["Rarity"]="Exclusive"},["Reindeer"]={["Rarity"]="Common",["Crate"]=999}}y["[Vehicle]"]=T;local U={["Bandana Black"]={["Rarity"]="Common"},["Bandana DH"]={["Rarity"]="Common"},["Hockey"]={["Rarity"]="Common"},["Ski Mask"]={["Rarity"]="Common"},["Ski Mask II"]={["Rarity"]="Common"},["Hockey DH"]={["Rarity"]="Rare"},["Hockey Gradient"]={["Rarity"]="Rare"},["Ski Mask Saint"]={["Rarity"]="Rare"},["Ski Mask DH"]={["Rarity"]="Rare"},["Ski Mask Red Eye"]={["Rarity"]="Rare"},["Ski Mask Saint II"]={["Rarity"]="Rare"},["Ski Mask X)"]={["Rarity"]="Rare"},["Ski Mask Half Green"]={["Rarity"]="Epic"},["Ski Mask Blue"]={["Rarity"]="Epic"},["Ski Mask II DH"]={["Rarity"]="Epic"},["Ski Mask Pink"]={["Rarity"]="Epic"},["Ski Mask Red"]={["Rarity"]="Epic"},["Ski Mask Skull"]={["Rarity"]="Epic"},["Ski Mask Horns"]={["Rarity"]="Legendary"},["Ski Mask Horns DH"]={["Rarity"]="Legendary"},["Ski Mask Horns Pink"]={["Rarity"]="Legendary"},["Ski Mask Horns White"]={["Rarity"]="Legendary"}}y["[Mask]"]=U;y["[Revolver]"].Rainbow={["TextureID"]="rbxassetid://12898879990",["Rarity"]="Rare",["Crate"]=1,["BorderColor"]=i}y["[DrumGun]"].Rainbow={["TextureID"]="rbxassetid://12899291391",["Rarity"]="Rare",["Crate"]=1,["BorderColor"]=i}y["[SMG]"].Rainbow={["TextureID"]="rbxassetid://12899335260",["Rarity"]="Rare",["Crate"]=1,["BorderColor"]=i}y["[Shotgun]"].Rainbow={["TextureID"]="rbxassetid://12899388473",["Rarity"]="Rare",["Crate"]=1,["BorderColor"]=i}y["[Rifle]"].Rainbow={["TextureID"]="rbxassetid://12899704735",["Rarity"]="Rare",["Crate"]=1,["BorderColor"]=i}y["[TacticalShotgun]"].Rainbow={["TextureID"]="rbxassetid://12899678631",["Rarity"]="Rare",["Crate"]=1,["BorderColor"]=i}y["[RPG]"].Rainbow={["TextureID"]="rbxassetid://12899423289",["Rarity"]="Rare",["Crate"]=1,["BorderColor"]=i}y["[P90]"].Rainbow={["TextureID"]="rbxassetid://12899451616",["Rarity"]="Rare",["Crate"]=1,["BorderColor"]=i}y["[LMG]"].Rainbow={["TextureID"]="rbxassetid://12899469894",["Rarity"]="Rare",["Crate"]=1,["BorderColor"]=i}y["[Flamethrower]"].Rainbow={["TextureID"]="rbxassetid://12899496204",["Rarity"]="Rare",["Crate"]=1,["BorderColor"]=i}y["[Double-Barrel SG]"].Rainbow={["TextureID"]="rbxassetid://12899533307",["Rarity"]="Rare",["Crate"]=1,["BorderColor"]=i}y["[Glock]"].Rainbow={["TextureID"]="rbxassetid://12899580244",["Rarity"]="Rare",["Crate"]=1,["BorderColor"]=i}y["[Silencer]"].Rainbow={["TextureID"]="rbxassetid://12899580244",["Rarity"]="Rare",["Crate"]=1,["BorderColor"]=i}y["[AUG]"].Rainbow={["TextureID"]="rbxassetid://12899730688",["Rarity"]="Rare",["Crate"]=1,["BorderColor"]=i}y["[AR]"].Rainbow={["TextureID"]="rbxassetid://12899633890",["Rarity"]="Rare",["Crate"]=1,["BorderColor"]=i}y["[SilencerAR]"].Rainbow={["TextureID"]="rbxassetid://12899633890",["Rarity"]="Rare",["Crate"]=1,["BorderColor"]=i}y["[AK47]"].Rainbow={["TextureID"]="rbxassetid://12899655828",["Rarity"]="Rare",["Crate"]=1,["BorderColor"]=i}y["[Revolver]"].Electric={["TextureID"]=a.Meshes.Electric.ElectricRevolver,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.185462952,0.0312761068,0.000610351562,0,0,-1,0,1,0,1,0,0),["BorderColor"]=j}y["[DrumGun]"].Electric={["TextureID"]=a.Meshes.Electric.ElectricDrum,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.471969604,0.184426308,0.075378418,1,0,0,0,1,0,0,0,1),["BorderColor"]=j}y["[SMG]"].Electric={["TextureID"]=a.Meshes.Electric.ElectricSMG,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0620956421,0.109580457,0.00729370117,1,0,0,0,1,0,0,0,1),["BorderColor"]=j}y["[Shotgun]"].Electric={["TextureID"]=a.Meshes.Electric.ElectricShotgun,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0000610351562,0.180232108,-0.624732971,1,0,-4.37113883e-8,0,1,0,4.37113883e-8,0,1),["BorderColor"]=j}y["[Rifle]"].Electric={["TextureID"]=a.Meshes.Electric.ElectricRifle,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.181793213,-0.0415201783,0.00421142578,1.8189894e-12,6.6174449e-24,1,7.27595761e-12,1,6.6174449e-24,-1,-7.27595761e-12,-1.8189894e-12),["BorderColor"]=j}y["[TacticalShotgun]"].Electric={["TextureID"]=a.Meshes.Electric.ElectricTac,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0838031769,-0.0377542973,0.00717163086,0,0,-1,0,1,0,1,0,0),["BorderColor"]=j}y["[RPG]"].Electric={["TextureID"]=a.Meshes.Electric.ElectricRPG,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.022277832,-0.0413781404,0.00997161865,1,-5.35309611e-24,-4.37113883e-8,2.49770094e-21,0.99999994,5.72632016e-14,4.37113883e-8,5.72631948e-14,1),["BorderColor"]=j}y["[P90]"].Electric={["TextureID"]=a.Meshes.Electric.ElectricP90,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.166191101,-0.225557804,-0.0075378418,1,0,0,0,1,0,0,0,1),["BorderColor"]=j}y["[LMG]"].Electric={["TextureID"]=a.Meshes.Electric.ElectricLMG,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.142379761,0.104723871,-0.303771973,-1,0,-4.37113883e-8,0,1,0,4.37113883e-8,0,-1),["BorderColor"]=j}y["[Flamethrower]"].Electric={["TextureID"]=a.Meshes.Electric.ElectricFT,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.158782959,0.173444271,0.00640869141,1,0,0,0,1,0,0,0,1),["BorderColor"]=j}y["[Double-Barrel SG]"].Electric={["TextureID"]=a.Meshes.Electric.ElectricDB,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0755996704,-0.0420352221,0.00543212891,1,0,0,0,1,0,0,0,1),["BorderColor"]=j}y["[Glock]"].Electric={["TextureID"]=a.Meshes.Electric.ElectricGlock,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.00207519531,0.0318723917,0.0401077271,0,0,-1,0,1,0,1,0,0),["BorderColor"]=j}y["[Silencer]"].Electric={["TextureID"]=a.Meshes.Electric.ElectricGlock,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.00207519531,0.0318723917,0.0401077271,0,0,-1,0,1,0,1,0,0),["BorderColor"]=j}y["[AUG]"].Electric={["TextureID"]=a.Meshes.Electric.ElectricAUG,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.331085205,-0.0117390156,0.00155639648,1,0,0,0,1,0,0,0,1),["BorderColor"]=j}y["[AR]"].Electric={["TextureID"]=a.Meshes.Electric.ElectricAR,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.16942215,0.0508521795,0.0669250488,1,0,0,0,1,0,0,0,1),["BorderColor"]=j}y["[SilencerAR]"].Electric={["TextureID"]=a.Meshes.Electric.ElectricAR,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.16942215,0.0508521795,0.0669250488,1,0,0,0,1,0,0,0,1),["BorderColor"]=j}y["[AK47]"].Electric={["TextureID"]=a.Meshes.Electric.ElectricAK,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.155792236,0.18423444,0.00140380859,0,0,-1,0,1,0,1,0,0),["BorderColor"]=j}y["[Revolver]"]["8-BIT"]={["TextureID"]=a.Meshes.BIT8.RPixel,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0261230469,-0.042888701,0.00260925293,-1,1.355249e-20,-3.55271071e-15,1.355249e-20,1,-1.81903294e-27,3.55271071e-15,-1.81903294e-27,-1),["BorderColor"]=k}y["[Flamethrower]"]["8-BIT"]={["TextureID"]=a.Meshes.BIT8.FTPixel,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0906066895,-0.0161985159,-0.0117645264,1,0,0,0,1,0,0,0,1),["BorderColor"]=k}y["[Double-Barrel SG]"]["8-BIT"]={["TextureID"]=a.Meshes.BIT8.DBPixel,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.240386963,-0.127295256,-0.00776672363,0,0,-1,0,1,0,1,0,0),["BorderColor"]=k}y["[RPG]"]["8-BIT"]={["TextureID"]=a.Meshes.BIT8.RPGPixel,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0102081299,0.0659624338,0.362945557,4.37113883e-8,0,1,-5.72632016e-14,1,2.50305399e-21,-1,5.72632016e-14,4.37113883e-8),["BorderColor"]=k}y["[Revolver]"]["Red Skull"]={["TextureID"]=a.Meshes.RedSkull.RedSkullRev,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0043258667,0.0084195137,-0.00238037109,0,0,-1,0,1,0,1,0,0),["BorderColor"]=l}y["[Shotgun]"]["Red Skull"]={["TextureID"]=a.Meshes.RedSkull.RedSkullShotgun,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.00326538086,0.0239292979,-0.039352417,-4.37113883e-8,0,-1,0,1,0,1,0,-4.37113883e-8),["BorderColor"]=l}y["[Double-Barrel SG]"]["Red Skull"]={["TextureID"]=a.Meshes.RedSkull.RedSkullDB,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0143432617,-0.151709318,0.00820922852,-1,0,0,0,1,0,0,0,-1),["BorderColor"]=l}y["[RPG]"]["Red Skull"]={["TextureID"]=a.Meshes.RedSkull.RedSkullRPG,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.00149536133,0.254377961,0.804840088,-1,0,4.37113883e-8,-2.50305399e-21,1,-5.72632016e-14,-4.37113883e-8,5.72632016e-14,-1),["BorderColor"]=l}y["[Revolver]"].Kitty={["TextureID"]=a.Meshes.Kitty.KittyRevolver,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0310440063,0.0737591386,0.0226745605,1,0,0,0,1,0,0,0,1),["BorderColor"]=m}y["[Flamethrower]"].Kitty={["TextureID"]=a.Meshes.Kitty.KittyFT,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.265670776,0.115545571,0.00997924805,-1,9.74078034e-21,5.47124086e-13,9.74092898e-21,1,3.12638804e-13,-5.47126309e-13,3.12638804e-13,-1),["BorderColor"]=m}y["[RPG]"].Kitty={["TextureID"]=a.Meshes.Kitty.KittyRPG,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0268554688,0.0252066851,0.117408752,-1,2.51111284e-40,4.37113883e-8,-3.7545812e-20,1,-8.58948004e-13,-4.37113883e-8,8.58948004e-13,-1),["BorderColor"]=m}y["[Shotgun]"].Kitty={["TextureID"]=a.Meshes.Kitty.KittyShotgun,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0233459473,0.223892093,-0.0213623047,4.37118963e-8,-6.53699317e-13,1,3.47284736e-20,1,7.38964445e-13,-0.999997139,8.69506734e-21,4.37119354e-8),["BorderColor"]=m}y["[Revolver]"].Toy={["TextureID"]=a.Meshes.Toy.RevolverTOY,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0250854492,-0.144362092,-0.00266647339,1,0,0,0,1,0,0,0,1),["BorderColor"]=n}y["[LMG]"].Toy={["TextureID"]=a.Meshes.Toy.LMGTOY,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.285247803,-0.0942560434,-0.270412445,1,0,4.37113883e-8,0,1,0,-4.37113883e-8,0,1),["BorderColor"]=n}y["[Double-Barrel SG]"].Toy={["TextureID"]=a.Meshes.Toy.DBToy,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0484313965,-0.00164616108,-0.0190467834,-1,0,0,0,1,0,0,0,-1),["BorderColor"]=n}y["[RPG]"].Toy={["TextureID"]=a.Meshes.Toy.RPGToy,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.00121307373,0.261434197,-0.318969727,1,2.5768439e-12,-4.37113883e-8,2.57684412e-12,1,6.29895225e-12,4.37113883e-8,6.29895225e-12,1),["BorderColor"]=n,["LauncherCFrame"]=CFrame.new(-0.00020980835,0.000125527382,-0.837677002,1,2.5768439e-12,-4.37113883e-8,2.57684412e-12,1,6.29895225e-12,4.37113883e-8,6.29895225e-12,1),["LauncherMesh"]=a.Meshes.Toy.RPG_LAUNCHER}y["[Revolver]"].Galactic={["TextureID"]=a.Meshes.Galactic.galacticRev,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.049041748,0.0399398208,-0.00772094727,0,0,1,0,1,0,-1,0,0),["BorderColor"]=o}y["[TacticalShotgun]"].Galactic={["TextureID"]=a.Meshes.Galactic.TacticalGalactic,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0411682129,-0.0281000137,0.00103759766,0,5.68434189e-14,1,-1.91456822e-13,1,5.68434189e-14,-1,1.91456822e-13,0),["BorderColor"]=o}y["[Knife]"].Galactic={["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.261539459,0.0143127441,0.0307006836,0,1,0,0,0,1,1,0,0),["BorderColor"]=j}y["[Revolver]"]["Web-Hero"]={["TextureID"]=a.Meshes.HERO.HeroWeb,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0891418457,-0.0215809345,-0.0041809082,-1.99520325e-23,-1.62920685e-7,1,2.44929371e-16,1,1.62920685e-7,-1,2.44929371e-16,1.99520294e-23),["BorderColor"]=p}y["[Shotgun]"]["Bat-Hero"]={["TextureID"]=a.Meshes.HERO.HeroBat,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.00122070312,0.141189337,0.146026611,-1,0,0,0,1,0,0,0,-1),["BorderColor"]=p}y["[Double-Barrel SG]"]["Angry-Hero"]={["TextureID"]=a.Meshes.HERO.HeroAngry,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.171646118,-0.0197404027,-0.00314331055,0,0,-1,0,1,0,1,0,0),["BorderColor"]=p}y["[RPG]"]["Robot-Hero"]={["TextureID"]=a.Meshes.HERO.HeroRobot,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.00689697266,-0.0342824459,0.105255127,-1,-1.821688e-44,4.37113883e-8,-2.50305399e-21,1,-5.72632016e-14,-4.37113883e-8,5.72632016e-14,-1),["BorderColor"]=p,["LauncherCFrame"]=CFrame.new(0.00717163086,0.000218987465,0.119476318,1,-2.44930165e-16,0,2.44929344e-16,1,1.19209346e-7,0,-1.19209226e-7,1),["LauncherMesh"]=a.Meshes.HERO.RobotLauncher}y["[Revolver]"].Water={["TextureID"]=a.Meshes.Water.WaterGunRevolver,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0440063477,0.028675437,-0.00469970703,0,0,-1,0,1,0,1,0,0),["BorderColor"]=j}y["[Double-Barrel SG]"].Water={["TextureID"]=a.Meshes.Water.DBWater,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0710754395,0.00169920921,-0.0888671875,0,0,1,0,1,0,-1,0,0),["BorderColor"]=j}y["[TacticalShotgun]"].Water={["TextureID"]=a.Meshes.Water.TactWater,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0238037109,-0.00912904739,0.00485229492,0,0,1,0,1,0,-1,0,0),["BorderColor"]=j}y["[Flamethrower]"].Water={["TextureID"]=a.Meshes.Water.FTWater,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0941314697,0.593509138,0.0191040039,-1,0,0,0,1,0,0,0,-1),["BorderColor"]=j}y["[Revolver]"].Tact={["TextureID"]=a.Meshes.Tact.Rev,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.318634033,-0.055095911,0.00491333008,0,0,1,0,1,0,-1,0,0),["BorderColor"]=f}y["[TacticalShotgun]"].Tact={["TextureID"]=a.Meshes.Tact.Tact,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0687713623,-0.0684046745,0.12701416,0,0,1,0,1,0,-1,0,0),["BorderColor"]=f}y["[Shotgun]"].Tact={["TextureID"]=a.Meshes.Tact.Shotgun,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0610046387,0.171100497,-0.00495910645,1,0,0,0,1,0,0,0,1),["BorderColor"]=f}y["[Double-Barrel SG]"].Tact={["TextureID"]=a.Meshes.Tact.DB,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0701141357,-0.0506889224,-0.0826416016,0,0,1,0,1,0,-1,0,0),["BorderColor"]=f}y["[Silencer]"].Tact={["TextureID"]=a.Meshes.Tact.Silencer,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0766601562,-0.0350288749,-0.648864746,1,0,-4.37113883e-8,0,1,0,4.37113883e-8,0,1),["BorderColor"]=f}y["[SMG]"].Tact={["TextureID"]=a.Meshes.Tact.Uzi,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0408782959,0.0827783346,-0.0423583984,-1,0,0,0,1,0,0,0,-1),["BorderColor"]=f}y["[RPG]"]["GPO-Ice"]={["TextureID"]=a.Meshes.GPO.Bazooka,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0184631348,0.0707798004,0.219360352,4.37113883e-8,1.07062025e-23,1,-5.75081297e-14,1,1.14251725e-36,-1,5.70182736e-14,4.37113883e-8),["BorderColor"]=q,["LauncherCFrame"]=CFrame.new(-0.044708252,-0.0522594452,-0.688751221,4.37113883e-8,1.07062025e-23,1,-5.75081297e-14,1,1.14251725e-36,-1,5.70182736e-14,4.37113883e-8),["LauncherMesh"]=a.Meshes.GPO.IceBoom}y["[TacticalShotgun]"]["GPO-Magma"]={["TextureID"]=a.Meshes.GPO.MaguTact,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.282501221,0.0472121239,-0.0065612793,-6.60624482e-6,1.5649757e-8,-1,-5.68434189e-14,1,-1.56486806e-8,1,5.68434189e-14,-6.60624482e-6),["BorderColor"]=q}y["[Rifle]"]["GPO-Light"]={["TextureID"]=a.Meshes.GPO.Rifle,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.208007812,0.185256913,0.000610351562,-3.37081539e-14,1.62803403e-7,-1.00000012,-8.74227695e-8,0.999999881,1.63036205e-7,1,8.74227766e-8,-1.94552524e-14),["BorderColor"]=q}y["[Knife]"]["GPO-Knife"]={["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.693048477,-0.0903320312,-0.00289916992,-1,2.44929371e-16,1.99520294e-23,2.44929371e-16,1,1.62920685e-7,1.99520325e-23,1.62920685e-7,-1),["BorderColor"]=q}y["[Knife]"]["GPO-Knife Prestige"]={["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.693048477,-0.0903320312,-0.00289916992,-1,2.44929371e-16,1.99520294e-23,2.44929371e-16,1,1.62920685e-7,1.99520325e-23,1.62920685e-7,-1),["BorderColor"]=q}y["[Revolver]"].Devil={["TextureID"]=a.Meshes.CyanPack.Devil,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0185699463,0.293397784,-0.00256347656,1,0,0,0,1,0,0,0,1),["BorderColor"]=r}y["[TacticalShotgun]"].Cloud={["TextureID"]=a.Meshes.CyanPack.Cloud,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0441589355,-0.0269355774,-0.000701904297,1,0,0,0,1,0,0,0,1),["BorderColor"]=r}y["[Double-Barrel SG]"].Flower={["TextureID"]=a.Meshes.CyanPack.DB,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.00828552246,0.417651355,-0.00537109375,4.18358377e-6,-1.62920685e-7,1,3.4104116e-13,1,1.62920685e-7,-1,3.41041052e-13,-4.18358377e-6),["BorderColor"]=r}y["[RPG]"].Cookie={["TextureID"]=a.Meshes.CyanPack.rpg,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.00448608398,0.211129785,0.108352661,-1,-6.87656033e-15,4.37113883e-8,2.44926856e-16,1,1.62920628e-7,-4.37113883e-8,1.62920742e-7,-1),["BorderColor"]=r,["LauncherCFrame"]=CFrame.new(0.000183105469,0.000218987465,-0.0145568848,4.37113883e-8,-1.62920671e-7,1,-5.70182736e-14,1,1.62920671e-7,-1,5.03866426e-14,4.37113883e-8),["LauncherMesh"]=a.Meshes.CyanPack.Rocket}y["[Knife]"].Frog={["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.763793707,0.0409240723,-0.0497436523,0.37460658,0.927183867,1.51057435e-7,-0.927183867,0.37460658,6.10311588e-8,-1.99520325e-23,-1.62920685e-7,1),["BorderColor"]=r}y["[Knife]"].Cartoon={["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.009542346,0.0122070312,0.00538635254,2.38220323e-8,1.00000095,-7.88475063e-10,-1.00000298,-2.35862601e-8,1.92318112e-7,-1.9185245e-7,-7.88077159e-10,1.00000429),["BorderColor"]=s}y["[Revolver]"].Cartoon={["TextureID"]=a.Meshes.Cartoon.CartoonRev,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.015411377,0.0135096312,0.00338745117,1.00000095,3.41326549e-13,2.84217399e-14,3.41326549e-13,1.00000191,-9.89490712e-10,2.84217399e-14,-9.89490712e-10,1.00000191),["BorderColor"]=s}y["[Double-Barrel SG]"].Cartoon={["TextureID"]=a.Meshes.Cartoon.DBCartoon,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.00927734375,-0.00691050291,0.000732421875,-1,-2.79396772e-8,-9.31322797e-10,-2.79396772e-8,1,1.42607872e-8,9.31322575e-10,1.42607872e-8,-1),["BorderColor"]=s}y["[RPG]"].Cartoon={["TextureID"]=a.Meshes.Cartoon.RPGCartoon,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0201721191,0.289476752,-0.0727844238,4.37113883e-8,6.58276836e-37,1,-5.72632016e-14,1,2.50305399e-21,-1,5.72632016e-14,4.37113883e-8),["BorderColor"]=s,["LauncherCFrame"]=CFrame.new(-0.00137329102,0.00280761719,-0.321243286,-1,-1.30858874e-16,4.36997354e-8,-2.50242694e-21,1,2.99444292e-9,-4.36997354e-8,2.99455749e-9,-1),["LauncherMesh"]=a.Meshes.Cartoon.RPGCartoonLauncher}y["[Flamethrower]"].Cartoon={["TextureID"]=a.Meshes.Cartoon.CartoonFT,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.272186279,0.197086751,0.0440063477,-1,4.8018768e-7,8.7078952e-8,4.80187623e-7,1,-3.54779985e-7,-8.70791226e-8,-3.54779957e-7,-1),["BorderColor"]=s}y["[Knife]"].Stars={["DisplayName"]="Star",["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.983487725,0.0367431641,-0.00146484375,0,1,0,-1,0,0,0,0,1),["BorderColor"]=t}y["[Revolver]"].Stars={["DisplayName"]="Thunder",["TextureID"]=a.Meshes.Stars.Revolver,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0765533447,0.0790345669,0.00277709961,1.99520325e-23,1.62920685e-7,-1,2.44929371e-16,1,1.62920685e-7,1,-2.44929371e-16,-1.99520294e-23),["BorderColor"]=t}y["[Double-Barrel SG]"].Stars={["DisplayName"]="Dino",["TextureID"]=a.Meshes.Stars.DB,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0697937012,0.0765505433,0.00863647461,7.54618668e-7,-1.62920685e-7,1,6.1716413e-14,1,1.62920685e-7,-1,6.17164197e-14,-7.54618668e-7),["BorderColor"]=t}y["[RPG]"].Stars={["DisplayName"]="Speed",["TextureID"]=a.Meshes.Stars.RPG,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.00457763672,-0.0361404419,-0.636352539,-1,-2.30390549e-28,4.37113883e-8,-2.50305399e-21,1,-5.72632084e-14,-4.37113883e-8,5.72632084e-14,-1),["BorderColor"]=t,["LauncherCFrame"]=CFrame.new(0.00271606445,-0.0138825178,-0.384429932,4.37113883e-8,-2.30390549e-28,1,-5.72632084e-14,1,2.50305399e-21,-1,5.72632084e-14,4.37113883e-8),["LauncherMesh"]=a.Meshes.Stars.Rocket}y["[Flamethrower]"].Stars={["DisplayName"]="Starry",["TextureID"]=a.Meshes.Stars.Flamethrower,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0000610351562,0.229534328,0.0126647949,0,0,1,0,1,0,-1,0,0),["BorderColor"]=t}y["[Revolver]"]["DH-Verified"]={["TextureID"]=a.Meshes.Popular.VERIFIEDREV,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.049407959,-0.0454721451,0.00158691406,-1,0,0,0,1,2.22044605e-15,0,-2.22044605e-15,-1),["NoTrade"]=true}y["[Revolver]"]["DH-Stars II"]={["TextureID"]=a.Meshes.Popular.STARSREV,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0578613281,-0.0479719043,-0.00115966797,-1.00000405,1.15596135e-16,1.64267286e-30,-1.15596135e-16,1,2.99751983e-14,1.66683049e-30,-2.99751983e-14,-1.00000405),["NoTrade"]=true}y["[Knife]"].Mystical={["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.146238923,0.0104064941,-0.0165710449,-3.94430029e-31,1,0,1.00000429,0,0,0,0,-1.00000429),["BorderColor"]=u}y["[Revolver]"].Mystical={["TextureID"]=a.Meshes.Mystical.Revolver,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.015838623,-0.0802496076,0.00772094727,1,0,4.37113883e-8,0,1,0,-4.37113883e-8,0,1),["BorderColor"]=u}y["[Double-Barrel SG]"].Mystical={["TextureID"]=a.Meshes.Mystical.DB,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.00408935547,-0.021312356,0.00366210938,-1,-1.95924309e-33,2.03287907e-20,1.95924309e-33,1,0,-2.0328781e-20,0,-0.999999523),["BorderColor"]=u}y["[RPG]"].Mystical={["TextureID"]=a.Meshes.Mystical.RPG,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0104980469,-0.132928133,0.311920166,4.37113883e-8,-3.72594783e-24,1,-1.46422097e-10,1,6.40030916e-18,-1,1.46422097e-10,4.37113883e-8),["BorderColor"]=u,["LauncherCFrame"]=CFrame.new(-0.00402832031,-0.00254774094,-0.735931396,-1,-3.30872245e-24,4.37113883e-8,-6.40531526e-18,1,-1.46536616e-10,-4.37113883e-8,1.46536616e-10,-1),["LauncherMesh"]=a.Meshes.Mystical.Launcher}y["[Flamethrower]"].Mystical={["TextureID"]=a.Meshes.Mystical.Flamethrower,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.192108154,0.183631241,0.0121765137,1,-6.33751573e-17,2.28174031e-8,1.47408879e-18,1.00000465,-1.34514666e-8,1.35041773e-8,-7.12136439e-9,1),["BorderColor"]=u}y["[Knife]"]["RGB Karambit"]={["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.147634387,0.286956787,-0.00314331055,8.88577406e-14,0.798631966,0.601811886,1.75618051e-14,-0.601811886,0.798631966,1,6.03960173e-14,6.75013837e-14),["BorderColor"]=j}y["[Knife]"].Candy={["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.844940186,0.132034421,-0.0134277344,-2.27373675e-13,3.69608081e-26,-1,-4.33481159e-13,0.999999523,-3.69608266e-26,1,-4.33480942e-13,2.27373675e-13),["BorderColor"]=u}y["[Revolver]"].Candy={["TextureID"]=a.Meshes.Candy.RevolverCandy,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.106658936,-0.0681198835,0.00198364258,0,0,-1,0,1,0,1,0,0),["BorderColor"]=u}y["[Double-Barrel SG]"].Candy={["TextureID"]=a.Meshes.Candy.DBCandy,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0430603027,-0.0375298262,-0.00198364258,0,0,1,0,1,0,-1,0,0),["BorderColor"]=u}y["[LMG]"].Candy={["TextureID"]=a.Meshes.Candy.LMG,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.125213623,-0.30771935,-0.0625305176,-4.37113883e-8,0,1,0,1,0,-1,0,-4.37113883e-8),["BorderColor"]=u}y["[RPG]"].Candy={["TextureID"]=a.Meshes.Candy.RPG,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.00387573242,-0.14110744,-0.552215576,-1,5.55111512e-17,4.37113883e-8,-5.58290533e-17,1,-7.27279868e-12,-4.37113883e-8,7.27279868e-12,-1),["BorderColor"]=u,["LauncherCFrame"]=CFrame.new(0.00396728516,0.00116837025,0.855957031,-1,5.55111479e-17,4.37113883e-8,-5.58340561e-17,1,-7.38732513e-12,-4.37113883e-8,7.38732513e-12,-1),["LauncherMesh"]=a.Meshes.Candy.RPGLAUNCHER}y["[RPG]"].Cake={["TextureID"]=a.Meshes.Barbie.rpg,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0417480469,0.253171682,1.63067627,4.37113883e-8,3.46944654e-18,1,-4.00865674e-13,1,3.48696912e-18,-1,4.00865674e-13,4.37113883e-8),["BorderColor"]=b,["LauncherCFrame"]=CFrame.new(-0.0161437988,0.275420427,-0.27822876,3.46944675e-18,-4.37113883e-8,1,1,5.15392091e-13,3.49197522e-18,5.15392091e-13,1,4.37113883e-8),["LauncherMesh"]=a.Meshes.Barbie.rpglaunhcher}y["[Double-Barrel SG]"].Car={["TextureID"]=a.Meshes.Barbie.db,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0457763672,0.0508109927,0.000579833984,-1,0,0,0,1,0,0,0,-1),["BorderColor"]=b}y["[Revolver]"].Skeleton={["TextureID"]=a.Meshes.Barbie.Revol,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0218505859,-0.0277693868,0.0029296875,1,0,0,0,1,0,0,0,1),["BorderColor"]=b}y["[Flamethrower]"].Doll={["TextureID"]=a.Meshes.Barbie.FT,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.450744629,-0.232652962,0.0798339844,-1,0,0,0,1,0,0,0,-1),["BorderColor"]=b}y["[Knife]"].Banana={["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.371171594,-0.131195068,0.0763549805,0,1,0,0,0,-1,-1,0,0),["BorderColor"]=b}y["[RPG]"].Soul={["TextureID"]=a.Meshes.Soul.RPG,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0071105957,-0.0523811579,-1.09643555,-4.37113883e-8,-1.16415322e-10,-1,7.68569407e-6,1,-1.16751275e-10,1,-7.68569407e-6,-4.37113847e-8),["BorderColor"]=v,["LauncherCFrame"]=CFrame.new(-0.0195617676,0.0611854792,-0.0733947754,-4.37113883e-8,-1.16415322e-10,-1,7.68569407e-6,1,-1.16751275e-10,1,-7.68569407e-6,-4.37113847e-8),["LauncherMesh"]=a.Meshes.Soul.launcher}y["[Double-Barrel SG]"].Soul={["TextureID"]=a.Meshes.Soul.db,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.405822754,0.0975035429,-0.00506591797,-1,0,0,0,1,0,0,0,-1),["BorderColor"]=v}y["[Revolver]"].Soul={["TextureID"]=a.Meshes.Soul.rev,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0646362305,0.2725088,-0.00242614746,0,0,-1,0,1,0,1,0,0),["BorderColor"]=v}y["[TacticalShotgun]"].Soul={["TextureID"]=a.Meshes.Soul.tact,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.347473145,0.0268714428,0.00553894043,1,0,0,0,1,0,0,0,1),["BorderColor"]=v}y["[Knife]"].Soul={["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.129888415,0.0243530273,-0.0148620605,1,0,0,0,-1,0,0,0,-1),["BorderColor"]=v}y["[Silencer]"].Mummy={["TextureID"]=a.Meshes.Raygun.mummy,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0105285645,-0.00735360384,-0.277282715,-1,-2.44256403e-16,4.37114309e-8,0,0.999999046,-5.58793545e-9,-4.37113883e-8,5.58793545e-9,-1.00000095),["BorderColor"]=v}y["[Revolver]"].Halloween23={["TextureID"]=a.Meshes.Halloween.Rev,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0257873535,-0.0117108226,-0.00671386719,-1,0,0,0,1,0,0,0,-1),["BorderColor"]=v}y["[Knife]"].Halloween23={["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.293486953,-0.203857422,0.0588989258,-6.05363013e-8,1,-3.97904366e-13,1,6.05363013e-8,9.94765387e-14,9.94765658e-14,-3.97904366e-13,-1),["BorderColor"]=v}y["[Double-Barrel SG]"].Halloween23={["TextureID"]=a.Meshes.Halloween.DB,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.00271606445,-0.0485508144,0.000732421875,1,0,0,0,1,0,0,0,1),["BorderColor"]=v}y["[TacticalShotgun]"].Halloween23={["TextureID"]=a.Meshes.Halloween.Tact,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0715637207,-0.0843618512,0.00582885742,-1,0,0,0,1,0,0,0,-1),["BorderColor"]=v}y["[Shotgun]"].Halloween23={["TextureID"]=a.Meshes.Halloween.SG,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.00573730469,0.294590235,-0.115814209,0,0,-1,0,1,0,1,0,0),["BorderColor"]=v}y["[RPG]"].Halloween23={["TextureID"]=a.Meshes.Halloween.RPG,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0249633789,-0.048746109,0.659362793,-1,1.73472327e-18,4.37113883e-8,-1.74223304e-18,1,-1.7180124e-13,-4.37113883e-8,1.7180124e-13,-1),["BorderColor"]=v,["LauncherCFrame"]=CFrame.new(0.0485229492,0.0587707758,-0.265991211,-1,1.73472337e-18,4.37113883e-8,-1.74723913e-18,1,-2.86327629e-13,-4.37113883e-8,2.86327629e-13,-1),["LauncherMesh"]=a.Meshes.Halloween.Launcher}y["[TacticalShotgun]"].Numbers={["TextureID"]=a.Meshes.Numbers.Tactical,["Rarity"]="Legendary",["CFrame"]=CFrame.new(-0.347015381,-0.101575613,-0.0437011719,0,0,1,0,1,0,-1,0,0),["BorderColor"]=v,["Crate"]=999}y["[Double-Barrel SG]"].Magma={["TextureID"]=a.Meshes.Numbers.MagmaDB,["Rarity"]="Legendary",["CFrame"]=CFrame.new(-0.750671387,0.339070976,0.0111999512,0,0,1,0,1,0,-1,0,0),["BorderColor"]=v,["Crate"]=999}y["[TacticalShotgun]"].Undead={["TextureID"]=a.Meshes.Undead.Tact,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.558105469,-0.00996416807,0.0152893066,1,0,0,0,1,0,0,0,1),["BorderColor"]=v}y["[RPG]"].Undead={["TextureID"]=a.Meshes.Undead.RPG,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0429077148,0.0559833646,2.07913208,-4.37113883e-8,-7.27595761e-12,-1,1.20086924e-7,1,7.27070834e-12,1,1.20086924e-7,-4.37113883e-8),["BorderColor"]=v,["LauncherCFrame"]=CFrame.new(0.0203552246,-0.0671813488,0.119415283,-4.37113883e-8,-7.27595761e-12,-1,1.20087037e-7,1,7.27070834e-12,1,1.20087037e-7,-4.37113883e-8),["LauncherMesh"]=a.Meshes.Undead.Rocket}y["[Revolver]"].Undead={["TextureID"]=a.Meshes.Undead.rev,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.202331543,0.0300472379,-0.00631713867,1,0,0,0,1,0,0,0,1),["BorderColor"]=v}y["[Knife]"].Undead={["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0730648041,0.029083252,0.00421142578,-1,0,0,0,-1,0,0,0,1),["BorderColor"]=v}y["[Double-Barrel SG]"].Undead={["TextureID"]=a.Meshes.Undead.AstroDB,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.193084717,0.17139101,0.00225830078,-1,0,0,0,1,0,0,0,-1),["BorderColor"]=v}y["[Revolver]"].Spooky={["DisplayName"]="Jason",["TextureID"]=a.Meshes.Spooky.rev,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0029296875,-0.0561903119,-0.011138916,0,0,-1,0,1,0,1,0,0),["BorderColor"]=v}y["[TacticalShotgun]"].Spooky={["DisplayName"]="Blood",["TextureID"]=a.Meshes.Spooky.tact,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.199981689,-0.124790192,-0.00152587891,-1,0,0,0,1,0,0,0,-1),["BorderColor"]=v}y["[RPG]"].Spooky={["TextureID"]=a.Meshes.Spooky.Rocket,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.00857543945,-0.00493192673,-0.046875,-1,2.8421706e-14,4.37113883e-8,-2.90778652e-14,1,-1.5011139e-8,-4.37113883e-8,1.5011139e-8,-1),["BorderColor"]=v,["LauncherCFrame"]=CFrame.new(-0.0168762207,0.0170578957,0.00112915039,-1,2.84217043e-14,4.37113883e-8,-2.9077872e-14,1,-1.50112527e-8,-4.37113883e-8,1.50112527e-8,-1),["LauncherMesh"]=a.Meshes.Spooky.Launcher}y["[Flamethrower]"].Spooky={["DisplayName"]="Eye",["TextureID"]=a.Meshes.Spooky.FT,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.415008545,0.349902928,-0.00164794922,0,0,-1,0,1,0,1,0,0),["BorderColor"]=v}y["[Double-Barrel SG]"].Spooky={["DisplayName"]="Eye",["TextureID"]=a.Meshes.Spooky.DB,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.170593262,0.0795405507,-0.0000610351562,1,0,0,0,0.999999762,0,0,0,0.999999762),["BorderColor"]=v}y["[Knife]"].Spooky={["DisplayName"]="Magma",["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.10736084,-0.0247398615,-0.0214538574,1.19212316e-7,1,-2.78531907e-12,0.999999523,-1.1921226e-7,6.96321581e-13,6.96321635e-13,-2.78531885e-12,-1),["BorderColor"]=v}y["[Revolver]"].Etheral={["TextureID"]=a.Meshes.Etheral.Rev,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0255432129,-0.0427106023,0.0140380859,-1,0,0,0,1,0,0,0,-1),["BorderColor"]=w}y["[Double-Barrel SG]"].Etheral={["TextureID"]=a.Meshes.Etheral.db,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0578613281,-0.0133004785,0.0168457031,1,0,0,0,1,0,0,0,1),["BorderColor"]=w}y["[Flamethrower]"].Etheral={["TextureID"]=a.Meshes.Etheral.ft,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.119934082,0.0947337747,-0.00924682617,0,0,1,0,1,0,-1,0,0),["BorderColor"]=w}y["[RPG]"].Etheral={["TextureID"]=a.Meshes.Etheral.RPG,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.00695800781,0.150677085,0.714691162,4.74366786e-8,-1.11847207e-16,1,-6.00474408e-8,1,2.51291001e-15,-1,6.00474408e-8,3.9986098e-8),["BorderColor"]=w,["LauncherCFrame"]=CFrame.new(-0.0138549805,-0.0158934593,0.209564209,4.74366786e-8,-1.11847313e-16,1,-6.00475545e-8,1,2.51291467e-15,-1,6.00475545e-8,3.9986098e-8),["LauncherMesh"]=a.Meshes.Etheral.Launcher}y["[Knife]"].Etheral={["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.540863037,-0.00247907639,0.124786377,-1,0,0,0,0.999999523,0,0,0,-1),["BorderColor"]=w}y["[Revolver]"].Ice={["DisplayName"]="Frozen",["TextureID"]=a.Meshes.Ice.rev,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0299072266,0.0293902755,-0.0108032227,1,0,0,0,0,1,0,-1,0),["BorderColor"]=x}y["[TacticalShotgun]"].Ice={["DisplayName"]="Frozen",["TextureID"]=a.Meshes.Ice.tact,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.151062012,0.0138154626,0.000366210938,1,0,0,0,0,1,0,-1,0),["BorderColor"]=x}y["[Knife]"]["Ice Sword"]={["DisplayName"]="Ice Dagger",["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.248702049,0.00454711914,-0.00390625,2.44929371e-16,1,1.62920657e-7,1.99519599e-23,1.62920202e-7,-0.999997616,-1,2.44929371e-16,1.99520262e-23),["BorderColor"]=x}y["[Double-Barrel SG]"].Ice={["DisplayName"]="Frozen",["TextureID"]=a.Meshes.Ice.DB,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.574920654,0.309675515,0.0344848633,-1,0,0,0,0,1,0,1,0),["BorderColor"]=x}y["[RPG]"].Ice={["DisplayName"]="Frozen",["TextureID"]=a.Meshes.Ice.RPG,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.00628662109,-0.0235987902,-1.82954407,-4.37113883e-8,1,1.62920685e-7,4.00923896e-13,-1.62920685e-7,1,1,4.37113883e-8,4.08045397e-13),["BorderColor"]=x,["LauncherCFrame"]=CFrame.new(-0.00628662109,0.00532734394,0.364135742,-4.37113883e-8,1,0,5.15450313e-13,2.2531046e-20,1,1,4.37113883e-8,5.15450313e-13),["LauncherMesh"]=a.Meshes.Ice.Launcher}y["[Revolver]"].Hoodmas={["TextureID"]=a.Meshes.Hoodmas.revolver,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.00862121582,-0.000740110874,-0.0009765625,1,0,0,0,1,0,0,0,1)}y["[Double-Barrel SG]"].Hoodmas={["TextureID"]=a.Meshes.Hoodmas.db,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0,0,0)*CFrame.Angles(0,3.141592653589793,0)}y["[Shotgun]"].Hoodmas={["TextureID"]=a.Meshes.Hoodmas.shotgun,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0,0,0)*CFrame.Angles(0,-1.5707963267948966,0)}y["[AR]"].Hoodmas={["TextureID"]=a.Meshes.Hoodmas.ar,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0,0,0)*CFrame.Angles(0,3.141592653589793,0)}y["[TacticalShotgun]"].Hoodmas={["TextureID"]=a.Meshes.Hoodmas.tact,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0,0,0)}y["[Flamethrower]"].Hoodmas={["TextureID"]=a.Meshes.Hoodmas.flamethrower,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0,0,0)*CFrame.Angles(0,3.141592653589793,0)}y["[RPG]"].Hoodmas={["TextureID"]=a.Meshes.Hoodmas.rpg,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0,0,0)*CFrame.Angles(0,-1.5707963267948966,0)}y["[Knife]"].Hoodmas={["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0,0,0)}y["[Revolver]"].XMAS={["TextureID"]=a.Meshes.XMAS.Rev,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0034942627,-0.0323467255,-0.000244140625,-1.00000095,7.45058149e-9,0,-7.45058149e-9,0.999999523,0,0,0,-1)}y["[Knife]"].XMAS={["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-1.27282023,-0.128097534,-0.0394134521,2.75315642e-7,0.719339967,0.694658518,-4.80564211e-9,0.694658518,-0.719339967,-1,1.94707184e-7,1.94707169e-7)}y["[Flamethrower]"].XMAS={["TextureID"]=a.Meshes.XMAS.Flamethrower,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.528900146,0.0900247097,0.00065612793,1,0,0,0,1,0,0,0,1)}y["[RPG]"].XMAS={["TextureID"]=a.Meshes.XMAS.rpg,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0332183838,-0.105202198,-2.14428711,4.37113883e-8,0,1,-5.72632016e-14,1,2.50305399e-21,-1,5.72632016e-14,4.37113883e-8),["LauncherCFrame"]=CFrame.new(0.0412902832,0.0782194138,-0.438598633,4.37113883e-8,8.14188054e-17,1,-1.86270244e-9,1,2.50305399e-21,-1,-1.86258786e-9,4.37113883e-8),["LauncherMesh"]=a.Meshes.XMAS.Ornament}y["[Double-Barrel SG]"].XMAS={["TextureID"]=a.Meshes.XMAS.DB,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(1.39941406,0.0596529841,-0.0409545898,1,0,0,0,1,0,0,0,1)}y["[Knife]"]["Crystal Karambit"]={["DisplayName"]="King Karambit",["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-1.59968805,-0.0777282715,-0.0473022461,0,0.37460658,-0.927183867,0,0.927183867,0.37460658,1,0,0)}y["[Knife]"]["Galaxy Karambit"]={["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-1.28114009,-0.0814056396,-0.0313110352,-0.342020094,-0.939692557,0,-0.939692557,0.342020094,0,-0,0,-1)}y["[Revolver]"]["Wild West"]={["TextureID"]=a.Meshes.WildWest.Rev,["Rarity"]="Legendary",["CFrame"]=CFrame.new(0.00323486328,-0.110876054,-0.00628662109,0,0,0.999995708,0,1,0,-1,0,0),["Crate"]=999}y["[Double-Barrel SG]"]["Wild West"]={["TextureID"]=a.Meshes.WildWest.DB,["Rarity"]="Legendary",["CFrame"]=CFrame.new(-0.159378052,-0.123334587,-0.00241088867,0,0,-0.999995232,0,1,0,1,0,0),["Crate"]=999}y["[Knife]"]["Wild West"]={["Rarity"]="Legendary",["CFrame"]=CFrame.new(0.383782029,0.0114746094,-0.00112915039,0,-1,0,1,0,0,0,0,1),["Crate"]=999}y["[Revolver]"].Portal={["TextureID"]=a.Meshes.Portal.rev,["Rarity"]="Exclusive",["BorderColor"]=c,["CFrame"]=CFrame.new(0.072303772,0.0471935868,-0.0138244629,-1,0,0,0,0.99999994,0,0,0,-1)}y["[TacticalShotgun]"].Portal={["TextureID"]=a.Meshes.Portal.Tact,["Rarity"]="Exclusive",["BorderColor"]=c,["CFrame"]=CFrame.new(-1.0434494,0.0293064713,-0.063079834,-1,0,0,0,1,0,0,0,-1)}y["[Double-Barrel SG]"].Portal={["TextureID"]=a.Meshes.Portal.DB,["Rarity"]="Exclusive",["BorderColor"]=c,["CFrame"]=CFrame.new(0.296951294,-0.054553628,0.0379638672,0.99999702,0,0,0,1,0,0,0,1)}y["[Knife]"].Portal={["Rarity"]="Exclusive",["BorderColor"]=c,["CFrame"]=CFrame.new(-0.102067709,0.150634766,-0.00653076172,0,0.999999225,0,0.999999166,0,0,0,0,-1)}y["[RPG]"].Portal={["TextureID"]=a.Meshes.Portal.rpg,["Rarity"]="Exclusive",["BorderColor"]=c,["CFrame"]=CFrame.new(0.00946044922,-0.19871664,0.647293091,4.37114167e-8,-6.46234854e-27,1,-4.00862828e-13,1,1.75222655e-20,-1,4.00862828e-13,4.37113599e-8),["LauncherCFrame"]=CFrame.new(-0.0126037598,0.00348734856,-0.17477417,4.37114167e-8,-8.07793567e-27,1,-5.15389272e-13,1,2.2528369e-20,-1,5.15389272e-13,4.37113599e-8),["LauncherMesh"]=a.Meshes.Portal.launcher}y["[Revolver]"].Ninja={["TextureID"]=a.Meshes.Ninja.NinjaRev,["Rarity"]="Legendary",["CFrame"]=CFrame.new(0.0598754883,0.102456093,0.00305175781,0,0,-1,0,1,0,1,0,0),["Crate"]=999}y["[Double-Barrel SG]"].Ninja={["TextureID"]=a.Meshes.Ninja.NinjaDB,["Rarity"]="Legendary",["CFrame"]=CFrame.new(-0.0128631592,0.0259246826,-0.00207519531,0,0,1,0,1,0,-1,0,0),["Crate"]=999}y["[Revolver]"].Love={["TextureID"]=a.Meshes.Love.rev,["Rarity"]="Exclusive",["BorderColor"]=b,["CFrame"]=CFrame.new(-0.0348358154,-0.112736881,0.0156860352,1,0,0,0,1,0,0,0,1)}y["[TacticalShotgun]"].Love={["TextureID"]=a.Meshes.Love.Tact,["Rarity"]="Exclusive",["BorderColor"]=b,["CFrame"]=CFrame.new(-0.0231781006,-0.114733696,0.0161743164,0,0,0.999999821,0,0.999998748,0,-1,0,0)}y["[Double-Barrel SG]"].Love={["TextureID"]=a.Meshes.Love.DB,["Rarity"]="Exclusive",["BorderColor"]=b,["CFrame"]=CFrame.new(0.159469604,-0.16393137,-0.00659179688,-1,0,0,0,0.999999106,0,0,0,-1)}y["[RPG]"].Love={["TextureID"]=a.Meshes.Love.rpg,["Rarity"]="Exclusive",["BorderColor"]=b,["CFrame"]=CFrame.new(0.020324707,-0.0424976349,0.149459839,-4.37113883e-8,-5.55111512e-17,-1,3.60756173e-12,1,5.53534575e-17,1,3.60756173e-12,-4.37113883e-8),["LauncherCFrame"]=CFrame.new(0.020690918,0.02942276,-0.542907715,-4.37113883e-8,-5.55111512e-17,-1,3.72208818e-12,1,5.53484481e-17,1,3.72208818e-12,-4.37113883e-8),["LauncherMesh"]=a.Meshes.Love.Launcher}y["[Flamethrower]"].Love={["TextureID"]=a.Meshes.Love.FT,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.306655884,-0.30743885,-0.00744628906,0,0,-1,0,1,0,1,0,0),["BorderColor"]=b}y["[Knife]"].Love={["Rarity"]="Exclusive",["BorderColor"]=b,["CFrame"]=CFrame.new(-0.352311015,0.0614624023,-0.0600585938,5.96049716e-8,1,3.97904366e-13,-1,5.96049716e-8,-9.94765387e-14,-9.94765658e-14,-3.97904366e-13,1)}y["[Revolver]"].Cupid={["TextureID"]=a.Meshes.Cupid.rev,["Rarity"]="Exclusive",["BorderColor"]=b,["CFrame"]=CFrame.new(0.0240020752,0.229963183,-0.0170898438,0,0,-1,0,1,0,1,0,0)}y["[Double-Barrel SG]"].Cupid={["TextureID"]=a.Meshes.Cupid.db,["Rarity"]="Exclusive",["BorderColor"]=b,["CFrame"]=CFrame.new(-0.0375976562,0.048615396,0.00555419922,0,0,1,0,0.999998212,0,-1,0,0)}y["[Knife]"].Cupid={["Rarity"]="Exclusive",["BorderColor"]=b,["CFrame"]=CFrame.new(0.248047352,-0.0400543213,-0.0659179688,0,1,0,0.999998093,0,0,0,0,-1)}y["[RPG]"].Cupid={["TextureID"]=a.Meshes.Cupid.rpg,["Rarity"]="Exclusive",["BorderColor"]=b,["CFrame"]=CFrame.new(0.00213623047,0.156091571,1.50897217,-4.37113883e-8,1,-8.8817842e-16,1.4601792e-11,-8.87540127e-16,1,1,4.37113883e-8,1.4601792e-11),["LauncherCFrame"]=CFrame.new(0.282226562,0.142233849,-0.418685913,-4.37113883e-8,1,-8.8817842e-16,1.47163184e-11,-8.87535151e-16,1,1,4.37113883e-8,1.47163184e-11),["LauncherMesh"]=a.Meshes.Cupid.Launcher}y["[Revolver]"].Shader={["TextureID"]=a.Meshes.Shader.Rev,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.00216674805,0.0199100971,-0.00390625,-1,0,0,0,1,0,0,0,-1),["DisplayName"]="Squid",["BorderColor"]=k}y["[Double-Barrel SG]"].Shader={["TextureID"]=a.Meshes.Shader.DB,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0402069092,-0.0140712261,-0.0110473633,0,0,1,0,0.999995232,0,-1,0,0),["DisplayName"]="Panda",["BorderColor"]=k}y["[RPG]"].Shader={["TextureID"]=a.Meshes.Shader.RPG,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.020324707,0.0273060203,0.97354126,1,0,-4.37113883e-8,1.05004345e-14,1,2.40221937e-7,4.37113883e-8,2.40221937e-7,1),["LauncherCFrame"]=CFrame.new(-0.00769042969,-0.0627783537,-1.30299377,1,0,-4.37113883e-8,1.05004396e-14,1,2.4022205e-7,4.37113883e-8,2.4022205e-7,1),["LauncherMesh"]=a.Meshes.Shader.Bear,["DisplayName"]="Arcade",["BorderColor"]=k}y["[Knife]"].Shader={["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.338645697,0.000183105469,0.0258331299,-1,0,0,0,-1,0,0,0,1),["DisplayName"]="Chain",["BorderColor"]=k}y["[Flamethrower]"].Shader={["TextureID"]=a.Meshes.Shader.FT,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.144821167,0.0677314401,-0.00170898438,0,0,1,0,1,0,-1,0,0),["DisplayName"]="Boba",["BorderColor"]=k}y["[Knife]"]["Dual Bayonets"]={["CFrame"]=CFrame.new(-0.520424962,0.0484008789,-0.00109863281,0,1,0,1,0,0,0,0,-1),["Rarity"]="Legendary",["Crate"]=999}y["[Knife]"]["RGB Dual Bayonets"]={["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.520424962,0.0484008789,-0.00109863281,0,1,0,1,0,0,0,0,-1),["BorderColor"]=j}y["[Revolver]"].Military={["TextureID"]=a.Meshes.Military.Rev,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0181350708,-0.10841608,-0.00543212891,0,0,1,1.49010297e-8,1,0,-1,1.49010297e-8,0),["BorderColor"]=g}y["[TacticalShotgun]"].Military={["TextureID"]=a.Meshes.Military.Tact,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.916564941,-0.0996659398,0.128448486,0,0,0.999999642,2.98023224e-8,1.00000012,0,-1.00000012,-2.98023224e-8,0),["BorderColor"]=g}y["[AUG]"].Military={["TextureID"]=a.Meshes.Military.Aug,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.108810425,0.0431235433,0.018737793,0,0,1,0,1.00000012,0,-1.00000012,0,0),["BorderColor"]=g}y["[RPG]"].Military={["TextureID"]=a.Meshes.Military.RPG,["Rarity"]="Exclusive",["BorderColor"]=g,["CFrame"]=CFrame.new(-0.0317993164,0.0230810642,0.252548218,-1,-4.06575815e-20,4.37113883e-8,-3.3601404e-13,1,-7.68710379e-6,-4.37113883e-8,-7.68710379e-6,-1),["LauncherCFrame"]=CFrame.new(0.000793457031,0.00350522995,0.530632019,-1,-2.71050543e-20,4.37113883e-8,-3.3601404e-13,1,-7.68710379e-6,-4.37113883e-8,-7.68710379e-6,-1),["LauncherMesh"]=a.Meshes.Military.Launcher}y["[Double-Barrel SG]"].Military={["TextureID"]=a.Meshes.Military.db,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.547592163,0.0359069705,-0.00466918945,0,0,1,0,1,0,-1,0,0),["BorderColor"]=g}y["[Knife]"].Military={["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0253430605,0.106079102,0.000465393066,0,3.25960725e-9,-1,0,1,3.25960747e-9,1,0,-0),["BorderColor"]=g}y["[Vehicle]"]["Toy Tank"]={["Rarity"]="Exclusive",["BorderColor"]=g}y["[Vehicle]"].Tractor={["Rarity"]="Exclusive",["BorderColor"]=g}y["[Vehicle]"].Cow={["Rarity"]="Exclusive",["BorderColor"]=g}y["[Revolver]"].Ruby={["TextureID"]=a.Meshes.Ruby.rev,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0331878662,-0.0243580937,0.000518798828,0,0,-1,0,1,0,1,0,0),["BorderColor"]=d}y["[Double-Barrel SG]"].Ruby={["TextureID"]=a.Meshes.Ruby.db,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0772705078,-0.0124946237,-0.00723266602,0,0,0.999999642,0,1,0,-1,0,0),["BorderColor"]=d}y["[RPG]"].Ruby={["TextureID"]=a.Meshes.Ruby.RPG,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.00457763672,0.226767719,0.190460205,1,5.82076609e-11,-4.37113883e-8,-5.78716935e-11,1,7.68612699e-6,4.37113883e-8,-7.68612699e-6,1),["LauncherCFrame"]=CFrame.new(0.00180053711,0.000730276108,0.176605225,1,5.82076609e-11,-4.37113883e-8,-5.78716935e-11,1,7.68612699e-6,4.37113883e-8,-7.68612699e-6,1),["LauncherMesh"]=a.Meshes.Ruby.Launcher,["BorderColor"]=d}y["[Flamethrower]"].Ruby={["TextureID"]=a.Meshes.Ruby.ft,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.262329102,0.352797449,-0.00415039062,-1,0,0,0,1,0,0,0,-1),["BorderColor"]=d}y["[Knife]"]["Ruby Fan"]={["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.531107247,-0.00726318359,0.0272521973,0,1,0,-1,0,0,0,0,1),["BorderColor"]=d}y["[Vehicle]"].Beatle={["Rarity"]="Exclusive"}y["[Vehicle]"].TriWheel={["Rarity"]="Exclusive"}y["[Vehicle]"]["TriWheel Red"]={["Rarity"]="Legendary",["Crate"]=999}y["[House]"]["Modern Town"]={["Rarity"]="Exclusive"}y["[Knife]"].Spatula={["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.301204205,0.0112304688,-0.0121459961,0,1,0,0,0,-1,-1,0,0)}y["[House]"]["Pizza Restaurant"]={["Rarity"]="Exclusive"}y["[Vehicle]"]["Delivery Moped"]={["Rarity"]="Exclusive"}y["[Vehicle]"]["Delivery Car"]={["Rarity"]="Exclusive"}y["[Revolver]"].Gothic={["TextureID"]=a.Meshes.gothic.Rev,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0787200928,0.0141905546,-0.00573730469,-1,0,0,0,1,0,0,0,-1),["BorderColor"]=f}y["[Double-Barrel SG]"].Gothic={["TextureID"]=a.Meshes.gothic.db,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.194915771,0.174392939,-0.001953125,0.999998927,0,0,0,1,0,0,0,1),["BorderColor"]=f}y["[Drum-Shotgun]"].Gothic={["TextureID"]=a.Meshes.gothic.Drum,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0383834839,0.183659613,0.00665283203,1,0,0,0,1,0,0,0,1),["BorderColor"]=f}y["[RPG]"].Gothic={["TextureID"]=a.Meshes.gothic.rpg,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0112915039,-0.00845080614,0.563346863,4.37113883e-8,3.97903932e-13,1,-2.4017919e-7,1,4.08402479e-13,-1,2.4017919e-7,4.37113883e-8),["LauncherCFrame"]=CFrame.new(0.0000610351562,0.00457000732,-0.492790222,4.37113883e-8,3.97903932e-13,0.999999642,-2.40179304e-7,1,4.08402343e-13,-1,2.40179304e-7,4.37113741e-8),["LauncherMesh"]=a.Meshes.gothic.Launcher,["BorderColor"]=f}y["[Knife]"].Gothic={["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.140083313,0.0152206421,0.00164794922,0,1,0,1,0,0,0,0,-1),["BorderColor"]=f}y["[House]"]["Garage Home"]={["Rarity"]="Exclusive"}y["[Vehicle]"]["Muscle B"]={["Rarity"]="Exclusive"}y["[Vehicle]"]["Muscle B [Black]"]={["Rarity"]="Legendary",["Crate"]=1}y["[Vehicle]"]["Muscle C"]={["Rarity"]="Exclusive"}y["[Vehicle]"]["Muscle C [Black]"]={["Rarity"]="Legendary",["Crate"]=1}y["[Vehicle]"]["Muscle C [Purple]"]={["Rarity"]="Legendary",["Crate"]=1}y["[Vehicle]"]["SUV [Black]"]={["DisplayName"]="PogiMobile [SUV]",["Rarity"]="Exclusive"}y["[Vehicle]"].Police={["Rarity"]="Exclusive"}y["[Vehicle]"].Sedan={["Rarity"]="Exclusive"}y["[Vehicle]"]["GT Kart"]={["Rarity"]="Legendary",["Crate"]=1}y["[Vehicle]"]["Supe Kart"]={["Rarity"]="Legendary",["Crate"]=1}y["[Vehicle]"].McMelon={["Rarity"]="Legendary",["Crate"]=1}y["[Knife]"]["Blue Dagger"]={["DisplayName"]="Blue Blaze",["BorderColor"]=j,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.672592163,-0.0405571461,-0.129821777,5.96044032e-8,0.999998093,-3.97903607e-13,-0.999990463,-5.96044032e-8,9.94756171e-14,-9.94756171e-14,-3.97903607e-13,1)}y["[Knife]"]["Purple Dagger"]={["DisplayName"]="Purple Blaze",["BorderColor"]=e,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.680389404,-0.0405454636,-0.0369262695,5.96057674e-8,0.999998093,1.19371158e-12,0.999990463,-1.78813664e-7,-2.98427868e-13,-9.94784563e-14,3.97905884e-13,-1)}y["[Knife]"]["Green Dagger"]={["DisplayName"]="Green Blaze",["BorderColor"]=s,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.0952148438,-0.0405509472,-0.0215454102,5.96057674e-8,0.999998093,1.19371158e-12,0.999990463,-1.78813664e-7,-2.98427868e-13,-9.94784563e-14,3.97905884e-13,-1)}y["[Knife]"]["Red Dagger"]={["DisplayName"]="Red Blaze",["BorderColor"]=l,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.105102539,-0.0555841923,-0.0150146484,-5.96057674e-8,0.999998093,-1.19371158e-12,-0.999990463,-1.78813664e-7,2.98427868e-13,9.94784563e-14,3.97905884e-13,1)}y["[Knife]"]["Penguin Ice Cream"]={["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0781555176,0.0322579145,-0.172119141,-8.67361738e-19,1,4.18487431e-8,1.86264515e-9,-4.55740334e-8,1,1,-8.22861671e-17,1.86264515e-9),["BorderColor"]=h}y["[Revolver]"].Penguin={["TextureID"]=a.Meshes.Penguin.rev,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.202697754,0.0907911062,0.0120239258,2.46913861e-12,-3.7252903e-8,1,2.98028908e-8,1.00000191,-3.7252903e-8,-1,-2.98028908e-8,-2.46916289e-12),["BorderColor"]=h}y["[Double-Barrel SG]"].Penguin={["TextureID"]=a.Meshes.Penguin.db,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.00805664062,0.10456717,-0.0380859375,-2.87964097e-16,-9.31328259e-9,-0.99999994,9.31322686e-10,1.00000036,8.38193159e-9,1,1.86264537e-9,2.90566156e-16),["BorderColor"]=h}y["[RPG]"].Penguin={["TextureID"]=a.Meshes.Penguin.rpg,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0556030273,0.0265565515,1.0914917,1,5.58498714e-9,-4.37113989e-8,5.5850089e-9,1.0000031,4.9060327e-7,4.37113918e-8,4.90604634e-7,1.00000024),["LauncherCFrame"]=CFrame.new(-0.00408935547,-0.00542700291,0.0866088867,1,-4.37113883e-8,-9.28367105e-10,9.283877e-10,4.82221196e-7,-1.0000006,4.37113883e-8,1,-4.82221481e-7),["LauncherMesh"]=a.Meshes.Penguin.Launcher,["BorderColor"]=h}y["[Flamethrower]"].Penguin={["TextureID"]=a.Meshes.Penguin.FT,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.146240234,0.487559378,-0.0191040039,-1,0,0,0,1,0,0,0,-1),["BorderColor"]=h}y["[Knife]"].Metal={["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.273397565,0.00601196289,0.00988769531,0,1,0,-0.999998927,0,0,0,0,1)}y["[Revolver]"].Metal={["TextureID"]=a.Meshes.Metal.rev,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.0964050293,-0.0217685103,-0.000549316406,1,0,-1.50995803e-7,0,0.999999642,0,1.50995803e-7,0,1)}y["[Double-Barrel SG]"].Metal={["TextureID"]=a.Meshes.Metal.db,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.125686646,-0.135336846,0.00628662109,0,0,-1,0,0.999998212,0,1,0,0)}y["[Flamethrower]"].Metal={["TextureID"]=a.Meshes.Metal.ft,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.14163208,0.573509276,0.024230957,0,0,-1,0,0.999999046,0,1,0,0)}y["[Rifle]"].Metal={["TextureID"]=a.Meshes.Metal.rifle,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(0.285713196,0.0110580921,-0.000793457031,2.01746307e-17,-2.32830588e-10,1.00000024,-3.18550298e-17,0.999999523,-2.32830644e-10,-1,3.18550232e-17,-2.01746307e-17)}y["[RPG]"].Metal={["TextureID"]=a.Meshes.Metal.rpg,["Rarity"]="Exclusive",["CFrame"]=CFrame.new(-0.00189208984,0.109036505,0.657577515,-1,8.88178314e-16,4.37113741e-8,-9.08680958e-16,0.999999881,-4.69042416e-10,-4.37113883e-8,4.69042527e-10,-0.999999642),["LauncherCFrame"]=CFrame.new(-0.00189208984,-0.000738143921,-0.14730072,-1,8.8817842e-16,4.37113812e-8,-9.0868604e-16,0.999999881,-4.69157047e-10,-4.37113883e-8,4.69157102e-10,-0.999999821),["LauncherMesh"]=a.Meshes.Metal.launcher}y["[Revolver]"]["Iced Out"]={["TextureID"]=a.Meshes.IcedOut.rev,["Rarity"]="Legendary",["Crate"]=1,["CFrame"]=CFrame.new(-0.0419578552,-0.0496253371,-0.0009765625,0,0,-1,0,1,0,1,0,0)}y["[Double-Barrel SG]"]["Iced Out"]={["TextureID"]=a.Meshes.IcedOut.db,["Rarity"]="Legendary",["Crate"]=1,["CFrame"]=CFrame.new(-0.0154724121,-0.0110113621,-0.00543212891,0,0,1.00000036,0,1.00000036,0,-1,0,0)}y["[Knife]"]["Iced Out"]={["Rarity"]="Legendary",["Crate"]=1,["CFrame"]=CFrame.new(-1.58911133,0.185030937,-0.00385284424,-1.00000036,0,0,0,0.999999881,0,0,0,-1)}return y end)

LPH_NO_VIRTUALIZE(function()
	local exec = identifyexecutor()
	
	if is_solara then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/solara_drawing.lua"))()
		getgenv().gethiddenproperty = function() return false end
		getgenv().setfflag = function() end
		getgenv().fireclickdetector = function(part) if auto then return end auto = true local cd = part:FindFirstChild("ClickDetector") or part local oldParent = cd.Parent local p = Instance.new("Part") p.Transparency = 1 p.Size = Vector3.new(30,30,30) p.Anchored = true p.CanCollide = false p.Parent = workspace cd.Parent = p cd.MaxActivationDistance = math.huge local conn conn = game["Run Service"].Heartbeat:Connect(function() p.CFrame = workspace.Camera.CFrame *CFrame.new(0,0,-20) * CFrame.new(workspace.Camera.CFrame.LookVector.X,workspace.Camera.CFrame.LookVector.Y,workspace.Camera.CFrame.LookVector.Z) game:GetService("VirtualUser"):ClickButton1(Vector2.new(20,20), workspace:FindFirstChildOfClass("Camera").CFrame) end) cd.MouseClick:Once(function() conn:Disconnect() cd.Parent = oldParent p:Destroy() auto = false end) end
	else
		if string.find(exec, "macsploit") or string.find(exec, "Rebel") then
			local old = getconnections
			local old_connections = {}
			getgenv().getconnections = function(...)
				local old = old(...)
				local new = {}
				for i = 1, #old do
					local connection = old[i]
					local func = connection.Function
					if not old_connections[func] then
						new[#new+1] = connection
						old_connections[func] = 1
					end
				end
				return new
			end
		else
			loadstring(game:HttpGet(string.find(exec, "Syn") and "https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/solara_drawing.lua" or "https://raw.githubusercontent.com/jujudotlol/jujudotlol.github.io/main/wave_drawing.lua"))()
		end
	end
end)()

--[[
                     _         _      _            
                    (_)       | |    | |           
 __   __ __ _  _ __  _   __ _ | |__  | |  ___  ___ 
 \ \ / // _` || '__|| | / _` || '_ \ | | / _ \/ __|
  \ V /| (_| || |   | || (_| || |_) || ||  __/\__ \
   \_/  \__,_||_|   |_| \__,_||_.__/ |_| \___||___/
                                                   
]]

local uis = cloneref(game:GetService("UserInputService"))
	local getMouseLocation = uis.GetMouseLocation
	local getFocusedTextBox = uis.getFocusedTextBox
local tws = cloneref(game:GetService("TweenService"))
	local getValue = tws.GetValue
local plrs = cloneref(game:GetService("Players"))
local ts = cloneref(game:GetService("TextService"))
local hs = cloneref(game:GetService("HttpService"))
local cg = cloneref(gethui and gethui() or game:GetService("CoreGui"))
local rs = cloneref(game:GetService("RunService"))
	local render_stepped = rs.RenderStepped
local lighting = game:GetService("Lighting")
local tps = cloneref(game:GetService("TeleportService"))
local reps = cloneref(game:GetService("ReplicatedStorage"))
	local event = reps.MainEvent
		local fire_server = event.FireServer
local is = cloneref(game:GetService("InsertService"))
local workspace = workspace
	local ignored_folder = workspace:WaitForChild("Ignored")

local arg = nil
local clamp = math.clamp
local floor = math.floor
local udim2new = UDim2.new
local vector2new = Vector2.new
local colorfromrgb = Color3.fromRGB
local vector3new = Vector3.new
local cframenew = CFrame.new
local abs = math.abs
local tostring = tostring
local sub = string.sub
local gsub = string.gsub
local newtweeninfo = TweenInfo.new
	local wait = task.wait
	local spawn = task.spawn
	local defer = task.defer
local angles = CFrame.Angles
local rad = math.rad
local lower = string.lower
local mathrandom = math.random
local clock = os.clock
local delay = task.delay
local destroy = workspace.Destroy
local findfirstchild = workspace.FindFirstChild
local findfirstchildofclass = workspace.FindFirstChildOfClass
local vehicles = workspace.Vehicles
	local small_font = 3
	local normal_font = 2

local raycast_params = RaycastParams.new()
raycast_params.FilterType = Enum.RaycastFilterType.Exclude
raycast_params.FilterDescendantsInstances = {ignored_folder, vehicles}

local getconnections = is_solara and function(...) return {} end or getconnections
getgenv().hookmetamethod = is_solara and function(...) return {} end or hookmetamethod
local sethiddenproperty = is_solara and function(...) return {} end or sethiddenproperty

local lplr = plrs.LocalPlayer
	local lplr_gui = lplr.PlayerGui
	local mouse = lplr:GetMouse()
	local char = lplr.Character
	local lplr_parts = {}
	local lplr_data = {
		viewing = nil,
		tool = nil,
		accessories = {},
		equipped_accessories = {},
		flashbang_connection = nil,
		landed_connection = nil,
		spoof = false,
		force_cframe = nil,
		skin_changer_cache = {},
		whitelisted = {},
		ragebot = {},
		aim_viewing = {},
		money = 0,
		last_bought_high_medium = clock()-30,
		last_bought_medium = clock()-30,
		guns = {}
	}
	local lplr_pos = cframenew()
	local ping = 50

local player_data = {}
	local camera = workspace.CurrentCamera
		local wtvp = camera.WorldToViewportPoint
		local vptr = camera.ViewportPointToRay
		local raycast = workspace.Raycast

local heartbeat_callbacks = {}
local anti_callbacks = {}

--[[
         _    _  _  _  _          
        | |  (_)| |(_)| |         
  _   _ | |_  _ | | _ | |_  _   _ 
 | | | || __|| || || || __|| | | |
 | |_| || |_ | || || || |_ | |_| |
  \__,_| \__||_||_||_| \__| \__, |
                             __/ |
                            |___/ 
]]

local images = {
	["indicator_gradient"] = "iVBORw0KGgoAAAANSUhEUgAAAGkAAAAhCAYAAADaiYU7AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAACySURBVGhD7dFBCsMwDABBtbSP8v8P+Yu/kBwahRqMiO9Z2AEjozinffXeY9u2T0R8zzNmqrs6V+/S6p8x6264e1vnfE/z9+o4z/6fadxzzvfVHOr+7u0802pX96t31661dryvlR7NSABGAjASgJEAjARgJAAjARgJwEgARgIwEoCRAIwEYCQAIwEYCcBIAEYCMBKAkQCMBGAkACMBGAnASABGAjASgJEAjARgJAAjPV7ED23xMgBp5elFAAAAAElFTkSuQmCC",
	["upward_gradient"] = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAEACAQAAADYN9QTAAAAdElEQVQoz5VSQQ7AIAgr3b/2/1+xE8xZGFtiTG0QbSn8JCwWApBwgsGgwesVLbOqPsmNsXhRe1pzLDH+F7Ni/MO7qfRoPmDihhqSPufuz0qbptCpSH5jdIKMiXAS8hKAsk8ZiXFAnXUqIS3yReyapTJXN7gAfRcL/BkMYYIAAAAASUVORK5CYII=",
	["glock"] = "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",
	["shotgun"] = "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",
	["drumshotgun"] = "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",
	["drumgun"] = "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",
	["doublebarrelsg"] = "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",
	["knife"] = "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",
	["rifle"] = "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",
	["revolver"] = "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",
	["silencerar"] = "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",
	["p90"] = "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",
	["tacticalshotgun"] = "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",
	["lmg"] = "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",
	["silencer"] = "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",
	["rpg"] = "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",
	["ar"] = "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",
	["smg"] = "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",
	["flamethrower"] = "iVBORw0KGgoAAAANSUhEUgAAAQAAAACACAYAAADktbcKAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAACjbSURBVHhe7Z0HWBXX1oYHu1IVLKixoKgYxQaCRqPGrvFasMSKJRosN3qN8VoTxSi/2BKNBaPYS2IXGxqJFTHGShB7QcSKIoIo9f++yRwv4sA5wAGBs9/nWc/sWTNnzpS91167GyUlJUkCgcAwyadsBQKBASIMgEBgwAgDIBAYMMIACAQGjDAAAoEBIwyAQGDACAMgEBgwwgAIBAaMMAACgQEjDIBAYMAIAyAQGDDCAAgEBowwAAKBASMMQA7ByMioCMRc2RUIsgUxHDibQSLPj00piA2kWp8+fexsbGzsKlasWMXMzMz01q1bFyZOnLgRx/bi20RiKxBkGcIAZCFI7CWwqQyp2qVLFzt7e3s7a2vrqmXLlq1UunTpEsWLF5coxsbGUpEiRaR8+fJJMTEx0r1796QLFy7c8fPz2+rl5bUN3yhAvqBAoGeEAdAzSPTGVlZW/SZNmtQLOXsNJPTSJUqUyGdubi6ZmppKhQsXlvLnpxOgnWfPnknXr19PPHPmjP/y5ctXBwYGHsD3uq8cFggyjTAAeoIJv2rVqv2R8P/TpEmTapUqVZIKFiyoHM0ccXFxUlhYmAQDELlp06ZxGzZs+EU5JBBkDhoAIRkXYOHo6Oi2bt26qzdv3kxKSEiAOuu4cuVKUt++fYchqHo/QoSkR1SVQrQLKIec3mPjxo2hd+7cSUpMTIQ6ewgODk764osvhBEQkmkRRYB0Ale/XPv27UcNGDBgWOPGjUtUqFBBOZK9wBOQpk6d+tWWLVuWKyqBIN0IA6AjTPjdunUb1adPn2HOzs4lypUrpxz5cFy+fFmaMGHCV7t37xZGwABBnLTGpgrkDtJxqKJr9e2333avU6fORwULFjRCRhH8/fffL8XxGzz+HjQAQlIXUK5fv34eO3fuDA8LC4MqZxEYGJjUoUMHURzI4wKMIEUhlpBKrVq1Grt9+/Ynf//9d9KBAweet2zZctiQIUM8//zzz6QXL17IdVGUyMjIpIMHDz7Cb5zUris8gFSAJa07ePBgV+T6/R0cHCxLly6tHMl5BAUFJU2cOHGyj4/PInzPKEUtyKUg7tm5uLi0L1++/Efm5ubWJiYmJczMzMyNjY3NixYtaoF9k+rVqxuzpUlDcHCw3JekcmV2O3kXGAJpzZo1l2EgHBE/XilqGWEAUoCXXw8JfxwSfo+GDRsWLFmypHIkZxMSEiL5+/sHzZ8/f+aZM2d+Q+To4ebm1hkRpwgOGxcqVCgOEnPx4sXb8+bN88R3f/LPLwXZDeIYe4KWhRhDCkBiIM/wTW7gWMO9oH79+lZM0Phmcr+RAgUKyB3FcBynph9kElKtWrXa4D8OKSoZYQAU+FGGDx8+v3Pnzr0cHR0LlCjBTny5C37LGzduSPAE/oZLWAMUYKQhjDiU58+fS3v27AkYNGjQv9JjBPBbXojCzg21+vfvX9/KyooRuBgiamKxYsVijh8//gju5g5cNwbnm+FYIiQa+0nYZ++nYhBG+FdQvVGuWRhCIxUD3Wts+V88h9eO5bUUHf+XvydR0CdAR5eYOosqVap80rZt20pIKCVh9ErifiwKFy78+tq1a8e9vLz24RzeCyM7t9qEaJ5Xm/C5KKaQcMgLZZ/Pz+fg/fE++TxFe/fu7dSrV68BZcqUKc7nTExMlGJj+ZhJMYcPH/69YsWKHyMDqoJjOF1/3L9/X8L/Djtx4sQ7fUiEAQCMSCtWrPDt0qVLU0tLFrFyN+w4lFYnpOjoaGnVqlWXjh07dhgRMRo5jJyI8Jv8MBhFsF8IUhhhbgtSEKYUMDU1NbG3t7epVq1afuZKhEaG8uTJEwlGIBAuZxSkHN5rHLZPkYsxYZsgXALnMbE/w7FnCBdFAjBBHDTHfgS2EbgHpgZTnFsSWxqKcOgScJ4ZxJL/Ax5DXvEc6CyQ2E2cnZ2NabR5nPdFYSLiPfn6+r7BO0mELomC55EF102Kj49PwrG3OuU4r2OErSw4xwjnvN1Pfgxhgr8yKoT7iUH4NfT5cN98f/mhlz8EwvL9wK2XUqtApnHGf0lZ4XU+ffpUGj9+/Chvb+/FikpGGACAD+McGBh4Ci6Sosn7cMzBq1ev3iZeRk7NNi1B5Ja3qcEcjXGK19Lsk+TX0JyTXMd9TVxMruO5yc8jyf9DoxOkDbuVT548eezSpUsXKCqZf76SQHr9WvY+DYaiRYtK9HY4GInjFOA2SyYmJvLAJOSo8nGWQTl2geVQehSaXDUtmCg1RoLCMCV5YtWck1zHLfdT6lKeRzS/T64TpA3fFb5hIWX3LcIA/MPtBw8ePFPCAkGegwYABlwYgFQwDw0NZcWSsisQ5C1oAODJvRfBDdYA4IVYQwa5u7vv3r9//59dunSpwJckEORV4AHEKsG3GJQBQAK3gHSaMGGC9/bt2y9evXrV+9tvv+3Url07c2tr9qoUCPImCQkJUkRExHsGIM+3AiDBs525wZdfftmjefPmLvb29h+xBxUn5xAIDIXHjx9Lo0ePHrFp06alikomzxoAJPyaLi4uvdu2bdutXr16NW1sbKTc2LlHINAH7Cnapk2bIVeuXPFWVDJ5ygAg0deoU6dOp0GDBnVu0KCBg62tbWF2qmCzkUBgyChdgT9Het+rqGRyvQFAoi+PTavp06e7ODk5tbKzsyvC8jzbrQUCwT+cOnUqvnHjxg5I7xcVlUyuNABI9BbYNBk/fnxfZ2fndrBsFuxiyc4rgpyBJl6pbSn4hrJo9pMfSykaD07tGHsF8ruzw5IaPM4utpreg5ot/5udibif/JhGn/xcbjWdj7iv0Wn07CCV/FxuiUavEXaoKlu2rPwfKXnz5o0UFRUld87KCnbs2HG3W7du9ri3d6aazzUGAC+N/dXrDxkyxLVFixbt4OqXr1ixoqjMyyC3b9+mcEAOJzFMTEhIkOc0Q0SVURJUvvj4+Hw4xv7w+eLi4vIhUudzdHQsYmFh8U6Epzx48EA6ffp0NM6PQsJ4Ad0b9rXntQnCb7ccQIQEIYd5DvXsr49zE6hLvjUxMUnkfcbGxvJcqhIZhu5ldHR0pL29fbu2bdvWY29GXOZtAsS50rlz5+54eXn5IfHyekn8HQVGI8HY2FgOU5AAZcHzJeLZZF1MTAz/Mwn/wcFO1Ce8fv2aevncFy9eJOI/E0uVKpVIPc979epVIgxOAjzQuMqVK1sgURu/fPnS5ObNm8VwjyVdXV3r4nxjPENhPC8HU7BmPvb69ev3IiMjK06cOLGSvr1XdvueO3fu9qlTp7ooqrfkOAOAj1ocG4cOHTo4Nm3atAY+lNWjR4/M8TJL1qtXz1ZU5mUejgybNWvWL0uWLJmjqBKSSbyyJRzVxkiqGfEm7w8YMKDrRx995ICIxYjMkX9PkXBC9+3bd+ny5cvncQ5zGY7i47UYwd4Rgq3ewP9bIF60Q8ZQCgmzGO6rAP7iVXh4eNTRo0e5wEqOmUod98reeLSumvcpv2/cY1SPHj2mLlq0yL1MmTJQ6Q8YH6l+/fqDYbBWKaq35AgDgJfCUTgNJk+e3LRhw4ZtK1WqVB5WUu6frnGj6D6JyjzduHXrlnTnzp14Ozu7Asyp6boSDv65ceNG4saNG+eDb2WlIMeAdFDS29t7R6NGjT6BdyDx23EiGsZ/FhGYk9Mz4/gNXWH63rBhQyiHbyP83vDvD2oA8MDlGzdu3Pv777//tnr16iWZswuXPuNERERIu3fvDvntt9/c9+7de6579+5d6tatSy/KHN/51d27d28jh+F4/RPKTwQ5DKQJziPADNGya9euDZ2dnesh8b95+vTpvQsXLkQhJ6//9ddft1eb+UeNS5cuSZ9++mkvxI3fFNU76N0A4AE48YE9JBTXvicrU4BzyvXs2XNUr169hiLHt2QFniDznD9/nq5eZ7z33YoqS8F3ZPGABVa6ZqzZ4ja5yEUGlW3KYoVGUp7Da2vC8r61tXVB5IAFUX4vCMNWEDlioSJFiuSHJKCcHgtdHI5x9qOETZs2hcET2oP3oZnkI08wcODAEW5ubotQDGP9jJzLa+o+kteBPHjwIHL16tXj4FWkupCMXg0AIkTJVatW7UBu/klUVNRzf3//X6dNmzYX/3FTOW7Zvn37cUOHDpWn1M7J8+zlRvz8/GJbtmxZD+/7sqLSO/iGpacCfOPqiHyssi6KIgYnEimQYqtsoCjAiYn+h6LnhBryPuDEGnIRD9eXt6mJ5njKbcowhZWS69at85o5c6bbP3efd8CzOtEbiI2NNXv58mV+eAiR0dHRnI2I8hLCuf8eIC6EYJs6NAD6EGC1b9++gNevX2P3H+B2JO3YseMBjn0K6b127dqb9+7dU44K9A1cf77rEgiqfqPMCjDz8vI69ezZM3nGWeQ2UOdsHj58mPTjjz+uxL1z5iHV5zJkUVWmV4DV5s2b30n8GhhRjh07FsfpixnODTBic2plLvV1/PjxGE61/OoVZ6fKucTFxSUtXLjwHL5FfuyqfqfMypw5c1Yx8ec2eM8wXP54N5xmTPXZcrMA1htUhTSBVFY7JzXJdBEArojVL7/84tO7d29nziaTG2F7MRK8PGAiLCzsNcqNN4KCgv5csGDBURzm0txVZ82a9d927dp9+vHHH8stEjkN1vDD1d0F6aKo9Mrw4cMXTJkyZUxOWBAlI3AexL179wb36tXLFXH+jKLOUSAtaSZIZZ8XtnUXxL1ewPYtOIdthC379OljV7ly5Spcar5UqVJlrUDx4sWLRUZGRvn4+Hzj6emp02IxmTYArq6uHsgZJrDZLrfAJhX2Dnv06JEUGhr64vbt28EXLlzwX7lyJRN7IOQW3sv7QyeNjDoil/2mdevWn3JSTJYzcwrh4eHSuHHj5q9ateobRaU3Pv/8869gDJfZ2toqmtwJm9ZgBJ527dqVfeJPK+osI0WCZi7NHqysNynl6OhYCgnYytra2srExKSkubn527n/sTWGjr8pAM95z+jRo4fifp8gzvWeB2rWrGnNJnJO3cZp2/Irzbwa2O4/bdq0r9atW6fVCGTKAOABS8ydO/cEbtCO7fU5FbafclZUlgdDQkIe3rp1629/f/8TO3fuZE4QhHeQdkVJMvDM/IjTkSD+3b9/f6OcMovw3bt3pY4dO45AhHlnuGdmwfO2P3369L6GDRsqmtwNvb3Dhw8/hTfXCd+dBl8n8B6Yyt5OQ66IOaQEErIlEiUXj7G0sLBAlLC0RG5sgcRshkRqjsRsXLRo0SLYx+Z/cy1qRDPfIhNyykyFk3kija3z8PBYERAQcNjJyUmnhIZvJjk7O7fGM/6uqFTJsAHAC2m8fv36JR06dKiTno4J2Q3bxufPnx/066+/Lr127RoT/A08c7rn/8Pz1hk8ePDANm3adIMlLgePJz8TPz9mTgAejFSvXr1WeLbDiirT4JnrIbH4fvbZZ7ljdRQdYZxHAolwcXEZjyIfm0z5Ea0gcg5dq1atkijqsV+KFaSkqakpc2nmzMUR5uo8RZmYkbiNWOxlImY8YNGQiZlbJmgmZrxDXDJznDhxIgGGPcbNzc1EUWmFXu6yZcv+QOb8maJShy8jPQKMkNOMO3LkCDyqOKhyNngRST/99NMRBFWfR5uAIig3/rB///7YJ0+eQJUzOXToEJcES1cFUFoCrLZt23aBfeHzKhcvXkzatWvXc8TlF3/++Wc8jGjS1atXk+BNJaF4mIRiIscByHGI4wg+FKxcZ4taejl79iw/JL0A1W9MUVWmJqDCzJkzD6HMjN0PQ0aanuA68eYbIaj6XKkJqLFo0SL/3NB0uXr16mu4X7pizM2YU2jKnKxMYu7GThesweN65jYQFujtIHUg9O/ZVNsW0hXSZ/HixacY+QW5FxoweA3eCKrGb4rWIgBcmBbskoht2X79+nVv3bp1WbhDytHsg0Mlz58//wKWsECnTp3S1dzActSkSZPmwyXSuYIMz+vk4+Ozp1WrVvIabTkZfsODBw++vH//fgjcT67mwwpKuUMOnkPeAqjedsJ5uwXyuTjvbWccHJNQzJHXCxDkXhgvkDFcRtGVncPeq9SW4UlqAowGDhw4g7kn3aGnT59+kHb8mJiYJJTXktzd3dfgniqULVv23xnxQDZu3MiKPvaJV33e5AKc4FI/yQ0dXZKT2+5XkPUcPnyYIzNTLRqqKik//vjjwpCQEAQ/HDdu3EhasGDBfjzAp9iV7wsUXrNmDdefk8/RleDgYP64C4LvPWtyAU579+59ou36PB4aGpp08uTJeOS+L8LCwpQjAkHO4cKFC3GI0/QA1OO7qlKSjI8ePXoH4Q8Ce+EhEd53cHD4Crvv3R/c1EHXrl1DUHfYk++7777bheB719MIcN65c+fjtCp8eIzGZOXKleeaN2/OIbUNIGX79u078fjx44/psWQ1zOnZu00YHYE2kE44EMoJQfU4r6qUJIsDBw5wNF+WwdrllN1KmbjYZXjGjBl098tAldr9FVm0aNGl9LZC+Pr6coBEdQTVrll+69at99Oq9WbtsLe391mc2wdSCKrkv286fPjwP+m16APWPNOY0HCxMo7y4MEDVmgmrlu37nyHDh12w0gqZwsE6rA7O+LmWw86pahWAhoZGZXYtm1bcLdu3bKkex+7ZaKMfXHfvn3Bbdq0cUSOboJcLf758+chkydPnv/48eOtyqmpgnvsAGOxl11zdQUuu9SzZ8//+vv7eyoqGVzLihV+uBcntW6+kZGRbIsN8/DwmIHtCrwzzuLC37FTSFtPT88xzZo1+5SrC7N3VkZhd947d+6wTT/0ypUrj/BOuGJpDLasjo+GNb+4fft2P4T/wn/3vXXr1npdx4ULDBNO/WZjY9MCceaIonoXGoCUAszhCmdJBQASd9LPP//Mm5EHZgDW6LOpilXOXFdd9Z7UZN68eQfT43LTw1i6dClnRWUfa/kawGrXrl0BqV0nKCgoafr06e94JIDNIG54jiuXLl2S22kzCr0Yehb79+9/PmXKlG24bicIm/PSfBeTJk3yfvnyJYICQerQI0VcaoygajxSV0pS0R07dtxEWK/QHRk/fvxiXJ9ztqn+d3oEtD537hyCusORffid/EKAFZ5TdRRjVFQU6yHu4pwe2NX8X/kmTZq4r1mz5gY7jGSmcwgT/unTpxNQlDnp5OQ0Btf+COr3nlFNQL5ly5ad0fb/rCsIDAyUW3C0wUrNjHQ2EeRskIFxfkdOB64el9SUlJEjR86FO4qgfkBkT0SRwg1B1f/LqPzwww+H0tNhhfUOKKvPxksx2bJlyym1nJ858pw5c3xwjhV2meDK9erVywPnh/MYE1ZmOXnyJN17DkpRfa60BBTfunWr1hpA1megyJN06tQpRZM6PJeVm4Ksh4abGUB29KQNCAh4g/hSC0H1uKSm1Ii7u/vy8PBwBDMOc1fkpA9xE2l2ScyoACdE8HT54GvXrn24fPny8ykTP3NBvLD4L774Qm594Itzc3NbsW/fvnBWwOkDvs+jR48mDho0iCO8VJ9Jm4Cqv//+u1arxwj25Zdf0tgomtThufRqBLrBeM0iGCUyMlLnPjJXrlxh5hK4ZMmSfci8ArO6V62Pj0844kvqFepqSo2AIitWrLim68OlhF0Rkdg4EUMV7Kr+hz6E5eH0uK+8L7r4yeH+zp07g3GvrSH1p06dus7Pzy8uswaQsEafZbFt27aFIkGyCOQIteqz6CLAwd/fX+tHYU4DA8YJWRRN6tAAMHIKdAPFwKh//etfZzp37hzdr1+/JF3HidAY4/vNgnzCbXqLsOmBnqq3tzeHt7/TYpVcVJXJBbnhhPv37yOYPugqz549O1umYgK1Dh8+nOGauMePHyd6enruwXWGzpw58wBdZlr1zELjgQ+ewCHTBQsW7Ivr69QTUZuAZrrk6jQA//73v5P++OMPRZM6PJdFAH0UbwyBsLCwxJs3b8beunUrkR3mdB00RUNx5MiRpBMnTshFs6ysd6F3Mn78+N8QVI1HFFVlcgH5Fi1atC89CYI143BxpyCoes2sEET0hRnJrdnvoEePHs9gAE7hvrnqi3IkY2hy+y1btoQNHTqUuX2qnTAyKqCxLrk6Pbf//Oc/CSguaE3VTPgpvSJB7oaGycHBYQyCqvGIoqpMKaAM3GOtNYJ0I1G+fWJiYuKCXdVrZZWAUgcOHHiIsM5wuOTSpUtl11dbjbo2WLlIt3zhwoUHLCwsBuJ+smz+OVAb7/kNwmnCZ0JR5i68o+eKSmBAID6yF2CaxU1d57RKKlSoUJo9XBDZuCjF7WbNmrWG68H27GwFD/N448aNSznNly7w4bm24LBhw6Tq1au/N62SLsDgyavwcObjiRMnLmkM4Im0e/78+Wpc/71VWPTIs+joaC69pZXChQuzswBrggUGBOM3MrarCLIOIFV0MgC1a9fuamdnl+asMJxQ87vvvluDP35nEsPsZO3atctQrtLJAhgZGckrsXL4a3pBApcCAgJiFy9efMLJyWlot27d6ixbtmwknj3L55lTiMQ9PFfCqaI8mxWKJblztlZBhomIiOCS4KwoYnNz6tBSaBO4tSe1VXIgQbDDgd7Lu+mVzz///PusmMCDZXt2ZNq+ffvtESNGsB9BbahV7yE75McffzyqS8UTmy/Z6iEwLP766y+WFbU2vWvN/pBTVucKJNqWLIZLSgOgPulANrJnz56lJ0+eDFV2M42S2ycih/etUqVKb+b2yPn/i5eXpmuV1dy5c+cixw5ogyvNcpFJgeGQmJgonTlzhk3anNY+bVJahJQCmrI7qTbYSuDh4eGLoOp1slMaNmw4JjMdLJizKu32YW5ubllSk59ZKV269MBbtzh7uSA3wQ5EbG1hE11mxpCkBZvgmzVr9h2CqnEnuagqkwsovXv3bp0GnjPR9e3b9xsEVa+VXQKKrl69+u/0dmBiTT7KTW/mzZt33MTE5EtcJ8euJAPqs48BwoIPgK+vb5KnpyczPU4sqmjThgn+//7v/yK+/PLLgz179jy4Zs2aLOkEoCzHl2rvv+SitQiAkx5t2LBhMRda1EalSpWk0aNHz0WxoZ2i+iDgnmMGDhw47/r164omdZDbywspILd/OGnSpJ8bNWrkMHbs2Kaw0Bz2m5U1+ZklCB4AO+8ru4LshEWrunXrSk5OTlLVqlyVSzv8VigqR0dERHAJt3NIJ+zO/c9BPXH//n1p8+bNy3Bddr/XDm9Am4Ciq1atCmQ7vzaY6/7222+cobYUdlWvlx0CCs2fP/8I5zNk5x66Xczhuc8OEvRW/P394xYsWHDc0tJyCM7PdevGjRw58idRwZe7YDzkN2MPQH0XAdiZC2mPTX8W2FWNMylF54VBYK3anj59ej/K11pXOkDuKXl5eR0cN24cp5n+YOCeS8PdmmJtbW0L4xUVHh7++MWLF89RRnoBI8ABPufx/LTGuRI8X6tLly4dql27tqIRGDLXrl2T2rdvPwge7WpFpZ3k1kCbDBgwYKyuFU8cP+Du7r4Lf9EUu6rXE5I5AYXWr19/WfTfF9CzmD179gHECTlT11VUlWnJ9OnTvVPO5ZcavCm42UnTpk2jIXCGSvWaQjIuvXr1+o5rHgoyBmvjWSxknGZLFudgZCsQi7K5ybDu2bOH9VXVEFSNJ6lJutcGhNtpunbt2kM9e/Z04ppouhAdHS0FBgYmHD582GfKlCk/4j+1t08KdALfw3zLli37mzdv3ojzGbINWCPs3szFPbT1duS57NLMBVTfvHkTicRghKKeaW5dClwX2I37ypUr0oEDB87/8ccfvhUqVODinaXxvizMzMxMixUrxpU8TfBOTbAtgv3CkEJFihQpwPdMYfzXhJMv8KkRfBvl37KWc+fOSQ0aNOiJdLVFUelMug0AwYNV27179/GOHTuWSk9XWnZcCQ4Olvz8/PaMHz9+rjAE+gHfo+TgwYNHm5qalsM7fRofH/86PDy8iJWVVZuZM2faa1vhJyYmRho1atRtb29vVobKTSc//PDDijFjxrTl4pd5Dbb8IMcMcXFxGYVdrhv58p8j/wPvlKvwcoZYzRLfnAeSwhfCZdfMK1asaF6jRg0La2tr8+LFi3Np7+IwFhYmJiamCONzmJrAYFBgKwoXgjBgxJWmaDxoNFIKDQfTlK4GhEZswoQJX+3cuVPrUuBqZMgAENyc86FDh3xatmxppcuNJuf169fS1atXpWPHju35+uuvhSHIImAUJs+dO/eHEiU452rqINeXPDw8/FFU4yQVMvim5X18fE7ByJdP7/fNyfBZfX19T3fu3Lkv4t1NRa138M7YdZbGg0aEA+loPEwh8nqNNBb29vamlpaWZhBTGBAzfCcaETMYCHofxvA4TLGlN1IY28L0PmAk8iEsG5D79++/9vLyGr169eoMJX4ZGoCMCnA+cuRIhpfQYv/6oKCgxJ9//vkErsW59t/O1isk8wI+DggIuK9tqDO/g6enJ2cNSfn7dmfOnMkzNYxsdoPnGoDnkud6zMkCaDhoMDgIj3O/s6lHs4grxQmS7jJ/SlFVpkeA8+bNm8Mys0oNK10uX77M1XbO1q5dm4agCNSq/ydENwEc31wUMpYzIacF3z8MAEeOvXedIUOGTM8LKxCxL8j27dtzReLPTlFVplcAl8byQJGAq/dClTFY88oOOps2bQpu167df8XHypjUqVOn0fr168/6+fk9+v3331+yljst6CHMmDHjBt63NXbfuRYotHjx4uOsHc+t8N63bNkiEr+KqCozKuDjcePGbWQPu+hMrC3PIgWH9O7atSsE5VgOvVVdzkvI+wLK7t+/PzS94yA4BTzKkrfxezvsprxmNS6YinCug4kfGYpI/KmIqjKzAupNnz79IGc8ZfkyM3AlIXgWL8eOHbsM181xo/JymvAdZXR+fy7KOmHChMUIql23py6jQnMSfJ41a9acwr2LxJ+KZLgVQBeMjIw6Lly4cHyrVq0+rVatmty0kVHwMdmEyFl298LL8ILqIO79g88/kNPAO2926dKlIxnpHsxp3by8vI6NHDmymaJ6h1GjRs0bM2bM2PLly6tGJvYnSG9Ys68Jw3N5G1bR0TuUgY6Vk9ggoKiwz8EqsuBZEmGwLk6ZMmU49h8rjyBIQZYaAA2IlP1RjpwKQ2DLkVMZmYZLA5sQb9y4IZ0+ffrskiVLlsLL2Iln4OIHAoB3/UlQUNCJmjVrKpr0sW7dupsDBgyog3carajegmvn79ix4/hPPvmkLtJd4ZiYmKJxcXFMfK8o0L3BPhNfPLcKcjg2NjYe3mA8vl8cJB5FxDgY9biwsDAutMo17LlVC3OiGY1Ql3yfx5kJaLaa45wMkwZB+4wphg4NQHYIKIaE77Zq1aqrnGwDkQXqjMOKK1YYbtmyJcTV1XUqrl8VatX/NiQBdTkdVEZZv379fVzDDEHV6wvJW6KqzEoBxra2tm6rV6++yjn2MmsICGu5jx49Gunu7s5VfFtA9LL4aG4UUHTu3LlHWInKilg28ekKvwfc/zkIql5bSN6TbCkCqAF3slitWrUGfPPNN/+BS1nNxsYmU3UEhGMO2MMQxYMzixYtWh4cHLwDz2dwxQO8W8tu3boNrlatmrOJiUnpGjVq1O3atatxWkUvTorSv3//Wf7+/pMVlcAQSG4NPoSAYiVKlHDz8vK6yko+FBehzhy8BosHO3bsCBkyZMgHn8H3Q8ugQYM2sUY8LY4fP86PYdDvyRBFVfkhhIYA4rZgwYIrXFoss82HGrg2/okTJ97ALeZY6V4Qg+tl+Nlnn81Oa31HLqk2c+bMjQiq/l5I3hVV5YcUxRB0hSE4eubMGbkcqw/YD5xLgG3cuDG4X79+U/AftlCr3kNeE0dHx1lprZWwbt26ELwPnSaRFJK3RFWZUwR0nDp16uFjx47F63PuO1YaHjly5OXs2bN98B9fQPJ0rberq+vy1BZOZR/5GTNm7EZQ9bdC8raoKnOagAYjRoxYv3fv3hd0ZRP1NFMLvYJr165xIsXbQ4cOnYP/yZOzFnl6eh5JrUjF2YRcXFymIaj6WyF5W1SVOVVAxU6dOrlv2LDhxvXr1/VSYaiBOeTp06cTlixZcrJ58+Zj8F8fQa16H7lJQLl9+/alOocbV0jGOS0RVP29kLwtqsqcLsCkQIECXy1atCiA9QSc101f0Khw2vCDBw8+d3d3343/ytKlvrNa7O3t3dgikhrr16+/i+fTeRppIXlLVJW5RQCnqmkzYcKETb6+vnotHhBWQLLicMeOHffHjx/vjf/qlJsSC+B6DpdT62zFgVaurq6ckUn190Lyvqgqc6OAiu3bt3dfs2bN9aCgIHkYqD5hOzpHw23evPneiBEjcoUx6Nq1q3toaCiC6vj5+cXgGWohqPp7IXlfVJW5WQAnbew6ffp0n0OHDsXQK9BHd+PksEXi/PnzHGd+b9SoUTnSGICmR48eTbUzBQ0aPCdvBFV/L8Qw5IN1Bc4OjIyMarRr165vjx49ujVo0KAmuxubmnKaNf0REREhIZdlF+R7Z8+e9fPw8DgMNWeavffPGdkPnrvU1q1bT3Tu3NmWU1WrcezYsZhmzZo54j6DFJXAENFYgrwsgBMsth03btymXbt2PedoRDYB6htWRrJ1wtfX99mcOXMOtmrV6lv8rwPEBIdV703fAqx+/fXXALbvpwab/oYPH/4DgqrXEGI4kqc9ADWQO5aHF9Bq0qRJA5ycnD6pVq1aodKlS8uLOugTzj3PhTZCQkISYRTuBgUFHd28efOxu3fvXsHhG3jvel95GM/msHPnzpVt27a159zzaqA4JG3YsOGqq6sr+zxEKGqBgWJwBiA5SDA1UUTo2KlTp2729vbOtra2UsmSJTM1YUlqREVFSeHh4dLjx4+le/fuPbp9+/bVS5cunVm7di3nq7sMuYtv8d4kHNrAM3DueUsHB4cv4HVMa9KkiWlaxiwgICC2UaNGbPfnVOwCA8egDYAGJCKmeGcXF5cubdq06QBj8HHlypUlKyurTA9RTg16CFxFmV7Co0ePYmEUQq9evXr+r7/+Ort///4LOIVlc87HHa8k8uIQa0iFFi1aVPn444+r4B6rwGB9ZGlpWd7Ozs6M95wW8ESksWPHDvfx8eH8igKBMAApURKbQ/fu3Tu3bt26RS1gY2PDZbb0XkxICZdO49yH9BJQTo+4A548eRJZpkwZSxRTyuAeLIoXL57fzMxM4pJdXCGG69LpAooi0ty5c5csXLhwpKISCIQBSAsYA3Y0suvSpUtH5Lqda9as6VC1atXCrDNg4stqWF7nRJ1cMy4zxZKwsDCJE6R4eHh8pagEAhlhANIB7IGdra3tJ3379v0XF9+oVq2albW1tU4r8H4o4ERIy8GsWbNE4he8hzAAGQTGoBQ2TsOGDWvdsGHDFjAG1StUqFCQRQW65zmBS5cuSXD5p65YseIHRSUQvIMwAHoAxoAF8eowAi27d+/erHbt2vUrV65coWzZspKlpaVUrBjnOMk+Xr9+LR0/fvxpmzZt3PB9tylqgeA9hAHIAmAQuH58zUaNGjVGImyKYkP9SpUqyQaBS3WbmJjovXUhMTFRblV4+PCh5Ofnd3LEiBEj8W0vKocFAlWEAcgGNAahXLlyDl27dnW0s7NrAA+hPAyCOYsMrNWnl5Aeo8DKQbYYPHnyRF4nHmX9G4GBgX/+9NNP+3F4F74rF8sQCNJEGIAPgFJkYB2CTfPmzes0aNCgno2NTW1ra+tKZcqUseLqSRYWFnLFIr8P+wzExMTI4w7YmegRCAkJuXr+/PkzK1euPI3rBEJu4VyxVJogXQgDkEOAUWAzgiWk+uDBgzs6OjraGhsbmyLxxyKHf44cPmTVqlXXcVwWfDe9dyUWGB7CAAgEBkzObLwWCATZgjAAAoEBIwyAQGDACAMgEBgwwgAIBAaMMAACgQEjDIBAYMAIAyAQGDDCAAgEBowwAAKBASMMgEBgwAgDIBAYLJL0//6HodHVMoMnAAAAAElFTkSuQmCC",
	["gradient_circle"] = "iVBORw0KGgoAAAANSUhEUgAAAIAAAACACAYAAADDPmHLAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsIAAA7CARUoSoAAACCdSURBVHhe7V1/jF1lmZ77Y+6dn50Cbadlpp3SFhAREBVYYQ1QEMmCBIJsjNl1/xCNGtFgsrpxXXXdRHdjMCaadTeuIdmY6CqGKoJgCxVwF2y7lgKlQh3KTKeUTlWgnd/3x+x5bue5Pved9zv33PlRWpYnefI+7/t95zvf977fOffcOz9u0xt4A2/g/zFSM/Z1j//89rdT7StWNHV2dqYizERrUS6Xm0aOHp0ePXy46YMf+9j0TPh1jdfdBtjyi1+k29rb06f39KQ62ttThUIhnc1mU/lcLtWczzdBh3bA9PR0U7FYnC5MTk5PTk42lUqlciabnR4ZHS2/9NJL00ePHi3/9oknpj/5mc+8bjbHSb0B/vVrX0u95aKL0us3bEhnM5lMvqUl1d7RkY6aUul0GkQ3rlHXGrduLW5FR3eGadwd4I+OjJSnJifL0QYpv7BvX+nZp54q33rbbSfthjjpNsBPNm1KrV+zJtPd04OCp1vb2qI6V4BmrEcJWAuotpi1AYyt6JlNUR4fG5seGxsrDR84UHp+aKh04403VnbKyYK4RJww+OpHPpJ678c/nuleuTLT0dWVaW5uTkcXPOYeIlDZERHo0wKqLUIbIE5P4+Viampq+ugrrxSHDx0q/vSOO0p//73vsd8Ji7hEvObY8sAD6bPOPjvbFRW9vbMzqnlN0Su3+gAB6wMhrdCi2UID1EFiM4xFLxVHXnmlsOe554rvvuaaE/auEErCa4r/fvDB9Lpzzsmecuqp2Vwul46e2bTYIU0CevUzRguotkARCWq1cUShq34E3BXKL//xj8X+PXsKf37VVaUofkIhLhHHHb/asiV91vnnNy9duhS3+UwUYgFRUBbbK7rGAG8DANQas0DxCGpaXsnVIhvqBqCu2GgjlF55+eXi7555pnDZxo0nzEaIS8Rxw/333JM+/8ILs6cuW5bN5/MsvBZctVpqQH1YgDFC4yGgaASLCai1rLnyxZ9lo3cPpcPRM8LObdumbrjlFsRfU8Ql4rjg+f7+5ujhrrktepqPXEvMTy21xj0fCGlAtQUKpRaAps+iMQaywJ6mX6Ojdw+l4eHhqTu+/OXCN++8E7HXBHGJWFTs2LYts+HMM5uXdHVVPpmJQiywR7artTpEQDWgWmELQR9WNQsJUJNuwU2sQuDV6F1Df3//1EUXX1yMYscduN0eV9z2iU+k7rrrrub1Gzbk2trbUXzMwSOKm52xNq5+HLUvtVpLjWOTaJsXC/lqrabfhI3f2tqaWbZ8eebDH/4wPrksP/Loo2g6bsBkjhvwdH/u296Wm7nqkYRGqImktdoSsJpQrcCVSkDTpw6RVzk1fbVB4h1DdDcoRM8Gkxuvvfa4PSSGkrDg2LtnT7anry8X7XgUzF6BoSuSxDxD1mpLwFpAtQLFIlhQgNojimi12sQcGx0tDe3bN3H2eecVIn/REUrCgmL/wEDzqp6eXCaTQaHAerfiEDFfa60mAcQB+rSAagWKZq3VliieWmr6uKI1pkRbjY8Pkl4cHJxcs27dZOQvKpigRcG/3XFH6vDwcP703l4UH8UG8bpObYk2JWPabq22a1uz+PMlxvLioHcOjemcPM5qA6K7ZcvwoUOt//7Nb4Y26oJg0Qa/+667Uhuvuiq/ZOlSLBAbDYvzrNUhYq7WZ0w1YDUtNaBagSvVs7g6AfgkYlZ71uOsK9/Yisa7hF8+9ND4jTffDH/BEUrCvLD5/vvTf3bppbmOzk7ubhSjnlVqDHOED0tf22hJ+oDGAVpANYGCEdRqWQRY+ErG1CZhTcHFVuMjR44Utj/66MTG669HbEHhJWFeePChh9IXveMd+c7OThRNi2x92DgdIuYcsnEEaAHVBApHUMNSoyAAC8w2arXUKJrGqoV1fGq1FT1y9Gjxf3/zm/ErrrgC/oLBS8KcsfknP0lfcuWVWnwSBbJardUawxxptY0+rNUeCWqNESgUAU1fLQrDNutDk9a3ZJFVe5YsH402wbZHHx2/+rrr4C8IvCTMCXf/6Eepq6+5Jt+xZIl9qEFh4rRaq0PEvK21mgQQB+gDqgkUjWBRAWpLFEk1fdUoFi3jJGOedTVeDrZGzwQ33HQT/HkDyZ43vvP1r6euv/nmfGdXV1zxwVlPvIahdsTtWKTGvT6I2T70qUOs1webKGTjCKi1MUB1Fbl8Pr2yuzu9bunS4j0PPjgTnTvckzQKvNVbtnw533YxadRKjVtN39NKzBltsPRprSYB1YT1caWqBaA94gq0Gpakz6tXqTG90mlJ61eITw3/cPjw5PLu7vHInxdsAhrG4L59zT1r1uTS6TSLGUcUx/PVWh1HzN9aasBqkFBNoGgENYoAwCcRs1ptiCyqas8qvVipXC6XhgYGJvvWrZuI/DnDS0Ji7H3mmewZZ52Vlw954ohChHxqtVZbsri01CR9gDHAWgUKSLDAADWJoqilTkItqrVWh2L4yWEZHxn+7tlnx9907rlTkT8nIElzwqMPPpjuWbu2Oao9k1+PLHZSJn1egLXa8+fD0Dm1PdTGuGUo7tHLJX4xNr167dqWrZs3w58T5nTgp2+/PfWX739/Xj7oARtdkBcPMenYdtyQr7YR4q4R0vUIWE2oBqzvAXedpubm5qaupUvTzQcPFh958slKQyNIcqJZGBwcbO7t7c3N/CzfK05cwZCwuBg1k6s6RKyD1moSsFpRSegMqHl7B3Abpg/Sh7VayVu4arVWh2K47atfZfRQWNq/f/9EX19fw88DSFRD2LF9e6a7u7t55uf5tjhaxBDZx6NttxsJvqX2s23KuB/ogI38wEfPabVlXFsc6+Wt2oZarFy5Mrd92zacqyFgoMT4m8suS33g4x/PtXd02EV5i0y6cG9xHhtJZGhMxpk81UmJO4dq+tQkENKAasD6FrjDWFRjeA5va2tLDe/bV3xi9+6ZaH3UO2kNBqK3fL1/esvHgiTZDIwjUdSw9JWMeZaEj7kzDm2tJeIANKEaYEJhrQZxW7YaNkTcoq3mrVt1I7QvBVUfbw0HBwbGz2jg9wiYlLq4b9Om1PLu7uzMH+GF6BWKVN9rt/Q2GHRcXNtI3Nr5IZXG69G+JOjx1N65lTZmc6BtcWS+7PH0KxqIXp5z92/aBD8R7BUQxIGhodzpPT25SOKEujBqL6b0Ypa6QPVrFipkjFe4algSPkCfUA3gilaLq9RqXvW0IeKqDFmlFwO9hz6NebrYFD0QHti/f7K3ry/Rp4RMTCy2Pf54+rRly1BAm+Qk1GJ6cW3TWBwxl9CGo2Yfz09K7+7hnQN6rtScKL129b1jM03RA+Gy6CH9sV/+Eu11Ya8AF8PDw/nlxz7r9xIAWy8W8uPIRapWGyI3p1pLQjWvdIBXOoArlL7VHnElWs0r1fM9xl39/pVvYocPH55csWLFWKRjgQTF4n+2bk0v7epi0pEwzyahLRz8EOu1g9hMi83QeexclPXadW2aC2qv3bZ5cbBal66uruZHtmzBXGKBzrE44+yzs825nHsSiXkMLTBucST7WNZLLsgisW+c3wh5rHcejVt667HrtFrb1U/CSl3wV9Ub3vQm3LVjgQOC2LJlS+qUU0/lJFhwnTBsI/QWOBfGFYJtnrav50nJY+y4Si+WlDYn6teL2wuR/VKnnHZa87333gsdRGzjm848E3+fjwH1JNT2xNYnky4Ivse4tlDSbbE8fyFpz2tp10g/FPf6WDLf7DurLvhL6/Pf8ha8cwsCB7v4pw9+MHX5jTfm8q2tOjmrNWYX7/UhkyStUcaNgzmwXedlNamb2eoQAVpAdRz4sEnQ1zgfPAnto2018VQqNR29LWw6rVAobH7ssWMtBsFJ7tq5M3Pueee1ZDIZJk6t1fRBvc16NqkOEYVQTZ9aifXRWgK0gJdEPLFXkikalsRTt9V8Gvd8Up/arW+f7G2b127jVV0qFku7d+8eveCtb3X/1AzJcbFq1aqo9tX/yaPJtFp9FML2t32V9YrIGGxI200DX+nFGqV3nlBMyXVY2va4viTyaHMZl9tKWyabTXUfewvvAh1nYdOmTanO2rd+PJHquDbtY9uSUBNkE0Xa5GuxbKxR1jtez9EouZb5UHOpuaWu8fHXWT///vfhz4Ib3LBuXeVfsUVSB+SgGlffatsnjpoYmyRNnjKuDWSh1GoB1Y+jjkGqrzo0J7se9ePo5dKLxfr4TeLV69fjvLOAjrOwortb/w+fHZCxkM/+cUzSL5Q8xqhBWxD61Nbnp5peW1wcPml9UudLJo03kj/2pQ76qOWpvb3uywA61OBb3/pWquXYk78O5NE7mcaspg87l0RpG33LUFFsAeknZWicJNQ5W625CcWtTuIzVvXb29szd955J3QN0KkGF6xfn2prbZ01wIyfNBZq9zT7hKiJo29p41o8S7362dfeEbRNx/Voz61zZZuNkWzz8mHzlNR3iX/Cta6nB+erAQ6uQd/ZZ/O/LLsDRfTa6k0KPmNW2z5gKJGhZLItjlpY9S3j2rWNGvTmorEQde2hfIR8xtRnbFY8nUql+5znAHSsQUt0q4jqX3OwIRA6sfW9mG1Xah/bpmSS69EWMAntHcKOBxuag52j+sq49WsOQn5cDLDxVPRQl2rt6MCcasADqsAPESKDg4BZAyWgnZjna0x96jh6ifYYKmA9hvrZsUJzUT+O9XKhsTi/XpxsyjU3Z+74ylcqmsBBVWy955509LDADnowCdQ7kUfvGBtTHzoJvYSzQKQtovqW2q5jhKjn0/NTK701Uod8LwbYeCLiuxTOv+ACjlFBjdPS0ZHCP6+LpCUAyxMD2q4EQhO0cfga83yNh8gi1KMtshbbxkg93tKbi2VoLRpXnzH1k5DgsUS1D9De2Yn2Kmqc3jPOiF79q1+nopaaYEwJYDyOadsZh7VtltqHY6oGQwXQ4lCTWlQtsqU9hto7l6dBO1+7Ls9nDLBxku2A105Ac/wKsAF6env1+JrBmto6O/GwAMmD1HokoOtNLI44lpPVmPUZowZDRYAmtbDUIdr+IXrnBO1cPZ8x9ZOQ0PEA248kKn7m2N8O4Lgqapzi1JQdgATiYoS2KwHYuEUDth2+F7Oa/UhbLKUW25Lt9hjSngcMzSnkh2JKtBNeuyLU7sVTxXJZx645UVM6m0UnD168ZmBDwIsRtk2ZJGHwGaMOkYWDtUVm4S3RRnpjWdo56TzVZ4ywbSABzeMJ7ae08GIVZLLZ9OVXXFFt18k04avVIhMiYHUIto3HWQLU9RKDdiZEY7ZdyYJpQUFb7JBV2rFBbx6erwT0eMD2IQnrE7avWpfR2/zUX7///ZE8Bkyigs0PPIDGGc8FBiCoawZ3SHgxwPMtAS9Oesn3yEJqkS212LQe7fk838aVCvVtv3pU0LfxGuTz+abTV6+e8Y5NsoJM9PyPXx6YcRcKoYnGEVC/OscZaJsyrhC2mCx0o5tAx9dzKBW2rR4XG6lsJgNi3hVURaFcrrxNiKRHQK1tW0h4Y9pzkgCsVwgbh2ZxQRbbKz7IY72xEWMcsO3kQiN0Di/uEd+omWo69lF/BVhEBdPT/FU4FzygeqCAg9cjEIrNFfZYHZvUYqlvi8+47UutVFg/BDsGCXhxjx5C8ThUi40FHi94E2WMC6xHIhSPg/ZnobkJ7FVPEhpjXG0ShhDXtug4nhtgIRBKJuPKJEA/LTpArbRgzGs7qXCib4DQ6xLi9VgP6GN/tRuw43hUqG/bTngs5gbQZKkG6NcjEIo3Ans8C87fo9dNYPt6sO2erscQ4toWCtU7V3UDNGcy+iDoTYIx2CQkrFZ/ocBxlSyoFhUaxVbyDym4EUB7jPpKhfXrwY5FAl7cYwjBtpkaV9urGyCK4EuP0cBGahtbDHjj6rlDZGEAL64+C0sdKj770YbGtDFA25SLBe9cIODFp4vFYhmMdAXVDXD1u989PTU5iU7zBU+mqE4gQMCLKWw7icV4xdE2UousxQ9tAh4Dy/G8c9gYqAj1iaOFF2sYk5OTTQcGB2c88wwwOVXzL2ftCelzgiESXoywMe1rGUpeqBiWLCALy0Jr0anpK+14pD2v+hqDBWw7qPB829fGLAkvVsHUxMT0hz/60RnPbIBSsWgP9PwQvDY9XglQM0GA9iGBegmHH0cWkkXVgmvhaUlvDEs7BzsvQGMkAMtjAG1XKqyvCPWvEv9LbkZXULMBsuk0JxxCzWCGgPo1J4qgbY2Q43g+NH1qUgsJanG14CGyL2nHt/Tmp/PSmLYBXptCjwe0n0dFjZ/NZHjOCmo2wPj4uD4IeiRUA7aftkPrSW0/0iYJvsY8n1YLZLXSK7TS629jIMcndT7U6tt2+oDGSEDHAGwfxgn1bZ+KjmrbNDo2xvNWULMB9r/wQvQuQcepGUgJwHKShO1nyQXVi8f50KRXDMbZRk2yqFr4EPU47xyeBr15J/E1DnhtIIF+HAOw/cgKUNwDQ0Mcu4LaO8DoKL7EmAfpwADjSoITAUL9OJ7SxjiOas/3qMWytEVV34vpsSF6c7CMWwe059cjAItjCNsHJKAr40coj4+M6HG1G+Cq667DlxdzMgT8JCfz4iCP9+Ih3+o42mJokbxiaqGT0o4B6rn03NTK0Lqok/j14iTBfsT06MjI9JM7dyJeRc0GAKK3gvYERNyJOWhcH6X2g7a+xj3aRLMQjKvvFTRE7a9jME4dmoP6cYxbu/qMqc8YYOOkd8z01NRU6dOf+xx0FbM2wET0kBBh1sEJGJqo9TVmdSNkMRohixtH24++juPRzk190q7Ty0MSPxRTAlUfNR0bG8M6ajBrA+zbu3euG0CJyekE1ae2PrXto/SSbdtIW0ClF/PIfhzTozcHjVl667Rrtm2eHxcDauKo6Qv9/ZhbDWZtgP7BwfL4sbcKdQed8b1YyKfmcZ7vMZRoj7ZgWsiQxn/QUmv7eL5HnSPnWS8Wyges1Z7vcVaf6OovvzA4iHPXwP2Fhpl/Do1fEdZfmbK/QmV9Gwv19/qoDcVsGzavxunDkvCxRmi1XDctkkRo4rQgSi0idD3ajWS12lDM+rbNi1X94YMHJ7pPP33WP49GQmbh0P79+Eo6TQJInzHra8xq+mqTEAsAQzHqEDUJtB5DbXqsR9um8yQbjXt5gta412bb6eP7BacPHTiAuc6CuwGe37evVJictINVBwz41JZxbUpNiE0OfI+2zSsWYiHylt8o7TnA0DztOtSPI/smzS205+OnvOX9e/di3rPAW+AsHH7ppfyy7m59GcDtlNr6cdpr86zVXoy3dSVijFMr7a2fJKiRLLU2qbSkFpMaNil1I1EnsUl11T908ODkytNPH430LCAxLg689FJJfjqIxam2vm1TxrWBmKSnNUZan4sM0UtKUupx3hg8R4h2HaRtj+sbR82rzXHVRw0PDQ0Fv1o2uAF++p3vlEaPfSqY5GTUtt22JSETFGKojy2Qx6T9QO/lwZ6T46kF49Zh16q+pc2j5tb2se0VPTIyUtr6s59hbi70VjgL+wcHcz29vflU7TeEwpLq2z6wXsxrC/kgNmkoBms1ibXRqgasBZAwgonUZNpkW7KYapWM1dtIqkPWxqyu+NP4AqmhobHVa9YEv1EUSQniqV27ihPj45h4KAH0cXKNk3EJA+1x8C1DcS6a2lLj0PN54LPWMhQndQ26Xi/u9bH5t328ukxPTEyUdj/9NNYdhF4BLl588cX8qlWr+DCIKw1WdZytF2uE2Kwhq+TVrhqWa7WaQNKISgINbaKhQwWltboe7UbyNp6Nwdr2iv/igQMT0R089oujkJxY/O63vy1OTU3pwnWRjVCP4WS13ZJ94sjFMgFqPXrHNUodgzouZqnrs2ulb9vr0dan8tbvhd27gw9/hF4BQQwfOpRfvmJFPpK8Gu1VHbJWe34csUGthrVaiTVZa0moRhKttdRk04Kh4qm1OsS4jeVtQNceOnRocuXKle5bPwUSVBfP79pViHYUBscCvARYsq/V9MlQPAmxUC5aY9YmpXcctPVtH/oLRS8nGguxWpfotb/c//TTib4/WK+AWOwfGMjji6MjiSsPV7F3lXsxpRdTYkOGfGj61B55lau2JFQjgQQ1EkqLWDXJxpJeAa1VejHQ21Qa83Q1Fr17m1jT11f3SyMBJCkRntixozA2OooTcNHQsEqNVSYjvsZCDPWxCw4lQNtUqz/XdwOkPZeS52If9S3j8uHlTGNBoka7duwIvu2z0CugLp7v72/uW7u2JX3s6+PB0BUfutIRx6bTdvjaR2OejSPWQ0sNMAbomlVjYxPUsEokWTX9agFmqAWj9myjjNtkxXK5XBoYGBhft25d4g2ApCbGq0ND01e+5z3pltZWTbJHwotrO2D9EJh4D2yzRKIBWPrWhoikxsXVWtbrT6tkf49eH/Whp1995ZXC39122/iuPXsiNxmSJr+KHdu3Z847//zWmS+UBO3VHrr66xGbympYqz1iHarpU5OAtQpsCmstkXCrKwWY8ZW2SLRxOgln3Qnw+35P7to1etHFF8d+8GPhJaEuBgcHc71/+ogY9IoetxFQnFDMs1YrsQbV9KlJwGoFCkhQw3pEwayNI4pkNYunWqnxuOeJIj7y3b9//0RfX9945DcEJLVhjO3aVX7XDTfoSwHBBNvkWtRr96AFUAJxvhJJtZZU32tDsjVG38Yttd1qHUP9UMxti279xX+8/faxHU8/HbmNYS6FqOCRzZvT77j00tbWtra53vJBbCC1Nma1EnNHGyx9qy0BaxUoNAFNH0mnZdzqJGQxPWt1IkZP/cUdv/71yOVXXQW/YXhJSIxn9+zJrj/zTHy9LAqRZCOgOCGfGtZqjWHOGqOvloQP0AdoAdUACw6wuAAKYzVIDUtan0SBrFZrtY3pywBixVKpVN773HNj57z5zYk+9PFgE9AwXujvz69euzYnbw3rEUWx2rNWe8T8rSXVB6wFVAMsMsAiM0aN5GsbfMasZrGUGqPWwlJ7fpV4y7d/YGBi7bp1Db/uK2wC5oTDhw+3LFu2jJ8SkiiA+l6c2rNKxDBXWm2Dzxi1EnGAPqGaQOHUAigCgJgS8ZCNIwqollrjVtcQf+P3+8OHJ1d0d9f9rL8ekNB546y1a0vRS0G6paXFJthLcj0giRaMaRs0CXiaRDJV06e2jGsjUQzV9K3VdhsLWas1Vj766qtTd9155/jPNm/GPOeFuRTIxd0//nH66quvbulYssR7FsBVGKdhrfZ8zDek6VOTgPUB1YQmFJo+tSUKopo+dYjVYor2LFn1o+IXHt66dfS9N92E2LzhJWHO2HLPPelLLr+8paOz024CFCak6auNI+ZstdoQCWqNESgewcIC1B5RiJD1yIKGdE3B1T9y5Ehx+5Yto1fffDNiCwIvCfPCQ1u3pt/x9re3dHZ24gsYURQtdj1LWp/EfNVSazxEglpjBApHUMNajYLEaRSIfhxZXNVqqxrF37lz59gVV1yBdwMLBi8J88Yv7r03/c53vQt3At0EcdbqOGLOqulThwjQAqoJFI2ghqVGMawGqa1FAekrWVjru3bkyJHCrzdvHrv6fe+Dv6DwkrAg2HTXXekrN25s6Vy6NDvzkTGKVK/woU2AeaINlr61pPqAWmpAtQIF8ywKArCgsErG1CYhi626YvG0jwe+Rx9+eOz6G29EfMGBpC4KfvDDH06v6eoqrj3rrFRrW5t8HWEFSJAHJtMS8KwlwGTCp1Vt25VaDMtQW03RRMeNRdo+1bHwN/p/+P3vp77/3e+O/dWtt2Kui4LQVbCgeGHfvnzv6tW5mU8McYWCSa58EHNMcvWrVgLWAqoJTTS1Wo8omNUsqOp6rG4G/GXu0NDQ5Nq1a+f1IU8SeElYFDyze3dzX19fvq29PWnhPWK+1pLWBxAD6NMCqhUoGsHCMqa+EoVTTV9tHKvFx2/0DA4MjJ9z7rl1f6N3IRBKwqLg4S1bMuddeGF+KZ4L0mkUB0yyCTBP1fTVhgiErAcUjGBRAeoQUcCQVTJWc/vHv/B4JXqP/9QTT4xfvnEj2o4L4hKxKPhQdM5/6O/Prertzc18Vb2St3q95YOehrXaErBarQcUSC0ATQKwLCapPjUtCkp/FqempsoHo1v+Z9evn/ivY/2OG+ISsajYvm1bdsOZZ+aWLFmSjW4GLK5HzFEttcbjCISshU0+fVgSUB9FtNrGSPi88nHRl4+8+mpx7969ExdfcklDv8mzUEACXxNcdPHFxQ/dcss4fpNlfHx81q84CemH4uqTGtd2L67UPt5vD6MdcaUeQ23PBV/bSmMjI4Xo4Xj8k7feOvJaFR8IXQnHFT+7++70BRdemFu+cmVzPp/Xq1xfCtSGNAANsI1xgFpjFrhKCWpezQC1Uq949dVW9OTkZOnw8HDhqe3bJ/9iAT/SnSviEnHc8fjDD2fWnXNOrqurK2ueD1hIao1Zsg1gDKAlrE+gYAQ1LAmoT+omsBtgujA1VXr55ZeL/bt2TVz6nve85oUnQkl4TfGrrVszZ0TPB6ecckoWv3eYSqW8TWA1CSAOaIyWsD6BghHUtCgoUCmqQ90E0/gkD39eHxW+MPjMM1PvvOYavAScUAgl4YTAAz//eTp6P9zcFT0o4vODbDZrC+5tABJQDWg8BBSPoFZbl/hOHryfx9u6Z/fsKVxz7bUnzBVvEZeIEwZf/exnU9fefHN21erV2c5oM+A5IZPJsLgegZAGVFugiAQ1iwtQq1/5V2yTExPlo0ePFl8cGipsue++4me++EX2OWERl4gTEvf94AepNRs2ZJf39GTzLS2Z9o4OvIvE50osshKwFlBtoUXTItNWdPQOrvI2bnRkpDw5NlYaPniwMPDcc6XrP/ABvkycFIhLxAmPf/7iF1OXXHZZZu2GDem21tZMcy6X6ejsxDNDZUMc+3hh/hsgurorL+jAyNGj5UKhUBobHy8N9PeXdj7+eOn2z39ejzmpcFJvAIt/+cIXUm+97LJUe/S80NvTk2pva0uXyuVoK6TS0ctGKtfS0hQ9R2B/uOuOLmgUuzw1MYGvV5vGz2Mz6XQZX7Ny4MUXyyPR1f7kY4+V//ZLXzppC27xutoAcfiPb3wjtXL9+qboZSO4AaKHt6ZioVB+6fnnm2791KcQet0U+g28gTfwBiyamv4Pt5OoSSD7hRIAAAAASUVORK5CYII=",
	["rpg_icon"] = "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",
	["grenade_icon"] = "iVBORw0KGgoAAAANSUhEUgAAAQAAAAEACAYAAABccqhmAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAABqbSURBVHhe7d0LdFT1nQfwZmYSCHknvEkCYiDhTRGoFGMRhW19bqEeu0Xddpddt6tVlHO0R22Xo549bLcV6lbpEctR8ZWNtSIrL40ItBAQjQFWEhqSISEJnbzI5D2ZyezvO3MvHWi7nXvnzszNzPdzzu/cx4RMSOb/u//X/d8vERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERERRVGCsiX6E16v1yabwLBKWJT9JAl8fhA4j3N4Def7JGoSEhI8siUTYwIwESlw+HtkSKAQgVrAcJwskSihFraRyhbn1H3AMfbxdTiPf6vGCAn1+6jfC8fY4nX1HN4T/xavqe+B1/Han0sACJzHFl/rkvhCYq/ExxK/l2TQLVsyGfzByCQkAaDwvC7xFYkhCRQ0tVAFFkBE4D7CrHokKiQOSvxcEoEDJ8kcmABMRBIACjWumNf5TsQYj8fznzab7Yeyi+RGJmDmK0fcUdrMsVxV/sfy8vKvyzZHAsmOoowJwHxituPMarVm5+Tk/IfsrpKY4DtJUcUEYD6DyjYm5efnFz377LN/J7vLJNCvQVHEBGA+MZ0AkpKSbLfddtuMuXPnLpHDq/xnKVqYAMwn5jvIpk6dOvahhx6aJ7vo7MTQJEUJE4D5uJVtzLKIFStWFE6fPn2xHE73n6VoYAIwn35lG9Nyc3NznnnmmQWy+zWJFN9JijgmAPOJ6T4AVYIoLi4uWLVqFfoCZvrPUqQxAZhPXCQAGD9+fOZ3v/tdFH7UAtJ8JymimADMZ0DZxoWlS5cW3H333Ytk98sS/DxGGH/h5hMXfQCq7OzsVKkFzJbdYoks30mKGCYA84mrGgDMnz8/b82aNegQRPAzGUH8ZZsP7qWPKzk5OWk333wzJgVdLzHad5IiggnAfDolXF6vt8vj8QwMDg66ZRuV+wPkbYfw/moMCeUlwy1dujRPNpgTgP4Afi4jhHdkmcyGDRuaZbOnubl514cffuj86KOPklwuV19+fn4Whs78XxUZJ0+ebCwtLa2trKxsKS8vv9DX19c7ZcqUsPwcKSkpSdnZ2T179+5FDahSIu5qQkSBUBX+gcRHzz///Kdut9sjtYKI2rNnT7W8/34lyqZOnVpmt9sdysuGO3HixHl5n+0SX5WgCGBVy7wwHwC1gTOZmZkNctH1+s5GkNVqVa/0WOKrsba29gu5Qh+QZIRjw1199dWjH3nkkYmyi2YAliQjiltonqEWUFBVVXWXNL/7lAtlxOzbt++MvD+u/iUS35JAR93VnZ2dLylfYjhp8uA9fymBoUEKM9YAzAsdf60SNYWFhXapAUT8LkFJOmqtA7WRCxJ1EmfT0tL+XV47hxeMNnfu3PF33HHHJNldKKEudEphwgQwPGByUMQTgFT1A5sdlzr+LBZLrSSATcqhoTAx6N57750iu3MluGpQmDEBDA+oDUS8D2D+/PljSkpKxjzwwANYHvyy97fZbC95PJ5y5dAwGGG45pprxi9cuBDDgvMl+Bml+CZN4+kSHb5GchT09vb2OJ3OD2R3hfIj+bhcrlulJtDv/yrjYMRj8+bNR+QtNkhk+96MKF5JmZgs0eIrHVEkhd0xODj4DeXHws9lkeO3/K8aK2BIELMDuXx9mLB6NTzg/oCorxYstfMxEi+fPXv2ZjlMRsekxWJBj73hw4IYEnz88cdzZRf3B6AJQmHABDA8oP0d8QQgV/w/6Xi0Wq1jx40bt620tBTDgqMkARyRL/ud/1XjjBo1akRxcTE6AWdJTPWdJMMxAQwPSAARHwU4evRo/a5du6rb2tq6lFM+KSkp42688cafbt269RapBWBU4GXlJUMVFhZmz5gxY4zsYkgQj0cjg/FegGFgw4YNo2TzTxJ4cGjElJeXN33zm9/8g7TzOxYsWJAuBf/SCr7Jyckpubm5144dO7ZCquvl8trNaCIoLxti5MiRiefOnbsoPwcWSv1fCdwoRQZiDWB4wAM2I75OgFTtfUN/mzZtcj777LP7nU7nZQVQCn/ePffcs2X9+vUTvF7vm8ppw0iSSbrhhhvwGLHxEtN8J8lQ7F01MSlU6ATDjTGFEuskIjokdv78+ba6urrO3t7elqamplek7W+VAvm0FMxM5Ut8ampqjrW3tz+9aNGibUbXAmprax1Swzgqu3jU+FaJsNyHQGQqUvinSnwhYQo9PT1l8mPZKisr7x4YGOhSTl9SVlb2lnzNduXQMF1dXX3r1q37rbw3Zh5iijAZiE0A80LH1wz/bvQlJiZO++CDD6bOmzdvt9QKfjw4OHjZ2oUTJky4Vl7vlTJr6H386He47rrrsFbgWAk2AwzGBGBeuCXWNGw22ySp5n9fdlcWFRWVNTY2/lQK+6WRiUmTJo3ZsWNHfmdnp105ZQhpUiTMnj07OysrC8uGF0nwBiEDMQGYkBQsjM58xX9kDlIOLZmZmbfILp7su/Sqq67aKE2Bk74XRWpq6si5c+eOPXLkSLtyyjCSXDJWrVqFERDMB0BNgAzCBGBO+RK42pnKtGnTMp966qnRW7ZsucZut8+UZgGW7vKxiEWLFmVt3br1osvl6lBOG0KSS/Ly5cvRAYrRAE4KMhBHAaJIrvS44w0z3dDGxRg7JrugqovFMO6RMFV1FzMDpXC7pax7pEnQLVv8zOn+V32jBu1r1qyp2L59++j8/Hw8/dcwp06dapwzZ85x2d0p8YpEzD9ENRI4EShKpPBjdZ1SiUclVkv8rcRtEn8jYcqn5KA9LgXfKhJlFw/0vOzR3vKapaqqqk227TNmzMD/z7ALjNQ2LJJgOk6ePInOxwqJXt8LFBI2AaJACj/as89JmKqjL1SYv79kyZK03/zmN30DAwONymlDpKWlJS9btgzzD3B/AJILGYAJIDo2Stzq340ts2bNynrttddsDoejXjllCNQ8pFaB5kaqBCZGsfZqAP4SI0yu/o/L5jH/UeyRK/UICWdXV1fj7NmzMY/BsGaAxWIZOnDgQFtzczOq/59L8NkBIWINIIKk8K+RzY/9R7Fp5MiRSWvXrp1pt9tHulwurPBrGKwXuHDhQtwYhaXDMU2aQsQaQIRI4cfKNtskLvWaxyr0BUyePDldEkBDamrqZOV0yBITE20dHR2d7777brccoolhaIKJR6wBRIAU/gLZbJEw9EYZM8vLyxsvBbZgaGgIhdUwM2fORAcqagHoCOQaASFiAggzKfwY439JYqbvRByRmkD24OCgoasZT5o0KW3x4sVYIgxzKCK6PkIsYgIIvzskvubfjS8jRoxIwsZ/ZIz09PTkFStWYCQAtSnMmKQQMAGEkVz9caX6e/9R/LFYLAlKEjAM+hfmzZuHBICJSIZONopHTADhhSv/Yv8uGQGzEQsKCjBdGskVHYyG1jDiDRNAmMjVH79bXP3RYUUGys3NTb/++uvx9GAMB8ZNx2o4MAGEDybBXHqIBhknMzMzpbi4WO0H4CpBIWACCJ+1EuylDgPMBwjoB8CDRNkPoBMTQBhI9R9t09v9RxQOeXl5aFqp8wHQHCAdmADC49sSXLgijMaNG4erP0YY0AQYjXOkHRNAePB21St0dnb2DA4OGraIR3p6+sjVq1cjAWBqNW4RJh2YAMIDq9ZwwYoAdru9w+FwOJXDkOGhIbNmzcIQIKr/WCqMdGACCA+sY3/av0tw9uxZZ319vWGP9kpKSrLl5uaqMw2RAPhZ1oG/tDBISEjAB32H/4jwiLEzZ870fvrppxfdbrchTznGAiH5+fmYDIQkgD4A9AmQRkwA4fO2RKt/N+55b7rpprHZ2dmJLpfrsgeKhGLChAkYBcDCqVgxOOZvsw4HJoDwwQMyLq2bH88sYuHChfl33XXXTGm746ptiJycnFFz5sxBAkDhv+x5hRQcJgCDeb3eJIkVsvuqhKke7hFtVqvVIs0jwz5zuDOwqKgIawJgUhAfGKIDE4BBpNBnSeCpOf8jsVviWxK8DyCMlDsD0QmIGCfBGYEaMQEYQAo+xqFfl3hDAld/LrUWAahRTJ8+HU0KNQHwuYEaMQEYA7f98safKJg4cSJqWRgJQBPAsP6FeMEEYAxc9SkKMjIyUPjVkQAEacAEECKp/mMSChNAlKSmpqL6j7Y/5gFwbQCNmABCh+W+sUAlRUFycnLismXL0OeiTggiDZgAQnezsqUoSEpKwoxAJAAMB3L9BY2YAEIg1X+sSsux/ihKTEy0TpgwAQlAnRDEoUANmABCg8I/3b9L0YDVgXJyclD4EZgQhKYABYkJIDRfl+DvMIowFyA1NRU1APwd0BHI1YE04IdXJ6n+o8MpLh/4YSZIAFlZWWj/IwlgTgATgAZMAPphSWquSBtleE4A7jKUXXyWMRGICUADJgD9UPjZ3jSBzMxMdS6Ael8ABYkJQD+uQmMSKSkpag0AV390BFKQ+AHWL0fZUpQhAUycOBE1ANTI8NgwChITgH5ciNIkRowYgaFA7KpzAShITAD6oROQzAUJgGsDasAEoIPX60VHE5sAJoGRAGVXnQzE2YBBYgLQB51NrGqaDz7P+Nvwcx0k/qL0yVKCzIdXfw2YAPRBO5M1APNh4deICUAfPPUHq/4SDWtMADokJCQMyeYZr9eLFYDJPLzKloLEBKCTJIHutra2HwwMDJxSTpEOeFSYJNKQCi4GAWw2G6r/bAJoxAQQgjFjxtgvXLjwA5fL1a6cIo26u7v7PR4PalShCCz4TAIaMAGEaMqUKQedTieaA6F+iONSRkbGKDzoUznU5Y/TAEgrJoDQDeXk5IyTDyF/lzrI783o0stsoAE/tCGSK/9K+Qw/qBxSFKAJ4Xa72QGoAxNACKTwY1Wgf5PgE2miqKenx9XQ0KAmANYANGACCM2jEl/171K0dHd3uy5evKgccShQCyYAneTqv1w2/+I/omjq7+/3KLvoiHVJMAkEiQlAP1z5ufhEiCSR+iiHusjVH4Ue3BJOCY7IBIkJQL+TEvyghaivr881MDAwqBxqhuTR0dERmAC6/LsUDCYA/ZAALjU8SZ/29vbuUBIARgCcTicKvu9Qos+/S8FgAtDvgsRZ/y7p5XA4etxut+6alJIA1D4AJBI0AShITAA6JSQk9Mqm0n9EeqD6Xl9f36Mc6jI4OOiWWgQSAPoR0BQI6fvFGyaA0HymbEmH/v5+V1NT0wCe7qOc0gy1h9bWVjQBkAD6JdgE0IAJIDRVEux00gk3AnV0dLjxhF/llGYul8tdV1eHGgCaEUgAAzhPwWECCE2dBPoCSIfOzs5+SQJDoSQA1AAaGxtR+BFoliEJUJCYAELTJGH375JWdrvdmZaWZgnlbkAkkaqqKlT/1REAJgANmABCkJCQgE6nT/xHpAXa/++//37b2LFjEy1COa1ZU1OT2umHGgASAJsAGjABhO4tCc4H0Eiu/m2bN2/uV57sqwtGEaqrq7uVQ9QA0ARQhwQpCEwAIZJaACYEvec/omAMiUOHDjmwn5KSgod56IJaREVFBQo9oDbWIqF7TkE8YgIwxja5GHE0IEgXLlzoLCkp8U3YkQTgO6eHtP/7Kisr1VmAqP43+3cpWEwAxjgksde/S3+NFFpHWVmZr6qelpam+4rd2tra88knn+DfoxMQCRidsqQBE4ABpBkwJLFNdln9/CucTmfvG2+80aocujMyMtQruGYNDQ1q+x9TgFH95+KsGjEBGGe/NG0/VPbpL6iurm557bXX1Jt/utPT03X12mMKcG1trdr+x/dA9Z+zADViAjCI1AD6LRbLr2SXtYC/oKenp3/nzp1/UA69CxYsaEtNTdU1B6C/v3+wpqZGTR4Y+0cC4AiARkwAxtortYDfKfsUAD32r7/+evXTTz+tXrV7v/Od7zgSExOxrqJmXV1d/QcOHFDXAcBcALb/dWACMJDUAjq9Xu99bre7QjlFioqKisb77ruvQzlEp11bcXFxi/zOMvyntGlpaemR74naFq76mIeBPgDSiAnAYDab7bTdbv/2xYsXjyin4h5W/dmzZ4/a8YfCjyHAilmzZuFY17Jq9fX1gR2AbRKcjKUDE0AYTJs2rebFF1/857Nnz3KasGhoaGh/7rnn1Cm7aK+jhvR2SkpKru+MRphIVF1drX4/NAPQr6AmBNKACSA8hh577LHqgoKCtZ9//nkZPrDK+biDtv+uXbualGW7cfXHDMAyaSrhqj0TJ7Xq6OjokRqF2peAhIL2PzsAdWACCB9UTb8oKyt7RApB3LZPz5071/7www+ry3Thao1bqL+QyJS4SkIzqVm1qxOJBBIBOwB1YgIIL/e6des8ycnJI5XjuCPtf3WiD67+mKiDVZSwnSAxWUITjP8fP35c7UxEEsA+pwDrxAQQZlardZrenu7hziOOHTuGqj7g6v97CbVfZJqE5sTY2dnZu3fvXrW9j6s/FmZV34M0YgIIPzR+4/Ie9bq6utaNGzeqvfPotDstoa6gNFfZamK32y++9957aq0CTQs0J9SZhaQRE0D4HZAo9e/GD1z9d+/e3SRJAFV/QBIMnKtfpGyDhs7U8vJy9WqPJIBkUuM7Il2YAMJMqv8oAJu8Xq/v/vd4gav/gw8+2Kkc4grdIIEaABbyQAcgmgCa4CEiO3fuVKv/mPePDkV1ajHpwAQQAZIEPpOL138rhzHP7XZ7pJ0e2DOPjjpMjDrvO/IP/2meA1BfX39x3759au8/bv9FQlGnA5MOTAARYrVaN0kSwFUw5tXW1rY8+eSTgVd/XKmPSqjNATxYNcu/Gxz0/h87dkxtQiAJYGi12ndEujEBRIjUAmql6vuichizent7B95+++3zAc/rR6HF1d83VCe/A6wBeC32tZDv11tSUqKuuoTqP0YU4qpZFQ5MABEktYDnpRZwSjmMSQcPHjz3xBNPqO10deJP4JRoVP2X+neDV1dX1/Hxxx+r1X/0/uPqz97/EDEBRJDUAjo8Hs/jkgRi8saV1tZW57Zt29RZj6ju4wYg3B4d2B+wUGK8fzc48vsaOnz4cGDvP2oTrP4bgAkgwpKSknZKdfYfpE2rzmaLGXL1P19aWqpelVFNPyGBtn+g5co2aC0tLV07duxQb/7B98XkH87+MwATQBTk5OTskCrtw/39/TGzkrDD4ejcvHmzessvbn5Ch+ceiUv3QSjDf4v9R8Grrq5uvaL6j95/3WsJ0h8xAUTHUGFhYemRI0ce7+rqGvY1AaXjr+7QoUPqXY9IbJ9KXFlNnydxtX83OLibUGoW6u8ISQAdf6z+G4QJIHp6ly9f/qudO3f+66lTpyoGBgaG5Xh2X1/fwPbt20/ff//9ar8GkkCjBJZKv/I5fYskNN0X0dra2r1t2za1+q9OJ+bqPxQzkiWu/9nPfvbW6dOnGzDeLVXlYQFLfP/iF7/A3X37lfhIAtOe75W47Ik/8uWjJLAOgCbS9keBV7/3yxJLJMggrAFEHzq1jq1fv37TjBkz3njllVcONzY2mv7uNhT+rVu3nn7ggQfUCT/o9cd+uUSZxJVtdCQE9BHg/xbUAimoXezbt0+t/qvTiTH+TxRzUECwQMbdxcXFvzx69OhptK2VC6GptLe3d/3kJz85Lj9r4JX/HYn1En9xiq/8U8vQ0FBBW1vb/fX19cc6Ojq6cdOQ/7v+qaqqqubMzEz1PfD975ZIkCCKWUkSMyTu27hx46+lENS7XK5BpUxEFRLS8ePHz8lVHzP7Agv/2xIPSkyU+GtQ68SdgC+sXbv20JYtWyoOHz5c29zc3IF+EOWtfEpKSjBpSn2PlyTmSJCBmE3NC30D+MDf+MILL6y85ZZbZuXl5Y1OEL5XI0gK5mB1dbXjzTffbJSkpK7FB6jKY6ovbnlGElDv9f//IAFMkrhdYrpEtkRqUVFRyurVq9OXLFmSWVhYmJmYmGjdsGHDmZdffhmdo+hMxISin0vEzNCpGTABmBv+PjkSN/3oRz/6xqOPPro6NTVV/+N0NcIMvJqaGkdpaen5J598MnDVXbT3cX8/CvxhiR0SWuflo6YzVmKKRIEEhgexTFjGpEmTUhYvXpyyf//+IeWeAvT6vyHxLg7IOEwAw0OSXH0X3X777W+OGjUqTzkXdmij33nnnRUBC3Ci4OOKjAJZJfFbCYwChHpVxuPBcHcgEgASAdYKyJdA7WCUBDr/npfg+L/BmACGCWkSp0q8Jy2AG5RTYYfZfbfeemul8ghu9MKjF/+MBAo+OgHDdU/DCAncLzBVAguHYnQBj18PbH4QxRdJANdLOCQiorKyEgt4oBMOTz3G489vk9D1LL8QoHaAhEBhwHkAw4hc/Q96PJ4fStkM66xBtP0/++yz+ieeeAK38gLeD1V+XIXV+f6RguZHXC6qSvTnWJxO53/5r9HGw9z7d955ByvtqsN8iPckvi+h61HeZF78gw4/3qVLlx6W2gAK6+SkpKRkm80W8t8RU5BbWlqcr7766pnvfe97gTMRcfW3SxyUqMUJih3sBBy+8FTdm5566qn7iouLC4qKinJGjx6dFmwywNUe03kdDke33W53njhxomv37t09V/T4o9MNtYGdErivP6xND4o8JoDhDcNkmFCzcsWKFZkrV64cvXjx4pzU1FQbJgxZrdYEi8WSIEnBgpBji8fjGWpubu6RAt95/PjxvgMHDgwGrN2vQo8/et7xFN9fS3D4LUYxAQxv+Pvh9tovS8yWwPj5OAnUDtBzHmwnL4b5MNsONyZhwg8m9WA1H9zUw5V3YhgTQOzAzDpMsZ2lBG4sQnJQmwT4WyOQFNR9VPdR6HHHXb0E2voIDP+ht5+LbsY4JoDYg78ppgsjGWASDR7AiUKPRIDAXYdYmhtfh6s+Cvs5CXT8IRlc2RwgIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiIiipQvfen/AAv7XK8fRaQPAAAAAElFTkSuQmCC",
	["line"] = "iVBORw0KGgoAAAANSUhEUgAAAPoAAAACCAIAAAD+T1YeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAErSURBVDhPjVKJkcIwDLQp5Oq4aqiCwqjnisGn1bNamzADY5T9JMdJ5u/zb64xx0Bd64ZKOpLmWrfSY5k7rEovKAOuO12pdLio1SFugN69LdC9N+9WRNkajU19SXh3ezu3NlrLxfN+Si9abobbctqTsfLy2nNCAV6ClRqwWQwfQyJAbNWpgXw9RXug13eaYA9D990Pi+GDXt4MlsxJfT9UxEh7oNPAqWjY5/SmDqp3/twf9hAsYD8oXoHtrxTVX6cozJw0YgGA16eYnTfEqGpZtY+v9euA607tRMClsDcqMgT15eWot9g2KmoCPAFufdErImm1YNNWkpAz58reKWIl1aJyNmq4kjibZgSwhecPmoCZwwpRlM7QCkBXelMJEOL3GSOlb1aAcKV3jn9pV4H5lbt2CAAAAABJRU5ErkJggg==",
	["sun"] = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsEAAA7BAbiRa+0AAABDSURBVDhPYxjm4D8UQLlYAROUJhvADSBkEzJAVoviAmIMwasGJAkCUC4GgEoT7dIhAhiR/cQIBCAalz8JyY9MwMAAAD1vM9woL+kbAAAAAElFTkSuQmCC",
	["toggle"] = "iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsIAAA7CARUoSoAAAAFcSURBVEhL1ZU7TgMxEIbXJEEIRAECkRU3QCIHoKGEKingmFwCiZqCIkcIDRJIFCBey/f7ETms1wVaF/mkXx7PyDNrrx/V2mN8m6Rpmmw8YIxpvNmilYCkQ5pdtOdb9XN8oVf0rJZi6rch8QCN0RT9F41VjoFP68AxRKeoLybIztxgqNoJepAj4hot0IftpdESb6Ia3cgRMUFzFRhjPFqXQ4lv0Qv6liPBCO2jA9tz6/+DzlBcqNbyxGt+hbZ9MAnxHXSB3lBAtnyHSDkCUw2ICV+UhPgIKVEXitXOdMQFVDm7JYkfofjL/6LYMVrOYsOPFfoPXWse0Ay3nJlEMZ2f5T+NCxQhLqCttnpA2jyhd2cmUUw7SrkcfqkCvf9kzWDmhlvO8XVuU+6ZT5o7dInimciW7x7pLARmxQ9a8avCWhTp+7JTrtUzhaPIdV38wck+iRTLxgO5J3PdqapfopuE8vs9Z0gAAAAASUVORK5CYII=",
	["pixel"] = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAMSURBVBhXY/j//z8ABf4C/qc1gYQAAAAASUVORK5CYII="
}

local sounds = {
	["SSG-08"] = "rbxassetid://2476571739",
	["SCAR20"] = "rbxassetid://1112856880",
	["G3SG1"] = "rbxassetid://1112950864",	
	["USP-S"] = "rbxassetid://1112952739",
	["AWP"] = "rbxassetid://1112948895",
	["RIFK7"] = "rbxassetid://9102080552", 
	["Bubble"] = "rbxassetid://9102092728",
	["Minecraft"] = "rbxassetid://5869422451", 
	["Cod"] = "rbxassetid://160432334",
	["Bameware"] = "rbxassetid://6565367558", 
	["Neverlose"] = "rbxassetid://6565370984", 
	["Gamesense"] = "rbxassetid://4817809188", 
	["Rust"] = "rbxassetid://6565371338"
}

local part_list = {"Head", "UpperTorso", "LowerTorso", "LeftFoot", "LeftUpperLeg", "RightFoot", "RightUpperLeg", "LeftHand", "LeftUpperArm", "RightHand", "RightUpperArm"}
local limb_descriptions = {
	["Head"] = "HeadColor",
	["UpperTorso"] = "TorsoColor",
	["LowerTorso"] = "TorsoColor",
	["LeftFoot"] = "LeftLegColor",
	["LeftLowerLeg"] = "LeftLegColor",
	["LeftUpperLeg"] = "LeftLegColor",
	["RightFoot"] = "RightLegColor",
	["RightLowerLeg"] = "RightLegColor",
	["RightUpperLeg"] = "RightLegColor",
	["LeftHand"] = "LeftArmColor",
	["LeftLowerArm"] = "LeftArmColor",
	["LeftUpperArm"] = "LeftArmColor",
	["RightHand"] = "RightArmColor",
	["RightLowerArm"] = "RightArmColor",
	["RightUpperArm"] = "RightArmColor",
}

LPH_JIT_MAX(function()
	for _, v in lplr:GetDescendants() do
		if v.Name == "Framework" then
			pcall(function()
				arg = string.match(getscriptbytecode(v), [[LookVector(.-)IsMobile]])
			end)
			break
		end
	end
end)()

if not arg or #arg < 2 then
	if getgenv().Xeno then
		arg = "UpdateMousePosI2"
	else
		lplr:Kick("juju > if the game updated recently, please wait for an update")
		return
	end
end

do
	for _, image in images do
		images[_] = crypt.base64.decode(image)
	end
end

local utility = {
	connections = {},
	is_dragging_blocked = false
}

do
	local newInstance = Instance.new
	local keybindBlacklist = {
		Enum.KeyCode.Escape,
		Enum.KeyCode.Tilde,
	}

	utility.lerp = LPH_NO_VIRTUALIZE(function(initial, new, elapsed)
        return initial + (new - initial) * elapsed
    end)

	utility.newConnection = function(signal, callback)
		local connection = signal:Connect(callback)

		utility.connections[#utility.connections+1] = connection

		return connection
	end

	utility.copyTable = function(original)
		local copy = {}
		for _, v in pairs(original) do
			if type(v) == "table" then
				v = utility.copyTable(v)
			end
			copy[_] = v
		end
		return copy
	end

	utility.removeBrackets = function(string)
		return lower(string):gsub('[%p%c%s]', '')
	end

	utility.round = LPH_NO_VIRTUALIZE(function(num, decimals)
		local mult = 10^(decimals or 0)
		return floor(num * mult + 0.5) / mult
	end)

	utility.find = LPH_NO_VIRTUALIZE(function(array, find)
		for _, obj in array do
			if find == obj then return  _ end
		end
	end)

	utility.insert = LPH_NO_VIRTUALIZE(function(array, _)
		local new = #array+1
		array[new] = _
		return new
	end)

	utility.isValidKey = function(keycode)
		if utility.find(keybindBlacklist, keycode) then
			return false
		end
		return true
	end

	utility.length = function(array)
		local length = 0
		for _, obj in array do length+=1 end
		return length
	end

	utility.remove = function(array, _, z)
		local pos = utility.find(array, _) or z

		if not pos then
			return end

		for i = pos, #array - 1 do
			array[i] = array[i + 1]
		end
		array[#array] = nil
	end

	utility.newDrawing = function(class, properties)
		local object = Drawing.new(class)

		for property, value in properties do
			object[property] = value
		end

		return object
	end

	local createTween = tws.Create
	utility.tween = LPH_NO_VIRTUALIZE(function(...)
		createTween(tws, ...):Play()
	end)

	utility.setDraggable = LPH_NO_VIRTUALIZE(function(object)
		local drag_connection = nil
		local drag_stop_connection = nil
	
		utility.newConnection(object.InputBegan, function(input, gpe)
			if gpe then
				return end
			
			if (input["UserInputType"] == Enum.UserInputType.MouseButton1 or input["UserInputType"] == Enum.UserInputType.Touch) and not utility["is_dragging_blocked"] then
				local window_start_x_position = object["Position"]["X"]["Scale"]
				local window_start_y_position = object["Position"]["Y"]["Scale"]
				local mouse_start_position = (getMouseLocation(uis)/camera["ViewportSize"])
				local mouse_start_x_position = mouse_start_position["X"]
				local mouse_start_y_position = mouse_start_position["Y"]
	
				drag_connection = utility.newConnection(mouse["Move"], function()
					local mouse_position = (getMouseLocation(uis)/camera["ViewportSize"])
					object["Position"] = UDim2.new(window_start_x_position - (mouse_start_x_position - mouse_position["X"]), 0, window_start_y_position - (mouse_start_y_position - mouse_position["Y"]), 0)
				end)
	
				drag_stop_connection = utility.newConnection(uis.InputEnded, function(input, gpe)
					if input["UserInputType"] == Enum.UserInputType.MouseButton1 or input["UserInputType"] == Enum.UserInputType.Touch then
						drag_stop_connection:Disconnect()
						drag_connection:Disconnect()
					end
				end)
			end
		end)
	end)

	utility.isInFrame = function(object, pos)
		local abs_pos = object.AbsolutePosition
		local abs_size = object.AbsoluteSize
		local x = abs_pos.Y <= pos.Y and pos.Y <= abs_pos.Y + abs_size.Y
		local y = abs_pos.X <= pos.X and pos.X <= abs_pos.X + abs_size.X

		return (x and y)
	end


	utility.newObject = function(class, properties)
		local object = newInstance(class)

		for property, value in properties do
			object[property] = value
		end

		object.Name = properties["Name"] or ""

		return object
	end
end

--[[
       _                       _ 
      (_)                     | |
  ___  _   __ _  _ __    __ _ | |
 / __|| | / _` || '_ \  / _` || |
 \__ \| || (_| || | | || (_| || |
 |___/|_| \__, ||_| |_| \__,_||_|
           __/ |                 
          |___/                  
]]

local signal = {}
signal.__index = signal

function signal.new()
	return setmetatable({connections = {}}, signal)
end

function signal:Fire(...)
	for _, callback in self.connections do
		spawn(callback, ...)
	end
end

function signal:Connect(callback)
	local connection = {}
	local connections = self.connections 

	local index = utility.insert(connections, callback)

	function connection:Disconnect()
		utility.remove(connections, "", index)
		setmetatable(connection, nil)
	end

	return connection
end

--[[
         _    _  _  _                              
        (_)  | |(_)| |                             
  _   _  _   | | _ | |__   _ __  __ _  _ __  _   _ 
 | | | || |  | || || '_ \ | '__|/ _` || '__|| | | |
 | |_| || |  | || || |_) || |  | (_| || |   | |_| |
  \__,_||_|  |_||_||_.__/ |_|   \__,_||_|    \__, |
                                              __/ |
                                             |___/ 
]]

local config_location = "juju"

if not isfolder("juju") then
	makefolder("juju")
end

if not isfolder("juju/configs") then
	makefolder("juju/configs")
end

if not isfolder("juju/addons") then
	makefolder("juju/addons")
end

if not isfolder("juju/assets") then
	makefolder("juju/assets")
end

local menu = {
	on_closing = signal.new(),
	on_opening = signal.new(),
	on_tab_switch = signal.new(),
	on_load = signal.new(),
	toggle = "INSERT",
	busy = false,
	is_open = true,
	flags = {
		loaded_scripts = {}
	},
	active_keybind = nil,
	active_colorpicker = nil,
	accent_color = colorfromrgb(153, 196, 39),
	on_accent_change = signal.new(),
	blocked = false,
	animation_speed = 0.15,
	keybinds = {}
}

local window = {}
window.__index = window
local tab = {}
tab.__index = tab
local section = {}
section.__index = section
local element = {}
element.__index = element
local toggle = {}
toggle.__index = toggle

local flags = menu.flags
local isInFrame = utility.isInFrame
local newObject = utility.newObject
local find = utility.find
local insert = utility.insert
local remove = utility.remove
local round = utility.round
local tween = utility.tween
local length = utility.length
local lerp = utility.lerp

-----------------
-- * Configs * --
-----------------

utility.saveConfig = LPH_NO_VIRTUALIZE(function(name)
	local new_flags = utility.copyTable(flags)
	for flag, info in new_flags do
		if typeof(info) == "Color3" then
			new_flags[flag] = {utility.round(info.R*255, 0), utility.round(info.G*255, 0), utility.round(info.B*255, 0)}
		elseif typeof(info) == "table" and info["key"] then
			new_flags[flag]["key"] = info["key"].Name
		end
	end
	writefile(config_location.."/configs/"..name..".cfg", hs:JSONEncode(new_flags))
end)

utility.convertConfig = LPH_NO_VIRTUALIZE(function(name)
	local config = isfile(config_location.."/configs/"..name..".cfg")

	if not config then
		return end

	config = readfile(config_location.."/configs/"..name..".cfg")

	local config = hs:JSONDecode(config)
	if config then
		for flag, info in config do
			if typeof(info) == "table" then
				if typeof(info[1]) == "number" then
					if info[3] then
						config[flag] = colorfromrgb(info[1], info[2], info[3])
					else
						config[flag] = info
					end
				elseif info["key"] then
					config[flag]["key"] = info["key"]:find("Mouse") and Enum.UserInputType[info["key"]] or Enum.KeyCode[info["key"]]
				end
			end
		end
	end

	return config
end)

utility.loadConfig = LPH_NO_VIRTUALIZE(function(config)
	if not config then
		return end

	for flag, info in config do
		menu.flags[flag] = config[flag]
	end

	return config
end)

utility.getConfigList = LPH_NO_VIRTUALIZE(function()
	local list = {}
	for _, config in listfiles(config_location.."/configs/") do
		utility.insert(list, string.sub(config, #(config_location.."/configs/")+1, #config-4))
	end
	return list
end)

utility.getScriptList = LPH_NO_VIRTUALIZE(function()
	local list = {}
	for _, config in listfiles(config_location.."/addons/") do
		utility.insert(list, string.sub(config, #(config_location.."/addons/")+1, #config-4))
	end
	return list
end)

local _screenGui = nil
local menu_references = {}
local tween_info = newtweeninfo(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In)

do
	local menu_font, menu_font_bold
	if identifyexecutor() ~= "Macsploit" then
		local path = hs:GenerateGUID(false)..".txt"

		writefile("temp.ttf", "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/wADAAQAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwA7AD8AQwBHAEsATwBTAFcAWwBfAGMAZwBrAG8AABE1MxUxNTMVMTUzFTE1MxUxNTMVMTUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVMTUzFTE1MxUxNTMVMTUzFTE1MxWAgICAgID9AIACAID9AIACAID9AIACAID9AIACAID9AIACAID9AIACAID9AIACAID9AIACAID9AICAgICAgAOAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAAABgEAAAABgAOAAAMABwALAA8AEwAXAAABNTMVBzUzFQc1MxUHNTMVBzUzFQM1MxUBAICAgICAgICAgICAAwCAgICAgICAgICAgICAgP8AgIAAAAAABgCAAoACAAQAAAMABwALAA8AEwAXAAATNTMVMzUzFQU1MxUzNTMVBTUzFTM1MxWAgICA/oCAgID+gICAgAOAgICAgICAgICAgICAgIAAAAASAAAAAAKAAwAAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3ADsAPwBDAEcAABM1MxUzNTMVBTUzFTE1MxUxNTMVMTUzFTE1MxUFNTMVMzUzFQU1MxUzNTMVBTUzFTE1MxUxNTMVMTUzFTE1MxUFNTMVMzUzFYCAgID+AICAgICA/gCAgID+gICAgP4AgICAgID+AICAgAKAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAEQAAAAACgAOAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwA7AD8AQwAAATUzFQU1MxUxNTMVMTUzFTE1MxUFNTMVMzUzFQU1MxUxNTMVMTUzFQU1MxUzNTMVBTUzFTE1MxUxNTMVMTUzFQU1MxUBAID/AICAgID9gICAgP8AgICA/wCAgID9gICAgID/AIADAICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAAADgAAAAADAAMAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwAAEzUzFSE1MxUFNTMVMzUzFTM1MxUFNTMVMzUzFQU1MxUzNTMVBTUzFTM1MxUzNTMVBTUzFSE1MxWAgAGAgP0AgICAgID+AICAgP8AgICA/gCAgICAgP0AgAGAgAKAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAAAEQAAAAADAAOAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwA7AD8AQwAAEzUzFTE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFTE1MxUFNTMVITUzFTM1MxUFNTMVITUzFQU1MxUxNTMVMTUzFTM1MxWAgID+gIABAID+AIABAID+gICA/oCAAQCAgID9AIABgID+AICAgICAAwCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAMBAAKAAYAEAAADAAcACwAAATUzFQc1MxUHNTMVAQCAgICAgAOAgICAgICAgIAAAAkAgP+AAgAEAAADAAcACwAPABMAFwAbAB8AIwAAATUzFQU1MxUFNTMVBzUzFQc1MxUHNTMVBzUzHQE1Mx0BNTMVAYCA/wCA/wCAgICAgICAgICAgAOAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAAACQCA/4ACAAQAAAMABwALAA8AEwAXABsAHwAjAAATNTMdATUzHQE1MxUHNTMVBzUzFQc1MxUHNTMVBTUzFQU1MxWAgICAgICAgICAgID/AID/AIADgICAgICAgICAgICAgICAgICAgICAgICAgICAAAsAAACAAoADAAADAAcACwAPABMAFwAbAB8AIwAnACsAAAE1MxUFNTMVMzUzFTM1MxUFNTMVMTUzFTE1MxUFNTMVMzUzFTM1MxUFNTMVAQCA/oCAgICAgP4AgICA/gCAgICAgP6AgAKAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAkAAACAAoADAAADAAcACwAPABMAFwAbAB8AIwAAATUzFQc1MxUFNTMVMTUzFTE1MxUxNTMVMTUzFQU1MxUHNTMVAQCAgID+gICAgICA/oCAgIACgICAgICAgICAgICAgICAgICAgICAgIAAAAIAgP+AAYAAgAADAAcAACE1MxUFNTMVAQCA/wCAgICAgIAAAAUAAAGAAoACAAADAAcACwAPABMAABE1MxUxNTMVMTUzFTE1MxUxNTMVgICAgIABgICAgICAgICAgIAAAAEBAAAAAYAAgAADAAAhNTMVAQCAgIAAAAkAAP+AAoAEAAADAAcACwAPABMAFwAbAB8AIwAAATUzFQc1MxUFNTMVBzUzFQU1MxUHNTMVBTUzFQc1MxUFNTMVAgCAgID/AICAgP8AgICA/wCAgID/AIADgICAgICAgICAgICAgICAgICAgICAgICAgICAAAAAABEAAAAAAoADgAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAOwA/AEMAABM1MxUxNTMVMTUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVMzUzFTM1MxUFNTMVITUzFQU1MxUhNTMVBTUzFTE1MxUxNTMVgICAgP4AgAGAgP2AgAGAgP2AgICAgID9gIABgID9gIABgID+AICAgAMAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAKAIAAAAIAA4AAAwAHAAsADwATABcAGwAfACMAJwAAATUzFQU1MxUxNTMVBzUzFQc1MxUHNTMVBzUzFQU1MxUxNTMVMTUzFQEAgP8AgICAgICAgICAgP8AgICAAwCAgICAgICAgICAgICAgICAgICAgICAgICAgAAPAAAAAAKAA4AAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3ADsAABM1MxUxNTMVMTUzFQU1MxUhNTMVBzUzFQU1MxUxNTMVBTUzFQU1MxUHNTMVMTUzFTE1MxUxNTMVMTUzFYCAgID+AIABgICAgP6AgID+gID/AICAgICAgIADAICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAOAAAAAAKAA4AAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3AAATNTMVMTUzFTE1MxUFNTMVITUzFQc1MxUFNTMVMTUzHQE1MxUFNTMVITUzFQU1MxUxNTMVMTUzFYCAgID+AIABgICAgP6AgICA/YCAAYCA/gCAgIADAICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAADgAAAAACgAOAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwAAATUzFQU1MxUxNTMVBTUzFTM1MxUFNTMVITUzFQU1MxUxNTMVMTUzFTE1MxUxNTMVBTUzFQc1MxUBgID/AICA/oCAgID+AIABAID+AICAgICA/wCAgIADAICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAARAAAAAAKAA4AAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3ADsAPwBDAAARNTMVMTUzFTE1MxUxNTMVMTUzFQU1MxUHNTMVBzUzFTE1MxUxNTMVMTUzHQE1MxUFNTMVITUzFQU1MxUxNTMVMTUzFYCAgICA/YCAgICAgICAgID9gIABgID+AICAgAMAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAADwAAAAACgAOAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwA7AAABNTMVMTUzFQU1MxUFNTMVBzUzFTE1MxUxNTMVMTUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVMTUzFTE1MxUBAICA/oCA/wCAgICAgID+AIABgID9gIABgID+AICAgAMAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAsAAAAAAoADgAADAAcACwAPABMAFwAbAB8AIwAnACsAABE1MxUxNTMVMTUzFTE1MxUxNTMVBzUzFQU1MxUHNTMVBTUzFQc1MxUFNTMVgICAgICAgP8AgICA/wCAgID/AIADAICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAEQAAAAACgAOAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwA7AD8AQwAAEzUzFTE1MxUxNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUxNTMVMTUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVMTUzFTE1MxWAgICA/gCAAYCA/YCAAYCA/gCAgID+AIABgID9gIABgID+AICAgAMAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAAAA8AAAAAAoADgAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAOwAAEzUzFTE1MxUxNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUxNTMVMTUzFTE1MxUHNTMVBTUzFQU1MxUxNTMVgICAgP4AgAGAgP2AgAGAgP4AgICAgICA/wCA/oCAgAMAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAACAQAAgAGAAoAAAwAHAAABNTMVAzUzFQEAgICAAgCAgP6AgIAAAAAAAwCAAAABgAKAAAMABwALAAABNTMVAzUzFQU1MxUBAICAgP8AgAIAgID+gICAgICAAAAAAAgAAACAAoADAAADAAcACwAPABMAFwAbAB8AAAE1MxUFNTMVMTUzFQU1MxUxNTMdATUzFTE1Mx0BNTMVAgCA/oCAgP4AgICAgIACgICAgICAgICAgICAgICAgICAgICAAAoAAAEAAoACgAADAAcACwAPABMAFwAbAB8AIwAnAAARNTMVMTUzFTE1MxUxNTMVMTUzFQE1MxUxNTMVMTUzFTE1MxUxNTMVgICAgID9gICAgICAAgCAgICAgICAgICA/wCAgICAgICAgICAAAgAAACAAoADAAADAAcACwAPABMAFwAbAB8AABE1Mx0BNTMVMTUzHQE1MxUxNTMVBTUzFTE1MxUFNTMVgICAgID+AICA/oCAAoCAgICAgICAgICAgICAgICAgICAgAAAAAkAAAAAAoADgAADAAcACwAPABMAFwAbAB8AIwAAEzUzFTE1MxUxNTMVBTUzFSE1MxUHNTMVBTUzFQU1MxUDNTMVgICAgP4AgAGAgICA/wCA/wCAgIADAICAgICAgICAgICAgICAgICAgICA/wCAgAAZAAAAAAMAA4AAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3ADsAPwBDAEcASwBPAFMAVwBbAF8AYwAAEzUzFTE1MxUxNTMVMTUzFQU1MxUhNTMVBTUzFTM1MxUxNTMVMzUzFQU1MxUzNTMVMTUzFTM1MxUFNTMVMzUzFTE1MxUxNTMVMTUzFQU1Mx0BNTMVMTUzFTE1MxUxNTMVMTUzFYCAgICA/YCAAgCA/QCAgICAgID9AICAgICAgP0AgICAgICA/QCAgICAgIADAICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAANAAAAAAKAA4AAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwAAATUzFQc1MxUFNTMVMzUzFQU1MxUzNTMVBTUzFTE1MxUxNTMVBTUzFSE1MxUFNTMVITUzFQEAgICA/wCAgID+gICAgP6AgICA/gCAAYCA/YCAAYCAAwCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAUAAAAAAKAA4AAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3ADsAPwBDAEcASwBPAAARNTMVMTUzFTE1MxUxNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUxNTMVMTUzFTE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFTE1MxUxNTMVMTUzFYCAgID+AIABgID9gIABgID9gICAgID+AIABgID9gIABgID9gICAgIADAICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAADQAAAAACgAOAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMAABM1MxUxNTMVMTUzFQU1MxUhNTMVBTUzFQc1MxUHNTMVBzUzFSE1MxUFNTMVMTUzFTE1MxWAgICA/gCAAYCA/YCAgICAgICAAYCA/gCAgIADAICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAAQAAAAAAKAA4AAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3ADsAPwAAETUzFTE1MxUxNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUxNTMVMTUzFYCAgP6AgAEAgP4AgAGAgP2AgAGAgP2AgAGAgP2AgAEAgP4AgICAAwCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAAABIAAAAAAoADgAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAOwA/AEMARwAAETUzFTE1MxUxNTMVMTUzFTE1MxUFNTMVBzUzFQc1MxUxNTMVMTUzFTE1MxUFNTMVBzUzFQc1MxUxNTMVMTUzFTE1MxUxNTMVgICAgID9gICAgICAgICA/gCAgICAgICAgIADAICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAAAA4AAAAAAoADgAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAABE1MxUxNTMVMTUzFTE1MxUxNTMVBTUzFQc1MxUHNTMVMTUzFTE1MxUxNTMVBTUzFQc1MxUHNTMVgICAgID9gICAgICAgICA/gCAgICAgAMAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAAABEAAAAAAoADgAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAOwA/AEMAABM1MxUxNTMVMTUzFQU1MxUhNTMVBTUzFQc1MxUhNTMVMTUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVMTUzFTE1MxUxNTMVgICAgP4AgAGAgP2AgICAAQCAgP2AgAGAgP2AgAGAgP4AgICAgAMAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAAAAARAAAAAAKAA4AAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3ADsAPwBDAAARNTMVITUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVMTUzFTE1MxUxNTMVMTUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVITUzFYABgID9gIABgID9gIABgID9gICAgICA/YCAAYCA/YCAAYCA/YCAAYCAAwCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAAAAAsAgAAAAgADgAADAAcACwAPABMAFwAbAB8AIwAnACsAABM1MxUxNTMVMTUzFQU1MxUHNTMVBzUzFQc1MxUHNTMVBTUzFTE1MxUxNTMVgICAgP8AgICAgICAgICA/wCAgIADAICAgICAgICAgICAgICAgICAgICAgICAgICAgIAADAAAAAACgAOAAAMABwALAA8AEwAXABsAHwAjACcAKwAvAAABNTMVMTUzFTE1MxUHNTMVBzUzFQc1MxUHNTMVBzUzFQU1MxUxNTMVMTUzFTE1MxUBAICAgICAgICAgICAgID9gICAgIADAICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAAAAAOAAAAAAKAA4AAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3AAARNTMVITUzFQU1MxUhNTMVBTUzFTM1MxUFNTMVMTUzFQU1MxUzNTMVBTUzFSE1MxUFNTMVITUzFYABgID9gIABAID+AICAgP6AgID/AICAgP6AgAEAgP4AgAGAgAMAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAALAAAAAAKAA4AAAwAHAAsADwATABcAGwAfACMAJwArAAARNTMVBzUzFQc1MxUHNTMVBzUzFQc1MxUHNTMVMTUzFTE1MxUxNTMVMTUzFYCAgICAgICAgICAgICAgICAAwCAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAAAABQAAAAAAoADgAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAOwA/AEMARwBLAE8AABE1MxUhNTMVBTUzFSE1MxUFNTMVMTUzFTM1MxUxNTMVBTUzFTE1MxUzNTMVMTUzFQU1MxUzNTMVMzUzFQU1MxUzNTMVMzUzFQU1MxUhNTMVgAGAgP2AgAGAgP2AgICAgID9gICAgICA/YCAgICAgP2AgICAgID9gIABgIADAICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAFQAAAAACgAOAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwA7AD8AQwBHAEsATwBTAAARNTMVMTUzFSE1MxUFNTMVMTUzFSE1MxUFNTMVMzUzFTM1MxUFNTMVMzUzFTM1MxUFNTMVMzUzFTM1MxUFNTMVITUzFTE1MxUFNTMVITUzFTE1MxWAgAEAgP2AgIABAID9gICAgICA/YCAgICAgP2AgICAgID9gIABAICA/YCAAQCAgAMAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAAQAAAAAAKAA4AAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3ADsAPwAAEzUzFTE1MxUxNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUxNTMVMTUzFYCAgID+AIABgID9gIABgID9gIABgID9gIABgID9gIABgID+AICAgAMAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAA8AAAAAAoADgAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAOwAAETUzFTE1MxUxNTMVMTUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVMTUzFTE1MxUxNTMVBTUzFQc1MxUHNTMVgICAgP4AgAGAgP2AgAGAgP2AgICAgP4AgICAgIADAICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAAAAASAAAAAAKAA4AAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3ADsAPwBDAEcAABM1MxUxNTMVMTUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFSE1MxUxNTMVBTUzFTE1MxUxNTMVMTUzFYCAgID+AIABgID9gIABgID9gIABgID9gIABgID9gIABAICA/gCAgICAAwCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAAAEgAAAAACgAOAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwA7AD8AQwBHAAARNTMVMTUzFTE1MxUxNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUxNTMVMTUzFTE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFSE1MxWAgICA/gCAAYCA/YCAAYCA/YCAgICA/gCAAYCA/YCAAYCA/YCAAYCAAwCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAADwAAAAACgAOAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwA7AAATNTMVMTUzFTE1MxUFNTMVITUzFQU1Mx0BNTMVMTUzFTE1Mx0BNTMVBTUzFSE1MxUFNTMVMTUzFTE1MxWAgICA/gCAAYCA/YCAgICAgP2AgAGAgP4AgICAAwCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAACwAAAAACgAOAAAMABwALAA8AEwAXABsAHwAjACcAKwAAETUzFTE1MxUxNTMVMTUzFTE1MxUFNTMVBzUzFQc1MxUHNTMVBzUzFQc1MxWAgICAgP6AgICAgICAgICAgIADAICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAAPAAAAAAKAA4AAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3ADsAABE1MxUhNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUxNTMVMTUzFYABgID9gIABgID9gIABgID9gIABgID9gIABgID9gIABgID+AICAgAMAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAAMAAAAAAKAA4AAAwAHAAsADwATABcAGwAfACMAJwArAC8AABE1MxUhNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUzNTMVBTUzFTM1MxUFNTMVBzUzFYABgID9gIABgID9gIABgID+AICAgP6AgICA/wCAgIADAICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAAEQAAAAACgAOAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwA7AD8AQwAAETUzFSE1MxUFNTMVMzUzFTM1MxUFNTMVMzUzFTM1MxUFNTMVMzUzFTM1MxUFNTMVMzUzFQU1MxUzNTMVBTUzFTM1MxWAAYCA/YCAgICAgP2AgICAgID9gICAgICA/gCAgID+gICAgP6AgICAAwCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAA0AAAAAAoADgAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzAAARNTMVITUzFQU1MxUhNTMVBTUzFTM1MxUFNTMVBTUzFTM1MxUFNTMVITUzFQU1MxUhNTMVgAGAgP2AgAGAgP4AgICA/wCA/wCAgID+AIABgID9gIABgIADAICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAAMAAAAAAKAA4AAAwAHAAsADwATABcAGwAfACMAJwArAC8AABE1MxUhNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUxNTMVMTUzFQU1MxUHNTMVBzUzFYABgID9gIABgID9gIABgID+AICAgP8AgICAgIADAICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAPAAAAAAKAA4AAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3ADsAABE1MxUxNTMVMTUzFTE1MxUxNTMVBzUzFQU1MxUFNTMVBTUzFQU1MxUHNTMVMTUzFTE1MxUxNTMVMTUzFYCAgICAgID/AID/AID/AID/AICAgICAgIADAICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAAAAANAID/gAIABAAAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwAAEzUzFTE1MxUxNTMVBTUzFQc1MxUHNTMVBzUzFQc1MxUHNTMVBzUzFQc1MxUxNTMVMTUzFYCAgID+gICAgICAgICAgICAgICAgICAA4CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAAAAAkAAP+AAoAEAAADAAcACwAPABMAFwAbAB8AIwAAETUzFQc1Mx0BNTMVBzUzHQE1MxUHNTMdATUzFQc1Mx0BNTMVgICAgICAgICAgICAgAOAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAA0AgP+AAgAEAAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzAAATNTMVMTUzFTE1MxUHNTMVBzUzFQc1MxUHNTMVBzUzFQc1MxUHNTMVBTUzFTE1MxUxNTMVgICAgICAgICAgICAgICAgICA/oCAgIADgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAAABQAAAgACgAOAAAMABwALAA8AEwAAATUzFQU1MxUzNTMVBTUzFSE1MxUBAID/AICAgP4AgAGAgAMAgICAgICAgICAgICAAAAABgAA/4ADAAAAAAMABwALAA8AEwAXAAAVNTMVMTUzFTE1MxUxNTMVMTUzFTE1MxWAgICAgICAgICAgICAgICAgICAAAACAQACgAIAA4AAAwAHAAABNTMdATUzFQEAgIADAICAgICAAAAOAAAAAAKAAoAAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3AAATNTMVMTUzFTE1Mx0BNTMVBTUzFTE1MxUxNTMVMTUzFQU1MxUhNTMVBTUzFTE1MxUxNTMVMTUzFYCAgICA/gCAgICA/YCAAYCA/gCAgICAAgCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAAAAARAAAAAAKABAAAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3ADsAPwBDAAARNTMVBzUzFQc1MxUHNTMVMTUzFTE1MxUxNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFTE1MxUxNTMVMTUzFYCAgICAgICAgID+AIABgID9gIABgID9gIABgID9gICAgIADgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAALAAAAAAKAAoAAAwAHAAsADwATABcAGwAfACMAJwArAAATNTMVMTUzFTE1MxUxNTMVBTUzFQc1MxUHNTMdATUzFTE1MxUxNTMVMTUzFYCAgICA/YCAgICAgICAgIACAICAgICAgICAgICAgICAgICAgICAgICAgICAAAAAEQAAAAACgAQAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwA7AD8AQwAAATUzFQc1MxUHNTMVBTUzFTE1MxUxNTMVMTUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUxNTMVMTUzFTE1MxUCAICAgICA/gCAgICA/YCAAYCA/YCAAYCA/YCAAYCA/gCAgICAA4CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAAAA8AAAAAAoACgAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAOwAAEzUzFTE1MxUxNTMVBTUzFSE1MxUFNTMVMTUzFTE1MxUxNTMVMTUzFQU1Mx0BNTMVMTUzFTE1MxUxNTMVgICAgP4AgAGAgP2AgICAgID9gICAgICAAgCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAAADQAAAAACgAQAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMAAAE1MxUxNTMVMTUzFQU1MxUHNTMVBTUzFTE1MxUxNTMVMTUzFQU1MxUHNTMVBzUzFQc1MxUBAICAgP4AgICA/wCAgICA/oCAgICAgICAA4CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAARAAD/AAKAAoAAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3ADsAPwBDAAATNTMVMTUzFTE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVMTUzFTE1MxUxNTMVBzUzFQU1MxUxNTMVMTUzFYCAgID+AIABgID9gIABgID9gIABgID+AICAgICAgP4AgICAAgCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAAPAAAAAAKABAAAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3ADsAABE1MxUHNTMVBzUzFQc1MxUxNTMVMTUzFTE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVITUzFYCAgICAgICAgID+AIABgID9gIABgID9gIABgID9gIABgIADgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAcAgAAAAYADgAADAAcACwAPABMAFwAbAAABNTMVATUzFTE1MxUHNTMVBzUzFQc1MxUHNTMVAQCA/wCAgICAgICAgICAAwCAgP8AgICAgICAgICAgICAgICAgAAACwAA/wACAAOAAAMABwALAA8AEwAXABsAHwAjACcAKwAAATUzFQE1MxUxNTMVBzUzFQc1MxUHNTMVBzUzFQc1MxUFNTMVMTUzFTE1MxUBgID/AICAgICAgICAgICAgP4AgICAAwCAgP8AgICAgICAgICAgICAgICAgICAgICAgICAgIAADQCAAAACgAQAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMAABM1MxUHNTMVBzUzFQc1MxUhNTMVBTUzFTM1MxUFNTMVMTUzFQU1MxUzNTMVBTUzFSE1MxWAgICAgICAgAEAgP4AgICA/oCAgP8AgICA/oCAAQCAA4CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAACQCAAAABgAQAAAMABwALAA8AEwAXABsAHwAjAAATNTMVMTUzFQc1MxUHNTMVBzUzFQc1MxUHNTMVBzUzFQc1MxWAgICAgICAgICAgICAgICAgAOAgICAgICAgICAgICAgICAgICAgICAgICAgAAAAA8AAAAAAoACgAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAOwAAETUzFTE1MxUzNTMVBTUzFTM1MxUzNTMVBTUzFTM1MxUzNTMVBTUzFTM1MxUzNTMVBTUzFTM1MxUzNTMVgICAgP4AgICAgID9gICAgICA/YCAgICAgP2AgICAgIACAICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAAMAAAAAAKAAoAAAwAHAAsADwATABcAGwAfACMAJwArAC8AABE1MxUxNTMVMTUzFTE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVITUzFYCAgID+AIABgID9gIABgID9gIABgID9gIABgIACAICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAAMAAAAAAKAAoAAAwAHAAsADwATABcAGwAfACMAJwArAC8AABM1MxUxNTMVMTUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUxNTMVMTUzFYCAgID+AIABgID9gIABgID9gIABgID+AICAgAIAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAAAAAQAAD/AAKAAoAAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3ADsAPwAAETUzFTE1MxUxNTMVMTUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUxNTMVMTUzFTE1MxUFNTMVBzUzFYCAgID+AIABgID9gIABgID9gIABgID9gICAgID+AICAgAIAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAAAEAAA/wACgAKAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwA7AD8AABM1MxUxNTMVMTUzFTE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVMTUzFTE1MxUxNTMVBzUzFQc1MxWAgICAgP2AgAGAgP2AgAGAgP2AgAGAgP4AgICAgICAgIACAICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAAAAAkAAAAAAoACgAADAAcACwAPABMAFwAbAB8AIwAAETUzFTM1MxUxNTMVBTUzFTE1MxUhNTMVBTUzFQc1MxUHNTMVgICAgP4AgIABAID9gICAgICAAgCAgICAgICAgICAgICAgICAgICAgICAAA0AAAAAAoACgAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzAAATNTMVMTUzFTE1MxUxNTMVBTUzHQE1MxUxNTMVMTUzHQE1MxUFNTMVMTUzFTE1MxUxNTMVgICAgID9gICAgICA/YCAgICAAgCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAACwCAAAACgAOAAAMABwALAA8AEwAXABsAHwAjACcAKwAAEzUzFQc1MxUHNTMVMTUzFTE1MxUFNTMVBzUzFQc1Mx0BNTMVMTUzFTE1MxWAgICAgICAgP6AgICAgICAgIADAICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAAMAAAAAAKAAoAAAwAHAAsADwATABcAGwAfACMAJwArAC8AABE1MxUhNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFTE1MxUxNTMVMTUzFYABgID9gIABgID9gIABgID9gIABgID+AICAgIACAICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAAJAAAAAAKAAoAAAwAHAAsADwATABcAGwAfACMAABE1MxUhNTMVBTUzFSE1MxUFNTMVMzUzFQU1MxUzNTMVBTUzFYABgID9gIABgID+AICAgP6AgICA/wCAAgCAgICAgICAgICAgICAgICAgICAgICAAAAAAAwAAAAAAoACgAADAAcACwAPABMAFwAbAB8AIwAnACsALwAAETUzFSE1MxUFNTMVMzUzFTM1MxUFNTMVMzUzFTM1MxUFNTMVMzUzFQU1MxUzNTMVgAGAgP2AgICAgID9gICAgICA/gCAgID+gICAgAIAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAAAAkAAAAAAoACgAADAAcACwAPABMAFwAbAB8AIwAAETUzFSE1MxUFNTMVMzUzFQU1MxUFNTMVMzUzFQU1MxUhNTMVgAGAgP4AgICA/wCA/wCAgID+AIABgIACAICAgICAgICAgICAgICAgICAgICAgIAAAAAAEAAA/wACgAKAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwA7AD8AABE1MxUhNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFTE1MxUxNTMVMTUzFQc1MxUFNTMVMTUzFTE1MxWAAYCA/YCAAYCA/YCAAYCA/YCAAYCA/gCAgICAgID+AICAgAIAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAA0AAAAAAoACgAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzAAARNTMVMTUzFTE1MxUxNTMVMTUzFQU1MxUFNTMVBTUzFQU1MxUxNTMVMTUzFTE1MxUxNTMVgICAgID/AID/AID/AID/AICAgICAAgCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAkAgP+AAgAEAAADAAcACwAPABMAFwAbAB8AIwAAATUzFQU1MxUHNTMVBzUzFQU1Mx0BNTMVBzUzFQc1Mx0BNTMVAYCA/wCAgICAgP8AgICAgICAgAOAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAAACQEA/4ABgAQAAAMABwALAA8AEwAXABsAHwAjAAABNTMVBzUzFQc1MxUHNTMVBzUzFQc1MxUHNTMVBzUzFQc1MxUBAICAgICAgICAgICAgICAgICAA4CAgICAgICAgICAgICAgICAgICAgICAgICAgAAAAAAJAID/gAIABAAAAwAHAAsADwATABcAGwAfACMAABM1Mx0BNTMVBzUzFQc1Mx0BNTMVBTUzFQc1MxUHNTMVBTUzFYCAgICAgICA/wCAgICAgP8AgAOAgICAgICAgICAgICAgICAgICAgICAgICAgIAABgAAAQADAAIAAAMABwALAA8AEwAXAAATNTMVMTUzFSE1MxUFNTMVITUzFTE1MxWAgIABAID9AIABAICAAYCAgICAgICAgICAgICAABMAAAAAAwADgAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAOwA/AEMARwBLAAABNTMVMTUzFTE1MxUFNTMVITUzFQU1MxUxNTMVMTUzFTE1MxUFNTMVBTUzFTE1MxUxNTMVMTUzFQU1MxUhNTMVBTUzFTE1MxUxNTMVAQCAgID+AIABgID9AICAgID+gID/AICAgID+gIABgID+AICAgAMAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAAAAgEA/4ACAACAAAMABwAAITUzFQU1MxUBgID/AICAgICAgAAADQCA/wACgAQAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMAAAE1MxUxNTMVBTUzFQc1MxUFNTMVMTUzFTE1MxUFNTMVBzUzFQc1MxUHNTMVBzUzFQU1MxUBgICA/oCAgID/AICAgP8AgICAgICAgICA/wCAA4CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAABACA/4ACAACAAAMABwALAA8AADM1MxUzNTMVBTUzFTM1MxWAgICA/oCAgICAgICAgICAgIAAAAADAAAAAAKAAIAAAwAHAAsAADE1MxUzNTMVMzUzFYCAgICAgICAgICAAAAAAA0AAP+AAoAEAAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzAAABNTMVBzUzFQU1MxUxNTMVMTUzFTE1MxUxNTMVBTUzFQc1MxUHNTMVBzUzFQc1MxUHNTMVAQCAgID+gICAgICA/oCAgICAgICAgICAgAOAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAAEQAA/4ACgAQAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwA7AD8AQwAAATUzFQc1MxUFNTMVMTUzFTE1MxUxNTMVMTUzFQU1MxUFNTMVMTUzFTE1MxUxNTMVMTUzFQU1MxUHNTMVBzUzFQc1MxUBAICAgP6AgICAgID+gID+gICAgICA/oCAgICAgICAA4CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAAAAwCAAwACAAQAAAMABwALAAABNTMVBTUzFTM1MxUBAID/AICAgAOAgICAgICAgAAACwAAAIADAAMAAAMABwALAA8AEwAXABsAHwAjACcAKwAAEzUzFSE1MxUFNTMVMzUzFQU1MxUFNTMVMzUzFTM1MxUFNTMVITUzFTM1MxWAgAEAgP4AgICA/wCA/wCAgICAgP0AgAEAgICAAoCAgICAgICAgICAgICAgICAgICAgICAgICAgAAAABIAAAAAAoAEAAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAOwA/AEMARwAAEzUzFTM1MxUFNTMVATUzFTE1MxUxNTMVMTUzFQU1MxUHNTMVMTUzFTE1MxUxNTMVMTUzFQc1MxUFNTMVMTUzFTE1MxUxNTMVgICAgP8AgP8AgICAgP2AgICAgICAgICA/YCAgICAA4CAgICAgICA/wCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAAFAIAAAAIAAoAAAwAHAAsADwATAAABNTMVBTUzFQU1Mx0BNTMdATUzFQGAgP8AgP8AgICAAgCAgICAgICAgICAgICAgAAAAAATAAAAAAMAA4AAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3ADsAPwBDAEcASwAAEzUzFTE1MxUzNTMVMTUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVITUzFTE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFTE1MxUzNTMVMTUzFYCAgICAgP0AgAEAgP4AgAEAgP4AgAEAgID9gIABAID+AIABAID+gICAgICAAwCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAQAAAAAAKABAAAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3ADsAPwAAEzUzFTM1MxUFNTMVATUzFTE1MxUxNTMVMTUzFTE1MxUFNTMVBTUzFQU1MxUFNTMVMTUzFTE1MxUxNTMVMTUzFYCAgID/AID+gICAgICA/wCA/wCA/wCA/wCAgICAgAOAgICAgICAgP8AgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAADAQACgAIABAAAAwAHAAsAAAE1MxUHNTMdATUzFQEAgICAgAOAgICAgICAgIAAAAADAQACgAIABAAAAwAHAAsAAAE1MxUHNTMVBTUzFQGAgICA/wCAA4CAgICAgICAgAAGAIACgAKABAAAAwAHAAsADwATABcAABM1MxUzNTMVBTUzFTM1MxUFNTMVMzUzFYCAgID+gICAgP8AgICAA4CAgICAgICAgICAgICAgAAAAAYAgAKAAoAEAAADAAcACwAPABMAFwAAATUzFTM1MxUFNTMVMzUzFQU1MxUzNTMVAQCAgID+gICAgP4AgICAA4CAgICAgICAgICAgICAgAAABAEAAQACAAIAAAMABwALAA8AAAE1MxUxNTMVBTUzFTE1MxUBAICA/wCAgAGAgICAgICAgICAAAAFAAABAAKAAYAAAwAHAAsADwATAAARNTMVMTUzFTE1MxUxNTMVMTUzFYCAgICAAQCAgICAgICAgICAAAAGAAABAAMAAYAAAwAHAAsADwATABcAABE1MxUxNTMVMTUzFTE1MxUxNTMVMTUzFYCAgICAgAEAgICAgICAgICAgICAAAQAgAEAAoACAAADAAcACwAPAAABNTMVMzUzFQU1MxUzNTMVAQCAgID+AICAgAGAgICAgICAgICAAAAAABAAAACAAwACgAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAOwA/AAARNTMVMTUzFTE1MxUxNTMVMTUzFTE1MxUFNTMVMzUzFTE1MxUxNTMVBTUzFTM1MxUzNTMVBTUzFTM1MxUzNTMVgICAgICA/YCAgICAgP2AgICAgID9gICAgICAAgCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAQAAAAAAKABAAAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3ADsAPwAAEzUzFTM1MxUFNTMVATUzFTE1MxUxNTMVMTUzFQU1Mx0BNTMVMTUzFTE1Mx0BNTMVBTUzFTE1MxUxNTMVMTUzFYCAgID/AID/AICAgID9gICAgICA/YCAgICAA4CAgICAgICA/wCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAUBAAAAAoACgAADAAcACwAPABMAAAE1Mx0BNTMdATUzFQU1MxUFNTMVAQCAgID/AID/AIACAICAgICAgICAgICAgICAAAAAAA8AAAAAAwACgAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAOwAAEzUzFTE1MxUzNTMVMTUzFQU1MxUhNTMVBTUzFSE1MxUxNTMVBTUzFSE1MxUFNTMVMTUzFTM1MxUxNTMVgICAgICA/QCAAQCA/gCAAQCAgP2AgAEAgP6AgICAgIACAICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAAQAAAAAAKABAAAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3ADsAPwAAEzUzFTM1MxUFNTMVATUzFTE1MxUxNTMVMTUzFTE1MxUFNTMVBTUzFQU1MxUFNTMVMTUzFTE1MxUxNTMVMTUzFYCAgID/AID+gICAgICA/wCA/wCA/wCA/wCAgICAgAOAgICAgICAgP8AgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAANAAAAAAKABAAAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwAAEzUzFTM1MxUBNTMVITUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVMTUzFTE1MxUFNTMVBzUzFYCAgID+AIABgID9gIABgID9gIABgID+AICAgP8AgICAA4CAgICA/wCAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAAABgEAAAABgAOAAAMABwALAA8AEwAXAAABNTMVAzUzFQc1MxUHNTMVBzUzFQc1MxUBAICAgICAgICAgICAAwCAgP8AgICAgICAgICAgICAgIAAAAAADACAAAACgAMAAAMABwALAA8AEwAXABsAHwAjACcAKwAvAAABNTMVBTUzFTE1MxUxNTMVBTUzFTM1MxUFNTMVMzUzFQU1MxUxNTMVMTUzFQU1MxUBgID/AICAgP4AgICA/oCAgID/AICAgP8AgAKAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAAAEAAAAAACgAQAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwA7AD8AAAE1MxUxNTMVBTUzFQc1MxUFNTMVMTUzFTE1MxUxNTMVBTUzFQU1MxUFNTMVBzUzFTE1MxUxNTMVMTUzFTE1MxUBgICA/oCAgID/AICAgID+gID/AID/AICAgICAgIADgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAAEAAAAAADAAMAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwA7AD8AABE1MxUhNTMVBTUzFTE1MxUxNTMVMTUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVMTUzFTE1MxUxNTMVBTUzFSE1MxWAAgCA/YCAgICA/gCAAQCA/gCAAQCA/gCAgICA/YCAAgCAAoCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAAAAA8AAAAAAoADgAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAOwAAETUzFSE1MxUFNTMVITUzFQU1MxUxNTMVMTUzFQU1MxUFNTMVMTUzFTE1MxUxNTMVMTUzFQU1MxUHNTMVgAGAgP2AgAGAgP4AgICA/wCA/oCAgICAgP6AgICAAwCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAAIAQD/gAGABAAAAwAHAAsADwATABcAGwAfAAABNTMVBzUzFQc1MxUHNTMVAzUzFQc1MxUHNTMVBzUzFQEAgICAgICAgICAgICAgICAA4CAgICAgICAgICAgP8AgICAgICAgICAgIAAABIAAP8AAoAEAAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAOwA/AEMARwAAATUzFTE1MxUFNTMVBzUzFQU1MxUxNTMVMTUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVMTUzFTE1MxUFNTMVBzUzFQU1MxUxNTMVAYCAgP6AgICA/wCAgID+AIABgID9gIABgID+AICAgP8AgICA/oCAgAOAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAACAIADAAIAA4AAAwAHAAATNTMVMzUzFYCAgIADAICAgIAAAAAXAAAAAAMAA4AAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3ADsAPwBDAEcASwBPAFMAVwBbAAATNTMVMTUzFTE1MxUxNTMVBTUzFSE1MxUFNTMVMzUzFTE1MxUzNTMVBTUzFTM1MxUhNTMVBTUzFTM1MxUxNTMVMzUzFQU1MxUhNTMVBTUzFTE1MxUxNTMVMTUzFYCAgICA/YCAAgCA/QCAgICAgID9AICAgAEAgP0AgICAgICA/QCAAgCA/YCAgICAAwCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAAIAIABgAIABAAAAwAHAAsADwATABcAGwAfAAABNTMdATUzFQU1MxUxNTMVBTUzFTM1MxUFNTMVMTUzFQEAgID/AICA/oCAgID/AICAA4CAgICAgICAgICAgICAgICAgICAgAAACgAAAAADAAKAAAMABwALAA8AEwAXABsAHwAjACcAAAE1MxUhNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFSE1MxUBAIABAID9gIABAID9gIABAID+gIABAID+gIABAIACAICAgICAgICAgICAgICAgICAgICAgICAgAAHAIAAAAKAAgAAAwAHAAsADwATABcAGwAAEzUzFTE1MxUxNTMVMTUzFQc1MxUHNTMVBzUzFYCAgICAgICAgICAAYCAgICAgICAgICAgICAgICAgAAVAAAAAAMAA4AAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3ADsAPwBDAEcASwBPAFMAABM1MxUxNTMVMTUzFTE1MxUFNTMVITUzFQU1MxUhNTMVMzUzFQU1MxUzNTMVITUzFQU1MxUzNTMVITUzFQU1MxUhNTMVBTUzFTE1MxUxNTMVMTUzFYCAgICA/YCAAgCA/QCAAQCAgID9AICAgAEAgP0AgICAAQCA/QCAAgCA/YCAgICAAwCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAUAAAMAAoADgAADAAcACwAPABMAABE1MxUxNTMVMTUzFTE1MxUxNTMVgICAgIADAICAgICAgICAgIAAAAQAgAIAAgADgAADAAcACwAPAAABNTMVBTUzFTM1MxUFNTMVAQCA/wCAgID/AIADAICAgICAgICAgIAAAA4AAAAAAoADAAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAAAE1MxUHNTMVBTUzFTE1MxUxNTMVMTUzFTE1MxUFNTMVBzUzFQU1MxUxNTMVMTUzFTE1MxUxNTMVAQCAgID+gICAgICA/oCAgID+gICAgICAAoCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAgAgAGAAgAEAAADAAcACwAPABMAFwAbAB8AABM1MxUxNTMdATUzFQU1MxUFNTMVBzUzFTE1MxUxNTMVgICAgP8AgP8AgICAgIADgICAgICAgICAgICAgICAgICAgICAAAgAgAGAAgAEAAADAAcACwAPABMAFwAbAB8AABM1MxUxNTMdATUzFQU1MxUxNTMdATUzFQU1MxUxNTMVgICAgP6AgICA/oCAgAOAgICAgICAgICAgICAgICAgICAgIAAAAIBAAMAAgAEAAADAAcAAAE1MxUFNTMVAYCA/wCAA4CAgICAgAAAAAAOAAD/AAMAAoAAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3AAATNTMVITUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUxNTMVMTUzFTM1MxUFNTMVBTUzFYCAAQCA/gCAAQCA/gCAAQCA/gCAAQCA/gCAgICAgP2AgP8AgAIAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAaAAD/AAMAA4AAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3ADsAPwBDAEcASwBPAFMAVwBbAF8AYwBnAAATNTMVMTUzFTE1MxUxNTMVMTUzFQU1MxUxNTMVMTUzFTM1MxUFNTMVMTUzFTE1MxUzNTMVBTUzFTE1MxUzNTMVBTUzFTM1MxUFNTMVMzUzFQU1MxUzNTMVBTUzFTM1MxUFNTMVMzUzFYCAgICAgP0AgICAgID9gICAgICA/gCAgICA/oCAgID+gICAgP6AgICA/oCAgID+gICAgAMAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAAAAAEBAAGAAYACAAADAAABNTMVAQCAAYCAgAAAAAAEAQD/AAIAAIAAAwAHAAsADwAAITUzFTE1MxUHNTMVBTUzFQEAgICAgP8AgICAgICAgICAgIAAAAgAgAGAAgAEAAADAAcACwAPABMAFwAbAB8AAAE1MxUFNTMVMTUzFQc1MxUHNTMVBTUzFTE1MxUxNTMVAQCA/wCAgICAgID/AICAgAOAgICAgICAgICAgICAgICAgICAgIAAAAAGAIACAAIABAAAAwAHAAsADwATABcAAAE1MxUFNTMVMzUzFQU1MxUzNTMVBTUzFQEAgP8AgICA/oCAgID/AIADgICAgICAgICAgICAgICAgAAAAAAKAAAAAAMAAoAAAwAHAAsADwATABcAGwAfACMAJwAAETUzFSE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVITUzFYABAID+gIABAID+gIABAID9gIABAID9gIABAIACAICAgICAgICAgICAgICAgICAgICAgICAgAAAABMAAP+AAwAEAAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAOwA/AEMARwBLAAABNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVMzUzFTE1MxUFNTMVMzUzFTE1MxUxNTMVBTUzFSE1MxUFNTMVAgCA/YCAAYCA/YCAAQCA/gCAAQCA/wCAAQCA/gCAgICA/YCAgICAgP2AgAGAgP0AgAOAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAAEgAA/4ADAAQAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwA7AD8AQwBHAAABNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFTM1MxUxNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUhNTMVMTUzFQU1MxUCAID9gIABgID9gIABAID+AIABAID/AICAgID+AIABAID9gIABAID+AIABAICA/QCAA4CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAAFgAA/4ADAAQAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwA7AD8AQwBHAEsATwBTAFcAABE1MxUhNTMVBTUzFSE1MxUFNTMVMTUzFTM1MxUFNTMVMzUzFQU1MxUzNTMVITUzFQU1MxUzNTMVMTUzFQU1MxUzNTMVMTUzFTE1MxUFNTMVITUzFQU1MxWAAYCA/gCAAQCA/YCAgICA/oCAgID+AICAgAEAgP4AgICAgP2AgICAgID9gIABgID9AIADgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAAACQAAAAACgAOAAAMABwALAA8AEwAXABsAHwAjAAABNTMVAzUzHQE1Mx0BNTMVBTUzFSE1MxUFNTMVMTUzFTE1MxUBAICAgICA/YCAAYCA/gCAgIADAICA/wCAgICAgICAgICAgICAgICAgICAgAAAAAwAAAAAAoAEAAADAAcACwAPABMAFwAbAB8AIwAnACsALwAAEzUzHQE1MxUDNTMVBTUzFTM1MxUFNTMVMTUzFTE1MxUFNTMVITUzFQU1MxUhNTMVgICAgID/AICAgP6AgICA/gCAAYCA/YCAAYCAA4CAgICAgP8AgICAgICAgICAgICAgICAgICAgICAgICAAAwAAAAAAoAEAAADAAcACwAPABMAFwAbAB8AIwAnACsALwAAATUzFQU1MxURNTMVBTUzFTM1MxUFNTMVMTUzFTE1MxUFNTMVITUzFQU1MxUhNTMVAQCA/wCAgP8AgICA/oCAgID+AIABgID9gIABgIADgICAgICA/wCAgICAgICAgICAgICAgICAgICAgICAgIAAAAANAAAAAAKABAAAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwAAATUzFQU1MxUzNTMVATUzFQU1MxUzNTMVBTUzFTE1MxUxNTMVBTUzFSE1MxUFNTMVITUzFQEAgP8AgICA/wCA/wCAgID+gICAgP4AgAGAgP2AgAGAgAOAgICAgICAgP8AgICAgICAgICAgICAgICAgICAgICAgICAAAAADgAAAAACgAQAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwAAATUzFTM1MxUFNTMVMzUzFQE1MxUFNTMVMzUzFQU1MxUxNTMVMTUzFQU1MxUhNTMVBTUzFSE1MxUBAICAgP4AgICA/wCA/wCAgID+gICAgP4AgAGAgP2AgAGAgAOAgICAgICAgICA/wCAgICAgICAgICAgICAgICAgICAgICAgIAADAAAAAACgAOAAAMABwALAA8AEwAXABsAHwAjACcAKwAvAAATNTMVMzUzFQE1MxUFNTMVMzUzFQU1MxUxNTMVMTUzFQU1MxUhNTMVBTUzFSE1MxWAgICA/wCA/wCAgID+gICAgP4AgAGAgP2AgAGAgAMAgICAgP8AgICAgICAgICAgICAgICAgICAgICAgICAAAAAAA4AAAAAAoAEAAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAAAE1MxUFNTMVMzUzFQU1MxUHNTMVBTUzFTM1MxUFNTMVMTUzFTE1MxUFNTMVITUzFQU1MxUhNTMVAQCA/wCAgID/AICAgP8AgICA/oCAgID+AIABgID9gIABgIADgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAABQAAAAAAwADgAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAOwA/AEMARwBLAE8AAAE1MxUxNTMVMTUzFTE1MxUFNTMVMzUzFQU1MxUzNTMVBTUzFTE1MxUxNTMVMTUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVITUzFTE1MxUxNTMVAQCAgICA/YCAgID+gICAgP6AgICAgP2AgAEAgP4AgAEAgP4AgAEAgICAAwCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAAADwAA/wACgAOAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwA7AAATNTMVMTUzFTE1MxUFNTMVITUzFQU1MxUHNTMVBzUzFQc1MxUhNTMVBTUzFTE1MxUxNTMVBTUzFQU1MxWAgICA/gCAAYCA/YCAgICAgICAAYCA/gCAgID/AID/AIADAICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAASAAAAAAKABAAAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3ADsAPwBDAEcAABM1Mx0BNTMVATUzFTE1MxUxNTMVMTUzFTE1MxUFNTMVBzUzFTE1MxUxNTMVMTUzFQU1MxUHNTMVMTUzFTE1MxUxNTMVMTUzFYCAgP6AgICAgID9gICAgICAgP4AgICAgICAgAOAgICAgID/AICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAASAAAAAAKABAAAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3ADsAPwBDAEcAAAE1MxUFNTMVATUzFTE1MxUxNTMVMTUzFTE1MxUFNTMVBzUzFTE1MxUxNTMVMTUzFQU1MxUHNTMVMTUzFTE1MxUxNTMVMTUzFQEAgP8AgP8AgICAgID9gICAgICAgP4AgICAgICAgAOAgICAgID/AICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAAEwAAAAACgAQAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwA7AD8AQwBHAEsAAAE1MxUFNTMVMzUzFQE1MxUxNTMVMTUzFTE1MxUxNTMVBTUzFQc1MxUxNTMVMTUzFTE1MxUFNTMVBzUzFTE1MxUxNTMVMTUzFTE1MxUBAID/AICAgP4AgICAgID9gICAgICAgP4AgICAgICAgAOAgICAgICAgP8AgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAAAABIAAAAAAoADgAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAOwA/AEMARwAAEzUzFTM1MxUBNTMVMTUzFTE1MxUxNTMVMTUzFQU1MxUHNTMVMTUzFTE1MxUxNTMVBTUzFQc1MxUxNTMVMTUzFTE1MxUxNTMVgICAgP4AgICAgID9gICAgICAgP4AgICAgICAgAMAgICAgP8AgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAsAgAAAAgAEAAADAAcACwAPABMAFwAbAB8AIwAnACsAABM1Mx0BNTMVATUzFTE1MxUxNTMVBTUzFQc1MxUHNTMVBTUzFTE1MxUxNTMVgICA/wCAgID/AICAgICA/wCAgIADgICAgICA/wCAgICAgICAgICAgICAgICAgICAgICAAAAAAAsAgAAAAgAEAAADAAcACwAPABMAFwAbAB8AIwAnACsAAAE1MxUFNTMVAzUzFTE1MxUxNTMVBTUzFQc1MxUHNTMVBTUzFTE1MxUxNTMVAQCA/wCAgICAgP8AgICAgID/AICAgAOAgICAgID/AICAgICAgICAgICAgICAgICAgICAgIAAAAwAgAAAAgAEAAADAAcACwAPABMAFwAbAB8AIwAnACsALwAAATUzFQU1MxUzNTMVATUzFTE1MxUxNTMVBTUzFQc1MxUHNTMVBTUzFTE1MxUxNTMVAQCA/wCAgID+gICAgP8AgICAgID/AICAgAOAgICAgICAgP8AgICAgICAgICAgICAgICAgICAgICAgAAAAAsAgAAAAgADgAADAAcACwAPABMAFwAbAB8AIwAnACsAABM1MxUzNTMVATUzFTE1MxUxNTMVBTUzFQc1MxUHNTMVBTUzFTE1MxUxNTMVgICAgP6AgICA/wCAgICAgP8AgICAAwCAgICA/wCAgICAgICAgICAgICAgICAgICAgICAAAAAABMAAAAAAwADgAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAOwA/AEMARwBLAAATNTMVMTUzFTE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFTE1MxUxNTMVMTUzFTM1MxUFNTMVITUzFQU1MxUhNTMVBTUzFTE1MxUxNTMVgICAgP6AgAEAgP4AgAGAgP0AgICAgICA/YCAAYCA/YCAAQCA/gCAgIADAICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAAAABMAAAAAAoAEAAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAOwA/AEMARwBLAAABNTMVMzUzFQU1MxUzNTMVATUzFTE1MxUhNTMVBTUzFTM1MxUzNTMVBTUzFTM1MxUzNTMVBTUzFSE1MxUxNTMVBTUzFSE1MxUxNTMVAQCAgID+AICAgP4AgIABAID9gICAgICA/YCAgICAgP2AgAEAgID9gIABAICAA4CAgICAgICAgID/AICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAAOAAAAAAKABAAAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3AAATNTMdATUzFQE1MxUxNTMVMTUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUxNTMVMTUzFYCAgP8AgICA/gCAAYCA/YCAAYCA/YCAAYCA/gCAgIADgICAgICA/wCAgICAgICAgICAgICAgICAgICAgICAgICAgICAAA4AAAAAAoAEAAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAAAE1MxUFNTMVAzUzFTE1MxUxNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFTE1MxUxNTMVAQCA/wCAgICAgP4AgAGAgP2AgAGAgP2AgAGAgP4AgICAA4CAgICAgP8AgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAAAA8AAAAAAoAEAAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAOwAAATUzFQU1MxUzNTMVATUzFTE1MxUxNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFTE1MxUxNTMVAQCA/wCAgID+gICAgP4AgAGAgP2AgAGAgP2AgAGAgP4AgICAA4CAgICAgICA/wCAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAAAABAAAAAAAoAEAAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAOwA/AAABNTMVMzUzFQU1MxUzNTMVATUzFTE1MxUxNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFTE1MxUxNTMVAQCAgID+AICAgP6AgICA/gCAAYCA/YCAAYCA/YCAAYCA/gCAgIADgICAgICAgICAgP8AgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAADgAAAAACgAOAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwAAEzUzFTM1MxUBNTMVMTUzFTE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVMTUzFTE1MxWAgICA/oCAgID+AIABgID9gIABgID9gIABgID+AICAgAMAgICAgP8AgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAJAAAAgAKAAwAAAwAHAAsADwATABcAGwAfACMAABE1MxUhNTMVBTUzFTM1MxUFNTMVBTUzFTM1MxUFNTMVITUzFYABgID+AICAgP8AgP8AgICA/gCAAYCAAoCAgICAgICAgICAgICAgICAgICAgICAAAAAABAAAAAAAwADAAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAOwA/AAABNTMVMTUzFTM1MxUFNTMVITUzFQU1MxUzNTMVMTUzFQU1MxUxNTMVMzUzFQU1MxUhNTMVBTUzFTM1MxUxNTMVAQCAgICA/YCAAQCA/gCAgICA/gCAgICA/gCAAQCA/YCAgICAAoCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAANAAAAAAKABAAAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwAAEzUzHQE1MxUBNTMVITUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUxNTMVMTUzFYCAgP6AgAGAgP2AgAGAgP2AgAGAgP2AgAGAgP4AgICAA4CAgICAgP8AgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAAADQAAAAACgAQAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMAAAE1MxUFNTMVATUzFSE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVMTUzFTE1MxUBAID/AID/AIABgID9gIABgID9gIABgID9gIABgID+AICAgAOAgICAgID/AICAgICAgICAgICAgICAgICAgICAgICAgICAAA4AAAAAAoAEAAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAAAE1MxUFNTMVMzUzFQE1MxUhNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFTE1MxUxNTMVAQCA/wCAgID+AIABgID9gIABgID9gIABgID9gIABgID+AICAgAOAgICAgICAgP8AgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAANAAAAAAKAA4AAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwAAEzUzFTM1MxUBNTMVITUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUxNTMVMTUzFYCAgID+AIABgID9gIABgID9gIABgID9gIABgID+AICAgAMAgICAgP8AgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAAADQAAAAACgAQAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMAAAE1MxUFNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFTE1MxUxNTMVBTUzFQc1MxUBgID/AID+gIABgID9gIABgID9gIABgID+AICAgP8AgICAA4CAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAA4AgP+AAoADgAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAABM1MxUHNTMVBzUzFTE1MxUxNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUxNTMVMTUzFQU1MxUHNTMVgICAgICAgID+gIABAID+AIABAID+AICAgP6AgICAAwCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAAEgAA/4ACgAOAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwA7AD8AQwBHAAATNTMVMTUzFTE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFTE1MxUxNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUxNTMVMTUzFQU1MxWAgICA/oCAAQCA/gCAAQCA/gCAgID+gIABAID+AIABAID+AICAgP4AgAMAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAAABAAAAAAAoAEAAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAOwA/AAATNTMdATUzFQE1MxUxNTMVMTUzHQE1MxUFNTMVMTUzFTE1MxUxNTMVBTUzFSE1MxUFNTMVMTUzFTE1MxUxNTMVgICA/wCAgICA/gCAgICA/YCAAYCA/gCAgICAA4CAgICAgP8AgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAEAAAAAACgAQAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwA7AD8AAAE1MxUFNTMVAzUzFTE1MxUxNTMdATUzFQU1MxUxNTMVMTUzFTE1MxUFNTMVITUzFQU1MxUxNTMVMTUzFTE1MxUBAID/AICAgICAgP4AgICAgP2AgAGAgP4AgICAgAOAgICAgID/AICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAAAEQAAAAACgAQAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwA7AD8AQwAAATUzFQU1MxUzNTMVATUzFTE1MxUxNTMdATUzFQU1MxUxNTMVMTUzFTE1MxUFNTMVITUzFQU1MxUxNTMVMTUzFTE1MxUBAID/AICAgP6AgICAgP4AgICAgP2AgAGAgP4AgICAgAOAgICAgICAgP8AgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAAAEgAAAAACgAQAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwA7AD8AQwBHAAABNTMVMzUzFQU1MxUzNTMVATUzFTE1MxUxNTMdATUzFQU1MxUxNTMVMTUzFTE1MxUFNTMVITUzFQU1MxUxNTMVMTUzFTE1MxUBAICAgP4AgICA/oCAgICA/gCAgICA/YCAAYCA/gCAgICAA4CAgICAgICAgID/AICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAAQAAAAAAKAA4AAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3ADsAPwAAEzUzFTM1MxUBNTMVMTUzFTE1Mx0BNTMVBTUzFTE1MxUxNTMVMTUzFQU1MxUhNTMVBTUzFTE1MxUxNTMVMTUzFYCAgID+gICAgID+AICAgID9gIABgID+AICAgIADAICAgID/AICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAABIAAAAAAoAEAAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAOwA/AEMARwAAATUzFQU1MxUzNTMVBTUzFQU1MxUxNTMVMTUzHQE1MxUFNTMVMTUzFTE1MxUxNTMVBTUzFSE1MxUFNTMVMTUzFTE1MxUxNTMVAQCA/wCAgID/AID/AICAgID+AICAgID9gIABgID+AICAgIADgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAADwAAAAADAAKAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwA7AAATNTMVMTUzFTM1MxUFNTMVMzUzFQU1MxUxNTMVMTUzFTE1MxUFNTMVITUzFQU1MxUxNTMVMzUzFTE1MxWAgICAgP8AgICA/YCAgICA/YCAAQCA/oCAgICAgAIAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAADQAA/wACgAKAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMAABM1MxUxNTMVMTUzFTE1MxUFNTMVBzUzFQc1Mx0BNTMVMTUzFTE1MxUxNTMVBTUzFQU1MxWAgICAgP2AgICAgICAgICA/oCA/wCAAgCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAAABEAAAAAAoAEAAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAOwA/AEMAABM1Mx0BNTMVATUzFTE1MxUxNTMVBTUzFSE1MxUFNTMVMTUzFTE1MxUxNTMVMTUzFQU1Mx0BNTMVMTUzFTE1MxUxNTMVgICA/wCAgID+AIABgID9gICAgICA/YCAgICAgAOAgICAgID/AICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAAAEQAAAAACgAQAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwA7AD8AQwAAATUzFQU1MxUDNTMVMTUzFTE1MxUFNTMVITUzFQU1MxUxNTMVMTUzFTE1MxUxNTMVBTUzHQE1MxUxNTMVMTUzFTE1MxUBAID/AICAgICA/gCAAYCA/YCAgICAgP2AgICAgIADgICAgICA/wCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAASAAAAAAKABAAAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3ADsAPwBDAEcAAAE1MxUFNTMVMzUzFQE1MxUxNTMVMTUzFQU1MxUhNTMVBTUzFTE1MxUxNTMVMTUzFTE1MxUFNTMdATUzFTE1MxUxNTMVMTUzFQEAgP8AgICA/oCAgID+AIABgID9gICAgICA/YCAgICAgAOAgICAgICAgP8AgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAAABEAAAAAAoADgAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAOwA/AEMAABM1MxUzNTMVATUzFTE1MxUxNTMVBTUzFSE1MxUFNTMVMTUzFTE1MxUxNTMVMTUzFQU1Mx0BNTMVMTUzFTE1MxUxNTMVgICAgP6AgICA/gCAAYCA/YCAgICAgP2AgICAgIADAICAgID/AICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAAACACAAAABgAQAAAMABwALAA8AEwAXABsAHwAAEzUzHQE1MxUBNTMVMTUzFQc1MxUHNTMVBzUzFQc1MxWAgID/AICAgICAgICAgIADgICAgICA/wCAgICAgICAgICAgICAgICAAAgAgAAAAYAEAAADAAcACwAPABMAFwAbAB8AAAE1MxUFNTMVAzUzFTE1MxUHNTMVBzUzFQc1MxUHNTMVAQCA/wCAgICAgICAgICAgIADgICAgICA/wCAgICAgICAgICAgICAgICAAAAACQCAAAACAAQAAAMABwALAA8AEwAXABsAHwAjAAABNTMVBTUzFTM1MxUBNTMVMTUzFQc1MxUHNTMVBzUzFQc1MxUBAID/AICAgP6AgICAgICAgICAgAOAgICAgICAgP8AgICAgICAgICAgICAgICAgAAAAAAIAIAAAAIAA4AAAwAHAAsADwATABcAGwAfAAATNTMVMzUzFQE1MxUxNTMVBzUzFQc1MxUHNTMVBzUzFYCAgID+gICAgICAgICAgIADAICAgID/AICAgICAgICAgICAgICAgIAAEAAAAAACgAOAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwA7AD8AABM1MxUxNTMVMzUzFQU1Mx0BNTMVBTUzFTE1MxUxNTMVMTUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVMTUzFTE1MxWAgICAgP8AgID+AICAgID9gIABgID9gIABgID+AICAgAMAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAEAAAAAACgAQAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwA7AD8AAAE1MxUzNTMVBTUzFTM1MxUBNTMVMTUzFTE1MxUxNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFSE1MxUBAICAgP4AgICA/gCAgICA/gCAAYCA/YCAAYCA/YCAAYCA/YCAAYCAA4CAgICAgICAgID/AICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAAADgAAAAACgAQAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwAAEzUzHQE1MxUBNTMVMTUzFTE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVMTUzFTE1MxWAgID/AICAgP4AgAGAgP2AgAGAgP2AgAGAgP4AgICAA4CAgICAgP8AgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAOAAAAAAKABAAAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3AAABNTMVBTUzFQM1MxUxNTMVMTUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUxNTMVMTUzFQEAgP8AgICAgID+AIABgID9gIABgID9gIABgID+AICAgAOAgICAgID/AICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAAPAAAAAAKABAAAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3ADsAAAE1MxUFNTMVMzUzFQE1MxUxNTMVMTUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUxNTMVMTUzFQEAgP8AgICA/oCAgID+AIABgID9gIABgID9gIABgID+AICAgAOAgICAgICAgP8AgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAAAAAQAAAAAAKABAAAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3ADsAPwAAEzUzFTM1MxUFNTMVMzUzFQE1MxUxNTMVMTUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUxNTMVMTUzFYCAgID+AICAgP8AgICA/gCAAYCA/YCAAYCA/YCAAYCA/gCAgIADgICAgICAgICAgP8AgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAAAA4AAAAAAoADgAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAABM1MxUzNTMVATUzFTE1MxUxNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFTE1MxUxNTMVgICAgP6AgICA/gCAAYCA/YCAAYCA/YCAAYCA/gCAgIADAICAgID/AICAgICAgICAgICAgICAgICAgICAgICAgICAgIAABwAAAIACgAMAAAMABwALAA8AEwAXABsAAAE1MxUBNTMVMTUzFTE1MxUxNTMVMTUzFQE1MxUBAID+gICAgICA/oCAAoCAgP8AgICAgICAgICAgP8AgIAAABAAAAAAAwADAAADAAcACwAPABMAFwAbAB8AIwAnACsALwAzADcAOwA/AAABNTMVMTUzFTM1MxUFNTMVITUzFQU1MxUzNTMVMTUzFQU1MxUxNTMVMzUzFQU1MxUhNTMVBTUzFTM1MxUxNTMVAQCAgICA/YCAAQCA/gCAgICA/gCAgICA/gCAAQCA/YCAgICAAoCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAAOAAAAAAKABAAAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3AAATNTMdATUzFQE1MxUhNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFTE1MxUxNTMVMTUzFYCAgP6AgAGAgP2AgAGAgP2AgAGAgP2AgAGAgP4AgICAgAOAgICAgID/AICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAAOAAAAAAKABAAAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3AAABNTMVBTUzFQE1MxUhNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFTE1MxUxNTMVMTUzFQEAgP8AgP8AgAGAgP2AgAGAgP2AgAGAgP2AgAGAgP4AgICAgAOAgICAgID/AICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAAADwAAAAACgAQAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwA7AAABNTMVBTUzFTM1MxUBNTMVITUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUxNTMVMTUzFTE1MxUBAID/AICAgP4AgAGAgP2AgAGAgP2AgAGAgP2AgAGAgP4AgICAgAOAgICAgICAgP8AgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAADgAAAAACgAOAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwAAEzUzFTM1MxUBNTMVITUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUxNTMVMTUzFTE1MxWAgICA/gCAAYCA/YCAAYCA/YCAAYCA/YCAAYCA/gCAgICAAwCAgICA/wCAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAAAEgAA/wACgAQAAAMABwALAA8AEwAXABsAHwAjACcAKwAvADMANwA7AD8AQwBHAAABNTMVBTUzFQE1MxUhNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFTE1MxUxNTMVMTUzFQc1MxUFNTMVMTUzFTE1MxUBAID/AID/AIABgID9gIABgID9gIABgID9gIABgID+AICAgICAgP4AgICAA4CAgICAgP8AgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAAAAASAAD/AAKAA4AAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3ADsAPwBDAEcAABE1MxUHNTMVBzUzFTE1MxUxNTMVMTUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVITUzFQU1MxUxNTMVMTUzFTE1MxUFNTMVBzUzFYCAgICAgICA/gCAAYCA/YCAAYCA/YCAAYCA/YCAgICA/gCAgIADAICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAAAASAAD/AAKAA4AAAwAHAAsADwATABcAGwAfACMAJwArAC8AMwA3ADsAPwBDAEcAABM1MxUzNTMVATUzFSE1MxUFNTMVITUzFQU1MxUhNTMVBTUzFSE1MxUFNTMVMTUzFTE1MxUxNTMVBzUzFQU1MxUxNTMVMTUzFYCAgID+AIABgID9gIABgID9gIABgID9gIABgID+AICAgICAgP4AgICAAwCAgICA/wCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgAAAAAAVAQIAAAAAAAAAAAAkAEcAAAAAAAAAAQAYAIEAAAAAAAAAAgAOAGsAAAAAAAAAAwAYAIEAAAAAAAAABAAYAIEAAAAAAAAABQAUAAAAAAAAAAAABgAYAIEAAQAAAAAAAAASABQAAQAAAAAAAQAMADEAAQAAAAAAAgAHACYAAQAAAAAAAwAQAC0AAQAAAAAABAAMADEAAQAAAAAABQAKAD0AAQAAAAAABgAMADEAAwABBAkAAAAkAEcAAwABBAkAAQAYAIEAAwABBAkAAgAOAGsAAwABBAkAAwAgAHkAAwABBAkABAAYAIEAAwABBAkABQAUAAAAAwABBAkABgAYAIEAMgAwADAANAAvADAANAAvADEANWJ5IFRyaXN0YW4gR3JpbW1lclJlZ3VsYXJUVFggUHJvZ2d5VGlueVRUMjAwNC8wNC8xNQBiAHkAIABUAHIAaQBzAHQAYQBuACAARwByAGkAbQBtAGUAcgBSAGUAZwB1AGwAYQByAFQAVABYACAAUAByAG8AZwBnAHkAVABpAG4AeQBUAFQAAAIAAAAAAAAAAAAUAAAAAQAAAAAAAAAAAAAAAAAAAAABAQAAAAEBAgEDAQQBBQEGAQcBCAEJAQoBCwEMAQ0BDgEPARABEQESARMBFAEVARYBFwEYARkBGgEbARwBHQEeAR8BIAADAAQABQAGAAcACAAJAAoACwAMAA0ADgAPABAAEQASABMAFAAVABYAFwAYABkAGgAbABwAHQAeAB8AIAAhACIAIwAkACUAJgAnACgAKQAqACsALAAtAC4ALwAwADEAMgAzADQANQA2ADcAOAA5ADoAOwA8AD0APgA/AEAAQQBCAEMARABFAEYARwBIAEkASgBLAEwATQBOAE8AUABRAFIAUwBUAFUAVgBXAFgAWQBaAFsAXABdAF4AXwBgAGEBIQEiASMBJAElASYBJwEoASkBKgErASwBLQEuAS8BMAExATIBMwE0ATUBNgE3ATgBOQE6ATsBPAE9AT4BPwFAAUEArACjAIQAhQC9AJYA6ACGAI4AiwCdAKkApADvAIoA2gCDAJMA8gDzAI0AlwCIAMMA3gDxAJ4AqgD1APQA9gCiAK0AyQDHAK4AYgBjAJAAZADLAGUAyADKAM8AzADNAM4A6QBmANMA0ADRAK8AZwDwAJEA1gDUANUAaADrAO0AiQBqAGkAawBtAGwAbgCgAG8AcQBwAHIAcwB1AHQAdgB3AOoAeAB6AHkAewB9AHwAuAChAH8AfgCAAIEA7ADuALoOdW5pY29kZSMweDAwMDEOdW5pY29kZSMweDAwMDIOdW5pY29kZSMweDAwMDMOdW5pY29kZSMweDAwMDQOdW5pY29kZSMweDAwMDUOdW5pY29kZSMweDAwMDYOdW5pY29kZSMweDAwMDcOdW5pY29kZSMweDAwMDgOdW5pY29kZSMweDAwMDkOdW5pY29kZSMweDAwMGEOdW5pY29kZSMweDAwMGIOdW5pY29kZSMweDAwMGMOdW5pY29kZSMweDAwMGQOdW5pY29kZSMweDAwMGUOdW5pY29kZSMweDAwMGYOdW5pY29kZSMweDAwMTAOdW5pY29kZSMweDAwMTEOdW5pY29kZSMweDAwMTIOdW5pY29kZSMweDAwMTMOdW5pY29kZSMweDAwMTQOdW5pY29kZSMweDAwMTUOdW5pY29kZSMweDAwMTYOdW5pY29kZSMweDAwMTcOdW5pY29kZSMweDAwMTgOdW5pY29kZSMweDAwMTkOdW5pY29kZSMweDAwMWEOdW5pY29kZSMweDAwMWIOdW5pY29kZSMweDAwMWMOdW5pY29kZSMweDAwMWQOdW5pY29kZSMweDAwMWUOdW5pY29kZSMweDAwMWYGZGVsZXRlBEV1cm8OdW5pY29kZSMweDAwODEOdW5pY29kZSMweDAwODIOdW5pY29kZSMweDAwODMOdW5pY29kZSMweDAwODQOdW5pY29kZSMweDAwODUOdW5pY29kZSMweDAwODYOdW5pY29kZSMweDAwODcOdW5pY29kZSMweDAwODgOdW5pY29kZSMweDAwODkOdW5pY29kZSMweDAwOGEOdW5pY29kZSMweDAwOGIOdW5pY29kZSMweDAwOGMOdW5pY29kZSMweDAwOGQOdW5pY29kZSMweDAwOGUOdW5pY29kZSMweDAwOGYOdW5pY29kZSMweDAwOTAOdW5pY29kZSMweDAwOTEOdW5pY29kZSMweDAwOTIOdW5pY29kZSMweDAwOTMOdW5pY29kZSMweDAwOTQOdW5pY29kZSMweDAwOTUOdW5pY29kZSMweDAwOTYOdW5pY29kZSMweDAwOTcOdW5pY29kZSMweDAwOTgOdW5pY29kZSMweDAwOTkOdW5pY29kZSMweDAwOWEOdW5pY29kZSMweDAwOWIOdW5pY29kZSMweDAwOWMOdW5pY29kZSMweDAwOWQOdW5pY29kZSMweDAwOWUOdW5pY29kZSMweDAwOWYAAA==")

		writefile(path, hs:JSONEncode({
			["name"] = "ProggyTini",
			["faces"] = {
				{
					["name"] = "Regular",
					["weight"] = 100,
					["style"] = "normal",
					["assetId"] = getcustomasset("temp.ttf")
				}
			}
		}))


		local asset = getcustomasset(path)
		menu_font = Font.new(asset, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
		menu_font_bold = Font.new(asset, Enum.FontWeight.Bold, Enum.FontStyle.Normal)

		delfile(path)
		delfile("temp.ttf")
	else
		menu_font = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)	
		menu_font_bold = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)	
	end

	local shortened_characters = {
		[Enum.KeyCode.LeftShift] = "LSHF",
		[Enum.KeyCode.RightShift] = "RSHF",
		[Enum.UserInputType.MouseButton1] = "M1",
		[Enum.UserInputType.MouseButton2] = "M2",
		[Enum.UserInputType.MouseButton3] = "M3",
		[Enum.KeyCode.ButtonX] = "XB",
		[Enum.KeyCode.ButtonY] = "YB",
		[Enum.KeyCode.ButtonA] = "AB",
		[Enum.KeyCode.ButtonB] = "BB",
		[Enum.KeyCode.ButtonR1] = "R1",
		[Enum.KeyCode.ButtonR2] = "R2",
		[Enum.KeyCode.ButtonR1] = "L1",
		[Enum.KeyCode.ButtonR2] = "L2",
		[Enum.KeyCode.DPadLeft] = "DPL",
		[Enum.KeyCode.DPadRight] = "DPR",
		[Enum.KeyCode.DPadUp] = "DPUP",
		[Enum.KeyCode.DPadDown] = "DPDN",
		[Enum.KeyCode.Thumbstick1] = "TS1",
		[Enum.KeyCode.Thumbstick2] = "TS2",
		[Enum.KeyCode.Delete] = "DEL",
		[Enum.KeyCode.Insert] = "INS",
		[Enum.KeyCode.PageUp] = "PGUP",
		[Enum.KeyCode.PageDown] = "PGDW",
		[Enum.KeyCode.LeftControl] = "LCTR",
		[Enum.KeyCode.RightControl] = "RCTR",
		[Enum.KeyCode.RightAlt] = "RALT",
		[Enum.KeyCode.LeftAlt] = "LALT",
		[Enum.KeyCode.CapsLock] = "CAPS",
		[Enum.KeyCode.ScrollLock] = "SLCK",
		[Enum.KeyCode.Backspace] = "BSPC",
		[Enum.KeyCode.Space] = "SPC",
	}

	_screenGui = newObject("ScreenGui", {
		ResetOnSpawn = false;
		Parent = cg
	})

	local KeybindOpen = newObject("Frame", {
		BackgroundColor3 = colorfromrgb(12, 12, 12);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 0, 0, 0);
		Size = udim2new(0, 100, 0, 0);
		AutomaticSize = Enum.AutomaticSize.Y;
		ZIndex = 25;
		BackgroundTransparency = 1;
		Visible = false;
		Parent = _screenGui	
	})
	local KeybindOpenInside2 = newObject("Frame", {
		Parent = KeybindOpen;
		BackgroundColor3 = colorfromrgb(35, 35, 35);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		AutomaticSize = Enum.AutomaticSize.Y;
		Position = udim2new(0, 1, 0, 1);
		Size = udim2new(1, -2, 0, 0);
		BackgroundTransparency = 1;
		ZIndex = 25
	})
	local UIListLayout = newObject("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Right;
		SortOrder = Enum.SortOrder.LayoutOrder;
		Parent = KeybindOpenInside2
	})
	local AlwaysOn = newObject("TextLabel", {
		BackgroundColor3 = colorfromrgb(25, 25, 25);
		BackgroundTransparency = 1.000;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(1, 0, 0, 17);
		ZIndex = 25;
		FontFace = menu_font;
		Text = "    Always on";
		TextColor3 = colorfromrgb(205, 205, 205);
		TextSize = 13.000;
		TextTransparency = 1;
		TextXAlignment = Enum.TextXAlignment.Left;
		Parent = KeybindOpenInside2
	})
	local OnHotkeyLabel = newObject("TextLabel", {
		BackgroundColor3 = colorfromrgb(25, 25, 25);
		BackgroundTransparency = 1.000;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(1, 0, 0, 17);
		ZIndex = 25;
		FontFace = menu_font;
		Text = "    On hotkey";
		TextColor3 = colorfromrgb(205, 205, 205);
		TextSize = 13.000;
		TextXAlignment = Enum.TextXAlignment.Left;
		TextTransparency = 1;
		Parent = KeybindOpenInside2
	})
	local ToggleLabel = newObject("TextLabel", {
		BackgroundColor3 = colorfromrgb(25, 25, 25);
		BackgroundTransparency = 1.000;
		TextTransparency = 1;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(1, 0, 0, 17);
		ZIndex = 25;
		FontFace = menu_font;
		Text = "    Toggle";
		TextColor3 = colorfromrgb(205, 205, 205);
		TextSize = 13.000;
		TextXAlignment = Enum.TextXAlignment.Left;
		Parent = KeybindOpenInside2
	})

	local counter = 0

	for _, object in KeybindOpenInside2:GetChildren() do
		if object:IsA("TextLabel") then
			counter+=1
			local count = counter

			object.Name = count

			utility.newConnection(object.MouseEnter, function()
				if not menu.active_keybind then return end
				object.BackgroundTransparency = 0
				if flags[menu.active_keybind.flag]["method"] == count then return end
				object.FontFace = menu_font_bold
			end)

			utility.newConnection(object.MouseLeave, function()
				if not menu.active_keybind then return end
				object.BackgroundTransparency = 1
				if flags[menu.active_keybind.flag]["method"] == count then return end
				object.FontFace = menu_font
			end)

			utility.newConnection(object.InputBegan, function(input, gpe)
				if not menu.active_keybind then return end
				if gpe then return end
				if flags[menu.active_keybind.flag]["method"] == count then return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					menu.active_keybind:setMethod(count, true, true)
				end
			end)
		end
	end

	local ColorCopy = newObject("Frame", {
		BackgroundColor3 = colorfromrgb(12, 12, 12);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(0, 100, 0, 60);
		ZIndex = 250;
		BackgroundTransparency = 1;
		ClipsDescendants = true;
		Visible = false;
		Parent = _screenGui
	})
	local ColorCopyInside = newObject("Frame", {
		BackgroundColor3 = colorfromrgb(35, 35, 35);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(0, 98, 0, 58);
		Position = udim2new(0, 1, 0, 1);
		ZIndex = 251;
		BackgroundTransparency = 1;
		Parent = ColorCopy
	})

	newObject("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Right;
		SortOrder = Enum.SortOrder.LayoutOrder;
		Parent = ColorCopyInside
	})
	
	local CopyLabel = newObject("TextLabel", {
		BackgroundColor3 = colorfromrgb(25, 25, 25);
		BackgroundTransparency = 1.000;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(1, 0, 0, 20);
		ZIndex = 252;
		FontFace = menu_font;
		Text = "   Copy";
		TextColor3 = colorfromrgb(208, 208, 208);
		TextSize = 13.000;
		TextXAlignment = Enum.TextXAlignment.Left;
		TextTransparency = 1;
		Parent = ColorCopyInside
	})
	local PasteLabel = newObject("TextLabel", {
		BackgroundColor3 = colorfromrgb(25, 25, 25);
		BackgroundTransparency = 1.000;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(1, 0, 0, 20);
		ZIndex = 252;
		FontFace = menu_font;
		Text = "   Paste";
		TextColor3 = colorfromrgb(208, 208, 208);
		TextSize = 13.000;
		TextXAlignment = Enum.TextXAlignment.Left;
		TextTransparency = 1;
		Parent = ColorCopyInside
	})
	local ResetLabel = newObject("TextLabel", {
		BackgroundColor3 = colorfromrgb(25, 25, 25);
		BackgroundTransparency = 1.000;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(1, 0, 0, 20);
		ZIndex = 252;
		FontFace = menu_font;
		Text = "   Reset";
		TextColor3 = colorfromrgb(208, 208, 208);
		TextSize = 13.000;
		TextXAlignment = Enum.TextXAlignment.Left;
		TextTransparency = 1;
		Parent = ColorCopyInside
	})

	local clickOutConnection2 = nil

	local function closeColorCopy(force)
		local speed = force and 0 or menu["animation_speed"]
		local info = newtweeninfo(speed, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
				
		tween(ColorCopy, info, {BackgroundTransparency = 1})
		tween(ColorCopyInside, info, {BackgroundTransparency = 1})
		tween(CopyLabel, info, {TextTransparency = 1, BackgroundTransparency = 1})
		tween(PasteLabel, info, {TextTransparency = 1, BackgroundTransparency = 1})
		tween(ResetLabel, info, {TextTransparency = 1, BackgroundTransparency = 1})

		for _, label in ColorCopyInside:GetChildren() do
			if label.ClassName == "UIListLayout" then
				continue end
			
			label.FontFace = menu_font
		end

		delay(speed, function()
			if menu.active_colorcopy == nil then
				menu.busy = false
				utility.is_dragging_blocked = false
				ColorCopy.Visible = false
			end
		end)
		clickOutConnection2:Disconnect()
		menu.active_colorcopy = nil
	end

	local function openColorCopy(new_element, _info, ColorBox)
		local speed = menu["animation_speed"]
		local info = newtweeninfo(speed, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
				
		local newPosition = ColorBox.AbsolutePosition
		ColorCopy.Position = udim2new(0, newPosition.X - 101, 0, newPosition.Y - 1)
		ColorCopy.Visible = true

		menu.active_colorcopy = new_element

		tween(ColorCopy, info, {BackgroundTransparency = 0})
		tween(ColorCopyInside, info, {BackgroundTransparency = 0})
		tween(CopyLabel, info, {TextTransparency = 0, BackgroundTransparency = 1})
		tween(PasteLabel, info, {TextTransparency = 0, BackgroundTransparency = 1})
		tween(ResetLabel, info, {TextTransparency = 0, BackgroundTransparency = 1})

		clickOutConnection2 = utility.newConnection(uis.InputBegan, LPH_NO_VIRTUALIZE(function(input, gpe)
			if gpe then return end
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				local pos = input.Position
				if not isInFrame(ColorCopy, pos) then closeColorCopy() end
			end
		end), true)

		menu.busy = true; utility.is_dragging_blocked = true

		task.wait() 
	end

	utility.newConnection(CopyLabel.InputBegan, function(input, gpe)
		if gpe then
			return end

		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local colorpicker = menu.active_colorcopy["colorpicker"]
			menu.copied_transparency = flags[colorpicker["transparency_flag"]]
			menu.copied_color = flags[colorpicker["flag"]]
			closeColorCopy()
		end
	end)

	utility.newConnection(ResetLabel.InputBegan, function(input, gpe)
		if gpe then
			return end

		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local colorpicker = menu.active_colorcopy["colorpicker"]
			menu.active_colorcopy:setColor(colorpicker["default"] or colorfromrgb(255,255,255), colorpicker["default_transparency"] or 0, true)
			closeColorCopy()
		end
	end)

	utility.newConnection(PasteLabel.InputBegan, function(input, gpe)
		if gpe then
			return end

		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if menu.copied_color == nil then
				return end

			menu.active_colorcopy:setColor(menu.copied_color, menu.copied_transparency, true)
			closeColorCopy()
		end
	end)

	for _, label in ColorCopyInside:GetChildren() do
		if label.ClassName == "UIListLayout" then
			continue end
		
		utility.newConnection(label.MouseEnter, function()
			label.BackgroundTransparency = 0
			label.FontFace = menu_font_bold
		end)
		
		utility.newConnection(label.MouseLeave, function()
			label.BackgroundTransparency = 1
			label.FontFace = menu_font
		end)
	end
	
	local ColorpickerOpen = newObject("Frame", {
		BackgroundColor3 = colorfromrgb(12, 12, 12);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Size = udim2new(0, 180, 0, 175);
		ZIndex = 250;
		BackgroundTransparency = 1;
		Visible = false;
		Parent = _screenGui
	})
	local Inside2 = newObject("Frame", {
		BackgroundColor3 = colorfromrgb(60, 60, 60);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 1, 0, 1);
		Size = udim2new(1, -2, 1, -2);
		BackgroundTransparency = 1;
		ZIndex = 250;
		Parent = ColorpickerOpen
	})
	local Inside3 = newObject("Frame", {
		BackgroundColor3 = colorfromrgb(40, 40, 40);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(0, 1, 0, 1);
		BackgroundTransparency = 1;
		Size = udim2new(1, -2, 1, -2);
		ZIndex = 250;
		Parent = Inside2
	})
	local SaturationImage = newObject("ImageLabel", {
		BackgroundColor3 = colorfromrgb(170, 0, 0);
		BorderColor3 = colorfromrgb(13, 13, 13);
		Position = udim2new(0, 3, 0, 3);
		Size = udim2new(0, 150, 0, 150);
		BackgroundTransparency = 1;
		ImageTransparency = 1;
		ZIndex = 250;
		Image = "rbxassetid://13966897785";
		Parent = Inside3
	})
	local SaturationMover = newObject("ImageLabel", {
		BackgroundColor3 = colorfromrgb(255, 255, 255);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		BackgroundTransparency = 1;
		ImageTransparency = 1;
		Size = udim2new(0, 4, 0, 4);
		ZIndex = 250;
		Image = "http://www.roblox.com/asset/?id=17819434984";
		Parent = SaturationImage
	})
	local HueFrame = newObject("Frame", {
		BackgroundColor3 = colorfromrgb(255, 255, 255);
		BorderColor3 = colorfromrgb(13, 13, 13);
		Position = udim2new(1, -18, 0, 3);
		Size = udim2new(0, 15, 0, 150);
		BackgroundTransparency = 1;
		ZIndex = 250;
		Parent = Inside3
	})
	local UIGradient = newObject("UIGradient", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(170, 0, 0)), ColorSequenceKeypoint.new(0.15, colorfromrgb(255, 255, 0)), ColorSequenceKeypoint.new(0.30, colorfromrgb(0, 255, 0)), ColorSequenceKeypoint.new(0.45, colorfromrgb(0, 255, 255)), ColorSequenceKeypoint.new(0.60, colorfromrgb(0, 0, 255)), ColorSequenceKeypoint.new(0.75, colorfromrgb(175, 0, 255)), ColorSequenceKeypoint.new(1.00, colorfromrgb(170, 0, 0))};
		Rotation = 90;
		Parent = HueFrame
	})
	local HueMover = newObject("ImageLabel", {
		BackgroundColor3 = colorfromrgb(255, 255, 255);
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		BackgroundTransparency = 1;
		ImageTransparency = 1;
		Size = udim2new(1, 0, 0, 4);
		ZIndex = 250;
		Image = "http://www.roblox.com/asset/?id=17819584226";
		Parent = HueFrame
	})
	local TransparencyImage = newObject("ImageLabel", {
		BorderColor3 = colorfromrgb(13, 13, 13);
		Position = udim2new(0, 3, 1, -13);
		Size = udim2new(0, 150, 0, 10);
		ImageTransparency = 0;
		ZIndex = 250;
		ScaleType = Enum.ScaleType.Tile;
		Image = "rbxassetid://18249241978";
		BackgroundTransparency = 1;
		TileSize = udim2new(0, 12, 0, 12);
		Parent = Inside3
	})
	local TransparencyFrame = newObject("Frame", {
		Position = udim2new(0, 0, 0, 0);
		Size = udim2new(1, 0, 1, 0);
		ZIndex = 251;
		Parent = TransparencyImage
	})
	local UIGradient2 = newObject("UIGradient", {
		Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(1, 0.8)};
		Rotation = 180;
		Parent = TransparencyFrame
	})
	local TransparencyMover = newObject("ImageLabel", {
		BackgroundColor3 = colorfromrgb(255, 255, 255);
		BackgroundTransparency = 1;
		BorderColor3 = colorfromrgb(0, 0, 0);
		BorderSizePixel = 0;
		Position = udim2new(1, -4, 0, 0);
		Size = udim2new(0, 4, 1, 0);
		ImageTransparency = 1;
		ZIndex = 250;
		Image = "http://www.roblox.com/asset/?id=17819483422";
		Parent = TransparencyFrame
	})

	local hue, saturation, value = 0, 0, 255

	local color = colorfromrgb(255,255,255)
	local transparency = 0

	local dragging_sat, dragging_hue, dragging_trans = false, false, false

	local function update_sv(val, sat, do_tween)
		saturation = sat
		value = val 
		color = Color3.fromHSV(hue/360, saturation/255, value/255)
		tween(SaturationMover, newtweeninfo(do_tween and menu["animation_speed"] or 0, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Position = udim2new(clamp(sat/255, 0, 0.98), 0, 1 - clamp(val/255, 0.02, 1), 0)})
		TransparencyFrame.BackgroundColor3 = color
		menu.active_colorpicker:setColor(color, transparency, true)
		menu.active_colorpicker.onColorChange:Fire(color, transparency)
	end

	local function update_hue(hue2, do_tween)
		tween(HueMover, newtweeninfo(do_tween and menu["animation_speed"] or 0, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Position = udim2new(0, 0, clamp(hue2/360, 0, 0.99), 0)})
		SaturationImage.BackgroundColor3 = Color3.fromHSV(hue2/360, 1, 1)
		color = Color3.fromHSV(hue2/360, saturation/255, value/255)
		hue = hue2
		TransparencyFrame.BackgroundColor3 = color
		menu.active_colorpicker:setColor(color, transparency, true)
		menu.active_colorpicker.onColorChange:Fire(color, transparency)
	end

	local function update_transparency(o, do_tween)
		tween(TransparencyMover, newtweeninfo(do_tween and menu["animation_speed"] or 0, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Position = udim2new(clamp(1 - o, 0, 0.98), 0, 0, 0)})
		transparency = o
		local color2 = 155 * (1-(transparency*0.5))
		UIGradient2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(color2, color2, color2)), ColorSequenceKeypoint.new(1.00, colorfromrgb(color2, color2, color2))};
		menu.active_colorpicker:setColor(color, transparency, true)
		menu.active_colorpicker.onColorChange:Fire(color, transparency)
	end

	local mouse_connection = nil

	utility.newConnection(SaturationImage.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			utility.is_dragging_blocked = true
			local xdistance = clamp((mouse.X - SaturationImage.AbsolutePosition.X)/SaturationImage.AbsoluteSize.X, 0, 1)
			local ydistance = 1 - clamp((mouse.Y - SaturationImage.AbsolutePosition.Y)/SaturationImage.AbsoluteSize.Y, 0, 1)
			local sat = 255 * xdistance
			local val = 255 * ydistance
			update_sv(val, sat, true)
			dragging_sat = true
			mouse_connection = utility.newConnection(mouse.Move, LPH_NO_VIRTUALIZE(function()
				local xdistance = clamp((mouse.X - SaturationImage.AbsolutePosition.X)/SaturationImage.AbsoluteSize.X, 0, 1)
				local ydistance = 1 - clamp((mouse.Y - SaturationImage.AbsolutePosition.Y)/SaturationImage.AbsoluteSize.Y, 0, 1)
				local sat = 255 * xdistance
				local val = 255 * ydistance
				update_sv(val, sat)
			end), true)
		end
	end)

	utility.newConnection(SaturationImage.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging_sat then
			dragging_sat = false
			mouse_connection:Disconnect()
		end
	end)

	utility.newConnection(HueFrame.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			utility.is_dragging_blocked = true
			local xdistance = clamp((mouse.Y - HueFrame.AbsolutePosition.Y)/HueFrame.AbsoluteSize.Y, 0, 1)
			local hue = 360 * xdistance
			update_hue(hue, true)
			dragging_hue = true
			mouse_connection = utility.newConnection(mouse.Move, LPH_NO_VIRTUALIZE(function()
				local xdistance = clamp((mouse.Y - HueFrame.AbsolutePosition.Y)/HueFrame.AbsoluteSize.Y, 0, 1)
				local hue = 360 * xdistance
				update_hue(hue)
			end), true)
		end
	end)

	utility.newConnection(HueFrame.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging_hue then
			dragging_hue = false
			mouse_connection:Disconnect()
		end
	end)

	utility.newConnection(TransparencyFrame.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			utility.is_dragging_blocked = true
			local xdistance = clamp((mouse.X - TransparencyFrame.AbsolutePosition.X)/TransparencyFrame.AbsoluteSize.X, 0, 1)
			update_transparency(1 - 1 * xdistance, true)
			dragging_trans = true
			mouse_connection = utility.newConnection(mouse.Move, function()
				local xdistance = clamp((mouse.X - TransparencyFrame.AbsolutePosition.X)/TransparencyFrame.AbsoluteSize.X, 0, 1)
				update_transparency(1 - 1 * xdistance)
			end, true)
		end
	end)

	utility.newConnection(TransparencyFrame.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging_trans then
			dragging_trans = false
			mouse_connection:Disconnect()
		end
	end)

	
	local clickOutConnection = nil

	local function closeColorpicker(force)
		local speed = force and 0 or menu["animation_speed"]
		local info = newtweeninfo(speed, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
				
		tween(ColorpickerOpen, info, {BackgroundTransparency = 1})
		tween(Inside2, info, {BackgroundTransparency = 1})
		tween(Inside3, info, {BackgroundTransparency = 1})
		tween(SaturationImage, info, {ImageTransparency = 1, BackgroundTransparency = 1})
		tween(SaturationMover, info, {ImageTransparency = 1, BackgroundTransparency = 1})
		tween(HueFrame, info, {BackgroundTransparency = 1})
		tween(HueMover, info, {ImageTransparency = 1, BackgroundTransparency = 1})
		tween(TransparencyFrame, info, {BackgroundTransparency = 1})
		tween(TransparencyMover, info, {ImageTransparency = 1, BackgroundTransparency = 1})
		tween(TransparencyImage, info, {ImageTransparency = 1})

		delay(speed, function()
			if menu.active_colorpicker == nil then
				menu.busy = false
				utility.is_dragging_blocked = false
				ColorpickerOpen.Visible = false
			end
		end)
		clickOutConnection:Disconnect()
		menu.active_colorpicker = nil
	end

	local function openColorpicker(new_element, _info, ColorBox, ColorpickerOpen)
		local speed = menu["animation_speed"]
		local info = newtweeninfo(speed, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
				
		local newPosition = ColorBox.AbsolutePosition
		ColorpickerOpen.Position = udim2new(0, newPosition.X, 0, newPosition.Y + 2 + ColorBox.AbsoluteSize.Y)
		ColorpickerOpen.Visible = true

		menu.active_colorpicker = new_element

		tween(ColorpickerOpen, info, {BackgroundTransparency = 0})
		tween(Inside2, info, {BackgroundTransparency = 0})
		tween(Inside3, info, {BackgroundTransparency = 0})
		tween(SaturationImage, info, {ImageTransparency = 0, BackgroundTransparency = 0})
		tween(SaturationMover, info, {ImageTransparency = 0, BackgroundTransparency = 0.6})
		tween(HueFrame, info, {BackgroundTransparency = 0})
		tween(HueMover, info, {ImageTransparency = 0.2, BackgroundTransparency = 0.5})
		tween(TransparencyFrame, info, {BackgroundTransparency = 0})
		tween(TransparencyMover, info, {ImageTransparency = 0, BackgroundTransparency = 0.5})
		tween(TransparencyImage, info, {ImageTransparency = 0})

		new_element:setColor(flags[_info.flag], flags[_info.transparency_flag])

		clickOutConnection = utility.newConnection(uis.InputBegan, LPH_NO_VIRTUALIZE(function(input, gpe)
			if gpe then return end
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				local pos = input.Position
				if not isInFrame(ColorBox, pos) and not isInFrame(ColorpickerOpen, pos) then closeColorpicker() end
			end
		end), true)

		menu.busy = true; utility.is_dragging_blocked = true

		task.wait() 
	end

	local function closeKeybind(force)
		local speed = force and 0 or menu["animation_speed"]
		local info = newtweeninfo(speed, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
				
		tween(KeybindOpen, info, {BackgroundTransparency = 1})
		tween(KeybindOpenInside2, info, {BackgroundTransparency = 1})
		tween(ToggleLabel, info, {TextTransparency = 1})
		tween(AlwaysOn, info, {TextTransparency = 1})
		tween(OnHotkeyLabel, info, {TextTransparency = 1})

		delay(speed, function()
			utility.is_dragging_blocked = false
			if menu.active_keybind == nil then
				menu.busy = false
				KeybindOpen.Visible = false
			end
		end)
		menu.active_keybind = nil
	end

	local function openKeybind(new_element, _info, KeybindOpen, KeybindLabel)
		local speed = menu["animation_speed"]
		local info = newtweeninfo(speed, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
			
		local newPosition = KeybindLabel.AbsolutePosition
		KeybindOpen.Position = udim2new(0, newPosition.X - 102, 0, newPosition.Y)
		KeybindOpen.Visible = true

		tween(KeybindOpen, info, {BackgroundTransparency = 0})
		tween(KeybindOpenInside2, info, {BackgroundTransparency = 0})
		tween(ToggleLabel, info, {TextTransparency = 0})
		tween(AlwaysOn, info, {TextTransparency = 0})
		tween(OnHotkeyLabel, info, {TextTransparency = 0})

		menu.active_keybind = new_element

		new_element:setMethod(flags[_info.flag]["method"], false, true)

		menu.busy = true; utility.is_dragging_blocked = true
	end

	function menu:set_accent_color(color)
		menu.accent_color = color
		menu.on_accent_change:Fire(color)
	end

	function menu:init(tabs, selected_tab)
		local Border = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(60, 60, 60);
			BorderColor3 = colorfromrgb(12, 12, 12);
			Position = udim2new(0.5, 0, 0.5, 0);
			Size = udim2new(0, 658, 0, 558);
			Parent = _screenGui
		})
		local Border2 = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(40, 40, 40);
			BorderColor3 = colorfromrgb(40, 40, 40);
			Position = udim2new(0, 2, 0, 2);
			Size = udim2new(1, -4, 1, -4);
			Parent = Border;
		})
		local Background = newObject("ImageLabel", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BorderColor3 = colorfromrgb(60, 60, 60);
			Position = udim2new(0, 3, 0, 3);
			Size = udim2new(1, -6, 1, -6);
			Image = "rbxassetid://15453092054";
			ScaleType = Enum.ScaleType.Tile;
			TileSize = udim2new(0, 4, 0, 548);
			ClipsDescendants = true;
			Parent = Border2
		})
		local TabFix = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 91, 0, 18);
			Size = udim2new(1, -105, 1, -33);
			Visible = true;
			ClipsDescendants = true;
			Parent = Background
		})
		local TabHolder = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(12, 12, 12);
			BackgroundTransparency = 1.000;
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 0, 0, 14);
			Size = udim2new(0, 73, 0, 0);
			Parent = Background
		})
		local TabLayout = newObject("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center;
			SortOrder = Enum.SortOrder.LayoutOrder;
			Parent = TabHolder
		})
		local TopGap = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(12, 12, 12);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Size = udim2new(0, 73, 0, 14);
			Parent = Background
		})
		local TopSideFix = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(0, 0, 0);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 73, 0, 0);
			Size = udim2new(0, 1, 1, 0);
			Parent = TopGap
		})
		local TopSideFix2 = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(40, 40, 40);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(1, 0, 0, 0);
			Size = udim2new(0, 1, 1, 0);
			Parent = TopSideFix
		})
		local BottomGap = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(12, 12, 12);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 0, 1, -22);
			Size = udim2new(0, 73, 0, 22);
			Parent = Background
		})
		local BottomSideFix = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(0, 0, 0);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 73, 0, 0);
			Size = udim2new(0, 1, 1, 0);
			Parent = BottomGap
		})
		local BottomSideFix2 = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(40, 40, 40);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(1, 0, 0, 0);
			Size = udim2new(0, 1, 1, 0);
			Parent = BottomSideFix
		})
		local TopBar_2 = newObject("ImageLabel", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BorderColor3 = colorfromrgb(12, 12, 12);
			Position = udim2new(0, 1, 0, 1);
			BackgroundTransparency = 1;
			Size = udim2new(1, -2, 0, 2);
			ZIndex = 2;
			Image = "rbxassetid://15453122383";
			Parent = Background
		})
		local BlackBar = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(6, 6, 6);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 0, 1, 0);
			Size = udim2new(1, 0, 0, 1);
			ZIndex = 2;
			Parent = TopBar_2
		})
		local Dragger = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(1, -6, 1, -6);
			Size = udim2new(0, 6, 0, 6);
			BackgroundTransparency = 1;
			Visible = true;
			Parent = Border
		})

		local isDragging = false

		utility.newConnection(Dragger.InputEnded, function(input, gpe)
			if gpe then return end
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				if isDragging then isDragging = false; utility.is_dragging_blocked = false end
			end
		end)

		utility.setDraggable(Border)

		local new_window = {
			tab_holder = TabHolder,
			active_tab = nil,
			background = Background,
			tab_fix = TabFix,
			tabs = {}
		}

		utility.newConnection(Dragger.InputBegan, function(input, gpe)
			if gpe then return end
			if input.UserInputType == Enum.UserInputType.MouseButton1 and not menu.busy then
				local oldSize = Border.Size
				isDragging = true
				utility.is_dragging_blocked = true
				spawn(function()
					while isDragging do
						local change = getMouseLocation(uis)-(Border.AbsolutePosition + Border.AbsoluteSize + vector2new(0,36))
						Border.Size = udim2new(0, clamp(oldSize.X.Offset + change.X, 658, 5000), 0, clamp(oldSize.Y.Offset + change.Y, 558, 5000))
						new_window.tabs[9].button.Visible = Border.Size.Y.Offset >= 628
						oldSize = Border.Size
						BottomGap.Size = udim2new(0, 73, 0, 22 + Border.Size.Y.Offset-(Border.Size.Y.Offset >= 628 and 622 or 558))
						BottomGap.Position = udim2new(0, 0, 1, -BottomGap.Size.Y.Offset)
						wait()
					end
				end)
			end
		end)	

		utility.newConnection(Border:GetPropertyChangedSignal("BackgroundTransparency"), function()
			if not menu.blocked then
				_screenGui.Enabled = Border.BackgroundTransparency ~= 1
				menu.is_open = _screenGui.Enabled
			end
		end)

		utility.newConnection(menu.on_closing, function()
			tween(Border, tween_info, {BackgroundTransparency = 1})
			tween(Border2, tween_info, {BackgroundTransparency = 1})
			tween(Background, tween_info, {ImageTransparency = 1})
			tween(TabHolder, tween_info, {BackgroundTransparency = 1})
			tween(TopGap, tween_info, {BackgroundTransparency = 1})
			tween(TopSideFix, tween_info, {BackgroundTransparency = 1})
			tween(TopSideFix2, tween_info, {BackgroundTransparency = 1})
			tween(BottomGap, tween_info, {BackgroundTransparency = 1})
			tween(BottomSideFix, tween_info, {BackgroundTransparency = 1})
			tween(BottomSideFix2, tween_info, {BackgroundTransparency = 1})
			tween(TopBar_2, tween_info, {ImageTransparency = 1})
			tween(BlackBar, tween_info, {BackgroundTransparency = 1})
		end, true)

		utility.newConnection(menu.on_opening, function()
			tween(Border, tween_info, {BackgroundTransparency = 0})
			tween(Border2, tween_info, {BackgroundTransparency = 0})
			tween(Background, tween_info, {ImageTransparency = 0})
			tween(TabHolder, tween_info, {BackgroundTransparency = 0})
			tween(TopGap, tween_info, {BackgroundTransparency = 0})
			tween(TopSideFix, tween_info, {BackgroundTransparency = 0})
			tween(TopSideFix2, tween_info, {BackgroundTransparency = 0})
			tween(BottomGap, tween_info, {BackgroundTransparency = 0})
			tween(BottomSideFix, tween_info, {BackgroundTransparency = 0})
			tween(BottomSideFix2, tween_info, {BackgroundTransparency = 0})
			tween(TopBar_2, tween_info, {ImageTransparency = 0})
			tween(BlackBar, tween_info, {BackgroundTransparency = 0})
		end, true)

		utility.newConnection(Background:GetPropertyChangedSignal("ImageTransparency"), function()
			Background.BackgroundTransparency = Background.ImageTransparency == 0 and 0 or 1
		end)

		setmetatable(new_window, window)

		for int = 1, 9 do
			new_window:_registerTab(int, tabs[int], int == selected_tab)
		end

		return new_window
	end

	function window:_registerTab(int, info, is_first_tab)
		local new_tab = {
			sections = {},
			is_open = false
		}

		local Button = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(12, 12, 12);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Size = udim2new(0, 73, 0, 64);
			Parent = self.tab_holder
		})
		local BottomBar = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(0, 0, 0);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 0, 1, 1);
			Size = udim2new(1, 0, 0, 1);
			Visible = false;
			ZIndex = 2;
			Parent = Button
		})
		local BottomBar2 = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(40, 40, 40);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 0, 0, -1);
			Size = udim2new(1, 2, 1, 0);
			ZIndex = 2;
			Parent = BottomBar
		})
		local Icon = newObject("ImageLabel", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Size = udim2new(1, 0, 1, 0);
			Image = info.icon;
			ImageColor3 = colorfromrgb(109, 109, 109);
			Parent = Button
		})
		local TopBar = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(0, 0, 0);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 0, 0, -2);
			Size = udim2new(1, 0, 0, 1);
			Visible = false;
			ZIndex = 2;
			Parent = Button
		})
		local TopBar2 = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(40, 40, 40);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 0, 0, 1);
			Size = udim2new(1, 2, 1, 0);
			ZIndex = 2;
			Parent = TopBar
		})
		local SideBar = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(0, 0, 0);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 73, 0, 0);
			Size = udim2new(0, 1, 1, 0);
			Parent = Button
		})
		local SideBar2 = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(40, 40, 40);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(1, 0, 0, 0);
			Size = udim2new(0, 1, 1, 0);
			Parent = SideBar    
		})

		if int == 9 then
			Button.Visible = false
		end

		local _Tab = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 5, 0, 5);
			Size = udim2new(1, -10, 1, -8);
			Visible = false;
			Parent = self.tab_fix
		})

		utility.newConnection(menu.on_closing, function()
			tween(Button, tween_info, {BackgroundTransparency = 1})
			tween(BottomBar, tween_info, {BackgroundTransparency = 1})
			tween(BottomBar2, tween_info, {BackgroundTransparency = 1})
			tween(SideBar2, tween_info, {BackgroundTransparency = 1})
			tween(SideBar, tween_info, {BackgroundTransparency = 1})
			tween(TopBar2, tween_info, {BackgroundTransparency = 1})
			tween(TopBar, tween_info, {BackgroundTransparency = 1})
			tween(Icon, tween_info, {ImageTransparency = 1})
		end, true)

		utility.newConnection(menu.on_opening, function()
			tween(Button, tween_info, {BackgroundTransparency = self.active_tab == int and 1 or 0})
			tween(BottomBar, tween_info, {BackgroundTransparency = 0})
			tween(BottomBar2, tween_info, {BackgroundTransparency = 0})
			tween(SideBar2, tween_info, {BackgroundTransparency = 0})
			tween(SideBar, tween_info, {BackgroundTransparency = 0})
			tween(TopBar2, tween_info, {BackgroundTransparency = 0})
			tween(TopBar, tween_info, {BackgroundTransparency = 0})
			tween(Icon, tween_info, {ImageTransparency = 0})
		end, true)

		utility.newConnection(Button.InputBegan, function(input, gpe)
			if gpe then return end
			local inputType = input.UserInputType
			if inputType == Enum.UserInputType.MouseButton1 then
				if self.active_tab == int then return end
				self:_setActiveTab(int)
			end
		end)

		utility.newConnection(Button.MouseEnter, function()
			if self.active_tab == int then return end
			tween(Icon, newtweeninfo(menu["animation_speed"]/2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageColor3 = colorfromrgb(204, 204, 204)})
		end)

		utility.newConnection(Button.MouseLeave, function()
			if self.active_tab == int then return end
			tween(Icon, newtweeninfo(menu["animation_speed"]/2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageColor3 = colorfromrgb(109, 109, 109)})
		end)

		utility.newConnection(_Tab:GetPropertyChangedSignal("Position"), LPH_NO_VIRTUALIZE(function()
			local scale = _Tab.Position.Y.Scale
			_Tab.Visible = not (scale == 1 or scale == -1)
		end))

		new_tab.button = Button
		new_tab.icon = Icon
		new_tab.bottom_bar = BottomBar
		new_tab.top_bar = TopBar
		new_tab.side_bar = SideBar
		new_tab.frame = _Tab

		setmetatable(new_tab, tab)

		self.tabs[int] = new_tab

		if info.subtabs then
			new_tab.subtabs = {}
			local Section = newObject("Frame", {
				BackgroundColor3 = colorfromrgb(0, 0, 0);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Size = udim2new(1, -1, 0, 61);
				Position = udim2new(0, 0, 0, 0);
				BackgroundTransparency = 1;
				Parent = _Tab
			})
			local Inside = newObject("Frame", {
				BackgroundColor3 = colorfromrgb(12, 12, 12);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Size = udim2new(1, 0, 1, -1);
				BackgroundTransparency = 1;
				Parent = Section
			})
			local Inside2 = newObject("Frame", {
				BackgroundColor3 = colorfromrgb(40, 40, 40);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 1, 0, 0);
				Size = udim2new(1, -2, 1, -1);
				BackgroundTransparency = 1;
				Parent = Inside
			})
			local Inside3 = newObject("Frame", {
				BackgroundColor3 = colorfromrgb(23, 23, 23);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 1, 0, 0);
				Size = udim2new(1, -2, 1, -1);
				BackgroundTransparency = 1;
				Parent = Inside2
			})
			local OptionHolder = newObject("Frame", {
				BackgroundTransparency = 1,
				Position = udim2new(0, 10, 0, 0),
				Size = udim2new(1,-20,1,0),
				Parent = Inside3,
			})
			newObject("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Parent = OptionHolder
			})
			local SectionLabel = newObject("TextLabel", {
				BackgroundColor3 = colorfromrgb(255, 255, 255);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 12, 0, -2);
				FontFace = menu_font_bold;
				Text = info.name or "Category";
				TextColor3 = colorfromrgb(198, 198, 198);
				TextSize = 13.000;
				TextXAlignment = Enum.TextXAlignment.Left;
				ZIndex = 4;
				TextTransparency = 1;
				Parent = Inside3
			})
			local TopLine = newObject("Frame", {
				BackgroundColor3 = colorfromrgb(40, 40, 40);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Size = udim2new(0, 9, 0, 1);
				BackgroundTransparency = 1;
				Parent = Inside3
			})
			local TopLine2 = newObject("Frame", {
				BackgroundColor3 = colorfromrgb(12, 12, 12);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, -2, 0, -1);
				Size = udim2new(1, 2, 0, 1);
				BackgroundTransparency = 1;
				Parent = TopLine
			})
			local size = ts:GetTextSize(info.name or "Category", 13, Enum.Font.SourceSansBold, vector2new(9999,9999)).x
			local _TopLine = newObject("Frame", {
				BackgroundColor3 = colorfromrgb(40, 40, 40);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Size = udim2new(1, -(size + 16), 0, 1);
				Position = udim2new(0, size + 16, 0, 0);
				BackgroundTransparency = 1;
				Parent = Inside3
			})
			local _TopLine2 = newObject("Frame", {	
				BackgroundColor3 = colorfromrgb(12, 12, 12);
				BorderColor3 = colorfromrgb(0, 0, 0);
				BorderSizePixel = 0;
				Position = udim2new(0, 0, 0, -1);
				Size = udim2new(1, 2, 0, 1);
				BackgroundTransparency = 1;
				Parent = _TopLine
			})
	
			new_tab.on_opening = function(bypass)
				if not _Tab.Visible and not bypass then return end; local info = bypass and newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.In) or tween_info
				tween(_TopLine2, info, {BackgroundTransparency = 0})
				tween(_TopLine, info, {BackgroundTransparency = 0})
				tween(TopLine2, info, {BackgroundTransparency = 0})
				tween(TopLine, info, {BackgroundTransparency = 0})
				tween(Inside, info, {BackgroundTransparency = 0})
				tween(Inside2, info, {BackgroundTransparency = 0})
				tween(Inside3, info, {BackgroundTransparency = 0})
				tween(SectionLabel, info, {TextTransparency = 0})
				local children = OptionHolder:GetChildren()
				for i = 1, #children do
					local image = children[i]
					if image.ClassName == "ImageLabel" then
						tween(image, info, {ImageTransparency = 0})
					end
				end
			end
			new_tab.on_closing = function(bypass)
				if not _Tab.Visible and not bypass then return end; local info = bypass and newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.In) or tween_info
		
				tween(_TopLine2, info, {BackgroundTransparency = 1})
				tween(_TopLine, info, {BackgroundTransparency = 1})
				tween(TopLine2, info, {BackgroundTransparency = 1})
				tween(TopLine, info, {BackgroundTransparency = 1})
				tween(Inside, info, {BackgroundTransparency = 1})
				tween(Inside2, info, {BackgroundTransparency = 1})
				tween(Inside3, info, {BackgroundTransparency = 1})
				tween(SectionLabel, info, {TextTransparency = 1})
				local children = OptionHolder:GetChildren()
				for i = 1, #children do
					local image = children[i]
					if image.ClassName == "ImageLabel" then
						tween(image, info, {ImageTransparency = 1})
					end
				end
			end

			new_tab.subtabs = {}

			local total = 0
			for _, option in info.subtabs.options do
				total+=1
				new_tab.subtabs[total] = new_tab:_registerSubtab(option)
				local int = total
				local Image = newObject("ImageLabel", {
					BackgroundTransparency = 1,
					Image = option.image,
					ImageColor3 = total == 1 and colorfromrgb(205,205,205) or colorfromrgb(96,96,96),
					Size = udim2new(0, 75, 0, 57),
					ImageTransparency = 1,
					Parent = OptionHolder
				})
	
				utility.newConnection(Image.MouseEnter, function()
					if new_tab.active_subtab == int then
						return end
	
					Image.ImageColor3 = colorfromrgb(135,135,135)
				end)
	
				utility.newConnection(Image.MouseLeave, function()
					if new_tab.active_subtab == int then
						return end
	
					Image.ImageColor3 = colorfromrgb(96,96,96)
				end)
	
				utility.newConnection(Image.InputBegan, function(input, gpe)
					if new_tab.active_subtab == int then
						return end
	
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						local children = OptionHolder:GetChildren()
						for i = 1, #children do
							local child = children[i]
							if child.ClassName == "ImageLabel" then
								child.ImageColor3 = colorfromrgb(96,96,96)
							end
						end
						Image.ImageColor3 = colorfromrgb(205,205,205)
						new_tab:_setActiveSubtab(int)
					end
				end)
			end
			utility.newConnection(menu.on_closing, new_tab.on_closing)
			utility.newConnection(menu.on_opening, new_tab.on_opening)
		end

		if is_first_tab then self:_setActiveTab(int) end

		return new_tab
	end

	function window:_setActiveTab(int)
		local tabs = self.tabs
		local new_tab = tabs[int]
		local last_tab = tabs[self.active_tab or int]
		
		local down = ((self.active_tab or int)-int) < 1
		local speed = menu["animation_speed"]

		self.active_tab = int

		for _, section in last_tab.sections do
			spawn(section.on_closing, true)
			for _, element in section.elements do
				for _, func in element.closing do
					spawn(func, true)
				end
			end
		end
		if new_tab.on_opening then
			spawn(new_tab.on_opening, true)
		end
		if last_tab.on_closing then
			spawn(last_tab.on_closing, true)
		end
		tween(last_tab.frame, newtweeninfo(speed+0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = udim2new(0, 5, down and -1 or 1, 5)})
		new_tab.frame.Position = udim2new(0, 5, down and 1 or -1, 5)
		tween(new_tab.frame, newtweeninfo(speed+0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = udim2new(0, 5, 0, 5)})
		for _, section in new_tab.sections do
			spawn(section.on_opening, true)
			for _, element in section.elements do
				for _, func in element.opening do
					spawn(func, true)
				end
			end
		end

		local tabs = self.tabs
		for _int = 1, 9 do
			local tab = tabs[_int]
			if not tab then continue end -- // no better way to do it!! frick
			local is_active_tab = int == _int
			tween(tab.icon, newtweeninfo(0, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageColor3 = is_active_tab and colorfromrgb(255,255,255) or colorfromrgb(109, 109, 109)})
			tab.bottom_bar.Visible = is_active_tab
			tab.top_bar.Visible = is_active_tab
			tab.side_bar.Visible = not is_active_tab
			tab.button.BackgroundTransparency = is_active_tab and 1 or 0
		end
	end

	function tab:_registerSubtab()
		local new_subtab = {
			has_selector = true,
			sections = {},
			frame = newObject("Frame", {
				BackgroundColor3 = colorfromrgb(0, 0, 0);
				BackgroundTransparency = 1;
				BorderSizePixel = 0;
				Position = udim2new(1,10,0,80);
				Size = udim2new(1, 0, 1, -80);
				Visible = false;
				Parent = self.frame
			})
		}

		setmetatable(new_subtab, tab)

		return new_subtab
	end

	function tab:_setActiveSubtab(int)
		local tabs = self.subtabs
		local new_tab = tabs[int]
		local old = self.active_subtab
		local last_tab = tabs[self.active_subtab or int]
		
		local down = ((old or int)-int) < 1
		local speed = menu["animation_speed"]

		new_tab.frame.Visible = true

		self.active_subtab = int

		for _, section in last_tab.sections do
			spawn(section.on_closing, true)
			for _, element in section.elements do
				for _, func in element.closing do
					spawn(func, true)
				end
			end
		end
		delay(speed+0.2, function()
			if self.active_subtab ~= old and last_tab ~= new_tab then
				last_tab.frame.Visible = false
			end
		end)
		tween(last_tab.frame, newtweeninfo(speed+0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = udim2new(down and -1 or 1, 0, 0, 80)})
		new_tab.frame.Position = udim2new(down and 1 or -1, 0, 0, 80)
		tween(new_tab.frame, newtweeninfo(speed+0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = udim2new(0, 0, 0, 80)})
		for _, section in new_tab.sections do
			spawn(section.on_opening, true)
			for _, element in section.elements do
				for _, func in element.opening do
					spawn(func, true)
				end
			end
		end
	end

	function tab:getSubtab(int)
		return self.subtabs[int]
	end

	function window:getTab(int)
		return self.tabs[int]
	end

	function tab:newSection(info)
		local Section = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(0, 0, 0);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Size = udim2new(0.5, -10, info.scale, info.y and -19);
			Position = udim2new(info.x, info.x and 9 or 0, info.y, info.y and 19 or 0);
			BackgroundTransparency = 1;
			Parent = self.frame
		})
		local Inside = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(12, 12, 12);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Size = udim2new(1, 0, 1, -1);
			BackgroundTransparency = 1;
			Parent = Section
		})
		local Inside2 = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(40, 40, 40);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 1, 0, 0);
			Size = udim2new(1, -2, 1, -1);
			BackgroundTransparency = 1;
			Parent = Inside
		})
		local Inside3 = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(23, 23, 23);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 1, 0, 0);
			Size = udim2new(1, -2, 1, -1);
			BackgroundTransparency = 1;
			Parent = Inside2
		})
		local SectionLabel = newObject("TextLabel", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 12, 0, -2);
			FontFace = menu_font_bold;
			Text = info.name;
			TextColor3 = colorfromrgb(198, 198, 198);
			TextSize = 13.000;
			TextXAlignment = Enum.TextXAlignment.Left;
			ZIndex = 4;
			TextTransparency = 1;
			Parent = Inside3
		})
		local TopLine = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(40, 40, 40);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Size = udim2new(0, 9, 0, 1);
			BackgroundTransparency = 1;
			Parent = Inside3
		})
		local TopLine2 = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(12, 12, 12);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, -2, 0, -1);
			Size = udim2new(1, 2, 0, 1);
			BackgroundTransparency = 1;
			Parent = TopLine
		})
		local ArrowUp = newObject("ImageLabel", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(1, -16, 0, 5);
			Size = udim2new(0, 5, 0, 4);
			Image = "rbxassetid://15540851994";
			ImageTransparency = 1;
			ZIndex = 3;
			Visible = false;
			Parent = Inside3
		})
		local ArrowDown = newObject("ImageLabel", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(1, -16, 1, -9);
			Size = udim2new(0, 5, 0, 4);
			Visible = false;
			ZIndex = 3;
			Image = "rbxassetid://15540867448";
			ImageTransparency = 1;
			Parent = Inside3
		})
		local BottomShadow = newObject("ImageLabel", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 1, 1, -20);
			Size = udim2new(1, -2, 0, 20);
			Image = "rbxassetid://15541064478";
			ImageColor3 = colorfromrgb(23, 23, 23);
			ZIndex = 2;
			ImageTransparency = 1;
			Parent = Inside3
		})
		local TopShadow = newObject("ImageLabel", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Rotation = 180.000;
			Position = udim2new(0, 1, 0, 2);
			Size = udim2new(1, -2, 0, 20);
			Image = "rbxassetid://15541064478";
			ImageColor3 = colorfromrgb(23, 23, 23);
			ImageTransparency = 1;
			ZIndex = 2;
			Parent = Inside3
		})
		local ScrollBackground = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(40, 40, 40);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BackgroundTransparency = 1;
			BorderSizePixel = 0;
			Position = udim2new(1, -6, 0, 0);
			Size = udim2new(0, 6, 1, 0);
			Visible = false;
			ZIndex = 2;
			Parent = Inside3
		})
		local Scroller = newObject("ScrollingFrame", {
			Active = false;
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 0, 0, 2);
			Selectable = false;
			ScrollingEnabled = false;
			Size = udim2new(1, 0, 1, -2);
			ZIndex = 3;
			BottomImage = "rbxassetid://15540816491";
			CanvasPosition = vector2new(0, 0);
			CanvasSize = udim2new(0, 0, 1, 0);
			MidImage = "rbxassetid://15540816491";
			ScrollBarImageTransparency = 1;
			AutomaticCanvasSize = Enum.AutomaticSize.Y;
			ScrollBarImageColor3 = colorfromrgb(65, 65, 65);
			ScrollBarThickness = 5;
			TopImage = "rbxassetid://15540816491";
			ClipsDescendants = true;
			Parent = Inside3
		})
		local ElementHolder = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 18, 0, 18);
			Size = udim2new(1, -36, 0, 0);
			AutomaticSize = Enum.AutomaticSize.Y;
			Parent = Scroller
		})
		local UIListLayout = newObject("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder;
			Padding = UDim.new(0, 10);
			Parent = ElementHolder
		})

		local size = ts:GetTextSize(info.name, 13, Enum.Font.SourceSansBold, vector2new(9999,9999)).x

		local _TopLine = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(40, 40, 40);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Size = udim2new(1, -(size + 16), 0, 1);
			Position = udim2new(0, size + 16, 0, 0);
			BackgroundTransparency = 1;
			Parent = Inside3
		})
		local _TopLine2 = newObject("Frame", {	
			BackgroundColor3 = colorfromrgb(12, 12, 12);
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 0, 0, -1);
			Size = udim2new(1, 2, 0, 1);
			BackgroundTransparency = 1;
			Parent = _TopLine
		})
		local _Frame = newObject("Frame", {
			Parent = nil;
			Size = udim2new(1,0,0,4);
			Visible = true;
			BackgroundTransparency = 1
		})
		local function updateSize()
			local wholeSectionSize = Section.AbsoluteSize - vector2new(0, 40)
			if ElementHolder.AbsoluteSize.Y > wholeSectionSize.Y then
				Scroller.CanvasSize = udim2new(0, 0, 1, 0)
				Scroller.ScrollingEnabled = true
				Scroller.ScrollBarImageTransparency = 0
				ScrollBackground.Visible = true
				ArrowUp.Visible = true
				ArrowDown.Visible = true
				BottomShadow.Visible = true; TopShadow.Visible = true
				_Frame.Parent = ElementHolder
			else
				_Frame.Parent = nil
				Scroller.ScrollingEnabled = false
				Scroller.ScrollBarImageTransparency = 1
				ScrollBackground.Visible = false
				ArrowUp.Visible = false
				ArrowDown.Visible = false
				BottomShadow.Visible = false; TopShadow.Visible = false
			end 
		end

		utility.newConnection(ArrowUp.InputBegan, function(input, gpe)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				Scroller.CanvasPosition = vector2new(0,0)
			end
		end)

		utility.newConnection(ArrowDown.InputBegan, function(input, gpe)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				Scroller.CanvasPosition = vector2new(0,Scroller.AbsoluteCanvasSize.Y)
			end
		end)

		utility.newConnection(_TopLine:GetPropertyChangedSignal("AbsoluteSize"), function()
			_TopLine.Visible = _TopLine.AbsoluteSize.X > 0 and true or false
		end)

		utility.newConnection(Scroller:GetPropertyChangedSignal("CanvasPosition"), function()
			if Scroller.CanvasPosition.Y/Scroller.AbsoluteCanvasSize.Y < 0.5 then
				ArrowUp.ImageTransparency = 0
				ArrowDown.ImageTransparency = 1
			else
				ArrowUp.ImageTransparency = 1
				ArrowDown.ImageTransparency = 0
			end
		end)

		local new_section = {
			tab_frame = self.frame;
			element_holder = ElementHolder;
			elements = {};
			frame = Section;
			on_closing = function(bypass)
				if not self.frame.Visible and not bypass then return end; local info = bypass and newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.In) or tween_info
				tween(_TopLine2, info, {BackgroundTransparency = 1})
				tween(_TopLine, info, {BackgroundTransparency = 1})
				tween(ScrollBackground, info, {BackgroundTransparency = 1})
				tween(Scroller, info, {ScrollBarImageTransparency = 1})
				tween(TopShadow, info, {ImageTransparency = 1})
				tween(BottomShadow, info, {ImageTransparency = 1})
				tween(ArrowUp, info, {ImageTransparency = 1})
				tween(ArrowDown, info, {ImageTransparency = 1})
				tween(TopLine2, info, {BackgroundTransparency = 1})
				tween(TopLine, info, {BackgroundTransparency = 1})
				tween(Inside, info, {BackgroundTransparency = 1})
				tween(Inside2, info, {BackgroundTransparency = 1})
				tween(Inside3, info, {BackgroundTransparency = 1})
				tween(SectionLabel, info, {TextTransparency = 1})
			end,
			on_opening = function(bypass)
				if not self.frame.Visible and not bypass then return end; local info = bypass and newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.In) or tween_info
				tween(_TopLine2, info, {BackgroundTransparency = 0})
				tween(_TopLine, info, {BackgroundTransparency = 0})
				tween(Scroller, info, {ScrollBarImageTransparency = Scroller.ScrollingEnabled and 0 or 1})
				tween(TopShadow, info, {ImageTransparency = 0})
				tween(BottomShadow, info, {ImageTransparency = 0})
				if Scroller.CanvasPosition.Y/Scroller.AbsoluteCanvasSize.Y < 0.5 then
					tween(ArrowUp, info, {ImageTransparency = 0})
				else
					tween(ArrowDown, info, {ImageTransparency = 0})
				end
				tween(TopLine2, info, {BackgroundTransparency = 0})
				tween(TopLine, info, {BackgroundTransparency = 0})
				tween(Inside, info, {BackgroundTransparency = 0})
				tween(Inside2, info, {BackgroundTransparency = 0})
				tween(Inside3, info, {BackgroundTransparency = 0})
				tween(SectionLabel, info, {TextTransparency = 0})
			end
		}

		utility.newConnection(menu.on_closing, new_section.on_closing)
		utility.newConnection(menu.on_opening, new_section.on_opening)

		setmetatable(new_section, section)

		utility.newConnection(Section:GetPropertyChangedSignal("Size"), updateSize)

		utility.newConnection(ElementHolder:GetPropertyChangedSignal("AbsoluteSize"), updateSize)

		self.sections[info.name] = new_section

		return new_section
	end

	function section:newElement(info)
		local Frame = newObject("Frame", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Size = udim2new(1, 0, 0, 8);
			Parent = self.element_holder	
		})
		local Label = newObject("TextLabel", {
			BackgroundColor3 = colorfromrgb(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = colorfromrgb(0, 0, 0);
			BorderSizePixel = 0;
			Position = udim2new(0, 20, 0, -1);
			Size = udim2new(0.5, 0, 0, 8);
			FontFace = menu_font;
			Text = info.name;
			TextColor3 = info.highlighted == true and colorfromrgb(182, 182, 101) or colorfromrgb(205, 205, 205);
			TextSize = 13.000;
			TextXAlignment = Enum.TextXAlignment.Left;
			TextTransparency = 1;
			Parent = Frame
		})

		local new_element = {
			frame = Frame,
			closing = {},
			visible = true,
			name = info.name,
			label = Label,
			opening = {}
		}

		local tab_frame = self.tab_frame
		local total = 0
		setmetatable(new_element, element)

		for _element, _info in info.types do
			new_element[_element] = _info
			if lower(_element) == "toggle" then
				total+=1
				local Box = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(12, 12, 12);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Size = udim2new(0, 8, 0, 8);
					BackgroundTransparency = 1;
					Parent = Frame
				})
				local Inside = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(77, 77, 77);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 1, 0, 1);
					Size = udim2new(1, -2, 1, -2);
					BackgroundTransparency = 1;
					Parent = Box
				})
				newObject("UIGradient", {
					Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(255, 255, 255)), ColorSequenceKeypoint.new(1.00, colorfromrgb(218, 218, 218))};
					Rotation = 90;
					Parent = Inside
				})

				insert(new_element.closing, function(bypass)
					if not tab_frame.Visible and not bypass then return end; local info = bypass and newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.In) or tween_info
					tween(Box, info, {BackgroundTransparency = 1})
					tween(Inside, info, {BackgroundTransparency = 1})
				end, true)

				insert(new_element.opening, function(bypass)
					if not new_element.visible then return end
					if not tab_frame.Visible and not bypass then return end; local info = bypass and newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.In) or tween_info
					tween(Box, info, {BackgroundTransparency = 0})
					tween(Inside, info, {BackgroundTransparency = 0})
				end, true)

				local h,s,v = menu.accent_color:ToHSV()

				new_element.onToggleChange = signal.new()

				new_element.toggled = false

				flags[_info.flag] = false

				utility.newConnection(menu.on_accent_change, function(color)
					h,s,v = color:ToHSV()
					if new_element.toggled then
						tween(Inside, newtweeninfo(0, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {BackgroundColor3 = color})
					end
				end)

				local function onHover()
					tween(Inside, newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundColor3 = new_element.toggled == true and Color3.fromHSV(h,s,v*1.1) or colorfromrgb(85,85,85)})
				end

				local function onLeave()
					tween(Inside, newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundColor3 = new_element.toggled == true and menu.accent_color or colorfromrgb(77,77,77)})
				end

				local function onClick(input, gpe)
					if gpe then return end
					if input.UserInputType == Enum.UserInputType.MouseButton1 and not menu.busy then
						new_element:setToggle(not new_element.toggled)
					end
				end

				local last_bool = _info.default

				function new_element:setToggle(bool, dont)
					if last_bool ~= bool or dont then
						new_element.onToggleChange:Fire(bool)
					end
					last_bool = bool
					tween(Inside, newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundColor3 = bool and menu.accent_color or colorfromrgb(77,77,77)})
					new_element.toggled = bool
					flags[_info.flag] = bool
				end

				new_element:setToggle(_info.default or false)

				utility.newConnection(Label.InputEnded, onClick)
				utility.newConnection(Box.InputEnded, onClick)
				utility.newConnection(Box.MouseEnter, onHover)
				utility.newConnection(Label.MouseEnter, onHover)
				utility.newConnection(Box.MouseLeave, onLeave)
				utility.newConnection(Label.MouseLeave, onLeave)

				if not _info.no_load then
					utility.newConnection(menu.on_load, function()
						new_element:setToggle(flags[_info.flag])
					end)
				end
			elseif lower(_element) == "dropdown" then
				total+=1
				Frame.Size = udim2new(1,0,0,31)
				local Border = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(12, 12, 12);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 19, 0, 11);
					Size = udim2new(0.72, 0, 0, 20);
					BackgroundTransparency = 1;
					Parent = Frame
				})
				local UISizeConstraint = newObject("UISizeConstraint", {
					MaxSize = vector2new(200, 9e9);
					Parent = Border
				})
				local _Inside = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(36, 36, 36);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 1, 0, 1);
					Size = udim2new(1, -2, 1, -2);
					BackgroundTransparency = 1;
					Parent = Border
				})
				newObject("UIGradient", {
					Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(219, 219, 219)), ColorSequenceKeypoint.new(1.00, colorfromrgb(255, 255, 255))};
					Rotation = 90;
					Parent = _Inside
				})
				local DropdownLabel = newObject("TextLabel", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BackgroundTransparency = 1.000;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 6, 0, 0);
					Size = udim2new(1, -24, 1, 0);
					FontFace = menu_font;
					TextTransparency = 1;
					Text = "-";
					TextColor3 = colorfromrgb(152, 152, 152);
					TextSize = 13.000;
					TextWrapped = true;
					TextXAlignment = Enum.TextXAlignment.Left;
					Parent = _Inside
				})
				local Arrow = newObject("ImageLabel", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BackgroundTransparency = 1.000;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(1, -11, 0, 6);
					Size = udim2new(0, 5, 0, 4);
					Image = "rbxassetid://15556784588";
					ImageColor3 = colorfromrgb(151, 151, 151);
					ImageTransparency = 1;
					Parent = _Inside
				})
				local DropdownOpen = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(12, 12, 12);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 19, 0, 11);
					Size = udim2new(0, 156, 0, 20);
					AutomaticSize = Enum.AutomaticSize.Y;
					Visible = false;
					ZIndex = 10;
					Parent = _screenGui
				})
				local OpenInside = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(35, 35, 35);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 1, 0, 1);
					Size = udim2new(1, -2, 1, -2);
					ClipsDescendants = true;
					ZIndex = 10;
					Parent = DropdownOpen
				})
				newObject("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Right;
					SortOrder = Enum.SortOrder.LayoutOrder;
					Parent = OpenInside
				})

				local isOpen = false

				local function onHover()
					tween(_Inside, newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundColor3 = colorfromrgb(46,46,46)})
					Arrow.ImageColor3 = colorfromrgb(156, 156, 156)
				end

				local function onLeave()
					if isOpen then return end
					Arrow.ImageColor3 = colorfromrgb(151, 151, 151)
					tween(_Inside, newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundColor3 = colorfromrgb(36,36,36)})
				end

				local clickOutConnection = nil

				new_element.onDropdownChange = signal.new()

				local function closeDropdown(notOnBorder)
					local speed = tab_frame.Position.Y.Scale ~= 0 and 0 or menu["animation_speed"]
					clickOutConnection:Disconnect()
					tween(DropdownOpen, newtweeninfo(speed, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = udim2new(0, Border.AbsoluteSize.X + 1, 0, 0), BackgroundTransparency = 1})
					local children = OpenInside:GetChildren()
					for i = 1, #children do
						local child = children[i]
						if child.ClassName == "TextLabel" then
							tween(child, newtweeninfo(speed, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 1})
						end
					end

					delay(0, function()
						isOpen = false
						clickOutConnection:Disconnect()
						if notOnBorder then 
							Arrow.ImageColor3 = colorfromrgb(151, 151, 151)
							tween(_Inside, newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundColor3 = colorfromrgb(36,36,36)})
						end
						if tab_frame.Position.Y.Scale ~= 0 then
							DropdownOpen.Visible = false
						end
					end)

					delay(speed-0.05, function()
						if not isOpen then
							menu.busy = false
							utility.is_dragging_blocked = false	
							DropdownOpen.Visible = false
						end
					end)
				end

				new_element.dropdown_visible = true

				local function openDropdown()
					if not new_element.dropdown_visible or menu.busy then
						return end

					local newPosition = Border.AbsolutePosition
					DropdownOpen.AutomaticSize = Enum.AutomaticSize.Y
					DropdownOpen.Size = udim2new(0, Border.AbsoluteSize.X + 1, 0, 20)
					local size = DropdownOpen.AbsoluteSize
					DropdownOpen.AutomaticSize = Enum.AutomaticSize.None
					DropdownOpen.Size = udim2new(0, Border.AbsoluteSize.X + 1, 0, 0)
					DropdownOpen.Position = udim2new(0, newPosition.X + 0.5, 0, newPosition.Y + 2 + Border.AbsoluteSize.Y)
					tween(DropdownOpen, newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = udim2new(0, Border.AbsoluteSize.X + 1, 0, size.Y), BackgroundTransparency = 0})
					local children = OpenInside:GetChildren()
					for i = 1, #children do
						local child = children[i]
						if child.ClassName == "TextLabel" then
							tween(child, newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0})
						end
					end
					DropdownOpen.Visible = true
					clickOutConnection = utility.newConnection(uis.InputBegan, LPH_NO_VIRTUALIZE(function(input, gpe)
						if gpe then return end
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							local pos = input.Position
							if not isInFrame(Border, pos) and not isInFrame(DropdownOpen, pos) then closeDropdown(true) end
						end
					end), true)

					isOpen = true; menu.busy = true; utility.is_dragging_blocked = true
				end

				function new_element:setSelected(options)
					local string = ""
					local children = OpenInside:GetChildren()
					for i = 1, #children do
						local label = children[i]
						if label.ClassName ~= "TextLabel" then 
							continue end
						local option = label.Name
						if find(options, option) then
							string = #string == 0 and option or string..", "..option
							label.FontFace = menu_font_bold
							label.TextColor3 = menu.accent_color
						else
							label.FontFace = menu_font
							label.TextColor3 = colorfromrgb(208, 208, 208)
						end
					end
					DropdownLabel.Text = string == "" and "-" or string
					new_element.onDropdownChange:Fire(options)
					flags[_info.flag] = options
				end

				utility.newConnection(menu.on_accent_change, function(color)
					local children = OpenInside:GetChildren() 
					for i = 1, #children do
						local label = children[i]
						if label.ClassName ~= "TextLabel" then 
							continue end
						local option = label.Name
						if find(flags[_info.flag], option) then
							label.TextColor3 = menu.accent_color
						end
					end
				end)

				flags[_info.flag] = {}

				do
					for _, option in _info.options do
						local DropdownOption = newObject("TextLabel", {
							BackgroundColor3 = colorfromrgb(25, 25, 25);
							BackgroundTransparency = 1.000;
							BorderColor3 = colorfromrgb(0, 0, 0);
							BorderSizePixel = 0;
							Size = udim2new(1, 0, 0, 20);
							ZIndex = 11;
							FontFace = menu_font;
							Text = "   "..option;
							TextColor3 = colorfromrgb(208, 208, 208);
							TextSize = 13.000;
							TextXAlignment = Enum.TextXAlignment.Left;
							TextTransparency = 1;
							Parent = OpenInside
						}); DropdownOption.Name = option

						if _info.multi then
							utility.newConnection(DropdownOption.MouseEnter, function()
								DropdownOption.BackgroundTransparency = 0
							end)

							utility.newConnection(DropdownOption.MouseLeave, function()
								DropdownOption.BackgroundTransparency = 1
							end)

							utility.newConnection(DropdownOption.InputBegan, function(input, gpe)
								if gpe then return end
								if input.UserInputType == Enum.UserInputType.MouseButton1 then
									if not find(flags[_info.flag], option) then 
										insert(flags[_info.flag], option)
									else
										if _info.no_none and length(flags[_info.flag]) == 1 then return end
										remove(flags[_info.flag], option)
									end
									new_element:setSelected(flags[_info.flag])
								end
							end)
						else
							utility.newConnection(DropdownOption.MouseEnter, function()
								DropdownOption.BackgroundTransparency = 0
								if flags[_info.flag][1] == option then return end
								DropdownOption.FontFace = menu_font_bold
							end)

							utility.newConnection(DropdownOption.MouseLeave, function()
								DropdownOption.BackgroundTransparency = 1
								if flags[_info.flag][1] == option then return end
								DropdownOption.FontFace = menu_font
							end)

							utility.newConnection(DropdownOption.InputBegan, function(input, gpe)
								if gpe then return end
								if input.UserInputType == Enum.UserInputType.MouseButton1 then
									if _info.no_none and find(flags[_info.flag], option) then return end
									flags[_info.flag] = find(flags[_info.flag], option) and nil or {option}
									new_element:setSelected(flags[_info.flag])
									closeDropdown()
								end
							end)
						end
					end
				end

				local closing = function(bypass)
					if not tab_frame.Visible and not bypass then return end; local info = bypass and newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.In) or tween_info
					tween(Border, info, {BackgroundTransparency = 1})
					tween(_Inside, info, {BackgroundTransparency = 1})
					tween(DropdownLabel, info, {TextTransparency = 1})
					tween(Arrow, info, {ImageTransparency = 1})
					if isOpen then closeDropdown() end
				end

				local opening = function(bypass)
					if not new_element.dropdown_visible then return end
					if not tab_frame.Visible and not bypass then return end; local info = bypass and newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.In) or tween_info
					tween(Border, info, {BackgroundTransparency = 0})
					tween(_Inside, info, {BackgroundTransparency = 0})
					tween(DropdownLabel, info, {TextTransparency = 0})
					tween(Arrow, info, {ImageTransparency = 0})
				end

				insert(new_element.closing, closing)

				insert(new_element.opening, opening)

				function new_element:setDropdownVisibility(bool, force)
					local speed = (tab_frame.Position.Y.Scale ~= 0 or force) and 0 or menu["animation_speed"]
			
					if bool then
						Border.Visible = true
					end

					new_element.dropdown_visible = bool
					spawn(bool and opening or closing, true)
					tween(Frame, newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {Size = bool and self.og_size or udim2new(1,0,0,8)})

					delay(speed, function()
						if not bool and not new_element.dropdown_visible then
							Border.Visible = false
						end
					end)
				end

				utility.newConnection(Border.MouseEnter, onHover)
				utility.newConnection(Border.MouseLeave, onLeave)

				utility.newConnection(Border.InputEnded, function(input, gpe)
					if gpe then return end
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if not menu.busy then
							openDropdown()
						elseif isOpen then
							closeDropdown()
						end
					end
				end)

				new_element:setSelected(_info.default ~= nil and _info.default or {})

				if not _info.no_load then
					utility.newConnection(menu.on_load, function()
						new_element:setSelected(flags[_info.flag])
					end, true)
				end
			elseif lower(_element) == "slider" then
				total+=1
				Frame.Size = udim2new(1,0,0,20)
				local Border = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(12, 12, 12);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 19, 0, 13);
					Size = udim2new(0.72, 0, 0, 7);
					BackgroundTransparency = 1;
					Parent = Frame
				})
				local UISizeConstraint = newObject("UISizeConstraint", {
					MaxSize = vector2new(200, 9e9);
					Parent = Border
				})
				local Inside = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(69, 69, 69);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 1, 0, 1);
					Size = udim2new(1, -2, 1, -2);
					BackgroundTransparency = 1;
					Parent = Border
				})
				newObject("UIGradient", {
					Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(204, 204, 204)), ColorSequenceKeypoint.new(1.00, colorfromrgb(255, 255, 255))};
					Rotation = 90;
					Parent = Inside
				})
				local Fill = newObject("Frame", {
					BackgroundColor3 = menu.accent_color;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Size = udim2new(0, 0, 1, 0);
					BackgroundTransparency = 1;
					Parent = Inside
				})
				newObject("UIGradient", {
					Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(249, 249, 249)), ColorSequenceKeypoint.new(1.00, colorfromrgb(201, 201, 201))};
					Rotation = 90;
					Parent = Fill
				})
				local ValueLabel = newObject("TextBox", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BackgroundTransparency = 1.000;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(1, -1, 0, -2);
					FontFace = menu_font_bold;
					Text = _info.prefix.._info.min.._info.suffix;
					TextColor3 = colorfromrgb(205, 205, 205);
					TextSize = 14.000;
					ClearTextOnFocus = true;
					TextStrokeTransparency = 1;
					TextTransparency = 1;
					Parent = Fill
				})
				local Down = newObject("ImageLabel", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BackgroundTransparency = 1.000;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, -7, 0, 2);
					ImageTransparency = 1;
					Size = udim2new(0, 3, 0, 3);
					Image = "rbxassetid://15582036409";
					Visible = _info.changers and true or false;
					Parent = Border	
				})
				local Up = newObject("ImageLabel", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BackgroundTransparency = 1.000;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(1, 4, 0, 2);
					Size = udim2new(0, 3, 0, 3);
					ImageTransparency = 1;
					Image = "rbxassetid://15582024931";
					Visible = _info.changers and true or false;
					Parent = Border
				})
				
				utility.newConnection(ValueLabel.FocusLost, function()
					local value = tonumber(ValueLabel.Text) or _info.min
					new_element:setValue(value)
				end, true)

				utility.newConnection(menu.on_accent_change, function(color)
					Fill.BackgroundColor3 = color
				end)

				flags[_info.flag] = _info.min

				new_element.onSliderChange = signal.new()

				local mouseConnection = nil
				local dragging = false

				function new_element:setValue(value, do_tween)
					local value = clamp(value, _info.min, _info.max)
					ValueLabel.Text = _info.prefix..value.._info.suffix
					tween(Fill, newtweeninfo(do_tween and menu["animation_speed"] or 0, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = udim2new((value - _info.min)/(_info.max-_info.min), 0, 1, 0)})
					tween(ValueLabel, newtweeninfo(do_tween and menu["animation_speed"] or 0, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = udim2new(0, ts:GetTextSize(tostring(value), 13, Enum.Font.SourceSansBold, vector2new(9999,9999)).X, 0, 13), Position = udim2new(1, -ts:GetTextSize(tostring(value), 13, Enum.Font.SourceSansBold, vector2new(9999,9999)).X/2, 0, -2)})
					if _info.min == value and _info.min_text then
						ValueLabel.Text = _info.min_text
					elseif _info.max == value and _info.max_text then
						ValueLabel.Text = _info.max_text
					end
					flags[_info.flag] = value
					if _info.changers then
						Down.Visible = value > _info.min
						Up.Visible = value < _info.max
					end 
					new_element.onSliderChange:Fire(value)		
				end

				if _info.changers then
					utility.newConnection(Down.InputBegan, function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							new_element:setValue(round(flags[_info.flag]-_info.changers, _info.decimal), true)
						end
					end)

					utility.newConnection(Up.InputBegan, function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							new_element:setValue(round(flags[_info.flag]+_info.changers, _info.decimal), true)
						end
					end)
				end

				local closing = function(bypass)
					if not tab_frame.Visible and not bypass then return end; local info = bypass and newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.In) or tween_info
					tween(Border, info, {BackgroundTransparency = 1})
					tween(Fill, info, {BackgroundTransparency = 1})
					tween(Inside, info, {BackgroundTransparency = 1})
					tween(ValueLabel, info, {TextTransparency = 1, TextStrokeTransparency = 1})
					tween(Down, info, {ImageTransparency = 1})
					tween(Up, info, {ImageTransparency = 1})
					if dragging then
						utility.is_dragging_blocked = false 
						dragging = false
					end
				end

				local opening = function(bypass)
					if not tab_frame.Visible and not bypass then return end; local info = bypass and newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.In) or tween_info
					tween(Border, info, {BackgroundTransparency = 0})
					tween(Inside, info, {BackgroundTransparency = 0})
					tween(Fill, info, {BackgroundTransparency = 0})
					tween(ValueLabel, info, {TextTransparency = 0.1, TextStrokeTransparency = 0.5})
					tween(Down, info, {ImageTransparency = 0})
					tween(Up, info, {ImageTransparency = 0})
				end

				insert(new_element.opening, opening)
				insert(new_element.closing, closing)

				new_element.slider_visible = true

				function new_element:setSliderVisibility(bool, force)
					local speed = (tab_frame.Position.Y.Scale ~= 0 or force) and 0 or menu["animation_speed"]
			
					if bool then
						Border.Visible = true
					end

					new_element.slider_visible = bool
					spawn(bool and opening or closing, true)
					tween(Frame, newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {Size = bool and self.og_size or udim2new(1,0,0,8)})

					delay(speed, function()
						if not bool and not new_element.slider_visible then
							Border.Visible = false
						end
					end)
				end

				utility.newConnection(Inside.InputBegan, function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 and not menu.busy then
						utility.is_dragging_blocked = true 
						local distance = clamp((input.Position.X - Inside.AbsolutePosition.X)/Inside.AbsoluteSize.X, 0, 1)
						local value = round(_info.min + (_info.max - _info.min) * distance, _info.decimal and _info.decimal or 0)
						new_element:setValue(value, true)

						mouseConnection = utility.newConnection(mouse.Move, LPH_NO_VIRTUALIZE(function()
							if dragging then
								local distance = clamp((mouse.X - Inside.AbsolutePosition.X)/Inside.AbsoluteSize.X, 0, 1)
								local value = round(_info.min + (_info.max-_info.min) * distance, _info.decimal and _info.decimal or 0)
								new_element:setValue(value)
							else
								mouseConnection:Disconnect()
							end
						end))

						dragging = true
					end
				end)

				utility.newConnection(Inside.InputEnded, function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
						utility.is_dragging_blocked = false 
						dragging = false
					end
				end)

				utility.newConnection(Inside.MouseEnter, function()
					tween(Inside, newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundColor3 = colorfromrgb(81,81,81)})
				end)

				utility.newConnection(Inside.MouseLeave, function()
					tween(Inside, newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundColor3 = colorfromrgb(69,69,69)})
				end)

				new_element:setValue(_info.default or _info.min)

				utility.newConnection(menu.on_load, function()
					new_element:setValue(flags[_info.flag])
				end, true)
			elseif lower(_element) == "colorpicker" then
				local ColorBox = newObject("Frame", {
					AnchorPoint = vector2new(1, 0);
					BackgroundColor3 = colorfromrgb(12, 12, 12);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(1, 0, 0, 0);
					Size = udim2new(0, 17, 0, 9);
					BackgroundTransparency = 1;
					Parent = Frame
				})
				local Inside = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 1, 0, 1);
					Size = udim2new(1, -2, 1, -2);
					BackgroundTransparency = 1;
					Parent = ColorBox
				})
				local UIGradient = newObject("UIGradient", {
					Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(255, 255, 255)), ColorSequenceKeypoint.new(1.00, colorfromrgb(218, 218, 218))};
					Rotation = 90;
					Parent = Inside
				})

				new_element.onColorChange = signal.new()

				function new_element:setColorpickerVisibility(bool)
					ColorBox.Visible = bool
				end

				utility.newConnection(ColorBox.InputEnded, function(input, gpe)
					if gpe then return end
					local input_type = input.UserInputType
					if input_type == Enum.UserInputType.MouseButton1 then
						if not menu.busy then
							openColorpicker(new_element, _info, ColorBox, ColorpickerOpen)
						elseif menu.active_colorpicker == new_element then
							closeColorpicker()
						end
					elseif input_type == Enum.UserInputType.MouseButton2 then
						if not menu.busy then
							openColorCopy(new_element, _info, ColorBox, ColorpickerOpen)
						elseif menu.active_colorcopy == new_element then
							closeColorCopy()
						end
					end
				end)

				insert(new_element.closing, function(bypass)
					if not tab_frame.Visible and not bypass then return end; local info = bypass and newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.In) or tween_info
					if menu.active_colorpicker == new_element then
						closeColorpicker(true)
					end
					tween(ColorBox, info, {BackgroundTransparency = 1})
					tween(Inside, info, {BackgroundTransparency = 1})
				end, true)

				insert(new_element.opening, function(bypass)
					if not tab_frame.Visible and not bypass then return end; local info = bypass and newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.In) or tween_info
					tween(ColorBox, info, {BackgroundTransparency = 0})
					tween(Inside, info, {BackgroundTransparency = 0})
				end, true)

				function new_element:setColor(color, transparency, no_move)
					if menu.active_colorpicker ~= new_element or no_move then
						flags[_info.flag] = color
						flags[_info.transparency_flag] = transparency
						Inside.BackgroundColor3 = color
						new_element.onColorChange:Fire(color, transparency)
						return
					end
					local h,s,v = color:ToHSV()
					update_sv(v*255, s*255, true)
					update_hue(h*360)
					update_transparency(transparency)
				end

				new_element:setColor(_info.default or colorfromrgb(255,255,255), _info.default_transparency or 0)

				utility.newConnection(menu.on_load, function()
					new_element:setColor(flags[_info.flag], flags[_info.transparency_flag])
				end, true)
			elseif lower(_element) == "button" then
				Frame.Size = udim2new(1,0,0,25)
				total+=1
				Label.Visible = false
				local Border = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(12, 12, 12);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 19, 0, 0);
					Size = udim2new(0.72, 0, 0, 25);
					BackgroundTransparency = 1;
					Parent = Frame
				})
				local Inside2 = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(50, 50, 50);
					BorderSizePixel = 0;
					Position = udim2new(0, 1, 0, 1);
					Size = udim2new(1, -2, 1, -2);
					BackgroundTransparency = 1;
					Parent = Border
				})
				local Inside3 = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(34, 34, 34);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 1, 0, 1);
					Size = udim2new(1, -2, 1, -2);
					BackgroundTransparency = 1;
					Parent = Inside2
				})
				local UIGradient = newObject("UIGradient", {
					Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(255, 255, 255)), ColorSequenceKeypoint.new(1.00, colorfromrgb(227, 227, 227))};
					Rotation = 90;
					Parent = Inside3
				})
				local ButtonLabel = newObject("TextLabel", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BackgroundTransparency = 1.000;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Size = udim2new(1, 0, 1, 0);
					FontFace = menu_font_bold;
					Text = _info.text;
					TextColor3 = colorfromrgb(212, 212, 212);
					TextSize = 13.000;
					TextTransparency = 1;
					TextWrapped = true;
					Parent = Inside3
				})
				local UISizeConstraint = newObject("UISizeConstraint", {
					Parent = Border;
					MaxSize = vector2new(200, 9e9)
				})

				insert(new_element.closing, function(bypass)
					if not tab_frame.Visible and not bypass then return end; local info = bypass and newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.In) or tween_info
					tween(Border, info, {BackgroundTransparency = 1})
					tween(Inside2, info, {BackgroundTransparency = 1})
					tween(Inside3, info, {BackgroundTransparency = 1})
					tween(ButtonLabel, info, {TextTransparency = 1})
				end, true)

				insert(new_element.opening, function(bypass)
					if not tab_frame.Visible and not bypass then return end; local info = bypass and newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.In) or tween_info
					tween(Border, info, {BackgroundTransparency = 0})
					tween(Inside2, info, {BackgroundTransparency = 0})
					tween(Inside3, info, {BackgroundTransparency = 0})
					tween(ButtonLabel, info, {TextTransparency = 0})
				end, true)

				local function onHover(force)
					tween(Inside3, newtweeninfo(force == true and 0 or menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundColor3 = colorfromrgb(39,39,39)})
				end

				local function onLeave()
					tween(Inside3, newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundColor3 = colorfromrgb(34,34,34)})
				end

				utility.newConnection(Border.InputBegan, function(input, gpe)
					if gpe then return end
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						tween(Inside3, newtweeninfo(0, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundColor3 = colorfromrgb(28,28,28)})
					end
				end)

				local do_confirmation = _info.confirmation
				local waiting = false

				utility.newConnection(Border.InputEnded, function(input, gpe)
					if gpe then return end
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if isInFrame(Border, input.Position) then
							if do_confirmation then
								if not waiting then
									waiting = true
									ButtonLabel.Text = "Are you sure?"
									delay(3, function()
										if waiting then
											ButtonLabel.Text = _info.text
											waiting = false
										end
									end)
								elseif waiting then
									waiting = false
									ButtonLabel.Text = _info.text
									_info.callback()
								end
							else
								_info.callback()
							end
							onHover(true)
						else
							tween(Inside3, newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundColor3 = colorfromrgb(34,34,34)})
						end
					end
				end)

				utility.newConnection(Border.MouseEnter, onHover)
				utility.newConnection(Border.MouseLeave, onLeave)
			elseif lower(_element) == "keybind" then
				local KeybindLabel = newObject("TextLabel", {
					AnchorPoint = vector2new(1, 0);
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BackgroundTransparency = 1.000;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					AutomaticSize = Enum.AutomaticSize.X;
					Position = udim2new(1, new_element.onColorChange and -22 or 0, 0, 0);
					Size = udim2new(0, 0, 0, 7);
					FontFace = Font.fromId(12187371840);
					Text = "[-]";
					TextColor3 = colorfromrgb(117, 117, 117);
					TextSize = 9.000;
					TextStrokeTransparency = 0.000;
					TextWrapped = true;
					TextTransparency = 1;
					Parent = Frame
				})

				new_element.onActiveChange = signal.new()

				local isOpen = false
				local clickOutConnection = nil
				local keyListenConnection = nil
				local counter = 0

				new_element.flag = _info.flag

				flags[_info.flag] = {
					method = 1,
					key = nil,
					active = false
				}

				function new_element:setActive(active)
					flags[_info.flag]["active"] = active
					new_element.onActiveChange:Fire(active)
				end

				function new_element:setMethod(method, just_visual, test)
					flags[_info.flag]["method"] = method

					if flags[_info.flag]["active"] ~= method == 1 or test then
						new_element:setActive(method == 1)
					end

					if menu.active_keybind ~= new_element then
						return end

					local children = KeybindOpenInside2:GetChildren()
					for i = 1, #children do
						local object = children[i]
						if object:IsA("TextLabel") then
							object.FontFace = menu_font
							object.TextColor3 = colorfromrgb(205,205,205)
						end
					end
					local object = findfirstchild(KeybindOpenInside2, method)
					object.FontFace = menu_font_bold
					object.TextColor3 = menu.accent_color
					if method == 1 and not just_visual then
						new_element:setActive(true)
					end
				end

				function new_element:setKey(keycode, new)
					local old_keycode = flags[_info.flag]["key"]
					if old_keycode and old_keycode ~= "" then
						local keybind = menu.keybinds[old_keycode]

						if keybind then
							if #keybind == 1 then
								for _, v in keybind do
									if v[2] == _info.flag then
										menu.keybinds[old_keycode] = nil
										break
									end
								end
							else
								for _, v in keybind do
									if v[1] == new_element then
										utility.remove(menu.keybinds[old_keycode], v)
										break
									end
								end
							end
						end
					end
					if keycode == nil or keycode == "" then
						KeybindLabel.Text = "[-]"
						flags[_info.flag]["key"] = nil
						flags[_info.flag]["active"] = flags[_info.flag]["method"] == 1
						return
					end
					if menu.keybinds[keycode] then
						utility.insert(menu.keybinds[keycode], {new_element, _info.flag})
					elseif keycode then
						menu.keybinds[keycode] = {{new_element, _info.flag}}
					end
					flags[_info.flag]["key"] = keycode
					local shortened = shortened_characters[keycode] and shortened_characters[keycode] or keycode.Name
					KeybindLabel.Text = "["..string.upper(shortened).."]"
				end

				new_element:setMethod(_info.method and _info.method or 1)
				new_element:setKey(_info.key and _info.key or nil)

				local function onHover()
					if menu.busy then return end
					tween(KeybindLabel, newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = colorfromrgb(176,176,176)})
				end

				local function onLeave(force)
					if menu.busy and force ~= true then return end
					tween(KeybindLabel, newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = colorfromrgb(117,117,117)})
				end

				local function stopKeybind()
					tween(KeybindLabel, newtweeninfo(0, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = colorfromrgb(117,117,117)})
					keyListenConnection:Disconnect()
					menu.busy = false; utility.is_dragging_blocked = false
				end

				local function startKeybind()
					menu.busy = true; utility.is_dragging_blocked = true
					wait()
					tween(KeybindLabel, newtweeninfo(0, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextColor3 = colorfromrgb(200,0,0)})
					keyListenConnection = utility.newConnection(uis.InputBegan, LPH_NO_VIRTUALIZE(function(input, gpe)
						if gpe then 
							new_element:setKey(nil)
							stopKeybind()
							return 
						end
						local key = shortened_characters[input.UserInputType] and input.UserInputType or input.KeyCode
						local is_valid_key = utility.isValidKey(key)
						if is_valid_key then
							new_element:setKey(key)
						else
							new_element:setKey(nil)
						end
						stopKeybind()
					end), true)
				end

				if not _info.method_locked then
					local clickOutConnection1 = nil
					
					utility.newConnection(KeybindLabel.InputEnded, function(input, gpe)
						if gpe then return end
						if input.UserInputType == Enum.UserInputType.MouseButton2 then
							if not menu.busy and menu.active_keybind ~= new_element then
								openKeybind(new_element, _info, KeybindOpen, KeybindLabel)
								clickOutConnection1 = utility.newConnection(uis.InputBegan, LPH_NO_VIRTUALIZE(function(input, gpe)
									if gpe then return end
									if input.UserInputType == Enum.UserInputType.MouseButton1 then
										local pos = input.Position
										if not isInFrame(KeybindLabel, pos) and not isInFrame(KeybindOpen, pos) then 
											closeKeybind()
											clickOutConnection1:Disconnect()
											onLeave(true)
										 end
									end
								end), true)
							elseif menu.active_keybind == new_element then
								clickOutConnection1:Disconnect()
								closeKeybind(false)
							end
						end
					end)
				end

				utility.newConnection(KeybindLabel.InputBegan, function(input, gpe)
					if gpe then return end
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if not menu.busy then
							startKeybind()
						end
					end
				end)

				insert(new_element.closing, function(bypass)
					if not tab_frame.Visible and not bypass then return end; local info = bypass and newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.In) or tween_info
					tween(KeybindLabel, info, {TextTransparency = 1, TextStrokeTransparency = 1})
					if menu.active_keybind == new_element then 
						closeKeybind(true) 
						onLeave() 
						if clickOutConnection then
							clickOutConnection:Disconnect()
						end
					end
				end, true)

				insert(new_element.opening, function(bypass)
					if not tab_frame.Visible and not bypass then return end; local info = bypass and newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.In) or tween_info
					tween(KeybindLabel, info, {TextTransparency = 0, TextStrokeTransparency = 0})
				end, true)

				utility.newConnection(KeybindLabel.MouseEnter, onHover)
				utility.newConnection(KeybindLabel.MouseLeave, onLeave)

				utility.newConnection(menu.on_load, function()
					new_element:setKey(flags[_info.flag]["key"], true)
					new_element:setMethod(flags[_info.flag]["method"])
				end, true)
			elseif lower(_element) == "multibox" then
				total+=1
				Frame.Size = udim2new(1, 0, 0, _info.max*20)
				Label.Visible = false
				local Inside = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(12, 12, 12);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 19, 0, 1);
					Size = udim2new(0.72, 0, 1, 0);
					ZIndex = 2;
					BackgroundTransparency = 1;
					Parent = Frame
				})
				local Inside2 = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(35, 35, 35);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 1, 0, 1);
					Size = udim2new(1, -2, 1, -2);
					ZIndex = 2;
					BackgroundTransparency = 1;
					Parent = Inside
				})
				local Scroller = newObject("ScrollingFrame", {
					Active = true;
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BackgroundTransparency = 1.000;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					AutomaticCanvasSize = Enum.AutomaticSize.Y;
					Size = udim2new(1, 0, 1, 0);
					BottomImage = "rbxassetid://15540816491";
					ScrollBarImageColor3 = colorfromrgb(65, 65, 65);
					CanvasSize = udim2new(0, 0, 1, 0);
					MidImage = "rbxassetid://15540816491";
					ScrollBarThickness = 5;
					ScrollingEnabled = false;
					TopImage = "rbxassetid://15540816491";
					ZIndex = 4;
					Parent = Inside2
				})
				local OptionHolder = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Size = udim2new(1, 0, 0, 0);
					AutomaticSize = Enum.AutomaticSize.Y;
					ZIndex = 2;
					BackgroundTransparency = 1;
					Parent = Scroller
				})
				local UIListLayout = newObject("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center;
					SortOrder = Enum.SortOrder.LayoutOrder;
					Padding = UDim.new(0, 0);
					Parent = OptionHolder
				})
				local ArrowDown = newObject("ImageLabel", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BackgroundTransparency = 1.000;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(1, -16, 1, -9);
					Size = udim2new(0, 5, 0, 4);
					Visible = false;
					ImageTransparency = 1;
					Image = "rbxassetid://15540867448";
					ZIndex = 5;
					Parent = Inside2	
				})
				local ArrowUp = newObject("ImageLabel", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BackgroundTransparency = 1.000;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					ImageTransparency = 1;
					Position = udim2new(1, -16, 0, 5);
					Size = udim2new(0, 5, 0, 4);
					Visible = false;
					Image = "rbxassetid://15547663604";
					ZIndex = 5;
					Parent = Inside2
				})
				local BottomShadow = newObject("ImageLabel", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BackgroundTransparency = 1.000;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 0, 1, -21);
					Size = udim2new(1, 0, 0, 20);
					Image = "rbxassetid://15541064478";
					ImageColor3 = colorfromrgb(35, 35, 35);
					ZIndex = 2;
					ImageTransparency = 1;
					Parent = Inside2
				})
				local TopShadow = newObject("ImageLabel", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BackgroundTransparency = 1.000;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Rotation = 180.000;
					Size = udim2new(1, 0, 0, 20);
					Image = "rbxassetid://15541064478";
					ImageColor3 = colorfromrgb(35, 35, 35);
					ImageTransparency = 1;
					ZIndex = 2;
					Parent = Inside2
				})
				local ScrollBackground = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(40, 40, 40);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(1, -6, 0, 0);
					BackgroundTransparency = 1;
					Size = udim2new(0, 6, 1, 0);
					Visible = false;
					ZIndex = 3;
					Parent = Inside2
				})
				local UISizeConstraint = newObject("UISizeConstraint", {
					Parent = Inside;
					MaxSize = vector2new(200, 9e9)
				})
				local ScrollBackground = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(40, 40, 40);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(1, -6, 0, 0);
					BackgroundTransparency = 1;
					Size = udim2new(0, 6, 1, 0);
					Visible = false;
					ZIndex = 2;
					Parent = Inside2
				})

				if _info.search then
					local Search = newObject("Frame", {
						BackgroundColor3 = colorfromrgb(12, 12, 12);
						BorderColor3 = colorfromrgb(0, 0, 0);
						BorderSizePixel = 0;
						Position = udim2new(0, 19, 0, 0);
						Size = udim2new(0.72, 0, 0, 20);
						BackgroundTransparency = 1;
						Parent = Frame
					})
					local SearchInside = newObject("Frame", {
						BackgroundColor3 = colorfromrgb(50, 50, 50);
						BorderColor3 = colorfromrgb(0, 0, 0);
						BorderSizePixel = 0;
						Position = udim2new(0, 1, 0, 1);
						Size = udim2new(1, -2, 1, -2);
						BackgroundTransparency = 1;
						Parent = Search
					})
					local SearchInside2 = newObject("Frame", {
						BackgroundColor3 = colorfromrgb(25, 25, 25);
						BorderColor3 = colorfromrgb(16, 16, 16);
						BorderSizePixel = 1;
						Position = udim2new(0, 2, 0, 2);
						Size = udim2new(1, -4, 1, -4);
						BackgroundTransparency = 1;
						Parent = SearchInside
					})
					local TextBox = newObject("TextBox", {
						BackgroundColor3 = colorfromrgb(255, 255, 255);
						BackgroundTransparency = 1.000;
						BorderColor3 = colorfromrgb(0, 0, 0);
						BorderSizePixel = 0;
						Position = udim2new(0, 5, 0, 0);
						Size = udim2new(1, -5, 1, 0);
						TextTransparency = 1;
						ZIndex = 2;
						FontFace = menu_font_bold;
						Text = "_";
						TextColor3 = colorfromrgb(208, 208, 208);
						TextSize = 13.000;
						TextXAlignment = Enum.TextXAlignment.Left;
						ClearTextOnFocus = false;
						Parent = SearchInside2
					})
					local UISizeConstraint = newObject("UISizeConstraint", {
						Parent = Search;
						MaxSize = vector2new(200, 9e9)
					})

					utility.newConnection(TextBox.FocusLost, function()
						TextBox.TextColor3 = colorfromrgb(208, 208, 208);
						if TextBox.Text == "" then
							TextBox.Text = "_" 
						end
					end)

					utility.newConnection(TextBox.Focused, function()
						if menu.busy then
							TextBox:ReleaseFocus()
							return
						end

						if TextBox.Text == "_" then
							TextBox.Text = "" 
						end
						TextBox.TextColor3 = menu.accent_color;
					end)

					utility.newConnection(TextBox:GetPropertyChangedSignal("Text"), function()
						local text = lower(TextBox.Text)

						if text == "_" then
							return end

						local children = OptionHolder:GetChildren()
						for i = 1, #children do
							local object = children[i]
							if object:IsA("TextLabel") then
								if text == "" or lower(object.Name):find(text) then
									object.Visible = true
								else
									object.Visible = false
								end
							end
						end
					end)

					Frame.Size = udim2new(1,0,0,(20*_info.max) + 20)
					Inside.Size = udim2new(0.72, 0, 1, -20)
					Inside.Position = udim2new(0, 19, 0, 19)

					insert(new_element.closing, function(bypass)
						if not tab_frame.Visible and not bypass then return end; local info = bypass and newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.In) or tween_info
						tween(Search, info, {BackgroundTransparency = 1})
						tween(SearchInside, info, {BackgroundTransparency = 1})
						tween(SearchInside2, info, {BackgroundTransparency = 1})
						tween(TextBox, info, {TextTransparency = 1})
						tween(ScrollBackground, info, {BackgroundTransparency = 1})
						tween(BottomShadow, info, {ImageTransparency = 1})
						tween(TopShadow, info, {ImageTransparency = 1})
						tween(ArrowDown, info, {ImageTransparency = 1})
						tween(ArrowUp, info, {ImageTransparency = 1})
						tween(Inside, info, {BackgroundTransparency = 1})
						tween(Inside2, info, {BackgroundTransparency = 1})
						tween(Scroller, info, {ScrollBarImageTransparency = 1})
						for _, object in OptionHolder:GetChildren() do
							if object:IsA("TextLabel") then
								tween(object, info, {TextTransparency = 1})
							end
						end
					end, true)

					insert(new_element.opening, function(bypass)
						if not tab_frame.Visible and not bypass then return end; local info = bypass and newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.In) or tween_info
						tween(Search, info, {BackgroundTransparency = 0})
						tween(SearchInside, info, {BackgroundTransparency = 0})
						tween(SearchInside2, info, {BackgroundTransparency = 0})
						tween(TextBox, info, {TextTransparency = 0})
						tween(ScrollBackground, info, {BackgroundTransparency = 0})
						tween(BottomShadow, info, {ImageTransparency = 0})
						tween(TopShadow, info, {ImageTransparency = 0})
						if Scroller.CanvasPosition.Y/Scroller.AbsoluteCanvasSize.Y < 0.5 then
							tween(ArrowUp, info, {ImageTransparency = 0})
						else
							tween(ArrowDown, info, {ImageTransparency = 0})
						end
						tween(Inside, info, {BackgroundTransparency = 0})
						tween(Inside2, info, {BackgroundTransparency = 0})
						tween(Scroller, info, {ScrollBarImageTransparency = 0})
						for _, object in OptionHolder:GetChildren() do
							if object:IsA("TextLabel") then
								tween(object, info, {TextTransparency = 0})
							end
						end
					end, true)
				else
					insert(new_element.closing, function(bypass)
						if not tab_frame.Visible and not bypass then return end; local info = bypass and newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.In) or tween_info
						tween(ScrollBackground, info, {BackgroundTransparency = 1})
						tween(BottomShadow, info, {ImageTransparency = 1})
						tween(TopShadow, info, {ImageTransparency = 1})
						tween(ArrowDown, info, {ImageTransparency = 1})
						tween(ArrowUp, info, {ImageTransparency = 1})
						tween(Inside, info, {BackgroundTransparency = 1})
						tween(Inside2, info, {BackgroundTransparency = 1})
						tween(Scroller, info, {ScrollBarImageTransparency = 1})
						for _, object in OptionHolder:GetChildren() do
							if object:IsA("TextLabel") then
								tween(object, info, {TextTransparency = 1})
							end
						end
					end, true)

					insert(new_element.opening, function(bypass)
						if not tab_frame.Visible and not bypass then return end; local info = bypass and newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.In) or tween_info
						tween(ScrollBackground, info, {BackgroundTransparency = 0})
						tween(BottomShadow, info, {ImageTransparency = 0})
						tween(TopShadow, info, {ImageTransparency = 0})
						tween(ArrowDown, info, {ImageTransparency = 0})
						tween(ArrowUp, info, {ImageTransparency = 0})
						tween(Inside, info, {BackgroundTransparency = 0})
						tween(Inside2, info, {BackgroundTransparency = 0})
						tween(Scroller, info, {ScrollBarImageTransparency = 0})
						for _, object in OptionHolder:GetChildren() do
							if object:IsA("TextLabel") then
								tween(object, info, {TextTransparency = 0})
							end
						end
					end)
				end

				local function updateSize()
					if OptionHolder.AbsoluteSize.Y > Inside.AbsoluteSize.Y then
						Scroller.CanvasSize = udim2new(0, 0, 1, 0)
						Scroller.ScrollingEnabled = true
						Scroller.ScrollBarImageTransparency = 0
						ScrollBackground.Visible = true
						ArrowUp.Visible = true
						ArrowDown.Visible = true
						ScrollBackground.Visible = true
						BottomShadow.Visible = true; TopShadow.Visible = true
					else
						Scroller.ScrollingEnabled = false
						Scroller.ScrollBarImageTransparency = 1
						ScrollBackground.Visible = false
						ArrowUp.Visible = false
						ArrowDown.Visible = false
						ScrollBackground.Visible = false
						BottomShadow.Visible = false; TopShadow.Visible = false
					end 
				end

				utility.newConnection(Scroller:GetPropertyChangedSignal("AbsoluteCanvasSize"), function()
					ArrowUp.Visible = (Scroller.CanvasPosition.Y > 1)
                    ArrowDown.Visible = (Scroller.CanvasPosition.Y + 1 < (Scroller.AbsoluteCanvasSize.Y - Scroller.AbsoluteSize.Y))
				end)

				utility.newConnection(Scroller:GetPropertyChangedSignal("CanvasPosition"), function()
					ArrowUp.Visible = (Scroller.CanvasPosition.Y > 1)
                    ArrowDown.Visible = (Scroller.CanvasPosition.Y + 1 < (Scroller.AbsoluteCanvasSize.Y - Scroller.AbsoluteSize.Y))
				end)

				utility.newConnection(OptionHolder:GetPropertyChangedSignal("AbsoluteSize"), updateSize)
				utility.newConnection(Scroller:GetPropertyChangedSignal("CanvasSize"), updateSize)

				updateSize()

				utility.newConnection(ArrowUp.InputBegan, function(input, gpe)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						Scroller.CanvasPosition = vector2new(0,0)
					end
				end)
		
				utility.newConnection(ArrowDown.InputBegan, function(input, gpe)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						Scroller.CanvasPosition = vector2new(0,Scroller.AbsoluteCanvasSize.Y)
					end
				end)

				new_element.selected_option = nil
				new_element.onSelectionChange = signal.new()

				function new_element:removeAllOptions()
					local children = OptionHolder:GetChildren()
					for i = 1, #children do
						local option = children[i]
						if option.ClassName == "TextLabel" then
							destroy(option)
						end
					end
					new_element:setSelected(nil, true)
				end

				function new_element:setSelected(text, no)
					text = text or ""
					if new_element.selected_option == text then
						return end

					local old_option = new_element.selected_option and findfirstchild(OptionHolder, new_element.selected_option) or nil

					if old_option and old_option.ClassName == "TextLabel" then
						old_option.FontFace = menu_font
						old_option.TextColor3 = colorfromrgb(208, 208, 208)
					end

					local option = findfirstchild(OptionHolder, text)

					if not option or option.ClassName ~= "TextLabel" then
						new_element.selected_option = nil
						new_element.onSelectionChange:Fire(nil)
						return
					end

					new_element.selected_option = text

					if not no then
						new_element.onSelectionChange:Fire(text)
					end

					option.FontFace = menu_font_bold
					option.TextColor3 = menu.accent_color
				end

				function new_element:removeOption(text)
					local option = findfirstchild(OptionHolder, text)
					if option then
						destroy(option)
					end
					if new_element.selected_option == text then
						new_element:setSelected(nil)
					end
				end

				utility.newConnection(menu.on_accent_change, function(color)
					local option = new_element.selected_option

					if not option then
						return end

					local label = findfirstchild(OptionHolder, option)

					if not label then
						return end

					label.TextColor3 = color
				end)

				function new_element:addOption(text)
					local MultiOption = newObject("TextLabel", {
						BackgroundColor3 = colorfromrgb(25, 25, 25);
						BackgroundTransparency = 1.000;
						BorderColor3 = colorfromrgb(0, 0, 0);
						BorderSizePixel = 0;
						Size = udim2new(1, 0, 0, 20);
						ZIndex = 25;
						FontFace = menu_font;
						Text = "     "..text;
						TextColor3 = colorfromrgb(208, 208, 208);
						TextSize = 13.000;
						TextXAlignment = Enum.TextXAlignment.Left;
						Parent = OptionHolder
					}); MultiOption.Name = text

					utility.newConnection(MultiOption.MouseEnter, function()
						MultiOption.BackgroundTransparency = 0
						if new_element.selected_option == text then return end
						MultiOption.FontFace = menu_font_bold
					end)

					utility.newConnection(MultiOption.MouseLeave, function()
						MultiOption.BackgroundTransparency = 1
						if new_element.selected_option == text then return end
						MultiOption.FontFace = menu_font
					end)

					utility.newConnection(MultiOption.InputBegan, function(input, gpe)
						if gpe or menu.busy then return end
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							new_element:setSelected(text)
						end
					end)
				end
			elseif lower(_element) == "textbox" then
				total+=1
				Frame.Size = udim2new(1, 0, 0, 20)
				local Textbox = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Size = udim2new(1, 0, 0, 20);
					BackgroundTransparency = 1;
					Parent = Frame
				})
				local Inside = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(12, 12, 12);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 19, 0, 0);
					Size = udim2new(0.72, 0, 0, 20);
					BackgroundTransparency = 1;
					Parent = Textbox
				})
				local Inside2 = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(50, 50, 50);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 1, 0, 1);	
					Size = udim2new(1, -2, 1, -2);
					BackgroundTransparency = 1;
					Parent = Inside
				})
				local Inside3 = newObject("Frame", {
					BackgroundColor3 = colorfromrgb(24, 24, 24);
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 1, 0, 1);
					Size = udim2new(1, -2, 1, -2);
					BackgroundTransparency = 1;
					Parent = Inside2
				})
				local TextBox = newObject("TextBox", {
					BackgroundColor3 = colorfromrgb(255, 255, 255);
					BackgroundTransparency = 1.000;
					BorderColor3 = colorfromrgb(0, 0, 0);
					BorderSizePixel = 0;
					Position = udim2new(0, 5, 0, 0);
					Size = udim2new(1, -5, 1, 0);
					ZIndex = 2;
					FontFace = menu_font_bold;
					Text = "_";
					TextColor3 = colorfromrgb(208, 208, 208);
					TextSize = 13.000;
					TextXAlignment = Enum.TextXAlignment.Left;
					ClearTextOnFocus = false;
					TextTransparency = 1;
					Parent = Inside3
				})
				local UISizeConstraint = newObject("UISizeConstraint", {
					MaxSize = vector2new(200, 9e9);
					Parent = Inside
				})

				flags[_info.flag] = ""

				Label.Visible = false

				new_element.onTextChange = signal.new()

				function new_element:setText(text)
					text = text or ""
					if TextBox.Text ~= text then
						TextBox.Text = text
					end

					flags[_info.flag] = text
					new_element.onTextChange:Fire(text)
				end

				utility.newConnection(TextBox.FocusLost, function()
					TextBox.TextColor3 = colorfromrgb(208, 208, 208);
					if TextBox.Text == "" then
						TextBox.Text = "_" 
					end
				end)

				utility.newConnection(TextBox.Focused, function()
					if menu.busy then
						TextBox:ReleaseFocus()
						return
					end

					if TextBox.Text == "_" then
						TextBox.Text = "" 
					end
					TextBox.TextColor3 = menu.accent_color;
				end)

				utility.newConnection(TextBox:GetPropertyChangedSignal("Text"), function()
					local text = lower(TextBox.Text)

					if text == "_" then
						new_element:setText(nil)
						return end

					new_element:setText(TextBox.Text)
				end)

				insert(new_element.closing, function(bypass)
					if not tab_frame.Visible and not bypass then return end; local info = bypass and newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.In) or tween_info
					tween(Inside, info, {BackgroundTransparency = 1})
					tween(Inside2, info, {BackgroundTransparency = 1})
					tween(Inside3, info, {BackgroundTransparency = 1})
					tween(TextBox, info, {TextTransparency = 1})
				end, true)

				insert(new_element.opening, function(bypass)
					if not tab_frame.Visible and not bypass then return end; local info = bypass and newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.In) or tween_info
					tween(Inside, info, {BackgroundTransparency = 0})
					tween(Inside2, info, {BackgroundTransparency = 0})
					tween(Inside3, info, {BackgroundTransparency = 0})
					tween(TextBox, info, {TextTransparency = 0})
				end, true)

				if not _info.no_load then
					utility.newConnection(menu.on_load, function()
						new_element:setText(flags[_info.flag])
					end, true)
				end
			end
		end

		insert(new_element.closing, function(bypass)
			if not tab_frame.Visible and not bypass then return end; local info = bypass and newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.In) or tween_info
			tween(Label, info, {TextTransparency = 1})
		end)

		insert(new_element.opening, function(bypass)
			if not new_element.visible then return end
			if not tab_frame.Visible and not bypass then return end; local info = bypass and newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Sine, Enum.EasingDirection.In) or tween_info
			tween(Label, info, {TextTransparency = 0})
		end)

		for _, opening in new_element.opening do
			utility.newConnection(menu.on_opening, opening)
		end

		for _, closing in new_element.closing do
			utility.newConnection(menu.on_closing, closing)
		end

		new_element.og_size = Frame.Size

		self.elements[info.name] = new_element

		return new_element
	end

	function element:Destroy()
		destroy(self.frame)
		setmetatable(self, nil)
	end
	
	function element:setText(text)
		self.label.Text = text
	end

	function element:setVisible(bool, force)
		local speed = force and 0 or menu["animation_speed"]
		self.visible = bool

		for _, func in self[bool and "opening" or "closing"] do
			spawn(func, true)
		end

		if bool then
			self.frame.Visible = true
		end

		tween(self.frame, newtweeninfo(menu["animation_speed"], Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = bool and ((self.slider_visible == false or self.dropdown_visible == false) and udim2new(1,0,0,8) or self.og_size) or udim2new(1,0,0,-10)})

		delay(speed, function()
			if not bool and not self.visible then
				self.frame.Visible = false
			end
		end)
	end

	utility.newConnection(uis.InputBegan, LPH_NO_VIRTUALIZE(function(input, gpe)
		if gpe then
			return end
			
		local keycode = shortened_characters[input.UserInputType] and input.UserInputType or input.KeyCode
		if keycode then
			if string.upper(input.KeyCode.Name) == menu.toggle then
				if menu.is_open then menu.on_closing:Fire() else menu.on_opening:Fire() end
				return
			end
			local keybinds = menu.keybinds[keycode]
			if keybinds then
				for _, info in keybinds do
					local flag = info[2]
					if flags[flag]["method"] == 2 then
						info[1]:setActive(true)
					elseif flags[flag]["method"] == 3 then
						info[1]:setActive(not menu.flags[flag]["active"])
					end
				end
			end
		end
	end), true)

	utility.newConnection(uis.InputEnded, LPH_NO_VIRTUALIZE(function(input, gpe)
		local keycode = shortened_characters[input.UserInputType] and input.UserInputType or input.KeyCode
		if keycode then
			local keybinds = menu.keybinds[keycode]
			if keybinds then
				for _, info in keybinds do
					local flag = info[2]
					if flags[flag]["method"] == 2 then
						info[1]:setActive(false)
					end
				end
			end
		end
	end), true)
end

--[[
      _    _              _                                 
     | |  (_)            | |                                
  ___| | ___ _ __     ___| |__   __ _ _ __   __ _  ___ _ __ 
 / __| |/ / | '_ \   / __| '_ \ / _` | '_ \ / _` |/ _ \ '__|
 \__ \   <| | | | | | (__| | | | (_| | | | | (_| |  __/ |   
 |___/_|\_\_|_| |_|  \___|_| |_|\__,_|_| |_|\__, |\___|_|   
                                             __/ |          
                                            |___/           
]]

local skins = {
	equipped = {}
}

skins["Galaxy"] = {
	Beam = {
		Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, colorfromrgb(25, 59, 255)),
			ColorSequenceKeypoint.new(1, colorfromrgb(25, 59, 255)) 
		},
		LightEmission = 0.2,
	},
	Particle = newObject("ParticleEmitter", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0.419608,0.376471,1)),ColorSequenceKeypoint.new(1,Color3.new(0.419608,0.376471,1))};
		Enabled = true;
		Lifetime = NumberRange.new(1,1);
		LightEmission = 0.699999988079071;
		LockedToPart = true;
		Rate = 3;
		RotSpeed = NumberRange.new(0,15);
		Rotation = NumberRange.new(0,360);
		Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0.5,0),NumberSequenceKeypoint.new(0.496,1.2,0),NumberSequenceKeypoint.new(1,0.5,0)};
		Speed = NumberRange.new(1,1);
		SpreadAngle = vector2new(-45,45);
		Squash = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.173364,0.525,0),NumberSequenceKeypoint.new(0.584386,-1.7625,0),NumberSequenceKeypoint.new(0.98163,0.0749998,0),NumberSequenceKeypoint.new(1,0,0)};
		Texture = [[rbxassetid://7422600824]];
		Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.107922,1,0),NumberSequenceKeypoint.new(0.391504,0.25,0),NumberSequenceKeypoint.new(0.670494,0.78125,0),NumberSequenceKeypoint.new(0.845006,0,0),NumberSequenceKeypoint.new(1,1,0)};
		ZOffset = 1				
	})
}
skins["Patriot"] = {
	Beam = {
		Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0.00, colorfromrgb(255, 255, 255)),
			ColorSequenceKeypoint.new(0.5, colorfromrgb(25, 163, 255)),
			ColorSequenceKeypoint.new(1, colorfromrgb(255, 19, 23)),
		}
	}
}
skins["Inferno"] = {
	Beam = {
		Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0.00, colorfromrgb(255, 89, 89)),
			ColorSequenceKeypoint.new(1, colorfromrgb(255, 89, 89)),
		}
	}
}
skins["Fish"] = {
	ShotParticle = {
		Brightness = 2;
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0.0980392,0.533333,1)),ColorSequenceKeypoint.new(1,Color3.new(0.0980392,0.533333,1))};
		Drag = 4.5;
		FlipbookFramerate = NumberRange.new(25,25);
		FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4;
		FlipbookMode = Enum.ParticleFlipbookMode.OneShot;
		Lifetime = NumberRange.new(1,1);
		LightEmission = 1;
		Rate = 0;
		RotSpeed = NumberRange.new(25,25);
		Rotation = NumberRange.new(-90,90);
		Size = NumberSequence.new{NumberSequenceKeypoint.new(0,2,0),NumberSequenceKeypoint.new(1,2.6,0)};
		Speed = NumberRange.new(0.1,0.1);
		Texture = [[http://www.roblox.com/asset/?id=11442980892]];
		Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0.5,0),NumberSequenceKeypoint.new(1,0.5,0)};
		ZOffset = -1		
	},
	ParticleEmit = 1
}
skins["Heaven"] = {
	Beam = {
		Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0.00, colorfromrgb(255, 255, 255)),
			ColorSequenceKeypoint.new(1, colorfromrgb(255, 255, 255))        
		}
	},
	PulloutAnimation = "rbxassetid://14500266726",
	PulloutSound = "rbxassetid://14489860007",
	PulloutVolume = 1,
}
skins["RGB Butterfly"] = {
	PulloutAnimation = "rbxassetid://14918231706",
	PulloutSound = "rbxassetid://14931902491",
	PulloutVolume = 1
}
skins["Soul"] = {
	PulloutAnimation = "rbxassetid://14918231706",
	PulloutSound = "rbxassetid://14931902491",
	PulloutVolume = 1
}
skins["Mystical"] = {
	PulloutAnimation = "rbxassetid://14496531574",
	PulloutSound = "rbxassetid://14489874349",
	PulloutVolume = 1
}
skins["GPO-Knife"] = {
	PulloutAnimation = "rbxassetid://14014278925",
	PulloutSound = "rbxassetid://4604390759",
	PulloutVolume = 1
}
skins["DH-Stars"] = {
	ShotParticle = {
		Lifetime = NumberRange.new(0.4,0.4);
		LightEmission = 0.25;
		Orientation = Enum.ParticleOrientation.VelocityPerpendicular;
		Rate = 0;
		RotSpeed = NumberRange.new(0,40);
		Rotation = NumberRange.new(0,90);
		Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0.813,0),NumberSequenceKeypoint.new(1,0,0)};
		Speed = NumberRange.new(0,5);
		SpreadAngle = vector2new(-90,90);
		Squash = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.513,1.09,0),NumberSequenceKeypoint.new(1,0,0)};
		Texture = [[http://www.roblox.com/asset/?id=198887652]];
		Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,1,0)};
	},
	ParticleEmit = 1
}
skins["8-BIT"] = {
	Beam = {
		Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0.00, colorfromrgb(0, 242, 255)),
			ColorSequenceKeypoint.new(1, colorfromrgb(0, 242, 254))        
		},
		LightEmission = 0.2,
		Width0 = 0.2,
		Brightness = 10,
		Transparency = NumberSequence.new(0, 0),
		Width1 = 0.2
	},
	Convert = "BIT8",
	ShootSounds = {
		["[Revolver]"] = "rbxassetid://13326584088",
		["[Double-Barrel SG]"] = "rbxassetid://13326578563"
	},
	Tween = {newtweeninfo(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}}
}
skins["Tact"] = {
	Beam = {
		Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0.00, colorfromrgb(0, 0, 0)),
			ColorSequenceKeypoint.new(1, colorfromrgb(0, 0, 0))        
		},
		LightEmission = 0.2,
		Width0 = 0.2,
		Brightness = 10,
		Transparency = NumberSequence.new(0, 0),
		Width1 = 0.2
	},
	ShootSounds = {
		["[Revolver]"] = "rbxassetid://13850086195"
	},
	Tween = {newtweeninfo(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}}
}
skins["Golden Age"] = {
	Beam = {
		Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0.00, colorfromrgb(170, 85, 127)),
			ColorSequenceKeypoint.new(1, colorfromrgb(170, 85, 127))        
		},
		LightEmission = 0.2,
		Width0 = 0.2,
		Brightness = 10,
		Transparency = NumberSequence.new(0, 0),
		Width1 = 0.2
	},
	ShootSound = "rbxassetid://6322588515",
	Convert = "GoldenAge",
	Tween = {newtweeninfo(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}}
}
skins["Gold Glory"] = {
	Particle = newObject("ParticleEmitter", {
		Acceleration = vector3new(0,20,0);
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(1,1,0)),ColorSequenceKeypoint.new(1,Color3.new(1,1,0))};
		Drag = 25;
		Lifetime = NumberRange.new(0.5,0.5);
		LightEmission = 1;
		LightInfluence = 0.5;
		LockedToPart = true;
		Rate = 5;
		RotSpeed = NumberRange.new(-90,90);
		Rotation = NumberRange.new(0,360);
		Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.48,0.875,0),NumberSequenceKeypoint.new(1,0,0)};
		Speed = NumberRange.new(20,20);
		SpreadAngle = vector2new(360,360);
		Texture = [[rbxassetid://7216848832]];
		Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,1,0)};
	})
}
skins["Shadow"] = {
	Beam = {
		Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0.00, colorfromrgb(140, 97, 255)),
			ColorSequenceKeypoint.new(1, colorfromrgb(140, 97, 255))        
		},
	}
}
skins["Electric"] = {
	Beam = {
		Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0.00, colorfromrgb(0, 234, 255)),
			ColorSequenceKeypoint.new(1, colorfromrgb(0, 234, 255))        
		},
	},
	ShotParticle = {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0,0.917647,1)),ColorSequenceKeypoint.new(1,Color3.new(0,0.917647,1))};
		FlipbookFramerate = NumberRange.new(24,24);
		Enabled = false;
		FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4;
		Lifetime = NumberRange.new(1,1);
		LightEmission = 1;
		Rotation = NumberRange.new(-180,180);
		Speed = NumberRange.new(0,0);
		LockedToPart = true;
		Squash = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.258,0.075,0),NumberSequenceKeypoint.new(0.719,0.75,0),NumberSequenceKeypoint.new(1,0,0)};
		Texture = [[rbxassetid://9255994696]];
		Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,1,0)}		
	},
	ParticleEmit = 5
}
skins["Luck"] = {
	Beam = {
		Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0.00, colorfromrgb(0, 255, 0)),
			ColorSequenceKeypoint.new(1, colorfromrgb(0, 255, 0))        
		},
	},
	Particle = newObject("ParticleEmitter", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0,colorfromrgb(0,255,0)),ColorSequenceKeypoint.new(1,colorfromrgb(0,255,0))};
		Lifetime = NumberRange.new(2.2, 2.6);
		LightEmission = 1;
		LockedToPart = true;
		Rate = 2;
		RotSpeed = NumberRange.new(0,0);
		Rotation = NumberRange.new(-30,30);
		Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0.1,0),NumberSequenceKeypoint.new(1,0.5,0.2	)};
		Speed = NumberRange.new(0.5,0.8);
		SpreadAngle = vector2new(360,360);
		Squash = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,0,0)};
		Texture = [[rbxassetid://8975696456]];
		Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0.2,0),NumberSequenceKeypoint.new(0.8,0.2,0),NumberSequenceKeypoint.new(1,1,0)};
		ZOffset = 0.5;
	})
}
skins["Matrix"] = {
	Beam = {
		Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0.00, colorfromrgb(41, 141, 33)),
			ColorSequenceKeypoint.new(1, colorfromrgb(41, 141, 33))        
		},
	},
	Particle = newObject("ParticleEmitter", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0.160784,0.552941,0.129412)),ColorSequenceKeypoint.new(1,Color3.new(0.160784,0.552941,0.129412))};
		Lifetime = NumberRange.new(1,1);
		LightEmission = 0.5;
		LockedToPart = true;
		Rate = 3;
		RotSpeed = NumberRange.new(0,15);
		Rotation = NumberRange.new(0,360);
		Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0.25,0),NumberSequenceKeypoint.new(0.496,0.5,0),NumberSequenceKeypoint.new(1,0.25,0)};
		Speed = NumberRange.new(1,1);
		SpreadAngle = vector2new(-45,45);
		Squash = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.173364,0.525,0),NumberSequenceKeypoint.new(0.584386,-1.7625,0),NumberSequenceKeypoint.new(0.98163,0.0749998,0),NumberSequenceKeypoint.new(1,0,0)};
		Texture = [[http://www.roblox.com/asset/?id=8865116993]];
		Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.107922,1,0),NumberSequenceKeypoint.new(0.391504,0.25,0),NumberSequenceKeypoint.new(0.670494,0.78125,0),NumberSequenceKeypoint.new(0.845006,0,0),NumberSequenceKeypoint.new(1,1,0)};
		ZOffset = 1;
	}),
	ShotParticle = {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0.411765,0.901961,0.105882)),ColorSequenceKeypoint.new(1,Color3.new(0.411765,0.901961,0.105882))};
		Enabled = false;
		Lifetime = NumberRange.new(0.4,0.4);
		Rate = 1;
		RotSpeed = NumberRange.new(0,90);
		Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0.2,0),NumberSequenceKeypoint.new(1,0.2,0)};
		SpreadAngle = vector2new(-45,45);
		Texture = [[http://www.roblox.com/asset/?id=119971173]];
		Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,1,0)};
		ZOffset = 1;
	},
	ShotParticle2 = {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0.411765,0.901961,0.105882)),ColorSequenceKeypoint.new(1,Color3.new(0.411765,0.901961,0.105882))};
		Enabled = false;
		Lifetime = NumberRange.new(0.4,0.4);
		Rate = 1;
		RotSpeed = NumberRange.new(0,90);
		Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0.2,0),NumberSequenceKeypoint.new(1,0.2,0)};
		SpreadAngle = vector2new(-45,45);
		Texture = [[http://www.roblox.com/asset/?id=119971193]];
		Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,1,0)};
		ZOffset = 1;
	},
	ParticleEmit = 1
}
skins["Snow Wrap"] = {
	Beam = {
		Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0.00, colorfromrgb(253, 253, 253)),
			ColorSequenceKeypoint.new(1, colorfromrgb(253, 253, 253))        
		},
	},
	Particle = newObject("ParticleEmitter", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0.376471,1,1)),ColorSequenceKeypoint.new(1,Color3.new(0.376471,1,1))};
		Lifetime = NumberRange.new(1,1);
		LightEmission = 0.699999988079071;
		LockedToPart = true;
		Rate = 3;
		RotSpeed = NumberRange.new(0,15);
		Rotation = NumberRange.new(0,360);
		Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0.5,0),NumberSequenceKeypoint.new(0.496799,0.625,0),NumberSequenceKeypoint.new(1,0.5,0)};
		Speed = NumberRange.new(1,1);
		SpreadAngle = vector2new(-45,45);
		Texture = [[rbxassetid://5063577843]];
		Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.107922,1,0),NumberSequenceKeypoint.new(0.391504,0.25,0),NumberSequenceKeypoint.new(0.670494,0.78125,0),NumberSequenceKeypoint.new(0.845006,0,0),NumberSequenceKeypoint.new(1,1,0)};
		ZOffset = 1
	})
}

local custom_skins = {}

local skin_table = {}

for _, skin in require(reps.SkinModules) do
    skin_table[_] = {}
    for skin_name, info in skin do
        skin_table[_][skin_name] = info
		if info["Rarity"] == "Exclusive" and info["BorderColor"] and not skins[skin_name] then
			local info = info["BorderColor"]
			skins[skin_name] = {
				Beam = {
					Color = ColorSequence.new{ColorSequenceKeypoint.new(0,info[1]), ColorSequenceKeypoint.new(1,info[1])}
				}
			}
		end
    end
end

--[[
	   _                           _       
       (_)                         | |      
  ___   _    __ _   _ __     __ _  | |  ___ 
 / __| | |  / _` | | '_ \   / _` | | | / __|
 \__ \ | | | (_| | | | | | | (_| | | | \__ \
 |___/ |_|  \__, | |_| |_|  \__,_| |_| |___/
             __/ |                          
            |___/                           
]]

local localPlayerKnocked = signal.new()
local characterFullyLoaded = signal.new()
local newLocalPlayerBullet = signal.new()
local newPlayerBullet = signal.new()
local newToolEquipped = signal.new()
local newGunEquipped = signal.new()
local newAimbotTarget = signal.new()

local aimbot_data = {
	target = nil,
	velocity = vector3new(),
	last_refresh = clock(),
	last_sleeping = clock(),
	type = "global",
	highest_fov = 9e9,
	force_pos = nil,
	highest_offset = 0,
	target_data = nil
}

--[[
  _ __ ___    ___  _ __   _   _ 
 | '_ ` _ \  / _ \| '_ \ | | | |
 | | | | | ||  __/| | | || |_| |
 |_| |_| |_| \___||_| |_| \__,_|
]]

local window = menu:init(
	{
		[1] = {
			icon = "rbxassetid://18248771514"
		},
		[2] = {
			icon = "rbxassetid://15453313321"
		},
		[3] = {
			icon = "rbxassetid://15453335745",
			subtabs = {
				name = "Category",
				options = {
					{
						image = "rbxassetid://18686402989"
					},
					{
						image = "rbxassetid://18657040454"
					},
					{
						image = "rbxassetid://18205704829"
					},
					{
						image = "rbxassetid://18205706952"
					},
					{
						image = "rbxassetid://18205822505"
					}
				}
			}
		},
		[4] = {
			icon = "rbxassetid://15453344494",
			subtabs = {
				name = "Category",
				options = {
					{
						image = "rbxassetid://18334627891"
					},
					{
						image = "rbxassetid://18334630306"
					},
					{
						image = "rbxassetid://18334626899"
					},
					{
						image = "rbxassetid://18334625304"
					}
				}
			}
		},
		[5] = {
			icon = "rbxassetid://15453349637"
		},
		[6] = {
			icon = "rbxassetid://15453354931"
		},
		[7] = {
			icon = "rbxassetid://15453359751"
		},
		[8] = {
			icon = "rbxassetid://15453364412"
		},
		[9] = {
			icon = "rbxassetid://18240049800"
		}
	},
	4
)

local old_list = utility.getConfigList()
local old_script_list = utility.getScriptList()
local script_environment = {}
local config_list = nil
local script_unloaded = signal.new()
local legit = nil

do
local rage = window:getTab(1)
	local target_section = rage:newSection({name = "Target", scale = 1})
		menu_references["send_hit_packet_always"] = target_section:newElement({name = "Send hit packet always", types = {toggle = {flag = "send_hit_packet_always"}}})
		menu_references["predict_auto_armor"] = target_section:newElement({name = "Predict auto armor", types = {toggle = {flag = "predict_auto_armor"}}})
		menu_references["attach_to_target"] = target_section:newElement({name = "Attach to target", types = {toggle = {flag = "attach_to_target"}, dropdown = {flag = "attach_to_target_value", no_none = true, options = {"Random teleport", "Strafe"}, default = {"Strafe"}}, keybind = {flag = "attach_to_target_keybind"}}})
		menu_references["disable_when_knocked"] = target_section:newElement({name = "Disable if knocked", types = {toggle = {flag = "disable_when_knocked"}}})
		menu_references["only_on_serverside"] = target_section:newElement({name = "Desync position", types = {toggle = {flag = "only_on_serverside"}}})
		menu_references["attach_horizontal_offset"] = target_section:newElement({name = "Horizontal offset", types = {slider = {flag = "attach_horizontal_offset", min = 1, max = 50, default = 10, suffix = "", prefix = ""}}})
		menu_references["attach_vertical_offset"] = target_section:newElement({name = "Vertical offset", types = {slider = {flag = "attach_vertical_offset", min = 1, max = 50, default = 10, suffix = "", prefix = ""}}})
		menu_references["attach_horizontal_strafe"] = target_section:newElement({name = "Horizontal offset", types = {slider = {flag = "attach_horizontal_strafe", min = 1, max = 50, default = 10, suffix = "", prefix = ""}}})
		menu_references["attach_vertical_strafe"] = target_section:newElement({name = "Vertical offset ", types = {slider = {flag = "attach_vertical_strafe", min = -50, max = 50, default = 10, suffix = "", prefix = ""}}})
		menu_references["attach_strafe_speed"] = target_section:newElement({name = "Strafe speed", types = {slider = {flag = "attach_strafe_speed", min = 1, max = 100, default = 50, suffix = "%", prefix = ""}}})
		menu_references["teleport_rockets"] = target_section:newElement({name = "Teleport rockets", types = {toggle = {flag = "teleport_rockets"}}})
		menu_references["view_target"] = target_section:newElement({name = "View target", types = {toggle = {flag = "view_target"}, keybind = {flag = "view_target_keybind", method = 2}}})
	menu_references["auto_shoot"] = target_section:newElement({name = "Auto shoot", types = {toggle = {flag = "auto_shoot"}, keybind = {flag = "auto_shoot_keybind", method = 2}}})
	local ragebot_section = rage:newSection({name = "Ragebot", scale = 1, x = 0.5})
		menu_references["include_aimbot_target"] = ragebot_section:newElement({name = "Include aimbot target", types = {toggle = {flag = "include_aimbot_target"}}})
		menu_references["auto_equip"] = ragebot_section:newElement({name = "Auto equip", types = {toggle = {flag = "auto_equip"}, dropdown = {options = {"custom", "lmg", "ak"}, no_none = true, flag = "auto_equip_value", default = {"lmg"}}}})
		menu_references["auto_equip_text"] = ragebot_section:newElement({name = "Custom equip text", types = {textbox = {flag = "auto_equip_text", default = "type here"}}})
		menu_references["auto_stomp"] = ragebot_section:newElement({name = "Auto stomp", types = {toggle = {flag = "auto_stomp"}}})
		menu_references["teleport_back"] = ragebot_section:newElement({name = "Teleport back", types = {toggle = {flag = "teleport_back"}}})
local anti_aim = window:getTab(2)
	local anti_aim_section = anti_aim:newSection({name = "Anti aim", scale = 1})
		menu_references["destroy_cheaters"] = anti_aim_section:newElement({name = "Destroy cheaters", types = {toggle = {flag = "destroy_cheaters"}, keybind = {flag = "destroy_cheaters_keybind"}}})
		menu_references["void_kill"] = anti_aim_section:newElement({name = "Void kill", types = {toggle = {flag = "void_kill"}}})
		menu_references["velocity_desync"] = anti_aim_section:newElement({name = "Velocity desync", types = {toggle = {flag = "velocity_desync"}, keybind = {flag = "velocity_desync_keybind"}, dropdown = {flag = "velocity_desync_value", default = {"Zero"}, options = {"Multiplier", "Underground", "Random", "Zero", "Max", "Sky"}}}})
		menu_references["multiplier_value"] = anti_aim_section:newElement({name = "Multiplier value", types = {slider = {flag = "multiplier_value", min = -4, max = 4, default = 0.2, decimal = 1, suffix = "x", prefix = ""}}})
		menu_references["random_value"] = anti_aim_section:newElement({name = "Random value", types = {slider = {flag = "random_value", max = 100, default = 5, min = 1, decimal = 1, suffix = "%", prefix = ""}}})
		menu_references["random_teleport"] = anti_aim_section:newElement({name = "Random teleport", types = {toggle = {flag = "random_teleport"}, keybind = {flag = "random_teleport_keybind", method = 2}}})
		menu_references["horizontal_offset"] = anti_aim_section:newElement({name = "Horizontal offset", types = {slider = {flag = "horizontal_offset", min = 0, max = 100, default = 5, prefix = "", suffix = ""}}})
		menu_references["vertical_offset"] = anti_aim_section:newElement({name = "Vertical offset", types = {slider = {flag = "vertical_offset", min = 0, max = 100, default = 5, prefix = "", suffix = ""}}})
		menu_references["network_desync"] = anti_aim_section:newElement({name = "Network desync", types = {toggle = {flag = "network_desync"}, keybind = {flag = "network_desync_keybind"}, dropdown = {flag = "network_desync_value", default = {"Simple"}, options = {"Teleport move", "Invisible", "Lag step", "Random", "Simple"}}}})
		menu_references["void_spam"] = anti_aim_section:newElement({name = "Void spam", types = {toggle = {flag = "void_spam"}, keybind = {flag = "void_spam_keybind"}}})
	local character = anti_aim:newSection({name = "Character", scale = 0.5, x = 0.5})
		menu_references["client_side_pitch"] = character:newElement({name = "Client side pitch", types = {toggle = {flag = "client_side_pitch"}, slider = {flag = "client_side_pitch_value", default = 90, min = -90, max = 90, suffix = "°", prefix = ""}}})
		menu_references["face_backwards"] = character:newElement({name = "Face backwards", types = {toggle = {flag = "face_backwards"}}})
		menu_references["animation_spam"] = character:newElement({name = "Animation spam", types = {toggle = {flag = "animation_spam"}, dropdown = {flag = "animation_spam_value", options = {"Floss", "Hype"}, default = {"Floss"}, no_none = true}}})
		menu_references["animation_lag"] = character:newElement({name = "Animation lag", types = {toggle = {flag = "animation_lag"}, slider = {flag = "animation_lag_value", prefix = "", suffix = "%", min = 1, max = 100, default = 0}}})
		menu_references["spinbot"] = character:newElement({name = "Spinbot", types = {toggle = {flag = "spinbot"}, slider = {flag = "spinbot_speed", min = 1, max = 100, suffix = "%", prefix = ""}}})
	local other = anti_aim:newSection({name = "Other", scale = 0.5, x = 0.5, y = 0.5})
		menu_references["remove_fire_cooldown"] = other:newElement({name = "Remove fire cooldown", types = {toggle = {flag = "remove_fire_cooldown"}}})
		menu_references["auto_fire_armor"] = other:newElement({name = "Auto fire armor", types = {toggle = {flag = "auto_fire_armor"}}})
		menu_references["fire_armor_purchase_at"] = other:newElement({name = "Purchase at", types = {slider = {min = 1, max = 100, suffix = "%", prefix = "", flag = "fire_armor_purchase_at"}}})
		menu_references["auto_armor"] = other:newElement({name = "Auto armor", types = {toggle = {flag = "auto_armor"}}})
		menu_references["armor_purchase_at"] = other:newElement({name = "Purchase at ", types = {slider = {min = 1, default = 20, max = 100, suffix = "%", prefix = "", flag = "armor_purchase_at"}}})
		menu_references["anti_stomp"] = other:newElement({name = "Anti stomp", types = {toggle = {flag = "anti_stomp"}}})
		menu_references["auto_peek"] = other:newElement({name = "Auto peek", types = {toggle = {flag = "auto_peek"}, colorpicker = {flag = "auto_peek_color", default = colorfromrgb(153, 196, 39), transparency_flag = "auto_peek_transparency"}, dropdown = {flag = "auto_peek_value", no_none = true, multi = true, default = {"On shot"}, options = {"Not moving", "On shot"}}, keybind = {flag = "auto_peek_keybind", method = 2}}})
		menu_references["return_method"] = other:newElement({name = "Return method", types = {dropdown = {flag = "return_method", options = {"Teleport", "Move"}, no_none = true, default = {"Move"}}}})
		menu_references["return_delay"] = other:newElement({name = "Return delay", types = {slider = {min = 0, max = 0.2, suffix = "s", prefix = "", flag = "return_delay", decimal = 2}}})
		menu_references["return_color"] = other:newElement({name = "Return color", types = {colorpicker = {flag = "return_color", default = colorfromrgb(177, 0, 0), transparency_flag = "return_transparency"}}})
		menu_references["auto_ammo"] = other:newElement({name = "Auto ammo", types = {toggle = {flag = "auto_ammo"}}})
		menu_references["buy_amount"] = other:newElement({name = "Buy amount", types = {slider = {flag = "buy_amount", prefix = "", min = 1, max = 20, suffix = "x", default = 5}}})
		menu_references["anti_rpg"] = other:newElement({name = "Anti rpg", types = {toggle = {flag = "anti_rpg"}, dropdown = {flag = "anti_rpg_method", no_none = true, default = {"Avoid"}, options = {"Avoid", "Reflect"}}}})
		menu_references["reflect_to"] = other:newElement({name = "Reflect to", types = {dropdown = {flag = "reflect_to", no_none = true, default = {"Target"}, options = {"Target", "Closest"}}}})
legit = window:getTab(3)
	local general_aimbot = legit:getSubtab(1)
		local aimbot = general_aimbot:newSection({name = "Aimbot", scale = 1})
			menu_references["aimbot_enabled"] = aimbot:newElement({name = "Enabled", types = {toggle = {flag = "aimbot"}, keybind = {flag = "aimbot_keybind", method = 1}}})
			menu_references["auto_select_target"] = aimbot:newElement({name = "Auto select target", types = {toggle = {flag = "auto_select_target"}, slider = {min = 0, max = 1, suffix = "s", default = 0.03, decimal = 3, prefix = "", flag = "auto_select_target_delay"}}})
			menu_references["sticky"] = aimbot:newElement({name = "Sticky", types = {toggle = {flag = "sticky"}}})
			menu_references["target_bind"] = aimbot:newElement({name = "Target bind", types = {keybind = {flag = "target_bind_keybind", method_locked = true, method = 3}}})
			menu_references["silent_aim"] = aimbot:newElement({name = "Silent aim", types = {toggle = {flag = "silent_aim"}, keybind = {flag = "silent_aim_keybind", method = 1}}})
			menu_references["anti_aim_viewer"] = aimbot:newElement({name = "Anti aim viewer", types = {toggle = {flag = "anti_aim_viewer"}}})
			menu_references["aim_backtrack"] = aimbot:newElement({name = "Aim backtrack", types = {toggle = {flag = "aim_backtrack"}}})
			menu_references["backtrack_max_distance"] = aimbot:newElement({name = "Max distance", types = {slider = {flag = "backtrack_max_distance", min = 0, decimal = 0, default = 100, max = 500, suffix = "px", prefix = ""}}})
			menu_references["backtrack_lifetime"] = aimbot:newElement({name = "Lifetime", types = {slider = {flag = "backtrack_lifetime", min = 0.1, max = 1, suffix = "s", prefix = "", decimal = 2, default = 0.1}}})
			menu_references["backtrack_fallback"] = aimbot:newElement({name = "Fallback", types = {dropdown = {flag = "backtrack_fallback", options = {"Silent aim position", "Mouse position"}, no_none = true, default = {"Mouse position"}}}})
			menu_references["silent_aim_use_fov"] = aimbot:newElement({name = "Use fov", types = {toggle = {flag = "silent_aim_use_fov"}, colorpicker = {flag = "silent_aim_fov_color", transparency_flag = "silent_aim_fov_transparency"}}})
			menu_references["silent_aim_fov_filled"] = aimbot:newElement({name = "Filled", types = {toggle = {flag = "silent_aim_fov_filled"}}})
			menu_references["silent_aim_fov_outline"] = aimbot:newElement({name = "Outline", types = {toggle = {flag = "silent_aim_fov_outline"}, colorpicker = {flag = "silent_aim_fov_outline_color", default = colorfromrgb(0,0,0),transparency_flag = "silent_aim_fov_outline_transparency"}}})
			menu_references["silent_aim_disablers"] = aimbot:newElement({name = "Disable when ", types = {dropdown = {flag = "silent_aim_disablers", multi = true, default = {"Outside of fov", "Behind wall", "Off screen"}, options = {"Outside of fov", "Behind wall", "Ping spike", "Off screen"}}}})
			menu_references["aim_assist"] = aimbot:newElement({name = "Aim assist", types = {toggle = {flag = "aim_assist"}, keybind = {flag = "aim_assist_keybind", method = 1}, dropdown = {flag = "aim_assist_value", no_none = true, options = {"Camera", "Mouse"}, default = {"Camera"}}}})
			menu_references["aim_assist_disablers"] = aimbot:newElement({name = "Disable when", types = {dropdown = {flag = "aim_assist_disablers", multi = true, default = {"Outside of fov", "Behind wall"}, options = {"No tool equipped", "In third person", "Outside of fov", "Behind wall", "Ping spike", "Off screen", "Typing"}}}})
			menu_references["aim_assist_use_fov"] = aimbot:newElement({name = "Use fov", types = {toggle = {flag = "aim_assist_use_fov"}, colorpicker = {flag = "aim_assist_fov_color", transparency_flag = "aim_assist_fov_transparency"}}})
			menu_references["aim_assist_fov_filled"] = aimbot:newElement({name = "Filled", types = {toggle = {flag = "aim_assist_fov_filled"}}})
			menu_references["aim_assist_fov_outline"] = aimbot:newElement({name = "Outline", types = {toggle = {flag = "aim_assist_fov_outline"}, colorpicker = {flag = "aim_assist_fov_outline_color", default = colorfromrgb(0,0,0),transparency_flag = "aim_assist_fov_outline_transparency"}}})			
			menu_references["triggerbot"] = aimbot:newElement({name = "Triggerbot", types = {toggle = {flag = "triggerbot"}, keybind = {flag = "triggerbot_keybind", method = 1}}})
			menu_references["triggerbot_only_in_first_person"] = aimbot:newElement({name = "Only in first person", types = {toggle = {flag = "triggerbot_only_in_first_person"}}})
			menu_references["show_radius"] = aimbot:newElement({name = "Show radius", types = {toggle = {flag = "show_radius"}, colorpicker = {flag = "show_radius_color", transparency_flag = "show_radius_transparency", default = colorfromrgb(225,0,0)}}})
			menu_references["show_radius_outline"] = aimbot:newElement({name = "Outline", types = {colorpicker = {flag = "show_radius_outline", default = colorfromrgb(76,76,76), transparency_flag = "show_radius_outline_transparency"}}})
			menu_references["show_radius_gradient"] = aimbot:newElement({name = "Gradient", types = {toggle = {flag = "show_radius_gradient"}}})
			menu_references["show_radius_filled"] = aimbot:newElement({name = "Filled", types = {toggle = {flag = "show_radius_filled"}}})
			menu_references["resolver"] = aimbot:newElement({name = "Resolver", types = {toggle = {flag = "resolver"}, keybind = {flag = "resolver_keybind"}}})
			menu_references["random_teleport_resolver_keybind"] = aimbot:newElement({name = "Random teleport", types = {keybind = {flag = "random_teleport_resolver_keybind", method = 2}}})
			menu_references["network_resolver"] = aimbot:newElement({name = "Network", types = {toggle = {flag = "network_resolver"}}})
			menu_references["refresh_rate"] = aimbot:newElement({name = "Refresh rate", types = {slider = {flag = "refresh_rate", min = 0, max = 0.5, suffix = "s", prefix = "", default = 0.095, decimal = 3}}})
			menu_references["target_checks"] = aimbot:newElement({name = "Target checks", types = {dropdown = {flag = "target_checks", multi = true, default = {}, options = {"Behind wall", "Forcefield", "Distance", "Grabbed", "Knocked", "Crew"}}}})
			menu_references["max_distance"] = aimbot:newElement({name = "Max distance", types = {slider = {min = 100, max = 10000, default = 250, suffix = "", prefix = "", flag = "max_distance_value"}}})
			menu_references["untarget_when"] = aimbot:newElement({name = "Untarget when", types = {dropdown = {flag = "untarget_when", multi = true, default = {}, options = {"Target knocked", "Self knocked"}}}})
		local utilities = general_aimbot:newSection({name = "Utilities", scale = 0.5, x = 0.5})
			menu_references["auto_reload"] = utilities:newElement({name = "Auto reload", types = {toggle = {flag = "auto_reload"}}})
			menu_references["smart_auto_reload"] = utilities:newElement({name = "Smart", types = {toggle = {flag = "smart_auto_reload"}, slider = {flag = "smart_auto_reload_delay", min = 0, default = 0.03, max = 1, decimal = 2, suffix = "s", prefix = ""}}})
			menu_references["auto_sort"] = utilities:newElement({name = "Auto sort", types = {toggle = {flag = "auto_sort"}, keybind = {flag = "auto_sort_keybind", method = 2, method_locked = true}}})
			for i = 1, 9 do
				menu_references["slot_"..i] = utilities:newElement({name = "Slot "..i, types = {textbox = {flag = "slot_"..i}}})
			end
		local visualize = general_aimbot:newSection({name = "Visualize", scale = 0.5, x = 0.5, y = 0.5})
			menu_references["highlight_assist_hitbox"] = visualize:newElement({name = "Highlight aim assist hitbox", types = {toggle = {flag = "highlight_assist_hitbox"}, colorpicker = {flag = "highlight_assist_hitbox_color", default = colorfromrgb(255,0,0), default_transparency = 0.6, transparency_flag = "highlight_assist_hitbox_transparency"}}})
			menu_references["highlight_silent_hitbox"] = visualize:newElement({name = "Highlight silent hitbox", types = {toggle = {flag = "highlight_silent_hitbox"}, colorpicker = {flag = "highlight_silent_hitbox_color", default = colorfromrgb(0,255,0), default_transparency = 0.6, transparency_flag = "highlight_silent_hitbox_transparency"}}})
			menu_references["silent_aim_line"] = visualize:newElement({name = "Silent aim line", types = {toggle = {flag = "silent_aim_line"}, dropdown = {options = {"From character", "From mouse"}, no_none = true, flag = "silent_aim_line_from", default = {"From character"}}, colorpicker = {flag = "silent_aim_line_color", default = colorfromrgb(255,255,255), transparency_flag = "silent_aim_line_transparency"}}})
legit:_setActiveSubtab(1)
local visuals = window:getTab(4)
	local enemies = visuals:getSubtab(1)
		local player_esp = enemies:newSection({name = "Player ESP", scale = 1})
			menu_references["player_esp_render_for"] = player_esp:newElement({name = "Render for", types = {dropdown = {flag = "render_for", default = {"All"}, multi = true, options = {"Ragebot targets", "Aimbot target", "Whitelisted", "All"}}}})
			menu_references["player_esp"] = player_esp:newElement({name = "Enabled", types = {toggle = {flag = "player_esp"}}})
			menu_references["player_esp_box"] = player_esp:newElement({name = "Box", types = {toggle = {flag = "player_esp_box"}, colorpicker = {flag = "player_esp_box_color", transparency_flag = "player_esp_box_transparency"}}})
			menu_references["player_esp_fill"] = player_esp:newElement({name = "Fill", types = {toggle = {flag = "player_esp_fill"}, colorpicker = {flag = "player_esp_fill_color", transparency_flag = "player_esp_fill_transparency", default_transparency = 0.8}}})
			menu_references["player_esp_fill_gradient"] = player_esp:newElement({name = "Gradient", types = {toggle = {flag = "player_esp_fill_gradient"}}})
			menu_references["player_esp_tool"] = player_esp:newElement({name = "Tool", types = {toggle = {flag = "player_esp_tool"}, colorpicker = {flag = "player_esp_tool_color", transparency_flag = "player_esp_tool_transparency"}}})
			menu_references["player_esp_name"] = player_esp:newElement({name = "Name", types = {toggle = {flag = "player_esp_name"}, dropdown = {options = {"Display name", "Username"}, no_none = true, flag = "player_esp_name_value", default = {"Username"}}, colorpicker = {flag = "player_esp_name_color", transparency_flag = "player_esp_name_transparency"}}})
			menu_references["player_esp_highlight"] = player_esp:newElement({name = "Highlight", types = {toggle = {flag = "player_esp_highlight"}, colorpicker = {flag = "player_esp_highlight_color", default_transparency = 0.8, default = colorfromrgb(59, 176, 255), transparency_flag = "player_esp_highlight_transparency"}}})
			menu_references["player_esp_outline"] = player_esp:newElement({name = "Outline", types = {colorpicker = {flag = "player_esp_outline_color", default = colorfromrgb(255, 133, 237), default_transparency = 0.1, transparency_flag = "player_esp_outline_transparency"}}})
			menu_references["player_esp_armor_bar"] = player_esp:newElement({name = "Armor bar", types = {toggle = {flag = "player_esp_armor_bar"}, colorpicker = {flag = "player_esp_armor_bar_color", default = colorfromrgb(0, 204, 255), transparency_flag = "player_esp_armor_bar_transparency"}}})
			menu_references["player_esp_armor_bar_gradient"] = player_esp:newElement({name = "Gradient", types = {toggle = {flag = "player_esp_armor_bar_gradient"}}})
			menu_references["player_esp_armor_bar_dynamic"] = player_esp:newElement({name = "Dynamic", types = {toggle = {flag = "player_esp_armor_bar_dynamic"}, colorpicker = {default = colorfromrgb(15, 48, 68), flag = "player_esp_armor_bar_dynamic_color", transparency_flag = "player_esp_armor_bar_dynamic_transparency"}}})
			menu_references["player_esp_health_bar"] = player_esp:newElement({name = "Health bar", types = {toggle = {flag = "player_esp_health_bar"}, colorpicker = {flag = "player_esp_health_bar_color", default = colorfromrgb(0,255,0), transparency_flag = "player_esp_health_bar_transparency"}}})
			menu_references["player_esp_health_bar_gradient"] = player_esp:newElement({name = "Gradient", types = {toggle = {flag = "player_esp_health_bar_gradient"}}})
			menu_references["player_esp_health_bar_dynamic"] = player_esp:newElement({name = "Dynamic", types = {toggle = {flag = "player_esp_health_bar_dynamic"}, colorpicker = {default = colorfromrgb(255,0,0), flag = "player_esp_health_bar_dynamic_color", transparency_flag = "player_esp_health_bar_dynamic_transparency"}}})
			menu_references["player_esp_health_text"] = player_esp:newElement({name = "Health text", types = {toggle = {flag = "player_esp_health_text"}, colorpicker = {flag = "player_esp_health_text_color", default = colorfromrgb(255,255,255), transparency_flag = "player_esp_health_text_transparency"}}})
			menu_references["player_esp_health_text_follow_health_bar"] = player_esp:newElement({name = "Follow health bar", types = {toggle = {flag = "player_esp_health_text_follow_health_bar"}}})
			menu_references["player_esp_minimum_health_visibility"] = player_esp:newElement({name = "Minimum health visibility", types = {slider = {flag = "player_esp_minimum_health_visibility", min = 1, max = 100, default = 95, prefix = "", suffix = "HP"}}})
			menu_references["player_esp_health_text_dynamic"] = player_esp:newElement({name = "Dynamic", types = {toggle = {flag = "player_esp_health_text_dynamic"}, colorpicker = {default = colorfromrgb(255,0,0), flag = "player_esp_health_text_dynamic_color", transparency_flag = "player_esp_health_text_dynamic_transparency"}}})
			menu_references["player_esp_weapon_icon"] = player_esp:newElement({name = "Weapon icon", types = {toggle = {flag = "player_esp_weapon_icon"}, colorpicker = {flag = "player_esp_weapon_icon_color", transparency_flag = "player_esp_weapon_icon_transparency"}}})
			menu_references["player_esp_super_gun_warning"] = player_esp:newElement({name = "Super gun warning", types = {toggle = {flag = "player_esp_super_gun_warning"}, colorpicker = {flag = "player_esp_super_gun_warning_color", transparency_flag = "player_esp_super_gun_warning_transparency"}}})
			menu_references["player_esp_name_font"] = player_esp:newElement({name = "Name font", types = {dropdown = {flag = "player_esp_name_font", no_none = true, default = {"Bold"}, options = {"Minecraft", "Small", "Mono", "Bold"}}}})
			menu_references["player_esp_small_font"] = player_esp:newElement({name = "Small font", types = {dropdown = {flag = "player_esp_small_font", no_none = true, default = {"Small"}, options = {"Minecraft", "Small", "Mono", "Bold"}}}})
		local models = enemies:newSection({name = "Models", scale = 0.5, x = 0.5})
			menu_references["forcefield_hats_2"] = models:newElement({name = "Forcefield hats", types = {toggle = {flag = "forcefield_hats_2"}, colorpicker = {default = colorfromrgb(220,255,0), flag = "forcefield_hats_2_color", transparency_flag = "forcefield_hats_2_transparency"}}})
			menu_references["body_material"] = models:newElement({name = "Body material", types = {toggle = {flag = "body_material"}, dropdown = {flag = "body_material_value", options = {"ForceField", "Neon"}, no_none = true, default = {"Neon"}}, colorpicker = {default = colorfromrgb(220,255,0), flag = "body_material_color", transparency_flag = "body_material_transparency"}}})
		local on_hit = enemies:newSection({name = "On hit", scale = 0.5, x = 0.5, y = 0.5})
			menu_references["damage_number"] = on_hit:newElement({name = "Damage number", types = {toggle = {flag = "damage_number"}, dropdown = {options = {"Still", "Float"}, default = {"Float"}, no_none = true, flag = "damage_number_value"}, colorpicker = {default = colorfromrgb(255,255,255), flag = "damage_number_color", transparency_flag = "damage_number_transparency"}}})
			menu_references["damage_number_lifetime"] = on_hit:newElement({name = "Lifetime  ", types = {slider = {flag = "damage_number_lifetime", min = 0.5, max = 2.5, suffix = "s", prefix = "", decimal = 1, default = 0.6}}})
			menu_references["hit_skeleton"] = on_hit:newElement({name = "Hit skeleton", types = {toggle = {flag = "hit_chams"}, colorpicker = {default = colorfromrgb(255,255,255), flag = "hit_skeleton_color", transparency_flag = "hit_skeleton_transparency"}}})
			menu_references["hit_skeleton_only_last_hit"] = on_hit:newElement({name = "Only last hit ", types = {toggle = {flag = "hit_skeleton_only_last_hit"}}})
			menu_references["hit_skeleton_fade_out"] = on_hit:newElement({name = "Fade out ", types = {toggle = {flag = "hit_skeleton_fade_out"}}})
			menu_references["hit_skeleton_lifetime"] = on_hit:newElement({name = "Lifetime ", types = {slider = {flag = "hit_skeleton_lifetime", min = 0.1, max = 2, suffix = "s", prefix = "", decimal = 1, default = 1.5}}})
			menu_references["hit_particle"] = on_hit:newElement({name = "Hit particle", types = {toggle = {flag = "hit_particle"}, colorpicker = {default = colorfromrgb(255,255,255), flag = "hit_particle_color", transparency_flag = "hit_particle_transparency"}, dropdown = {options = {"Sparks", "Splash", "Flame", "Bubble", "Bits", "Air"}, flag = "hit_particle_value", default = {"Sparks"}, no_none = true}}})
			menu_references["hit_marker"] = on_hit:newElement({name = "Hit marker", types = {toggle = {flag = "hit_marker"}, colorpicker = {flag = "hit_marker_color", transparency_flag = "hit_marker_transparency"}, dropdown = {options = {"3D", "2D"}, flag = "hit_marker_value", default = {"2D"}, no_none = true}}})
			menu_references["hit_chams"] = on_hit:newElement({name = "Hit chams", types = {toggle = {flag = "hit_chams"}, colorpicker = {default = colorfromrgb(255,255,255), flag = "hit_chams_color", transparency_flag = "hit_chams_transparency"}, dropdown = {options = {"ForceField", "Outline", "Neon"}, flag = "hit_chams_value", default = {"Outline"}, no_none = true}}})
			menu_references["hit_chams_only_last_hit"] = on_hit:newElement({name = "Only last hit", types = {toggle = {flag = "hit_chams_only_last_hit"}}})
			menu_references["hit_chams_fade_out"] = on_hit:newElement({name = "Fade out", types = {toggle = {flag = "hit_chams_fade_out"}}})
			menu_references["hit_chams_lifetime"] = on_hit:newElement({name = "Lifetime", types = {slider = {flag = "hit_chams_lifetime", min = 0.1, max = 2, suffix = "s", prefix = "", decimal = 1, default = 1.5}}})
			menu_references["hit_sound"] = on_hit:newElement({name = "Hit sound", types = {toggle = {flag = "hit_sound"}, dropdown = {options = {"Minecraft", "Gamesense", "Neverlose", "Bameware", "Bubble", "RIFK7", "Rust", "Cod", "Custom"}, flag = "hit_sound_value", default = {"Gamesense"}, no_none = true}}})
			menu_references["hit_sound_id"] = on_hit:newElement({name = "Custom ID", types = {textbox = {flag = "hit_sound_id"}}})
			menu_references["hit_sound_volume"] = on_hit:newElement({name = "Volume", types = {slider = {flag = "hit_sound_volume", min = 0, max = 100, suffix = "%", default = 20, prefix = ""}}})
	local self = visuals:getSubtab(2)
		local local_player = self:newSection({name = "Local player", scale = 1})
			menu_references["accessory_adder"] = local_player:newElement({name = "Accessory adder", types = {toggle = {flag = "accessory_adder"}}})
			menu_references["accessories"] = local_player:newElement({name = "Accessories", types = {multibox = {max = 3}}})
			menu_references["remove_accessory"] = local_player:newElement({name = "Remove hat", types = {button = {text = "Remove accessory", callback = function()
				local id = menu_references["accessories"].selected_option

				if not id or not tonumber(id) then
					return end

				local accessories = lplr_data["accessories"]
				if accessories[id] then
					destroy(accessories[id])
					accessories[id] = nil
				end

				if find(lplr_data["equipped_accessories"], id) then
					remove(lplr_data["equipped_accessories"], id)
				end

				menu_references["accessories"]:removeOption(id)

				if char then
					local accessory = lplr_parts[tostring(id)]
					if accessory then
						destroy(accessory)
					end
				end

				flags["equipped_accessories"] = lplr_data["equipped_accessories"]
			end}}})
			menu_references["accessory_id"] = local_player:newElement({name = "Hat id", types = {textbox = {flag = "accessory_id", no_load = true}}})
			menu_references["add_accessory"] = local_player:newElement({name = "Add hat", types = {button = {text = "Add accessory", callback = function()
				local id = flags["accessory_id"]

				if not id or not tonumber(id) then
					return end

				if lplr_data["accessories"][id] then
					return end

				lplr_data["accessories"][id] = is:LoadLocalAsset("rbxassetid://"..id)
				menu_references["accessories"]:addOption(id)
				insert(lplr_data["equipped_accessories"], id)

				if char then
					local accessory = lplr_data["accessories"][id]:Clone()
					accessory.Name = id
					lplr_parts["Humanoid"]:AddAccessory(accessory)
					local attachment = findfirstchildofclass(accessory.Handle, "Attachment")
					accessory.Handle.CanCollide = false
					newObject("Weld", {
						Name = "AccessoryWeld",
						Part0 = accessory.Handle,
						Part1 = lplr_parts["Head"],
						C0 = attachment.CFrame,
						C1 = cframenew(0,0.6,0),
						Parent = accessory.Handle
					})
				end

				flags["equipped_accessories"] = lplr_data["equipped_accessories"]
			end}}})	
			menu_references["headless"] = local_player:newElement({name = "Headless", types = {toggle = {flag = "headless"}}})
			menu_references["korblox"] = local_player:newElement({name = "Korblox", types = {toggle = {flag = "korblox"}}})
			menu_references["trail"] = local_player:newElement({name = "Trail", types = {toggle = {flag = "trail"}, colorpicker = {flag = "trail_color", transparency_flag = "trail_transparency"}}})
			menu_references["trail_gradient"] = local_player:newElement({name = "Gradient", types = {toggle = {flag = "trail_gradient"}, colorpicker = {flag = "trail_gradient_color", default_transparency = 0.5, transparency_flag = "trail_gradient_transparency"}}})
			menu_references["trail_lifetime"] = local_player:newElement({name = "Lifetime", types = {slider = {flag = "trail_lifetime", min = 0.1, max = 1.5, prefix = "", suffix = "s", decimal = 1, default = 0.5}}})
		local local_player_model = self:newSection({name = "Model", scale = 1, x = 0.5})
			menu_references["desynced_position"] = local_player_model:newElement({name = "Desynced position", types = {toggle = {flag = "desynced_position"}, dropdown = {flag = "desynced_position_value", options = {"ForceField", "Neon"}, default = {"ForceField"}, no_none = true}, colorpicker = {flag = "desynced_position_color", transparency_flag = "desynced_position_transparency"}}})
			menu_references["desynced_position_highlight"] = local_player_model:newElement({name = "Higlight", types = {toggle = {flag = "desynced_position_highlight"}, colorpicker = {flag = "desynced_position_highlight_color", default_transparency = 0.8, transparency_flag = "desynced_position_highlight_transparency"}}})
			menu_references["desynced_position_outline"] = local_player_model:newElement({name = "Outline", types = {toggle = {flag = "desynced_position_outline"}, colorpicker = {flag = "desynced_position_outline_color", default = colorfromrgb(0,0,0),transparency_flag = "desynced_position_outline_transparency"}}})
			menu_references["forcefield_body"] = local_player_model:newElement({name = "Forcefield body", types = {toggle = {flag = "forcefield_body"}, colorpicker = {flag = "forcefield_body_color", transparency_flag = "forcefield_body_transparency"}}})
			menu_references["forcefield_hats"] = local_player_model:newElement({name = "Forcefield hats", types = {toggle = {flag = "forcefield_hats"}, colorpicker = {flag = "forcefield_hats_color", transparency_flag = "forcefield_hats_transparency"}}})
			menu_references["material_tools"] = local_player_model:newElement({name = "Material tools", types = {toggle = {flag = "material_tools"}, dropdown = {options = {"ForceField", "Neon"}, default = {"ForceField"}, no_none = true, flag = "material_tools_value"}, colorpicker = {flag = "material_tools_color", transparency_flag = "material_tools_transparency"}}})
			menu_references["particle_aura"] = local_player_model:newElement({name = "Particle aura", types = {toggle = {flag = "particle_aura"}, dropdown = {options = {"Ritual", "Bubble", "Swirl", "Rain", "Air"}, default = {"Swirl"}, no_none = true, flag = "particle_aura_value"}, colorpicker = {flag = "particle_aura_color", default = colorfromrgb(0,255,0.14902*255), transparency_flag = "particle_aura_transparency"}}})
	local world = visuals:getSubtab(3)
		local world_modulation = world:newSection({name = "World modulation", scale = 1})
			menu_references["atmosphere_changer"] = world_modulation:newElement({name = "Atmosphere changer", types = {toggle = {flag = "atmosphere_changer"}}})
			menu_references["atmosphere_color"] = world_modulation:newElement({name = "Atmosphere color", types = {colorpicker = {flag = "atmosphere_color", transparency_flag = "atmosphere_transparency", default = colorfromrgb(238, 147, 237)}}})
			menu_references["atmosphere_decay"] = world_modulation:newElement({name = "Atmosphere decay", types = {colorpicker = {flag = "atmosphere_decay", transparency_flag = "atmosphere_decay_transparency", default = colorfromrgb(255,255,255)}}})
			menu_references["atmosphere_density"] = world_modulation:newElement({name = "Atmosphere density", types = {slider = {flag = "atmosphere_density", prefix = "", suffix = "%", min = 0, max = 1, decimal = 3, default = 0.4}}})
			menu_references["atmosphere_glare"] = world_modulation:newElement({name = "Atmosphere glare", types = {slider = {flag = "atmosphere_glare", prefix = "", suffix = "", min = 0, max = 10, decimal = 1, default = 10}}})
			menu_references["atmosphere_haze"] = world_modulation:newElement({name = "Atmosphere haze", types = {slider = {flag = "atmosphere_haze", prefix = "", suffix = "", min = 0, max = 10, decimal = 1, default = 10}}})
			menu_references["brightness_changer"] = world_modulation:newElement({name = "Brightness changer", types = {toggle = {flag = "brightness_changer"}, slider = {flag = "brightness_changer_value", prefix = "", suffix = "", min = -10, max = 10, default = -3}}})
			menu_references["saturation_changer"] = world_modulation:newElement({name = "Saturation changer", types = {toggle = {flag = "saturation_changer"}, slider = {flag = "saturation_changer_value", prefix = "", suffix = "", min = -5, max = 5, default = 0}}})
			menu_references["exposure_changer"] = world_modulation:newElement({name = "Exposure changer", types = {toggle = {flag = "exposure_changer"}, slider = {flag = "exposure_changer_value", prefix = "", suffix = "", min = -10, max = 10, default = -0.5}}})
			menu_references["ambient_changer"] = world_modulation:newElement({name = "Ambient changer", types = {toggle = {flag = "ambient_changer"}, colorpicker = {flag = "ambient_changer_color", transparency_flag = "ambient_changer_transparency"}}})
			menu_references["skybox_changer"] = world_modulation:newElement({name = "Skybox changer", types = {toggle = {flag = "skybox_changer"}, dropdown = {flag = "skybox_changer_value", options = {"Purple default", "Red night", "Blossom", "Custom", "Jungle", "Foggy"}, default = {"Jungle"}, no_none = true}}})
			menu_references["SkyboxBk"] = world_modulation:newElement({name = "SkyboxBk", types = {textbox = {flag = "SkyboxBk", default = ""}}})
			menu_references["SkyboxDn"] = world_modulation:newElement({name = "SkyboxDn", types = {textbox = {flag = "SkyboxDn", default = ""}}})
			menu_references["SkyboxFt"] = world_modulation:newElement({name = "SkyboxFt", types = {textbox = {flag = "SkyboxFt", default = ""}}})
			menu_references["SkyboxLf"] = world_modulation:newElement({name = "SkyboxLf", types = {textbox = {flag = "SkyboxLf", default = ""}}})
			menu_references["SkyboxRt"] = world_modulation:newElement({name = "SkyboxRt", types = {textbox = {flag = "SkyboxRt", default = ""}}})
			menu_references["SkyboxUp"] = world_modulation:newElement({name = "SkyboxUp", types = {textbox = {flag = "SkyboxUp", default = ""}}})
			menu_references["time_changer"] = world_modulation:newElement({name = "Time changer", types = {toggle = {flag = "time_changer"}, slider = {flag = "time_changer_value", prefix = "", suffix = "", min = 0, max = 24, decimal = 1, default = 3}}})
			menu_references["fog_changer"] = world_modulation:newElement({name = "Fog changer", types = {toggle = {flag = "fog_changer"}, colorpicker = {flag = "fog_changer_color", transparency_flag = "fog_changer_transparency"}}})
			menu_references["fog_changer_start"] = world_modulation:newElement({name = "Fog start", types = {slider = {flag = "fog_changer_start", prefix = "", suffix = "", min = 0, max = 10000, default = 0}}})
			menu_references["fog_changer_end"] = world_modulation:newElement({name = "Fog end", types = {slider = {flag = "fog_changer_end", prefix = "", suffix = "", min = 0, max = 10000, default = 800}}})
		local effects = world:newSection({name = "Effects", scale = 1, x = 0.5})
			menu_references["custom_shoot_sound"] = effects:newElement({name = "Custom shoot sound", types = {toggle = {flag = "custom_shoot_sound"}, dropdown = {flag = "custom_shoot_sound_value", options = {"Custom", "SSG-08", "SCAR20", "G3SG1", "USP-S", "AWP"}, default = {"SSG-08"}, no_none = true}}})
			menu_references["custom_shoot_sound_id"] = effects:newElement({name = "Custom ID", types = {textbox = {flag = "custom_shoot_sound_id"}}})
			menu_references["custom_shoot_sound_volume"] = effects:newElement({name = "Volume", types = {slider = {flag = "custom_shoot_sound_volume", min = 0.1, max = 5, suffix = "", decimal = 1, default = 1, prefix = ""}}})
			menu_references["aspect_ratio_changer"] = effects:newElement({name = "Aspect ratio changer", types = {toggle = {flag = "aspect_ratio"}, slider = {flag = "aspect_ratio_value", prefix = "", suffix = "%", min = 1, max = 100, default = 100}}})
			menu_references["enemy_bullet_tracers"] = effects:newElement({name = "Enemy bullet tracers", types = {toggle = {flag = "enemy_bullet_tracers"}, colorpicker = {flag = "enemy_bullet_tracers_color", default = colorfromrgb(252, 136, 3), transparency_flag = "enemy_bullet_tracers_transparency"}, dropdown = {flag = "enemy_bullet_tracers_value", options = {"Drawing", "Beam"}, default = {"Drawing"}, no_none = true}}})
			menu_references["enemy_bullet_tracers_texture"] = effects:newElement({name = "Texture", types = {dropdown = {flag = "enemy_bullet_tracers_texture", options = {"Laser", "Beam"}, default = {"Laser"}, no_none = true}}})
			menu_references["enemy_bullet_tracers_outline"] = effects:newElement({name = "Outline", types = {colorpicker = {flag = "enemy_bullet_tracers_outline_color", default = colorfromrgb(0,0,0), transparency_flag = "enemy_bullet_tracers_outline_transparency"}}})
			menu_references["enemy_bullet_tracers_lifetime"] = effects:newElement({name = "Lifetime", types = {slider = {flag = "enemy_bullet_tracers_lifetime", min = 0.1, max = 2, prefix = "", suffix = "s", decimal = 1, default = 0.6}}})
			menu_references["local_bullet_tracers"] = effects:newElement({name = "Local bullet tracers", types = {toggle = {flag = "local_bullet_tracers"}, colorpicker = {flag = "local_bullet_tracers_color", default = colorfromrgb(0, 213, 255), transparency_flag = "local_bullet_tracers_transparency"}, dropdown = {flag = "local_bullet_tracers_value", options = {"Drawing", "Beam"}, default = {"Drawing"}, no_none = true}}})
			menu_references["local_bullet_tracers_texture"] = effects:newElement({name = "Texture", types = {dropdown = {flag = "local_bullet_tracers_texture", options = {"Laser", "Beam"}, default = {"Laser"}, no_none = true}}})
			menu_references["local_bullet_tracers_outline"] = effects:newElement({name = "Outline", types = {colorpicker = {flag = "local_bullet_tracers_outline_color", default = colorfromrgb(0,0,0), transparency_flag = "local_bullet_tracers_outline_transparency"}}})
			menu_references["local_bullet_tracers_lifetime"] = effects:newElement({name = "Lifetime", types = {slider = {flag = "local_bullet_tracers_lifetime", min = 0.1, max = 2, prefix = "", suffix = "s", decimal = 1, default = 0.6}}})
			menu_references["grenade_warnings"] = effects:newElement({name = "Grenade warnings", types = {toggle = {flag = "grenade_warnings"}}})
			menu_references["bullet_impacts"] = effects:newElement({name = "Bullet impacts", types = {toggle = {flag = "bullet_impacts"}, colorpicker = {flag = "bullet_impacts_color", default = colorfromrgb(255,255,255), transparency_flag = "bullet_impacts_transparency"}, dropdown = {flag = "bullet_impacts_value", options = {"ForceField", "Neon"}, default = {"Neon"}, no_none = true}}})
			menu_references["bullet_impacts_outline"] = effects:newElement({name = "Outline", types = {colorpicker = {flag = "bullet_impacts_outline_color", default = colorfromrgb(255,255,255), transparency_flag = "bullet_impacts_outline_transparency"}}})
			menu_references["bullet_impacts_lifetime"] = effects:newElement({name = "Lifetime", types = {slider = {flag = "bullet_impacts_lifetime", min = 0.1, max = 2, prefix = "", suffix = "s", decimal = 1, default = 0.6}}})
			menu_references["bullet_impacts_size"] = effects:newElement({name = "Size", types = {slider = {flag = "bullet_impacts_size", min = 0.1, max = 1, prefix = "", suffix = "", decimal = 1, default = 0.2}}})
			menu_references["rpg_warnings"] = effects:newElement({name = "RPG warnings", types = {toggle = {flag = "rpg_warnings"}}})
	local eyes = visuals:getSubtab(4)
		local view = eyes:newSection({name = "View", scale = 1})
			menu_references["unlock_max_zoom_distance"] = view:newElement({name = "Unlock max zoom distance", types = {toggle = {flag = "unlock_max_zoom_distance"}}})
			view:newElement({name = "Remove pepper spray effect", types = {toggle = {flag = "remove_pepper_spray_effect"}}})
			menu_references["suppress_flashbang_effect"] = view:newElement({name = "Suppress flashbang effect", types = {toggle = {flag = "suppress_flashbang_effect"}, dropdown = {flag = "suppress_flashbang_effect_value", options = {"Flash", "Full"}, default = {"Flash"}, no_none = true}}})
			menu_references["hide_gun_crosshair"] = view:newElement({name = "Hide gun crosshair", types = {toggle = {flag = "hide_gun_crosshair"}}})
			view:newElement({name = "Remove recoil", types = {toggle = {flag = "remove_recoil"}}})
			utility.newConnection(view:newElement({name = "Hide cursor", types = {toggle = {flag = "hide_cursor"}}}).onToggleChange, function(bool)
				uis.MouseIconEnabled = not bool
			end)
			utility.newConnection(view:newElement({name = "Show chat", types = {toggle = {flag = "show_chat"}}}).onToggleChange, function(bool)
				lplr_gui.Chat.Frame.ChatChannelParentFrame.Visible = bool
				lplr_gui.Chat.Frame.ChatBarParentFrame.Position = bool and udim2new(0, 0, 1, -44) or udim2new(0,0,0,0)
			end)
		local hud = eyes:newSection({name = "Hud", scale = 1, x = 0.5})
			menu_references["feature_indicators"] = hud:newElement({name = "Feature indicators", types = {colorpicker = {default = colorfromrgb(226,226,226), flag = "feature_indicators_color", transparency_flag = "feature_indicators_transparency"}, dropdown = {options = {"Random teleport resolver", "Predict auto armor", "Destroy cheaters", "Velocity desync", "Random teleport", "Network desync", "CFrame speed", "CFrame fly", "Void spam"}, multi = true, flag = "feature_indicators"}}})
			menu_references["custom_money_text"] = hud:newElement({name = "Custom money text", types = {toggle = {flag = "custom_money_text"}, colorpicker = {default = colorfromrgb(95, 255, 87), flag = "custom_money_text_color", transparency_flag = "custom_money_text_transparency"}, dropdown = {default = {"Default"}, flag = "custom_money_text_value", no_none = true, options = {"Default", "Simple"}}}})
			menu_references["hide_money_button"] = hud:newElement({name = "Hide money button", types = {toggle = {flag = "hide_money_button"}}})
			menu_references["custom_money_text_image"] = hud:newElement({name = "Image", types = {dropdown = {default = {"None"}, flag = "custom_money_text_image", no_none = true, options = {"My Melody", "Custom", "None"}}}})
			menu_references["custom_money_text_image_value"] = hud:newElement({name = "Image ", types = {textbox = {flag = "custom_money_text_image_value"}}})
			menu_references["drawing_crosshair"] = hud:newElement({name = "Drawing crosshair", types = {toggle = {flag = "drawing_crosshair"}, colorpicker = {flag = "drawing_crosshair_color", transparency_flag = "drawing_crosshair_transparency"}}})
			menu_references["drawing_crosshair_follow_target"] = hud:newElement({name = "Follow aimbot target", types = {toggle = {flag = "drawing_crosshair_follow_target"}}})
			menu_references["drawing_crosshair_location"] = hud:newElement({name = "Location", types = {dropdown = {flag = "drawing_crosshair_location", no_none = true, default = {"Mouse"}, options = {"Center", "Mouse"}}}})
			menu_references["drawing_crosshair_smoothness"] = hud:newElement({name = "Smoothness", types = {slider = {flag = "drawing_crosshair_smoothness", suffix = "%", prefix = "", min = 0, max = 100}}})
			menu_references["line_length"] = hud:newElement({name = "Line size", types = {slider = {flag = "line_length", min = 2, decimal = 1, default = 10, max = 100, suffix = "", prefix = ""}}})
			menu_references["line_gap"] = hud:newElement({name = "Line gap", types = {slider = {flag = "line_gap", min = 0, decimal = 1, default = 1, max = 100, suffix = "", prefix = ""}}})
			menu_references["line_spin"] = hud:newElement({name = "Spin", types = {slider = {flag = "line_spin", suffix = "%", prefix = "", min = 0, max = 100}}})
			menu_references["custom_stat_bars"] = hud:newElement({name = "Custom stat bars", types = {toggle = {flag = "custom_stat_bars"}, dropdown = {default = {"Default"}, flag = "custom_stat_bars_value", no_none = true, options = {"Minimalistic", "Gamesense", "Minecraft", "Sanrio", "Default", "Flat"}}}})
			menu_references["fire_armor_bar_color"] = hud:newElement({name = "Fire armor bar color", types = {colorpicker = {default = colorfromrgb(253, 121, 33), flag = "fire_armor_bar_color", transparency_flag = "fire_armor_bar_transparency"}}})
			menu_references["health_bar_color"] = hud:newElement({name = "Health bar color", types = {colorpicker = {default = colorfromrgb(36, 182, 3), flag = "health_bar_color", transparency_flag = "health_bar_transparency"}}})
			menu_references["energy_bar_color"] = hud:newElement({name = "Energy bar color", types = {colorpicker = {default = colorfromrgb(182, 182, 9), flag = "energy_bar_color", transparency_flag = "energy_bar_transparency"}}})
			menu_references["armor_bar_color"] = hud:newElement({name = "Armor bar color", types = {colorpicker = {default = colorfromrgb(0, 136, 194), flag = "armor_bar_color", transparency_flag = "armor_bar_transparency"}}})
			menu_references["car_hp_bar_color"] = hud:newElement({name = "Car HP bar color", types = {colorpicker = {default = colorfromrgb(204, 59, 49), flag = "car_hp_bar_color", transparency_flag = "car_hp_bar_transparency"}}})
			menu_references["notifications"] = hud:newElement({name = "Notifications", types = {dropdown = {options = {"On target change", "On hit"}, multi = true, flag = "notifications_value"}, colorpicker = {flag = "notifications_color", default = colorfromrgb(242,255,0), transparency_flag = "notifications_transparency"}}})
			menu_references["notifications_style"] = hud:newElement({name = "Style", types = {dropdown = {options = {"Gamesensical", "Gamesense", "Simple"}, default = {"Gamesensical"}, flag = "notifications_style"}}})
			menu_references["notifications_vertical_offset"] = hud:newElement({name = "Vertical offset", types = {slider = {flag = "notifications_vertical_offset", min = 0, max = 500, default = 0, prefix = "", suffix = "px"}}})
			menu_references["custom_hotbar"] = hud:newElement({name = "Custom hotbar", types = {toggle = {flag = "custom_hotbar"}, dropdown = {default = {"Default"}, flag = "custom_hotbar_value", no_none = true, options = {"Minimalistic", "Default"}}}})
			menu_references["watermark"] = hud:newElement({name = "Watermark", types = {toggle = {flag = "watermark"}, colorpicker = {flag = "watermark_color", default = colorfromrgb(255,255,255), transparency_flag = "watermark_transparency"}}})
			menu_references["watermark_position"] = hud:newElement({name = "Position", types = {dropdown = {flag = "watermark_position", no_none = true, default = {"Center"}, options = {"Mouse", "Center"}}}})
			menu_references["watermark_y_offset"] = hud:newElement({name = "Y offset", types = {slider = {flag = "watermark_y_offset", min = -400, max = 400, default = 0, suffix = "px", prefix = ""}}})
			menu_references["watermark_size"] = hud:newElement({name = "Size", types = {slider = {flag = "watermark_size", min = 8, max = 24, default = 8, suffix = "px", prefix = ""}}})
visuals:_setActiveSubtab(1)
local misc = window:getTab(5)
	local movement = misc:newSection({name = "Movement", scale = 1})
		menu_references["cframe_speed"] = movement:newElement({name = "CFrame speed", types = {toggle = {flag = "cframe_speed"}, slider = {flag = "cframe_speed_value", min = 1, max = 100, suffix = "%", prefix = "", decimal = 1}, keybind = {flag = "cframe_speed_keybind", default = Enum.KeyCode.LeftShift}}})
		menu_references["cframe_fly"] = movement:newElement({name = "CFrame fly", types = {toggle = {flag = "cframe_fly"}, slider = {flag = "cframe_fly_value", min = 1, max = 100, suffix = "%", prefix = "", decimal = 1}, keybind = {flag = "cframe_fly_keybind", default = Enum.KeyCode.LeftShift}}})
		menu_references["noclip"] = movement:newElement({name = "Noclip", types = {toggle = {flag = "noclip"}}})
		menu_references["prevent_fling"] = movement:newElement({name = "Prevent fling", types = {toggle = {flag = "prevent_fling"}}})
		local animation_ids = {
			["Happier Jump"] = "rbxassetid://15609995579",
			["Bouncy Twirl"] = "rbxassetid://14352343065",
			["V Pose"] = "rbxassetid://10214319518"
		}
		utility.newConnection(movement:newElement({name = "Emote", types = {dropdown = {flag = "emote_value", no_none = true, default = {"Happier Jump"}, options = {"Happier Jump", "Bouncy Twirl", "V Pose"}}, keybind = {flag = "emote_keybind", method = 2, method_locked = true}}}).onActiveChange, LPH_JIT_MAX(function()
			local humanoid = lplr_parts["Humanoid"]

			if not humanoid then
				return end

			local animation = newObject("Animation", {
				AnimationId = animation_ids[flags["emote_value"][1]]
			})

			local a = humanoid:LoadAnimation(animation)
			a:Play()

			local connection = utility.newConnection(humanoid:GetPropertyChangedSignal("MoveDirection"), function()
				a:Stop()
			end)
			destroy(animation)
		end))

		menu_references["macro"] =  movement:newElement({name = "Macro", types = {keybind = {flag = "macro_keybind", method = 2}}})
		utility.newConnection(movement:newElement({name = "Greet", types = {keybind = {flag = "greet_keybind", method_locked = true, method = 2}}}).onActiveChange, function()
			event:FireServer("AnimationPack", "Greet")
		end)
		utility.newConnection(movement:newElement({name = "Lay", types = {keybind = {flag = "lay_keybind", method_locked = true, method = 2}}}).onActiveChange, function()
			event:FireServer("AnimationPack", "Lay")
		end)
	local other = misc:newSection({name = "Other", scale = 1, x = 0.5})
		menu_references["remove_jump_cooldown"] = other:newElement({name = "Remove jump cooldown", types = {toggle = {flag = "remove_jump_cooldown"}}})
		menu_references["remove_slowdowns"] = other:newElement({name = "Remove slowdowns", types = {toggle = {flag = "remove_slowdowns"}}})
		do
			local instant_stand_connection = nil
			local instant_stand_connection2 = nil

			local function doInstantStand()
				local humanoid = lplr_parts["Humanoid"]

				if not humanoid then
					return end

				if instant_stand_connection then
					instant_stand_connection:Disconnect()
					instant_stand_connection = nil
				end

				instant_stand_connection = utility.newConnection(humanoid.StateChanged, LPH_NO_VIRTUALIZE(function(state)
					if state == Enum.HumanoidStateType.FallingDown then
						humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
					end
				end))

				humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
			end

			utility.newConnection(other:newElement({name = "Instant stand", types = {toggle = {flag = "instant_stand"}}}).onToggleChange, function(bool)
				local humanoid = lplr_parts["Humanoid"]

				if instant_stand_connection then
					instant_stand_connection:Disconnect()
					instant_stand_connection = nil
				end
				if instant_stand_connection2 then
					instant_stand_connection2:Disconnect()
					instant_stand_connection2 = nil
				end

				if bool then
					instant_stand_connection2 = utility.newConnection(characterFullyLoaded, doInstantStand)
					doInstantStand()
				elseif humanoid then
					humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
				end
			end)	
		end
		menu_references["no_void_kill"] = other:newElement({name = "No void kill", types = {toggle = {flag = "no_void_kill"}}})
		do
			local no_sit_connection = nil
			local no_sit_connection2 = nil

			local function doNoSit()
				local humanoid = lplr_parts["Humanoid"]

				if not humanoid then
					return end

				if no_sit_connection then
					no_sit_connection:Disconnect()
					no_sit_connection = nil
				end

				no_sit_connection = utility.newConnection(humanoid:GetPropertyChangedSignal("Sit"), LPH_NO_VIRTUALIZE(function()
					if humanoid.Sit then
						delay(0, function()
							humanoid["Sit"] = false
							humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
						end)
					end
				end))

				humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
			end
			menu_references["cash_aura"] = other:newElement({name = "Cash aura", types = {toggle = {flag = "cash_aura"}}})
			utility.newConnection(other:newElement({name = "No sit", types = {toggle = {flag = "no_sit"}}}).onToggleChange, function(bool)
				local humanoid = lplr_parts["Humanoid"]

				if no_sit_connection then
					no_sit_connection:Disconnect()
					no_sit_connection = nil
				end
				if no_sit_connection2 then
					no_sit_connection2:Disconnect()
					no_sit_connection2 = nil
				end

				if bool then
					no_sit_connection2 = utility.newConnection(characterFullyLoaded, doNoSit)
					doNoSit()
				elseif humanoid then
					humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
				end
			end)	
		end
		other:newElement({name = "Force reset", types = {button = {flag = "", text = "Force reset", confirmation = true, callback = function()
			local humanoid = lplr_parts["Humanoid"]

			if humanoid then
				humanoid.Health = 0
			end
		end}}})

local skins_tab = window:getTab(6)
	local purchases_section = skins_tab:newSection({name = "Purchases", scale = 1})
		menu_references["purchases_section"] = purchases_section
		menu_references["purchases"] = purchases_section:newElement({name = "Purchases", types = {multibox = {max = 16, search = true}}})
		menu_references["ammo_"] = purchases_section:newElement({name = "Ammo", types = {slider = {min = 0, max = 20, suffix = "x", no_load = true, prefix = "", flag = "purchase_ammo"}}})
		menu_references["purchase_style"] = purchases_section:newElement({name = "Purchase style", types = {dropdown = {no_none = true, default = {"Hidden"}, options = {"Hidden", "Rage"}, flag = "purchase_style"}}})
	local skins_section = skins_tab:newSection({name = "Skins", x = 0.5, scale = 1})
		menu_references["skin_changer"] = skins_section:newElement({name = "Enable skin changer", types = {toggle = {flag = "skin_changer"}}})
		menu_references["weapon_skin"] = skins_section:newElement({name = "Weapon skin", types = {multibox = {search = true, no_load = true, max = 8}}})
		menu_references["pullout_animation"] = skins_section:newElement({name = "Pullout animation", types = {dropdown = {no_none = true, flag = "pullout_animation", default = {"None"}, options = {"None", "Skin", "Soul", "Mystical"}}}})
		menu_references["selected_weapon"] = skins_section:newElement({name = "Selected weapon", types = {dropdown = {flag = "selected_weapon", no_none = true, no_load = true, options = {"[Knife]", "[Glock]", "[Silencer]", "[Shotgun]", "[Rifle]", "[SMG]", "[AR]", "[P90]", "[SilencerAR]", "[Revolver]", "[AK47]", "[TacticalShotgun]", "[DrumGun]", "[AUG]", "[LMG]", "[Double-Barrel SG]"}}}})
		utility.newConnection(menu_references["weapon_skin"].onSelectionChange, function(selected)
			skins["equipped"][flags["selected_weapon"][1]] = selected
			flags["equipped_skins"] = skins["equipped"]
		end)
		utility.newConnection(menu_references["selected_weapon"].onDropdownChange, function(selected)
			if not skin_table[selected[1]] then
				return end

			menu_references["weapon_skin"]:removeAllOptions()
			for skin, _ in skin_table[selected[1]] do
				menu_references["weapon_skin"]:addOption(skin)
			end
			local equipped_skin = skins["equipped"][selected[1]] 
			if equipped_skin then
				menu_references["weapon_skin"]:setSelected(equipped_skin, true)
			end
			menu_references["pullout_animation"]:setVisible(selected[1] == "[Knife]")
		end)
		menu_references["pullout_animation"]:setVisible(false)
		skins_section:newElement({name = "Refresh custom skins", types = {button = {text = "Refresh custom skins", callback = LPH_JIT(function()
			for _, file in listfiles(config_location.."/assets/") do
				if string.sub(file, -5) ~= ".skin" then
					continue end

				local data = readfile(file)
				local new_skin = nil
				local s, err = pcall(function()
					new_skin = loadstring(data)()
				end)

				if err then
					continue end
				
				local name = new_skin["Name"]

				if skins[name] and not custom_skins[name]  then
					continue end

				skins[name] = {
					Beam = new_skin["Beam"],
					ShootSounds = {
						[new_skin["Gun"]] = new_skin["Sound"]
					},
					Tween = new_skin["Tween"],
				}

				if new_skin["Particle"] then
					local object = nil
					local s, err = pcall(function()
						object = is:LoadLocalAsset(new_skin["Particle"])
					end)

					if not object or not s then
						print(err)
						continue end
					
					skins[name]["Particle"] = object[1]
				end

				skin_table[new_skin["Gun"]][name] = {
					CFrame = new_skin["CFrame"],
					TextureID = new_skin["TextureID"],
					TextureId = new_skin["TextureId"],
					MeshId = new_skin["MeshId"],
					Color = new_skin["Color"],
					Material = new_skin["Material"],
					Scale = new_skin["Scale"]
				}

				custom_skins[name] = ""

				menu_references["selected_weapon"].onDropdownChange:Fire(flags["selected_weapon"])
			end
		end)}}})
local players_tab = window:getTab(7)
	local players_section = players_tab:newSection({name = "Players", x = 0, scale = 1})
		menu_references["players_box"] = players_section:newElement({name = "_", types = {multibox = {max = 12, search = true}}})
		players_section:newElement({name = "View player", types = {button = {text = "View player", callback = function()
			if not menu_references["players_box"].selected_option then
				return end

			local player = findfirstchild(plrs, menu_references["players_box"].selected_option)

			if not player then
				return end 

			local hrp = player_data[player]["character_parts"]["HumanoidRootPart"]

			if not hrp then
				return end

			if lplr_data["viewing"] == player then
				camera.CameraSubject = char
				lplr_data["viewing"] = nil
				return
			end

			camera.CameraSubject = player.Character
			lplr_data["viewing"] = player
		end}}})
		players_section:newElement({name = "Teleport to", types = {button = {text = "Teleport to", callback = function()
			if not menu_references["players_box"].selected_option then
				return end

			local player = findfirstchild(plrs, menu_references["players_box"].selected_option)

			if not player then
				return end 

			local hrp = player_data[player]["character_parts"]["HumanoidRootPart"]

			if not hrp then
				return end

			local lplr_hrp = lplr_parts["HumanoidRootPart"]

			if not lplr_hrp then 
				return end

			lplr_hrp["CFrame"] = hrp["CFrame"]
			lplr_pos = hrp["CFrame"]
			rs.Heartbeat:Wait()
			lplr_hrp["CFrame"] = hrp["CFrame"]
			lplr_pos = hrp["CFrame"]
		end}}})
	local adjustments_section = players_tab:newSection({name = "Adjustments", x = 0.5, scale = 1})
		menu_references["whitelisted"] = adjustments_section:newElement({name = "Whitelisted", types = {toggle = {flag = "whitelisted"}}})
		menu_references["ragebot"] = adjustments_section:newElement({name = "Ragebot", types = {toggle = {flag = "ragebot"}}})
		menu_references["view_aim"] = adjustments_section:newElement({name = "View aim", types = {toggle = {flag = "view_aim"}, colorpicker = {flag = "view_aim_color", transparency_flag = "view_aim_transparency"}}})
local configuration = window:getTab(8)
	local config_section = configuration:newSection({name = "Configs", is_changeable = false, scale = 0.8})
		config_list = config_section:newElement({name = "Config list", types = {multibox = {max = 8, search = true}}})
		config_section:newElement({name = "Update config", types = {button = {confirmation = true, text = "Update config", 
			callback = function()
				local option = config_list.selected_option
				if option then
					utility.saveConfig(option)
					for _, config in old_list do
						config_list:removeOption(config)
					end
					old_list = utility.getConfigList()
					for _, config in old_list do
						config_list:addOption(config)
					end
				end
			end
		}}})
		config_section:newElement({name = "Load config", types = {button = {confirmation = true, text = "Load config",
			callback = function()
				if config_list.selected_option then
					for lua, _ in script_environment do
						task.cancel(script_environment[lua])
						script_environment[lua] = nil
						script_unloaded:Fire(lua)
						flags["loaded_scripts"] = {}
					end
					if flags["equipped_accessories"] then
						for id, object in lplr_data["accessories"] do
							destroy(object)
							lplr_data["accessories"][id] = nil
						end

						lplr_data["equipped_accessories"] = {}
						
						for _, id in flags["equipped_accessories"] do
							if not id or not tonumber(id) then
								continue end

							lplr_data["accessories"][id] = is:LoadLocalAsset("rbxassetid://"..id)
							menu_references["accessories"]:addOption(id)
							insert(lplr_data["equipped_accessories"], id)
						end

						menu_references["accessory_adder"].onToggleChange:Fire(flags["accessory_adder"])
					end
					local config = utility.convertConfig(config_list.selected_option)
					if config["equipped_skins"] then
						skins["equipped"] = config["equipped_skins"]
					end
					if config["loaded_scripts"] then
						for _, script in config["loaded_scripts"] do
							local data = nil
							pcall(function()
								data = readfile(config_location.."/addons/"..script..".lua")
							end)
		
							if not data then
								continue
							end
		
							wait()
		
							local s, err = pcall(function()
								script_environment[script] = spawn(loadstring(data))
							end)
						end
					end
					utility.loadConfig(config)
					delay(0, function()
						menu.on_load:Fire()
					end)
				end
			end
		}}})
		config_section:newElement({name = "Config name", types = {textbox = {no_load = true, flag = "config_name"}}})
		config_section:newElement({name = "Create config", types = {button = {confirmation = true, text = "Create config", 
			callback = function()
				if flags["config_name"] and #flags["config_name"] > 0 then
					utility.saveConfig(flags["config_name"])
					for _, config in old_list do
						config_list:removeOption(config)
					end
					old_list = utility.getConfigList()
					for _, config in old_list do
						config_list:addOption(config)
					end
				end
			end
		}}})
		config_section:newElement({name = "Refresh list", types = {button = {text = "Refresh list",
			callback = function()
				for _, config in old_list do
					config_list:removeOption(config)
				end
				old_list = utility.getConfigList()
				for _, config in old_list do
					config_list:addOption(config)
				end
			end
		}}})
local lua = window:getTab(9)
	local a_section = lua:newSection({name = "Tab A", scale = 1})
	local b_section = lua:newSection({name = "Tab B", scale = 1, x = 0.5})
	local lua_section = configuration:newSection({name = "LUA", is_changeable = false, x = 0.5, scale = 1})
		getgenv().juju = {
			script_unloaded = script_unloaded,
			menu_references = menu_references,
			flags = flags,
			a_section = a_section,
			b_section = b_section,
			on_local_bullet = newLocalPlayerBullet,
			on_player_bullet = newPlayerBullet,
			on_tool_equipped = newToolEquipped,
			on_gun_equipped = newGunEquipped,
			on_character_loaded = characterFullyLoaded,
			new_aimbot_target = newAimbotTarget,
			get_aimbot_target = LPH_JIT_MAX(function()
				return aimbot_data["target"]
			end),
			set_aimbot_target = setAimbotTarget,
		}
		local script_list = lua_section:newElement({name = "Script list", types = {multibox = {max = 2, search = true}}})
		lua_section:newElement({name = "Load script", types = {button = {text = "Load script",
			callback = function()
				if script_list.selected_option and not script_environment[script_list.selected_option] then
					local data = nil
					pcall(function()
						data = readfile(config_location.."/addons/"..script_list.selected_option..".lua")
					end)

					if not data then
						error("juju.lol\n	failed to read script \""..script_list.selected_option.."\"")
						return
					end

					local new_script_list = utility.getScriptList()
					for name, lua in script_environment do
						if not find(new_script_list, name..".lua") then
							task.cancel(lua)
							script_environment[name] = nil
							if find(flags["loaded_scripts"], name) then
								remove(flags["loaded_scripts"], name)
							end
						end	
					end

					wait()

					local s, err = pcall(function()
						script_environment[script_list.selected_option] = spawn(loadstring(data))
					end)

					if not find(flags["loaded_scripts"], script_list.selected_option) then
						insert(flags["loaded_scripts"], script_list.selected_option)
					end
					
					if not s then
						error(err)
					end
				end
			end
		}}})
		lua_section:newElement({name = "Unload script", types = {button = {text = "Unload script",
			callback = function()
				if script_list.selected_option and script_environment[script_list.selected_option]  then
					local lua = script_list.selected_option 

					if not lua then
						error("juju.lol\n	failed to unload script \""..script_list.selected_option.."\"")
						return 
					end

					task.cancel(script_environment[lua])
					if find(flags["loaded_scripts"], lua) then
						remove(flags["loaded_scripts"], lua)
					end
					script_environment[lua] = nil
					script_unloaded:Fire(lua)
				end
			end
		}}})
		lua_section:newElement({name = "Refresh list", types = {button = {text = "Refresh list",
			callback = function()
				for _, lua in old_script_list do
					script_list:removeOption(lua)
				end
				old_script_list = utility.getScriptList()
				for _, lua in old_script_list do
					script_list:addOption(lua)
				end
			end
		}}})
		for _, lua in old_script_list do
			script_list:addOption(lua)
		end
	local menu_section = configuration:newSection({name = "Menu", is_changeable = false, y = 0.8, scale = 0.2})
		utility.newConnection(menu_section:newElement({name = "Menu key", types = {keybind = {flag = "menu_key", key = Enum.KeyCode.Insert, method = 2, method_locked = true}}}).onActiveChange, function()
			if flags["menu_key"]["key"] ~= nil then
				menu["toggle"] = string.upper(flags["menu_key"]["key"]["Name"])
			end
		end)
		utility.newConnection(menu_section:newElement({name = "Menu color", types = {colorpicker = {flag = "menu_accent", transparency_flag = "", default = menu.accent_color}}}).onColorChange, function(color)
			menu:set_accent_color(color)
		end)
		utility.newConnection(menu_section:newElement({name = "Menu animation speed", types = {slider = {flag = "animation_speed", default = 100, min = 0, max = 150, min_text = "Off", prefix = "", suffix = "%"}}}).onSliderChange, function(value)
			menu["animation_speed"] = value == 0 and value or 0.5 - value/300
		end)
		menu_section:newElement({name = "Unload cheat", types = {button = {text = "Unload cheat",
			callback = function()
				getgenv().unload_juju()
			end
		}}})
		menu_section:newElement({name = "Disable all", types = {button = {text = "Disable all",
			callback = function()
				for flag, value in pairs(flags) do
					if typeof(value) == "boolean" then
						flags[flag] = false
					end
				end
				menu.on_load:Fire()
			end
		}}})
window:_setActiveTab(7)
end

--[[
  _            _                         
 | |          | |                        
 | |__    ___ | | _ __    ___  _ __  ___ 
 | '_ \  / _ \| || '_ \  / _ \| '__|/ __|
 | | | ||  __/| || |_) ||  __/| |   \__ \
 |_| |_| \___||_|| .__/  \___||_|   |___/
                 | |                     
                 |_|                     
]]

local gun_types = {
	["[LMG]"] = "automatic",
	["[Double-Barrel SG]"] = "shotgun",
	["[TacticalShotgun]"] = "shotgun",
	["[AUG]"] = "automatic",
	["[P90]"] = "automatic",
	["[Glock]"] = "pistol",
	["[DrumGun]"] = "automatic",
	["[Rifle]"] = "global",
	["[Shotgun]"] = "shotgun",
	["[SMG]"] = "automatic",
	["[AR]"] = "automatic",
	["[Revolver]"] = "pistol",
	["[AK47]"] = "automatic",
	["[SilencerAR]"] = "automatic",
	["[Silencer]"] = "pistol"
}

local hitPlayer = signal.new()

local color_correction = findfirstchildofclass(lighting, "ColorCorrectionEffect")

if not color_correction then
	color_correction = newObject("ColorCorrectionEffect", {
		Enabled = false,
		Parent = lighting
	})
end

local sky = findfirstchildofclass(lighting, "Sky") -- // TO-DO: implement making it NOT create a sky.. xd

if not sky then
	sky = newObject("Sky", {
		Parent = lighting
	})
end

local spoof_properties = {
	[lighting] = {
		["FogColor"] = lighting.FogColor,
		["FogStart"] = lighting.FogStart,
		["FogEnd"] = lighting.FogEnd,
		["ExposureCompensation"] = lighting.ExposureCompensation,
		["ClockTime"] = floor(lighting.ClockTime),
		["Ambient"] = lighting.Ambient,
		["Brightness"] = lighting.Brightness,
	},
	[sky] = {
		["SkyboxBk"] = sky.SkyboxBk,
		["SkyboxDn"] = sky.SkyboxDn,
		["SkyboxFt"] = sky.SkyboxFt,
		["SkyboxLf"] = sky.SkyboxLf,
		["SkyboxRt"] = sky.SkyboxRt,
		["SkyboxUp"] = sky.SkyboxUp,
	},
	[color_correction] = {
		["Saturation"] = color_correction.Saturation
	},
	[lighting.PepperSprayBlur] = {
		["Enabled"] = lighting.PepperSprayBlur.Enabled
	},
	[workspace] = {
		["FallenPartsDestroyHeight"] = -500
	}
}

local spoof_skip = {
	["FogColor"] = "fog_changer",
	["FogStart"] = "fog_changer",
	["FogEnd"] = "fog_changer",
	["ClockTime"] = "time_changer",
	["Ambient"] = "ambient_changer",
	["ExposureCompensation"] = "exposure_changer",
	["Brightness"] = "brightness_changer",
	["Saturation"] = "saturation_changer",
	["SkyboxBk"] = "skybox_changer",
	["SkyboxDn"] = "skybox_changer",
	["SkyboxFt"] = "skybox_changer",
	["SkyboxLf"] = "skybox_changer",
	["SkyboxRt"] = "skybox_changer",
	["SkyboxUp"] = "skybox_changer",
	["Enabled"] = "remove_pepper_spray_effect",
	["Visible"] = "remove_pepper_spray_effect",
	["CameraMaxZoomDistance"] = lplr.CameraMaxZoomDistance,
}

--[[
   ___  ___  _ __  
  / _ \/ __|| '_ \ 
 |  __/\__ \| |_) |
  \___||___/| .__/ 
            | |    
            |_|    
]]

local offset = vector3new(0,0.5,0)
local box_size_offset = vector2new(2,2)
local box_position_offset = vector2new(1,1) 
local health_bar_outline_offset = vector2new(7,3)

local do_box = false
local do_fill = false
local do_health_bar = false
local do_dynamic_health_color = false
local do_dynamic_health_text_color = false
local do_armor_bar = false
local do_dynamic_armor_color = false
local do_name = false
local do_health_text = false
local follow_health_bar = false
local do_tool = false
local do_super_gun_warning = false
local minimum_health_visibility = 95
local do_weapon_icon = false

local renderESP = LPH_NO_VIRTUALIZE(function(dt)
	for player, data in player_data do
		local character_parts = data["character_parts"]
		local hrp = character_parts["UpperTorso"]
		local last_position = data["last_position"]

		if (not hrp and not last_position) or not data["rendering"] then
			if not data["dont_render"] then
				for _, drawing in data["drawings"] do
					drawing["Visible"] = false
				end
				data["dont_render"] = true
			end
			continue 
		end

		local hrp_position = hrp and hrp["Position"] or last_position
		local above, on_screen = wtvp(camera, hrp_position + offset)

		if on_screen then
			local drawings = data["drawings"]

			if data["dont_render"] then
				for _, drawing in drawings do
					drawing["Visible"] = true
				end
			end
			data["dont_render"] = false

			local below = wtvp(camera, hrp_position - offset)
			local divided = below.Y-above.Y
			local y_size = divided * 6
			local x_size = divided * 4
			local v2_size = vector2new(x_size, y_size)
			local v2_position = vector2new(below.X - x_size/2, below.Y - y_size/2)

			if do_box then
				local box = drawings["box"]
				local outline = drawings["box_outline"]
				
				box["Size"] = v2_size + box_size_offset
				box["Position"] = v2_position - box_position_offset
				outline["Size"] = v2_size 
				outline["Position"] = v2_position
			end

			if do_fill then
				local fill = drawings["fill"]

				fill["Size"] = v2_size
				fill["Position"] = v2_position
			end

			local health_bar_position = nil
			if do_health_bar then
				local health_bar = drawings["health_bar"]
				local size = (y_size)*(data["health"]/data["max_health"])
				health_bar_position = v2_position + vector2new(-6, -(size-y_size+2))
				health_bar["Size"] = vector2new(1,size + 4)
				health_bar["Position"] = health_bar_position
				
				local health_bar_outline = drawings["health_bar_outline"]
				health_bar_outline["Size"] = vector2new(3,6 + y_size)
				health_bar_outline["Position"] = v2_position - health_bar_outline_offset
			end

			if do_armor_bar then
				local armor_bar = drawings["armor_bar"]
				local size = (y_size)*(data["armor"]/130)
				armor_bar["Size"] = vector2new(1,size + 4)
				armor_bar["Position"] = v2_position + vector2new(health_bar_position and -10 or -6, -(size-y_size+2))
				
				local armor_bar_outline = drawings["armor_bar_outline"]
				armor_bar_outline["Size"] = vector2new(3,6 + y_size)
				armor_bar_outline["Position"] = v2_position - vector2new(health_bar_position and 11 or 7,3)
			end

			if do_health_text then
				local health_text = drawings["health_text"]
				health_text["Position"] = follow_health_bar and (health_bar_position and health_bar_position-vector2new(health_text["TextBounds"]["X"]/2,2)) or v2_position - vector2new(health_text["TextBounds"]["X"] + (health_bar_position and 8 or 3),4)
				health_text["Visible"] = data["health"] < minimum_health_visibility
			end

			if do_name then
				local name = drawings["name"]

				name["Position"] = vector2new(x_size / 2 + v2_position["X"], v2_position["Y"] - name["TextBounds"]["Y"] - 4)
			end

			local tool_offset = 0

			if do_tool and data["tool"] then
				local drawing = drawings["tool"]
				tool_offset = drawing["TextBounds"]["Y"]
				drawing["Position"] = vector2new(x_size / 2 + v2_position["X"], v2_position["Y"] + y_size + 3)
			end

			if do_weapon_icon and data["weapon"] then
				local icon = drawings["weapon_icon"]
				icon["Position"] = vector2new(v2_position["X"] + (x_size-20)/2, v2_position["Y"] + y_size + tool_offset + 5)
			end

			if do_super_gun_warning and data["has_super_gun"] then
				drawings["super_gun_warning"]["Position"] = vector2new(v2_position["X"] + x_size + 3, v2_position["Y"])
			end
		elseif not data["dont_render"] then
			for _, drawing in data["drawings"] do
				drawing["Visible"] = false
			end
			data["dont_render"] = true
		end
	end
end)

local createBox = LPH_NO_VIRTUALIZE(function(data)
	local drawings = data["drawings"]

	drawings["box"] = utility.newDrawing("Square", {
		Color = flags["player_esp_box_color"],
		Transparency = -flags["player_esp_box_transparency"]+1,
		Filled = false,
		Thickness = 1,
		ZIndex = 2,
		Visible = not data["dont_render"]
	})
	drawings["box_outline"] = utility.newDrawing("Square", {
		Color = colorfromrgb(0,0,0),
		Transparency = -flags["player_esp_box_transparency"]+1,
		Filled = false,
		Thickness = 3,
		ZIndex = 1,
		Visible = not data["dont_render"]
	})
end)

local createFill = LPH_NO_VIRTUALIZE(function(data, do_gradient)
	data["drawings"]["fill"] = utility.newDrawing(do_gradient and "Image" or "Square", {
		Color = flags["player_esp_fill_color"],
		Transparency = -flags["player_esp_fill_transparency"]+1,
		Filled = true,
		ZIndex = 1,
		Visible = not data["dont_render"]
	})
	if do_gradient then
		data["drawings"]["fill"]["Data"] = images["upward_gradient"]
	end
end)

local createHealthBar = LPH_NO_VIRTUALIZE(function(data, do_gradient)
	local drawings = data["drawings"]
	local transparency = -flags["player_esp_health_bar_transparency"]+1

	drawings["health_bar"] = utility.newDrawing(do_gradient and "Image" or "Square", {
		Color = do_dynamic_health_color and flags["player_esp_health_bar_dynamic_color"]:Lerp(flags["player_esp_health_bar_color"], data["health"]/data["max_health"]) or flags["player_esp_health_bar_color"],
		Transparency = transparency,
		Filled = true,
		ZIndex = 2,
		Thickness = 1,
		Visible = not data["dont_render"]
	})
	if do_gradient then
		drawings["health_bar"]["Data"] = images["upward_gradient"]
	end
	drawings["health_bar_outline"] = utility.newDrawing("Square", {
		Color = colorfromrgb(0,0,0),
		Transparency = transparency,
		ZIndex = 1,
		Filled = true,
		Thickness = 1,
		Visible = not data["dont_render"]
	})
end)

local createArmorBar = LPH_NO_VIRTUALIZE(function(data, do_gradient)
	local drawings = data["drawings"]
	local transparency = -flags["player_esp_armor_bar_transparency"]+1

	drawings["armor_bar"] = utility.newDrawing(do_gradient and "Image" or "Square", {
		Color = do_dynamic_armor_color and flags["player_esp_armor_bar_dynamic_color"]:Lerp(flags["player_esp_armor_bar_color"], data["armor"]/130) or flags["player_esp_armor_bar_color"],
		Transparency = transparency,
		Filled = true,
		ZIndex = 2,
		Thickness = 1,
		Visible = not data["dont_render"]
	})
	if do_gradient then
		drawings["armor_bar"]["Data"] = images["upward_gradient"]
	end
	drawings["armor_bar_outline"] = utility.newDrawing("Square", {
		Color = colorfromrgb(0,0,0),
		Transparency = transparency,
		ZIndex = 1,
		Filled = true,
		Thickness = 1,
		Visible = not data["dont_render"]
	})
end)

local createHealthText = LPH_NO_VIRTUALIZE(function(data, do_dynamic_health_text_color)
	data["drawings"]["health_text"] = utility.newDrawing("Text", {
		Size = 9,
		Font = small_font,
		Text = tostring(floor(data["health"])),
		Color = do_dynamic_health_text_color and flags["player_esp_health_text_dynamic_color"]:Lerp(flags["player_esp_health_text_color"], data["health"]/data["max_health"]) or flags["player_esp_health_text_color"],
		Transparency = -flags["player_esp_health_text_transparency"]+1,
		Outline = true,
		ZIndex = 3,
		Visible = not data["dont_render"]
	})
end)

local createName = LPH_NO_VIRTUALIZE(function(data)
	data["drawings"]["name"] = utility.newDrawing("Text", {
		Size = 11,
		Font = normal_font,
		Text = flags["player_esp_name_value"][1] == "Username" and data["name"] or data["instance"]["DisplayName"],
		Color = flags["player_esp_name_color"], 
		Transparency = -flags["player_esp_name_transparency"]+1,
		Outline = true,
		Center = true,
		Visible = not data["dont_render"]
	})
end)

local createTool = LPH_NO_VIRTUALIZE(function(data)
	data["drawings"]["tool"] = utility.newDrawing("Text", {
		Size = 9,
		Font = small_font,
		Text = data["tool"] or "",
		Color = flags["player_esp_tool_color"], 
		Transparency = -flags["player_esp_tool_transparency"]+1,
		Outline = true,
		Center = true,
		Visible = not data["dont_render"]
	})
end)

local createSuperGunWarning = LPH_NO_VIRTUALIZE(function(data)
	data["drawings"]["super_gun_warning"] = utility.newDrawing("Text", {
		Size = 9,
		Font = small_font,
		Text = data["has_super_gun"] and "SG" or " ",
		Color = flags["player_esp_super_gun_warning_color"], 
		Transparency = -flags["player_esp_super_gun_warning_transparency"]+1,
		Outline = true,
		Center = false,
		Visible = not data["dont_render"]
	})
end)

local createHighlight = LPH_NO_VIRTUALIZE(function(data)
	data["highlight"] = newObject("Highlight", {
		Adornee = data["character"],
		Enabled = data["rendering"],
		FillColor = flags["player_esp_highlight_color"],
		FillTransparency = flags["player_esp_highlight_transparency"],
		OutlineColor = flags["player_esp_outline_color"],
		OutlineTransparency = flags["player_esp_outline_transparency"],
		Parent = cg
	})
end)

local createWeaponIcon = LPH_NO_VIRTUALIZE(function(data)
	data["drawings"]["weapon_icon"] = utility.newDrawing("Image", {
		["Color"] = flags["player_esp_weapon_icon_color"],
		["Transparency"] = -flags["player_esp_weapon_icon_transparency"]+1,
		["Data"] = data["weapon"] and images[data["weapon"]],
		["Visible"] = not data["dont_render"],
	})
end)

local createESP = LPH_NO_VIRTUALIZE(function(data)
	if do_box then
		createBox(data)
	end
	if do_fill then
		createFill(data, flags["player_esp_fill_gradient"])
	end
	if do_health_bar then
		createHealthBar(data, flags["player_esp_health_bar_gradient"])
	end
	if do_health_text then
		createHealthText(data, flags["do_dynamic_health_text_color"])
	end
	if do_tool then
		createTool(data)
	end
	if do_name then
		createName(data)
	end
	if do_weapon_icon then
		createWeaponIcon(data)
	end
	if do_super_gun_warning then
		createSuperGunWarning(data)
	end
	if do_armor_bar then
		createArmorBar(data, flags["player_esp_armor_bar_gradient"])
	end
	if flags["highlight"] then
		createHighlight(data)
	end
end)

local esp_flags = {
	["health_bar"] = "player_esp_health_bar_transparency",
	["health_bar_outline"] = "player_esp_health_bar_transparency",
	["box"] = "player_esp_box_transparency",
	["box_outline"] = "player_esp_box_transparency",
	["fill"] = "player_esp_fill_transparency",
	["name"] = "player_esp_name_transparency",
	["health_text"] = "player_esp_health_text_transparency",
	["tool"] = "player_esp_tool_transparency",
	["super_gun_warning"] = "player_esp_super_gun_warning_transparency",
	["armor_bar"] = "player_esp_armor_bar_transparency",
	["armor_bar_outline"] = "player_esp_armor_bar_transparency",
	["weapon_icon"] = "player_esp_weapon_icon_transparency",
}

local tweenESP = LPH_NO_VIRTUALIZE(function(data, showing)
	local direction = Enum.EasingDirection.In
	local style = Enum.EasingStyle.Quad
	local drawings = data["drawings"]
	local highlight = data["highlight"]

	local elapsed_time = 0
	if showing then
		for _, drawing in drawings do
			drawing["Transparency"] = 0
		end
	end
	local connection = utility.newConnection(rs.Heartbeat, function(dt)
		elapsed_time+=dt
		local value = getValue(tws, (elapsed_time / 0.75), style, direction)
		if highlight then
			highlight["FillTransparency"]+=((showing and (flags["player_esp_highlight_transparency"]) or 1)-highlight["FillTransparency"])*value
			highlight["OutlineTransparency"]+=((showing and (flags["player_esp_outline_transparency"]) or 1)-highlight["OutlineTransparency"])*value
		end
		for name, drawing in drawings do
			drawing["Transparency"]+=((showing and -(flags[esp_flags[name]])+1 or 0)-drawing["Transparency"])*value
		end
	end)
	delay(0.75, function()
		if connection then
			connection:Disconnect()
		end
	end)
end)

local tweenProperty = LPH_NO_VIRTUALIZE(function(data, property, value)
	if data["dont_render"] or abs(data[property]-value) <= 1 then 
		data[property] = value
		return 
	end

	local name = "tween"..property
	local tween = data[name]

	if tween then
		tween[1]:Disconnect()
		data[tween[2]] = tween[3]
		wait()
	end

	local direction = Enum.EasingDirection.Out
	local style = Enum.EasingStyle.Circular

	local elapsed_time = 0
	local old = data[property]
	local connection = utility.newConnection(rs.Heartbeat, function(dt)
		if not data then return end
		elapsed_time+=dt
		data[property] = old+(value-old)*getValue(tws, (elapsed_time / 0.15), style, direction)
	end)
	data[name] = {connection, property, value}
	delay(0.15, function()
		data["tween"] = nil
		if connection then
			connection:Disconnect()
		end
	end)
end)

--[[
  _             _  _        _        
 | |           | || |      | |       
 | |__   _   _ | || |  ___ | |_  ___ 
 | '_ \ | | | || || | / _ \| __|/ __|
 | |_) || |_| || || ||  __/| |_ \__ \
 |_.__/  \__,_||_||_| \___| \__||___/                          
]]

do
	local get_attribute = lplr["GetAttribute"]
	local lplr_name = lplr["Name"]

	utility.newConnection(ignored_folder.Siren.Radius.ChildAdded, LPH_NO_VIRTUALIZE(function(object)
		wait()
		if object.Name == "BULLET_RAYS" then
			local bullet_beam = findfirstchildofclass(object, "Beam")
			if bullet_beam then
				local position = object.Position
				local cframe_pos = bullet_beam.Attachment1.WorldCFrame
				if get_attribute(object, "OwnerCharacter") == lplr_name then
					newLocalPlayerBullet:Fire(object, bullet_beam, true, cframe_pos)
				else
					newPlayerBullet:Fire(object, bullet_beam, false, cframe_pos)
				end
			end
		end
	end), true)
end

--[[
	     _               _  _  _                   _         
        (_)             | || || |                 | |        
  _   _  _    ___  __ _ | || || |__    __ _   ___ | | __ ___ 
 | | | || |  / __|/ _` || || || '_ \  / _` | / __|| |/ // __|
 | |_| || | | (__| (_| || || || |_) || (_| || (__ |   < \__ \
  \__,_||_|  \___|\__,_||_||_||_.__/  \__,_| \___||_|\_\|___/
                                                                                                                
]]

utility.newConnection(menu_references["player_esp"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
	if find(heartbeat_callbacks, renderESP) then
		remove(heartbeat_callbacks, renderESP)
	end
	if bool then
		for player, data in player_data do
			spawn(createESP, data)
		end
		insert(heartbeat_callbacks, renderESP)
	else
		delay(0, function()
			for player, data in player_data do
				local drawings = data["drawings"]
				for _, drawing in drawings do
					drawing:Destroy()
					drawings[_] = nil
				end
				if data["highlight"] then
					data["highlight"]["Adornee"] = nil
					destroy(data["highlight"])
				end
			end
		end)
	end
end))

utility.newConnection(menu_references["player_esp_box"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
	if do_box and not bool then
		delay(0, function()
			for player, data in player_data do
				local drawings = data["drawings"]
				local box, box_outline = drawings["box"], drawings["box_outline"]
				if box then
					box:Destroy()
					drawings["box"] = nil
				end
				if box_outline then
					box_outline:Destroy()
					drawings["box_outline"] = nil
				end
			end
		end)
	elseif bool then
		for player, data in player_data do
			spawn(createBox, data)
		end
	end
	do_box = bool
end))

utility.newConnection(menu_references["player_esp_box"].onColorChange, LPH_NO_VIRTUALIZE(function(color, transparency)
	if not do_box then
		return end
		
	local transparency = -transparency+1
	for player, data in player_data do
		local drawings = data["drawings"]
		local box, box_outline = drawings["box"], drawings["box_outline"]
		box["Color"] = color
		box["Transparency"] = transparency
		box_outline["Transparency"] = transparency
	end
end))

utility.newConnection(menu_references["player_esp_fill"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
	if do_fill and not bool then
		delay(0, function()
			for player, data in player_data do
				local drawings = data["drawings"]
				local fill = drawings["fill"]
				if fill then
					fill:Destroy()
					drawings["fill"] = nil
				end
			end
		end)
	elseif bool then
		for player, data in player_data do
			spawn(createFill, data, flags["player_esp_fill_gradient"])
		end
	end
	do_fill = bool
	menu_references["player_esp_fill_gradient"]:setVisible(bool)
end))
menu_references["player_esp_fill_gradient"]:setVisible(false, true)

utility.newConnection(menu_references["player_esp_fill_gradient"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
	for player, data in player_data do
		local drawings = data["drawings"]
		local fill = drawings["fill"]
		if fill then
			fill:Destroy()
			drawings["fill"] = nil
			spawn(createFill, data, bool)
		end
	end
end))

utility.newConnection(menu_references["player_esp_fill"].onColorChange, LPH_NO_VIRTUALIZE(function(color, transparency)
	if not do_fill then
		return end
		
	local transparency = -transparency+1
	for player, data in player_data do
		local fill = data["drawings"]["fill"]
		fill["Color"] = color
		fill["Transparency"] = transparency
	end
end))

utility.newConnection(menu_references["player_esp_health_bar"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
	if do_health_bar and not bool then
		delay(0, function()
			for player, data in player_data do
				local drawings = data["drawings"]
				local health_bar = drawings["health_bar"]
				if health_bar then
					health_bar:Destroy()
					drawings["health_bar"] = nil
				end
				local health_bar_outline = drawings["health_bar_outline"]
				if health_bar_outline then
					health_bar_outline:Destroy()
					drawings["health_bar_outline"] = nil
				end
			end
		end)
	elseif bool then
		for player, data in player_data do
			spawn(createHealthBar, data, flags["player_esp_health_bar_gradient"])
		end
	end
	do_health_bar = bool
	menu_references["player_esp_health_bar_gradient"]:setVisible(bool)
	menu_references["player_esp_health_bar_dynamic"]:setVisible(bool)
	menu_references["player_esp_health_text_follow_health_bar"]:setVisible(bool and flags["player_esp_health_text"])
end))

utility.newConnection(menu_references["player_esp_health_bar"].onColorChange, LPH_NO_VIRTUALIZE(function(color, transparency)
	if not do_health_bar then
		return end
		
	local transparency = -transparency+1
	for player, data in player_data do
		local health_bar = data["drawings"]["health_bar"]
		health_bar["Color"] = do_dynamic_health_color and flags["player_esp_health_bar_dynamic_color"]:Lerp(color, data["health"]/data["max_health"]) or color
		health_bar["Transparency"] = transparency
	end
end))

utility.newConnection(menu_references["player_esp_health_bar_dynamic"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
	do_dynamic_health_color = bool
	if not do_health_bar then
		return end
		
	for player, data in player_data do
		local health_bar = data["drawings"]["health_bar"]
		health_bar["Color"] = bool and flags["player_esp_health_bar_dynamic_color"]:Lerp(flags["player_esp_health_bar_color"], data["health"]/data["max_health"]) or flags["player_esp_health_bar_color"]
	end
end))

utility.newConnection(menu_references["player_esp_health_bar_gradient"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
	for player, data in player_data do
		local drawings = data["drawings"]
		local health_bar = drawings["health_bar"]
		local health_bar_outline = drawings["health_bar_outline"]
		if health_bar_outline then
			health_bar_outline:Destroy()
			drawings["health_bar_outline"] = nil
		end
		if health_bar then
			health_bar:Destroy()
			drawings["health_bar"] = nil
			spawn(createHealthBar, data, bool)
		end
	end
end))

menu_references["player_esp_health_bar_gradient"]:setVisible(false)
menu_references["player_esp_health_bar_dynamic"]:setVisible(false)

utility.newConnection(menu_references["player_esp_name"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
	if do_name and not bool then
		delay(0, function()
			for player, data in player_data do
				local drawings = data["drawings"]
				local name = drawings["name"]
				if name then
					name:Destroy()
					drawings["name"] = nil
				end
			end
		end)
	elseif bool then
		for player, data in player_data do
			spawn(createName, data)
		end
	end
	do_name = bool
	menu_references["player_esp_name"]:setDropdownVisibility(bool)
end))
menu_references["player_esp_name"]:setDropdownVisibility(false)

utility.newConnection(menu_references["player_esp_name"].onDropdownChange, LPH_JIT_MAX(function(selected)
	local selected = selected[1]
	local is_username = selected == "Username"
	if do_name then
		for player, data in player_data do
			local drawings = data["drawings"]
			local name = drawings["name"]
			if name then
				name["Text"] = is_username and data["name"] or data["instance"]["DisplayName"]
			end
		end
	end
end))

utility.newConnection(menu_references["player_esp_name"].onColorChange, LPH_NO_VIRTUALIZE(function(color, transparency)
	local transparency = -transparency+1
	for player, data in player_data do
		local name = data["drawings"]["name"]
		if name then
			name["Color"] = color
			name["Transparency"] = transparency
		end
	end
end))

utility.newConnection(menu_references["player_esp_health_text"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
	if do_health_text and not bool then
		delay(0, function()
			for player, data in player_data do
				local drawings = data["drawings"]
				local health_text = drawings["health_text"]
				if health_text then
					health_text:Destroy()
					drawings["health_text"] = nil
				end
			end
		end)
	elseif bool then
		for player, data in player_data do
			spawn(createHealthText, data, flags["player_esp_health_text_dynamic_color"])
		end
	end
	menu_references["player_esp_health_text_follow_health_bar"]:setVisible(bool and flags["player_esp_health_bar"])
	menu_references["player_esp_health_text_dynamic"]:setVisible(bool)
	menu_references["player_esp_minimum_health_visibility"]:setVisible(bool)
	do_health_text = bool
end))
menu_references["player_esp_minimum_health_visibility"]:setVisible(false)

utility.newConnection(menu_references["player_esp_minimum_health_visibility"].onSliderChange, function(value)
	minimum_health_visibility = value
end)

utility.newConnection(menu_references["player_esp_health_text"].onColorChange, LPH_NO_VIRTUALIZE(function(color, transparency)
	local transparency = -transparency+1
	for player, data in player_data do
		local health_text = data["drawings"]["health_text"]
		if health_text then
			health_text["Color"] = flags["player_esp_health_text_dynamic"] and flags["player_esp_health_text_dynamic_color"]:Lerp(flags["player_esp_health_text_color"], data["health"]/data["max_health"]) or color
			health_text["Transparency"] = transparency
		end
	end
end))

utility.newConnection(menu_references["player_esp_health_text_dynamic"].onColorChange, LPH_NO_VIRTUALIZE(function(color, transparency)
	if not flags["player_esp_health_text_dynamic"] then
		return end

	local transparency = -transparency+1
	for player, data in player_data do
		local health_text = data["drawings"]["health_text"]
		if health_text then
			health_text["Color"] = flags["player_esp_health_text_dynamic_color"]:Lerp(flags["player_esp_health_text_color"], data["health"]/data["max_health"])
			health_text["Transparency"] = transparency
		end
	end
end))

utility.newConnection(menu_references["player_esp_health_text_follow_health_bar"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
	follow_health_bar = bool
end))

utility.newConnection(menu_references["player_esp_health_text_dynamic"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
	for player, data in player_data do
		local drawings = data["drawings"]
		local health_text = drawings["health_text"]
		if health_text then
			health_text:Destroy()
			drawings["health_text"] = nil
			spawn(createHealthText, data, bool)
		end
	end
	do_dynamic_health_text_color = bool
end))
menu_references["player_esp_health_text_follow_health_bar"]:setVisible(false)
menu_references["player_esp_health_text_dynamic"]:setVisible(false)

utility.newConnection(menu_references["player_esp_tool"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
	if do_tool and not bool then
		for player, data in player_data do
			delay(0, function()
				local drawings = data["drawings"]
				local tool = drawings["tool"]
				if tool then
					tool:Destroy()
					drawings["tool"] = nil
				end
			end)
		end
	elseif bool then
		for player, data in player_data do
			spawn(createTool, data)
		end
	end
	do_tool = bool
end))

utility.newConnection(menu_references["player_esp_super_gun_warning"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
	if do_super_gun_warning and not bool then
		delay(0, function()
			for player, data in player_data do
				local drawings = data["drawings"]
				local super_gun_warning = drawings["super_gun_warning"]
				if super_gun_warning then
					super_gun_warning:Destroy()
					drawings["super_gun_warning"] = nil
				end
			end
		end)
	elseif bool then
		for player, data in player_data do
			spawn(createSuperGunWarning, data)
		end
	end
	do_super_gun_warning = bool
end))

utility.newConnection(menu_references["player_esp_super_gun_warning"].onColorChange, LPH_NO_VIRTUALIZE(function(color, transparency)
	local transparency = -transparency+1
	for player, data in player_data do
		local super_gun_warning = data["drawings"]["super_gun_warning"]
		if super_gun_warning then
			super_gun_warning["Color"] = color
			super_gun_warning["Transparency"] = transparency
		end
	end
end))

utility.newConnection(menu_references["player_esp_highlight"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
	menu_references["player_esp_outline"]:setVisible(bool)

	if not flags["player_esp"] then 
		return end

	if not bool then
		for player, data in player_data do
			local highlight = data["highlight"]
			if highlight then
				highlight["Adornee"] = nil
				destroy(highlight)
			end
		end
	elseif bool then
		for player, data in player_data do
			spawn(createHighlight, data)
		end
	end
end))

utility.newConnection(menu_references["player_esp_highlight"].onColorChange, LPH_NO_VIRTUALIZE(function(color, transparency)
	for player, data in player_data do
		local highlight = data["highlight"]
		if highlight then
			highlight["FillColor"] = color
			highlight["FillTransparency"] = transparency
		end
	end
end))

utility.newConnection(menu_references["player_esp_outline"].onColorChange, LPH_NO_VIRTUALIZE(function(color, transparency)
	for player, data in player_data do
		local highlight = data["highlight"]
		if highlight then
			highlight["OutlineColor"] = color
			highlight["OutlineTransparency"] = transparency
		end
	end
end))
menu_references["player_esp_outline"]:setVisible(false)

utility.newConnection(menu_references["player_esp_armor_bar"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
	if do_armor_bar and not bool then
		delay(0, function()
			for player, data in player_data do
				local drawings = data["drawings"]
				local armor_bar = drawings["armor_bar"]
				if armor_bar then
					armor_bar:Destroy()
					drawings["armor_bar"] = nil
				end
				local armor_bar_outline = drawings["armor_bar_outline"]
				if armor_bar_outline then
					armor_bar_outline:Destroy()
					drawings["armor_bar_outline"] = nil
				end
			end
		end)
	elseif bool then
		for player, data in player_data do
			spawn(createArmorBar, data, flags["player_esp_armor_bar_gradient"])
		end
	end
	do_armor_bar = bool
	menu_references["player_esp_armor_bar_gradient"]:setVisible(bool)
	menu_references["player_esp_armor_bar_dynamic"]:setVisible(bool)
end))

utility.newConnection(menu_references["player_esp_armor_bar"].onColorChange, LPH_NO_VIRTUALIZE(function(color, transparency)
	if not do_armor_bar then
		return end
		
	local transparency = -transparency+1
	for player, data in player_data do
		local armor_bar = data["drawings"]["armor_bar"]
		armor_bar["Color"] = do_dynamic_armor_color and flags["player_esp_armor_bar_dynamic_color"]:Lerp(color, data["armor"]/130) or color
		armor_bar["Transparency"] = transparency
	end
end))

utility.newConnection(menu_references["player_esp_armor_bar_dynamic"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
	do_dynamic_armor_color = bool
	if not do_armor_bar then
		return end
		
	for player, data in player_data do
		local armor_bar = data["drawings"]["armor_bar"]
		armor_bar["Color"] = bool and flags["player_esp_armor_bar_dynamic_color"]:Lerp(flags["player_esp_armor_bar_color"], data["armor"]/130) or flags["player_esp_armor_bar_color"]
	end
end))

utility.newConnection(menu_references["player_esp_armor_bar_dynamic"].onColorChange, LPH_NO_VIRTUALIZE(function(color)
	if not do_armor_bar then
		return end
		
	for player, data in player_data do
		local armor_bar = data["drawings"]["armor_bar"]
		armor_bar["Color"] =flags["player_esp_armor_bar_dynamic_color"]:Lerp(flags["player_esp_armor_bar_color"], data["armor"]/130)
	end
end))

utility.newConnection(menu_references["player_esp_armor_bar_gradient"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
	for player, data in player_data do
		local drawings = data["drawings"]
		local armor_bar = drawings["armor_bar"]
		local armor_bar_outline = drawings["armor_bar_outline"]
		if armor_bar_outline then
			armor_bar_outline:Destroy()
			drawings["armor_bar_outline"] = nil
		end
		if armor_bar then
			armor_bar:Destroy()
			drawings["armor_bar"] = nil
			spawn(createArmorBar, data, bool)
		end
	end
end))
menu_references["player_esp_armor_bar_gradient"]:setVisible(false)
menu_references["player_esp_armor_bar_dynamic"]:setVisible(false)

utility.newConnection(menu_references["player_esp_weapon_icon"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
	if do_weapon_icon and not bool then
		delay(0, function()
			for player, data in player_data do
				local drawings = data["drawings"]
				local weapon_icon = drawings["weapon_icon"]
				if weapon_icon then
					weapon_icon:Destroy()
					drawings["weapon_icon"] = nil
				end
			end
		end)
	elseif bool then
		for player, data in player_data do
			spawn(createWeaponIcon, data)
		end
	end
	do_weapon_icon = bool
end))

utility.newConnection(menu_references["player_esp_weapon_icon"].onColorChange, LPH_NO_VIRTUALIZE(function(color, transparency)
	local transparency = -transparency+1
	for player, data in player_data do
		local weapon_icon = data["drawings"]["weapon_icon"]
		if weapon_icon then
			weapon_icon["Color"] = color
			weapon_icon["Transparency"] = transparency
		end
	end
end))

utility.newConnection(menu_references["player_esp_name_font"].onDropdownChange, LPH_NO_VIRTUALIZE(function(selected)
	local selected = selected[1]
	normal_font = selected == "Bold" and 2 or selected == "Minecraft" and 4 or selected == "Small" and 3 or 5

	for player, data in player_data do
		local drawings = data["drawings"]
		local name = drawings["name"]
		if name then
			name["Font"] = normal_font
		end
	end
end))

utility.newConnection(menu_references["player_esp_small_font"].onDropdownChange, LPH_NO_VIRTUALIZE(function(selected)
	local selected = selected[1]
	small_font = selected == "Bold" and 2 or selected == "Minecraft" and 4 or selected == "Small" and 3 or 5

	for player, data in player_data do
		local drawings = data["drawings"]
		local health_text = drawings["health_text"]
		local super_gun_warning = drawings["super_gun_warning"]
		local tool = drawings["tool"]

		if tool then
			tool["Font"] = small_font
		end
		if health_text then
			health_text["Font"] = small_font
		end
		if super_gun_warning then
			super_gun_warning["Font"] = small_font
		end
		if tool then
			tool["Font"] = small_font
		end
	end
end))
utility.newConnection(menu_references["fog_changer"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
	lighting["FogColor"] = bool and flags["fog_changer_color"] or spoof_properties[lighting]["FogColor"]
	lighting["FogStart"] = bool and flags["fog_changer_start"] or spoof_properties[lighting]["FogStart"]
	lighting["FogEnd"] = bool and flags["fog_changer_end"] or spoof_properties[lighting]["FogEnd"]

	menu_references["fog_changer_start"]:setVisible(bool)
	menu_references["fog_changer_end"]:setVisible(bool)
end))
menu_references["fog_changer_start"]:setVisible(false)
menu_references["fog_changer_end"]:setVisible(false)

utility.newConnection(menu_references["fog_changer"].onColorChange, LPH_NO_VIRTUALIZE(function(color, transparency)
	if not flags["fog_changer"] then
		return end

	lighting["FogColor"] = color
end))

utility.newConnection(menu_references["fog_changer_start"].onSliderChange, LPH_NO_VIRTUALIZE(function(value)
	if not flags["fog_changer"] then
		return end

	lighting["FogStart"] = value
end))

utility.newConnection(menu_references["fog_changer_end"].onSliderChange, LPH_NO_VIRTUALIZE(function(value)
	if not flags["fog_changer"] then
		return end

	lighting["FogEnd"] = value
end))

utility.newConnection(menu_references["time_changer"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
	lighting["ClockTime"] = bool and flags["time_changer_value"] or spoof_properties[lighting]["ClockTime"]
	menu_references["time_changer"]:setSliderVisibility(bool)
end))
menu_references["time_changer"]:setSliderVisibility(false)

utility.newConnection(menu_references["time_changer"].onSliderChange, LPH_NO_VIRTUALIZE(function(value)
	if not flags["time_changer"] then
		return end

	lighting["ClockTime"] = value
end))

utility.newConnection(menu_references["ambient_changer"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
	lighting["Ambient"] = bool and flags["ambient_changer_color"] or spoof_properties[lighting]["Ambient"]
end))

utility.newConnection(menu_references["ambient_changer"].onColorChange, LPH_NO_VIRTUALIZE(function(color)
	if not flags["ambient_changer"] then
		return end

	lighting["Ambient"] = color
end))

utility.newConnection(menu_references["exposure_changer"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
	lighting["ExposureCompensation"] = bool and flags["exposure_changer_value"] or spoof_properties[lighting]["ExposureCompensation"]
	menu_references["exposure_changer"]:setSliderVisibility(bool)
end))
menu_references["exposure_changer"]:setSliderVisibility(false)

utility.newConnection(menu_references["exposure_changer"].onSliderChange, LPH_NO_VIRTUALIZE(function(value)
	if not flags["exposure_changer"] then
		return end

	lighting["ExposureCompensation"] = value
end))

utility.newConnection(menu_references["brightness_changer"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
	lighting["Brightness"] = bool and flags["brightness_changer_value"] or spoof_properties[lighting]["Brightness"]
	menu_references["brightness_changer"]:setSliderVisibility(bool)
end))
menu_references["brightness_changer"]:setSliderVisibility(false)

utility.newConnection(menu_references["brightness_changer"].onSliderChange, LPH_NO_VIRTUALIZE(function(value)
	if not flags["brightness_changer"] then
		return end

	lighting["Brightness"] = value
end))

utility.newConnection(menu_references["saturation_changer"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
	color_correction["Saturation"] = bool and flags["saturation_changer_value"] or spoof_properties[color_correction]["Saturation"]
	menu_references["saturation_changer"]:setSliderVisibility(bool)
end))
menu_references["saturation_changer"]:setSliderVisibility(false)

utility.newConnection(menu_references["saturation_changer"].onSliderChange, LPH_NO_VIRTUALIZE(function(value)
	if not flags["saturation_changer"] then
		return end

	color_correction["Saturation"] = value
end))

utility.newConnection(menu_references["resolver"].onToggleChange, function(bool)
	menu_references["refresh_rate"]:setVisible(bool)
	menu_references["network_resolver"]:setVisible(bool)
	menu_references["random_teleport_resolver_keybind"]:setVisible(bool)
end)
menu_references["refresh_rate"]:setVisible(false)
menu_references["network_resolver"]:setVisible(false)
menu_references["random_teleport_resolver_keybind"]:setVisible(false)

do
	local skyboxes = {
		["Jungle"] = {
			["SkyboxBk"] = "http://www.roblox.com/asset/?id=214399891",
			["SkyboxDn"] = "http://www.roblox.com/asset/?id=214399887",
			["SkyboxFt"] = "http://www.roblox.com/asset/?id=214399894",
			["SkyboxLf"] = "http://www.roblox.com/asset/?id=214405668",
			["SkyboxRt"] = "http://www.roblox.com/asset/?id=214399899",
			["SkyboxUp"] = "http://www.roblox.com/asset/?id=214399889"
		},
		["Blossom"] = {
			["SkyboxBk"] = "http://www.roblox.com/asset/?id=271042516",
			["SkyboxDn"] = "http://www.roblox.com/asset/?id=271077243",
			["SkyboxFt"] = "http://www.roblox.com/asset/?id=271042556",
			["SkyboxLf"] = "http://www.roblox.com/asset/?id=271042310",
			["SkyboxRt"] = "http://www.roblox.com/asset/?id=271042467",
			["SkyboxUp"] = "http://www.roblox.com/asset/?id=271077958"
		},
		["Red night"] = {
			["SkyboxBk"] = "http://www.roblox.com/Asset/?ID=401664839",
			["SkyboxDn"] = "http://www.roblox.com/Asset/?ID=401664862",
			["SkyboxFt"] = "http://www.roblox.com/Asset/?ID=401664960",
			["SkyboxLf"] = "http://www.roblox.com/Asset/?ID=401664881",
			["SkyboxRt"] = "http://www.roblox.com/Asset/?ID=401664901",
			["SkyboxUp"] = "http://www.roblox.com/Asset/?ID=401664936"
		},
		["Purple default"] = {
			["SkyboxBk"] = "http://www.roblox.com/asset/?id=13694952867",
			["SkyboxDn"] = "http://www.roblox.com/asset/?id=13694968325",
			["SkyboxFt"] = "http://www.roblox.com/asset/?id=13694980654",
			["SkyboxLf"] = "http://www.roblox.com/asset/?id=13694998113",
			["SkyboxRt"] = "http://www.roblox.com/asset/?id=13695002700",
			["SkyboxUp"] = "http://www.roblox.com/asset/?id=13695007103"
		},
		["Foggy"] = {
			["SkyboxBk"] = "rbxassetid://1370717244",
			["SkyboxDn"] = "rbxassetid://1370717336",
			["SkyboxFt"] = "rbxassetid://1370717438",
			["SkyboxLf"] = "rbxassetid://1370717567",
			["SkyboxRt"] = "rbxassetid://1370717698",
			["SkyboxUp"] = "rbxassetid://1370717782"
		},
		["Custom"] = {
			["SkyboxBk"] = "",
			["SkyboxDn"] = "",
			["SkyboxFt"] = "",
			["SkyboxLf"] = "",
			["SkyboxRt"] = "",
			["SkyboxUp"] = ""
		}
	}

	utility.newConnection(menu_references["skybox_changer"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
		if not bool then
			local property = spoof_properties[sky]
			sky["SkyboxBk"] = property["SkyboxBk"]
			sky["SkyboxDn"] = property["SkyboxDn"]
			sky["SkyboxFt"] = property["SkyboxFt"]
			sky["SkyboxLf"] = property["SkyboxLf"]
			sky["SkyboxRt"] = property["SkyboxRt"]
			sky["SkyboxUp"] = property["SkyboxUp"]
		else
			local skybox = skyboxes[flags["skybox_changer_value"][1]]
			
			sky["SkyboxBk"] = skybox["SkyboxBk"]
			sky["SkyboxDn"] = skybox["SkyboxDn"]
			sky["SkyboxFt"] = skybox["SkyboxFt"]
			sky["SkyboxLf"] = skybox["SkyboxLf"]
			sky["SkyboxRt"] = skybox["SkyboxRt"]
			sky["SkyboxUp"] = skybox["SkyboxUp"]
		end
		local is_custom = flags["skybox_changer_value"][1] == "Custom" and bool
		menu_references["SkyboxBk"]:setVisible(is_custom)
		menu_references["SkyboxDn"]:setVisible(is_custom)
		menu_references["SkyboxFt"]:setVisible(is_custom)
		menu_references["SkyboxLf"]:setVisible(is_custom)
		menu_references["SkyboxRt"]:setVisible(is_custom)
		menu_references["SkyboxUp"]:setVisible(is_custom)
		menu_references["skybox_changer"]:setDropdownVisibility(bool)
	end))
	menu_references["skybox_changer"]:setDropdownVisibility(false)

	utility.newConnection(menu_references["skybox_changer"].onDropdownChange, LPH_NO_VIRTUALIZE(function(selected)
		if not flags["skybox_changer"] then
			return end

		local flag = selected[1]
		local is_custom = flag == "Custom"

		menu_references["SkyboxBk"]:setVisible(is_custom)
		menu_references["SkyboxDn"]:setVisible(is_custom)
		menu_references["SkyboxFt"]:setVisible(is_custom)
		menu_references["SkyboxLf"]:setVisible(is_custom)
		menu_references["SkyboxRt"]:setVisible(is_custom)
		menu_references["SkyboxUp"]:setVisible(is_custom)

		local skybox = skyboxes[flag]
		sky["SkyboxBk"] = skybox["SkyboxBk"]
		sky["SkyboxDn"] = skybox["SkyboxDn"]
		sky["SkyboxFt"] = skybox["SkyboxFt"]
		sky["SkyboxLf"] = skybox["SkyboxLf"]
		sky["SkyboxRt"] = skybox["SkyboxRt"]
		sky["SkyboxUp"] = skybox["SkyboxUp"]
	end))

	for name, property in skyboxes do
		for property, _ in property do
			local ref = menu_references[property]
			ref:setVisible(false)
			utility.newConnection(ref.onTextChange, function(text)
				skyboxes["Custom"][property] = text

				if flags["skybox_changer_value"][1] == "Custom" then
					sky[property] = text
				end
			end)
		end
	end
end

do
	local atmosphere = nil

	utility.newConnection(menu_references["atmosphere_changer"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
		menu_references["atmosphere_color"]:setVisible(bool)
		menu_references["atmosphere_decay"]:setVisible(bool)
		menu_references["atmosphere_density"]:setVisible(bool)
		menu_references["atmosphere_glare"]:setVisible(bool)
		menu_references["atmosphere_haze"]:setVisible(bool)
		if bool then
			atmosphere = newObject("Atmosphere", {
				Color = flags["atmosphere_color"],
				Haze = flags["atmosphere_haze"],
				Decay = flags["atmosphere_decay"],
				Glare = flags["atmosphere_glare"],
				Density = flags["atmosphere_density"],
				Parent = lighting
			})
		elseif atmosphere then
			destroy(atmosphere)
		end
	end))

	local updateAtmosphere = LPH_NO_VIRTUALIZE(function()
		if not atmosphere then
			return end

		atmosphere["Color"] = flags["atmosphere_color"]
		atmosphere["Haze"] = flags["atmosphere_haze"]
		atmosphere["Decay"] = flags["atmosphere_decay"]
		atmosphere["Glare"]= flags["atmosphere_glare"]
		atmosphere["Density"] = flags["atmosphere_density"]
	end)

	utility.newConnection(menu_references["atmosphere_color"].onColorChange, updateAtmosphere)
	utility.newConnection(menu_references["atmosphere_decay"].onColorChange, updateAtmosphere)
	utility.newConnection(menu_references["atmosphere_density"].onSliderChange, updateAtmosphere)
	utility.newConnection(menu_references["atmosphere_glare"].onSliderChange, updateAtmosphere)
	utility.newConnection(menu_references["atmosphere_haze"].onSliderChange, updateAtmosphere)
	
	menu_references["atmosphere_color"]:setVisible(false)
	menu_references["atmosphere_decay"]:setVisible(false)
	menu_references["atmosphere_density"]:setVisible(false)
	menu_references["atmosphere_glare"]:setVisible(false)
	menu_references["atmosphere_haze"]:setVisible(false)
end

utility.newConnection(menu_references["suppress_flashbang_effect"].onToggleChange, LPH_JIT_MAX(function(bool)
	local do_full = flags["suppress_flashbang_effect_value"][1] == "Full" and bool
	
	if not is_solara then
		for _,v in getconnections(event.OnClientEvent) do
			for _, c in debug.getconstants(v.Function) do
				if c == "FLASHBANG" or c == "JUJU" then
					debug.setconstant(v.Function, _, do_full and "JUJU" or "FLASHBANG")
					break
				end
			end
		end
	end

	local connection = lplr_data["flashbang_connection"]
	if connection then
		connection:Disconnect()
		lplr_data["flashbang_connection"] = nil
	end

	if bool and lplr_data["main_screen_gui"] and not do_full then
		lplr_data["flashbang_connection"] = utility.newConnection(lplr_data["main_screen_gui"].ChildAdded, function(flash)
			if flash.Name == "whiteScreen" then
				wait()
				destroy(flash)
			end
		end)
	end
	menu_references["suppress_flashbang_effect"]:setDropdownVisibility(bool)
end))
menu_references["suppress_flashbang_effect"]:setDropdownVisibility(false)

utility.newConnection(menu_references["suppress_flashbang_effect"].onDropdownChange, LPH_JIT_MAX(function(selected)
	if not flags["suppress_flashbang_effect"] then
		return end

	local do_full = selected[1] == "Full"

	if not is_solara then
		for _,v in getconnections(event.OnClientEvent) do
			for _, c in debug.getconstants(v.Function) do
				if c == "FLASHBANG" or c == "JUJU" then
					debug.setconstant(v.Function, _, do_full and "JUJU" or "FLASHBANG")
					break
				end
			end
		end
	end

	local connection = lplr_data["flashbang_connection"]
	if connection then
		connection:Disconnect()
		lplr_data["flashbang_connection"] = nil
	end

	if lplr_data["main_screen_gui"] and not do_full then
		lplr_data["flashbang_connection"] = utility.newConnection(lplr_data["main_screen_gui"].ChildAdded, function(flash)
			if flash.Name == "whiteScreen" then
				wait()
				destroy(flash)
			end
		end)
	end
end))

utility.newConnection(menu_references["unlock_max_zoom_distance"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
	lplr.CameraMaxZoomDistance = bool and 9e9 or spoof_skip["CameraMaxZoomDistance"]
end))

do
	local custom_stat_bar_connection = nil
	local updateCustomStatsBars = LPH_JIT_MAX(function(selected)
		local main_screen_gui = lplr_data["main_screen_gui"]

		local bar = main_screen_gui.Bar

		local enabled = flags["custom_stat_bars"]

		local selected = selected or flags["custom_stat_bars_value"][1]

		bar.HP.bar.BackgroundColor3 = enabled and flags["health_bar_color"] or colorfromrgb(36, 182, 3)
		bar.HP.bar.BackgroundTransparency = enabled and flags["health_bar_transparency"] or 0
		bar.Energy.bar.BackgroundColor3 = enabled and flags["energy_bar_color"] or colorfromrgb(182, 182, 9)
		bar.Energy.bar.BackgroundTransparency = enabled and flags["energy_bar_transparency"] or 0
		bar.Armor.bar.BackgroundColor3 = enabled and flags["armor_bar_color"] or colorfromrgb(0, 136, 194)
		bar.Armor.bar.BackgroundTransparency = enabled and flags["armor_bar_transparency"] or 0.3 
		bar.Armor.firebar.BackgroundColor3 = enabled and flags["fire_armor_bar_color"] or colorfromrgb(253, 121, 33)
		bar.Armor.firebar.BackgroundTransparency = enabled and flags["fire_armor_bar_transparency"] or 0
		bar.CarHP.BarContainer.Bar.BackgroundColor3 = enabled and flags["car_hp_bar_color"] or colorfromrgb(253, 121, 33)
		bar.CarHP.BarContainer.Bar.BackgroundTransparency = enabled and flags["car_hp_bar_transparency"] or 0
		bar.CarHP.BarContainer.Position = enabled and udim2new(0.019, -3, 0.1, -2) or udim2new(0.019, -1, 0.1, 0)
		bar.CarHP.Position = enabled and udim2new(0.5, 0, 1, -125) or udim2new(0.5, 0, 1, -115)

		if selected == "Default" then
			local descendants = bar:GetDescendants()
			for i = 1, #descendants do
				local descendant = descendants[i]
				if #descendant.Name == 0 then
					destroy(descendant)
				end
			end

			for _, object in bar:GetChildren() do
				local text_label = object.TextLabel
				local bar = object["Name"] ~= "CarHP" and object.bar or bar.CarHP.BarContainer.Bar
				object.BackgroundColor3 = colorfromrgb(58,58,58)
				object.Picture.Visible = true
				object.BackgroundTransparency = 0
				bar.BackgroundTransparency = object.Name == "Armor" and 0.3 or 0
				bar.Image = "rbxassetid://131886135"
				bar.ImageColor3 = colorfromrgb(0,0,0)
				if object.Name == "Armor" then
					object.firebar.BackgroundTransparency = 0
					object.firebar.Image = "rbxassetid://131886135"
					object.firebar.Visible = true
				end
				text_label.TextXAlignment = object.Name == "Energy" and Enum.TextXAlignment.Right or object.Name == "Armor" and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center
				text_label.TextSize = 18
				text_label.Font = Enum.Font.SourceSansBold
				text_label.Text = string.upper(sub(object.TextLabel.Text, 1, 1))..sub(object.TextLabel.Text, 2, #object.TextLabel.Text)
				text_label.Visible = true
				text_label.TextStrokeTransparency = 0.25
				text_label.TextStrokeColor3 = colorfromrgb(0,0,0)
				text_label.Position = udim2new(0,0,0,0)

				bar.Position = udim2new(0.019, 1, 0.1, 0)
				bar.ResampleMode = Enum.ResamplerMode.Default
				bar.ScaleType = Enum.ScaleType.Stretch
			end
		elseif selected == "Flat" then
			for _, object in bar:GetChildren() do
				local text_label = object.TextLabel
				object.BackgroundColor3 = colorfromrgb(24,24,24)
				object.Picture.Visible = false
				object.BackgroundTransparency = 0
				text_label.TextXAlignment = Enum.TextXAlignment.Center
				text_label.TextSize = 18
				text_label.Font = Enum.Font.SourceSansBold
				text_label.Text = lower(text_label.Text)
			end
		elseif selected == "Gamesense" then
			for _, object in bar:GetChildren() do
				object.Picture.Visible = false
				local text_label = object.TextLabel
				text_label.Position = udim2new(0,0,0,2)
				text_label.TextXAlignment = Enum.TextXAlignment.Center
				text_label.TextSize = 12
				text_label.FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
				text_label.Text = lower(text_label.Text)


				local bar = object["Name"] ~= "CarHP" and object.bar or bar.CarHP.BarContainer.Bar
				bar.Position = udim2new(0.019, 0, 0.1, 0)
				bar.BackgroundTransparency = 1
				bar.Image = "http://www.roblox.com/asset/?id=15541064478"
				bar.ImageColor3 = bar.BackgroundColor3

				local firebar = findfirstchild(object, "firebar")
				if firebar then
					firebar.BackgroundTransparency = 1
					firebar.Image = "http://www.roblox.com/asset/?id=15541064478"
					firebar.ImageColor3 = firebar.BackgroundColor3
				end

				local frame_5 = newObject("Frame", {
					AnchorPoint = vector2new(0.5,0.5),
					BackgroundColor3 = Color3.new(0.0470588,0.0470588,0.0470588),
					BorderColor3 = Color3.new(0,0,0),
					BorderSizePixel = 0,
					Position = UDim2.new(0.5,-1,0.5,0),
					Size = UDim2.new(1,3,1,8),
					ZIndex = -4,
					Name = "\0",
					Parent = object
				})

				local frame_1 = newObject("Frame", {
					AnchorPoint = vector2new(0.5,0.5),
					BackgroundColor3 = Color3.new(0.235294,0.235294,0.235294),
					BorderColor3 = Color3.new(0,0,0),
					BorderSizePixel = 0,
					Position = UDim2.new(0.5,0,0.5,0),
					Size = UDim2.new(1,-2,1,-2),
					ZIndex = -4,
					Name = "\0",
					Parent = frame_5
				})
				local frame_2 = newObject("Frame", {
					AnchorPoint = vector2new(0.5,0.5),
					BackgroundColor3 = Color3.new(0.156863,0.156863,0.156863),
					BorderColor3 = Color3.new(0,0,0),
					BorderSizePixel = 0,
					Position = UDim2.new(0.5,0,0.5,0),
					Size = UDim2.new(1,-2,1,-2),
					ZIndex = -4,
					Name = "\0",
					Parent = frame_1
				})
				local frame_3 = newObject("Frame", {
					AnchorPoint = vector2new(0.5,0.5),
					BackgroundColor3 = Color3.new(0.235294,0.235294,0.235294),
					BorderColor3 = Color3.new(0,0,0),
					BorderSizePixel = 0,
					Position = UDim2.new(0.5,0,0.5,0),
					Size = UDim2.new(1,-6,1,-6),
					ZIndex = -4,
					Name = "\0",
					Parent = frame_2
				})
				local frame_4 = newObject("Frame", {
					AnchorPoint = vector2new(0.5,0.5),
					BackgroundColor3 = Color3.new(0.235294,0.235294,0.235294),
					BorderColor3 = Color3.new(0,0,0),
					BorderSizePixel = 0,
					Position = UDim2.new(0.5,0,0.5,0),
					Size = UDim2.new(1,-2,1,-2),
					ZIndex = -4,
					Name = "\0",
					Parent = frame_3
				})
				local image_1 = newObject("ImageLabel", {
					Image = [[rbxassetid://15453092054]],
					ScaleType = Enum.ScaleType.Tile,
					TileSize = UDim2.new(0,8,0,548),
					BackgroundColor3 = Color3.new(1,1,1),
					BorderColor3 = Color3.new(0,0,0),
					BorderSizePixel = 0,
					Size = UDim2.new(1,0,1,0),
					Name = "\0",
					Parent = frame_4
				})
				local image_2 = newObject("ImageLabel", {
					Image = [[rbxassetid://15453122383]],
					TileSize = UDim2.new(0,8,0,548),
					BackgroundColor3 = Color3.new(1,1,1),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.new(0,0,0),
					BorderSizePixel = 0,
					Size = UDim2.new(1,0,0,2),
					ZIndex = 2,
					Name = "\0",
					Parent = frame_4,
				})

			end	
		elseif selected == "Minimalistic" then
			for _, object in bar:GetChildren() do
				local bar = object["Name"] ~= "CarHP" and object.bar or bar.CarHP.BarContainer.Bar

				newObject("UICorner", {
					Parent = object
				})
				object.BackgroundColor3 = colorfromrgb(0,0,0)
				object.Picture.Visible = false
				newObject("UICorner", {
					Parent = bar,
					Name = "\0"
				})
				if object.Name == "Armor" then
					newObject("UICorner", {
						Parent = object.firebar,
						Name = "\0"
					})
					object.firebar.BackgroundTransparency = 0.5
				end
				bar.BackgroundTransparency = 0.5
				local text_label = object.TextLabel

				object.BackgroundTransparency = 0.5
				text_label.TextXAlignment = Enum.TextXAlignment.Center
				text_label.TextSize = 14
				text_label.Text = lower(text_label.Text)
				text_label.Font = Enum.Font.GothamBold
			end
		elseif selected == "Minecraft" then
			for _, object in bar:GetChildren() do
				local text_label = object.TextLabel
				local bar = object["Name"] ~= "CarHP" and object.bar or bar.CarHP.BarContainer.Bar

				object.BackgroundTransparency = 1
				bar.BackgroundTransparency = 1
				bar.Image = object.Name == "HP" and "rbxassetid://18400147703" or object.Name == "Energy" and "rbxassetid://18400228268" or object.Name == "Armor" and "rbxassetid://18400219869" or ""
				object.Picture.Visible = false
				bar.ResampleMode = Enum.ResamplerMode.Pixelated
				bar.ScaleType = Enum.ScaleType.Tile
				bar.TileSize = udim2new(0, 19, 0, 19)
				bar.ImageColor3 = colorfromrgb(255,255,255)
				if object.Name == "Armor" then
					object.firebar.Visible = false
				end
				text_label.Visible = false

				newObject("UIGradient", {
					Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(0.03, 0.00), NumberSequenceKeypoint.new(0.97, 0.00), NumberSequenceKeypoint.new(1.00, 1.00)},
					Name = "\0",
					Parent = bar
				})
			end	
		elseif selected == "Sanrio" then
			local font = Font.new("rbxasset://fonts/families/Kalam.json",Enum.FontWeight.Regular,Enum.FontStyle.Normal)
			for _, object in bar:GetChildren() do
				local text_label = object.TextLabel
				local bar = object["Name"] ~= "CarHP" and object.bar or bar.CarHP.BarContainer.Bar
				object.BackgroundColor3 = colorfromrgb(20,20,20)
				object.Picture.Visible = false

				text_label.TextXAlignment = Enum.TextXAlignment.Center
				text_label.TextSize = 24
				text_label.TextStrokeTransparency = 0
				text_label.TextStrokeColor3 = object.Name == "HP" and colorfromrgb(85,0,0) or object.Name == "Energy" and colorfromrgb(89, 89, 44) or object.Name == "Armor" and colorfromrgb(35, 129, 144) or colorfromrgb(0,0,0)
				text_label.FontFace = font

				if object.Name == "Armor" then
					object.firebar.Image = ""
					object.firebar.BackgroundColor3 = colorfromrgb(226, 255, 252)
				end
				bar.Image = ""

				object.BackgroundColor3 = object.Name == "HP" and colorfromrgb(255, 0, 4) or object.Name == "Energy" and colorfromrgb(255, 233, 110) or object.Name == "Armor" and colorfromrgb(0, 163, 212) or colorfromrgb(13,13,13)
				bar.BackgroundColor3 = object.Name == "HP" and colorfromrgb(255, 103, 106) or object.Name == "Energy" and colorfromrgb(249, 255, 139) or object.Name == "Armor" and colorfromrgb(128, 232, 255) or colorfromrgb(13,13,13)

				if object.Name == "Energy" then
					newObject("ImageLabel", {
						Image = "rbxassetid://18400491732",
						AnchorPoint = vector2new(1,0),
						BackgroundColor3 = Color3.new(1,1,1),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.new(0,0,0),
						BorderSizePixel = 0,
						Position = udim2new(1,0,0,-32),
						Size = udim2new(0,38,0,38),
						Parent = bar,
						Name = "\0"
					})
				elseif object.Name == "Armor" then
					newObject("ImageLabel", {
						Image = "rbxassetid://18400525414",
						AnchorPoint = vector2new(1,0),
						BackgroundColor3 = Color3.new(1,1,1),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.new(0,0,0),
						BorderSizePixel = 0,
						Position = udim2new(1,0,0,-32),
						Size = udim2new(0,50,0,50),
						Parent = bar,
						Name = "\0"
					})
				elseif object.Name == "HP" then
					newObject("ImageLabel", {
						Image = "rbxassetid://18400427732",
						AnchorPoint = vector2new(1,0),
						BackgroundColor3 = Color3.new(1,1,1),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.new(0,0,0),
						BorderSizePixel = 0,
						Position = udim2new(1,0,0,-30),
						Size = udim2new(0,34,0,34),
						Parent = bar,
						Name = "\0"
					})
				elseif object.Name == "CarHP" then
					newObject("ImageLabel", {
						Image = "rbxassetid://139619875341441",
						AnchorPoint = vector2new(1,0),
						BackgroundColor3 = Color3.new(1,1,1),
						BackgroundTransparency = 1,
						BorderColor3 = Color3.new(0,0,0),
						BorderSizePixel = 0,
						Position = udim2new(1,0,0,-30),
						Size = udim2new(0,34,0,34),
						Parent = bar,
						Name = "\0"
					})
				end


				newObject("UICorner", {
					CornerRadius = UDim.new(0, 4),
					Name = "\0",
					Parent = bar
				})

				newObject("UICorner", {
					CornerRadius = UDim.new(0, 4),
					Name = "\0",
					Parent = object
				})
			end	
		end
	end)

	utility.newConnection(menu_references["custom_stat_bars"].onToggleChange, function(bool)
		if custom_stat_bar_connection then
			custom_stat_bar_connection:Disconnect()
			custom_stat_bar_connection = nil
		end
		menu_references["custom_stat_bars"]:setDropdownVisibility(bool)
		menu_references["health_bar_color"]:setVisible(bool)
		menu_references["armor_bar_color"]:setVisible(bool)
		menu_references["fire_armor_bar_color"]:setVisible(bool)
		menu_references["energy_bar_color"]:setVisible(bool)
		menu_references["car_hp_bar_color"]:setVisible(bool)

		if bool then
			custom_stat_bar_connection = utility.newConnection(characterFullyLoaded, updateCustomStatsBars)
		end
		delay(0, updateCustomStatsBars, bool and flags["custom_stat_bars_value"][1] or "Default")
	end)
	menu_references["custom_stat_bars"]:setDropdownVisibility(false)
	menu_references["health_bar_color"]:setVisible(false)
	menu_references["armor_bar_color"]:setVisible(false)
	menu_references["fire_armor_bar_color"]:setVisible(false)
	menu_references["energy_bar_color"]:setVisible(false)
	menu_references["car_hp_bar_color"]:setVisible(false)

	utility.newConnection(menu_references["custom_stat_bars"].onDropdownChange, function(selected)
		if not flags["custom_stat_bars"] then
			return end

		local selected = selected[1]

		spawn(updateCustomStatsBars, "Default")
		spawn(updateCustomStatsBars, selected)
	end)

	utility.newConnection(menu_references["health_bar_color"].onColorChange, function(color, transparency)
		local flag = flags["custom_stat_bars_value"][1]
		if not flags["custom_stat_bars"] or flag == "Minecraft" or flag == "Sanrio" then
			return end

		local main_screen_gui = lplr_data["main_screen_gui"]

		if not main_screen_gui then
			return end
			
		local bar = main_screen_gui.Bar.HP.bar

		if flag == "Gamesense" then
			bar.ImageColor3 = color
			return end

		bar.BackgroundColor3 = color
		bar.BackgroundTransparency = transparency
	end)

	utility.newConnection(menu_references["armor_bar_color"].onColorChange, function(color, transparency)
		local flag = flags["custom_stat_bars_value"][1]
		if not flags["custom_stat_bars"] or flag == "Minecraft" or flag == "Sanrio" then
			return end

		local main_screen_gui = lplr_data["main_screen_gui"]

		if not main_screen_gui then
			return end
			
		local bar = main_screen_gui.Bar.Armor.bar

		if flag == "Gamesense" then
			bar.ImageColor3 = color
			return end

		bar.BackgroundColor3 = color
		bar.BackgroundTransparency = transparency
	end)

	utility.newConnection(menu_references["energy_bar_color"].onColorChange, function(color, transparency)
		local flag = flags["custom_stat_bars_value"][1]
		if not flags["custom_stat_bars"] or flag == "Minecraft" or flag == "Sanrio" then
			return end

		local main_screen_gui = lplr_data["main_screen_gui"]

		if not main_screen_gui then
			return end
			
		local bar = main_screen_gui.Bar.Energy.bar

		if flag == "Gamesense" then
			bar.ImageColor3 = color
			return end

		bar.BackgroundColor3 = color
		bar.BackgroundTransparency = transparency
	end)

	utility.newConnection(menu_references["fire_armor_bar_color"].onColorChange, function(color, transparency)
		local flag = flags["custom_stat_bars_value"][1]
		if not flags["custom_stat_bars"] or flag == "Minecraft" or flag == "Sanrio" then
			return end

		local main_screen_gui = lplr_data["main_screen_gui"]

		if not main_screen_gui then
			return end

		local bar = main_screen_gui.Bar.Armor.firebar

		if flag == "Gamesense" then
			bar.ImageColor3 = color
			return end
		
		bar.BackgroundColor3 = color
		bar.BackgroundTransparency = transparency
	end)

	utility.newConnection(menu_references["car_hp_bar_color"].onColorChange, function(color, transparency)
		local flag = flags["custom_stat_bars_value"][1]
		if not flags["custom_stat_bars"] or flag == "Minecraft" or flag == "Sanrio" then
			return end

		local main_screen_gui = lplr_data["main_screen_gui"]

		if not main_screen_gui then
			return end
			
		local bar = main_screen_gui.Bar.CarHP.BarContainer.Bar

		if flag == "Gamesense" then
			bar.ImageColor3 = color
			return end

		bar.BackgroundColor3 = color
		bar.BackgroundTransparency = transparency
	end)

	local custom_money_text_connection = nil

	local updateCustomMoneyText = LPH_JIT_MAX(function(selected)
		local main_screen_gui = lplr_data["main_screen_gui"]

		if not main_screen_gui then
			return end

		local selected = selected or flags["custom_money_text_value"][1]
		local text = main_screen_gui.MoneyText

		text["TextColor3"] = flags["custom_money_text"] and flags["custom_money_text_color"] or colorfromrgb(95, 255, 87)
		text["TextTransparency"] = flags["custom_money_text"] and flags["custom_money_text_transparency"] or 0
		local children = text:GetChildren()
		for i = 1, #children do
			destroy(children[i])
		end
		main_screen_gui.Promote["Visible"] = true
		if flags["custom_money_text"] then
			main_screen_gui.Promote["Visible"] = not flags["hide_money_button"]
		end

		if selected == "Default" then
			text.Font = Enum.Font.GothamMedium
			text.TextSize = 25
			text.TextStrokeTransparency = 1
			text.Position = udim2new(1, -210, 1, -60)
			text.AnchorPoint = vector2new(0,0)
			text.AutomaticSize = Enum.AutomaticSize.None
			text.Size = udim2new(0,200,0,50)
		elseif selected == "Simple" then
			text.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal)
			text.TextSize = 24
			text.TextStrokeTransparency = 0
			text.AnchorPoint = vector2new(1,1)
			text.AutomaticSize = Enum.AutomaticSize.X
			text.Position = udim2new(1,-10,1,-10)
			text.Size = udim2new(0,0,0,20)

			local image = flags["custom_money_text_image"][1]
			newObject("ImageLabel", {
				Image = image == "My Melody" and "rbxassetid://18401067020" or image == "None" and "" or image == "Custom" and flags["custom_money_text_image_value"],
				ResampleMode = Enum.ResamplerMode.Pixelated,
				AnchorPoint = vector2new(0,0.5),
				BackgroundTransparency = 1,
				BorderColor3 = colorfromrgb(0,0,0),
				Position = udim2new(0,-28,0.5,0),
				Size = udim2new(0,24,0,24),
				Parent = text,
				Name = "\0"
			})
		end
	end)

	utility.newConnection(menu_references["custom_money_text"].onToggleChange, function(bool)
		if custom_money_text_connection then
			custom_money_text_connection:Disconnect() 
			custom_money_text_connection = nil
		end
		menu_references["custom_money_text"]:setDropdownVisibility(bool)
		menu_references["custom_money_text_image"]:setVisible(bool and flags["custom_money_text_value"][1] == "Simple" or false)
		menu_references["custom_money_text_image_value"]:setVisible((bool and flags["custom_money_text_value"][1] == "Simple") and flags["custom_money_text_image"][1] == "Custom" or false)
		menu_references["hide_money_button"]:setVisible(bool)
		if bool then
			custom_money_text_connection = utility.newConnection(characterFullyLoaded, updateCustomMoneyText)
		end
		delay(0, updateCustomMoneyText, bool and flags["custom_money_text_value"][1] or "Default")
	end)

	utility.newConnection(menu_references["hide_money_button"].onToggleChange, function(bool)
		if not flags["custom_money_text"] then
			return end

		local main_screen_gui = lplr_data["main_screen_gui"]

		if not main_screen_gui then
			return end

		main_screen_gui.Promote["Visible"] = not bool
	end)

	utility.newConnection(menu_references["custom_money_text"].onColorChange, function(color, transparency)
		if not flags["custom_money_text"] then
			return end

		local main_screen_gui = lplr_data["main_screen_gui"]

		if not main_screen_gui then
			return end

		main_screen_gui.MoneyText["TextColor3"] = color
		main_screen_gui.MoneyText["TextTransparency"] = transparency
	end)

	utility.newConnection(menu_references["custom_money_text"].onDropdownChange, function(selected)
		local cmt = flags["custom_money_text"]
		local selected = selected[1]
		menu_references["custom_money_text_image"]:setVisible(cmt and selected == "Simple")
		menu_references["custom_money_text_image_value"]:setVisible((cmt and selected == "Simple") and flags["custom_money_text_image"][1] == "Custom" or false)

		if not flags["custom_money_text"] then
			return end

		spawn(updateCustomMoneyText, selected)
	end)

	utility.newConnection(menu_references["custom_money_text_image"].onDropdownChange, function(selected)
		if not flags["custom_money_text"] then
			return end
		
		menu_references["custom_money_text_image_value"]:setVisible(selected[1] == "Custom")
		delay(0, updateCustomMoneyText, flags["custom_money_text_value"][1])
	end)

	utility.newConnection(menu_references["custom_money_text_image_value"].onTextChange, function()
		if not flags["custom_money_text"] then
			return end

		delay(0, updateCustomMoneyText, flags["custom_money_text_value"][1])
	end)
	menu_references["custom_money_text"]:setDropdownVisibility(false)
	menu_references["custom_money_text_image"]:setVisible(false)
	menu_references["custom_money_text_image_value"]:setVisible(false)
	menu_references["hide_money_button"]:setVisible(false)
end

do
	local custom_hotbar_connection = nil
	local connections2 = {}
	local connections = {}
	local hotbar = game:GetService("CoreGui").RobloxGui.Backpack.Hotbar
	local inventory = hotbar.Parent.Inventory
	local temp_fix = nil

	local applyMinimalisticOutline = LPH_JIT_MAX(function(object)
		local children = object:GetChildren()

		for i = 1, #children do
			local line = children[i]

			if line["ClassName"] ~= "Frame" then
				continue
			end

			line["Visible"] = true
			line["BackgroundTransparency"] = 1
		end

		newObject("UICorner", {
			CornerRadius = UDim.new(0, 6),
			Parent = object,
			Name = "\0"
		})

		newObject("UIStroke", {
			Thickness = 2,
			Transparency = 0.56,
			Name = "\0",
			Parent = object
		})

		children["Visible"] = true
	end)

	local applyDefaultOutline = LPH_JIT_MAX(function(object)
		local children = object:GetChildren()

		for i = 1, #children do
			local line = children[i]

			if #line["Name"] == 0 then
				destroy(line)
				continue 
			elseif line["ClassName"] ~= "Frame" then
				continue
			end

			line["Visible"] = true
			line["BackgroundColor3"] = colorfromrgb(90, 142, 233)
			line["BackgroundTransparency"] = 0
		end

		children["Visible"] = true
	end)

	local updateCustomHotbar = LPH_JIT_MAX(function(selected)
		local descendants = hotbar:GetDescendants()
		for i = 1, #descendants do
			local descendant = descendants[i]
			if #descendant.Name == 0 then
				destroy(descendant)
			end
		end

		for i = 1, #connections do
			connections[i]:Disconnect()
		end

		for i = 1, #connections2 do
			connections2[i]:Disconnect()
		end

		local outline_function = selected == "Minimalistic" and applyMinimalisticOutline or applyDefaultOutline
		
		if selected == "Minimalistic" then
			local children = hotbar:GetChildren()
			for i = 1, #children do
				local object = children[i]
				newObject("UICorner", {
					CornerRadius = UDim.new(0, 6),
					Parent = object,
					Name = "\0"
				})
				object["Number"]["Font"] = Enum.Font.GothamMedium
				object["Number"]["TextSize"] = 12
				newObject("ImageLabel", {
					ImageColor3 = colorfromrgb(0, 0, 0),
					ScaleType = Enum.ScaleType.Slice,
					ImageTransparency = 0.8,
					AnchorPoint = vector2new(0.5, 0.5),
					Image = "rbxassetid://1316045217",
					BackgroundTransparency = 1,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Name = "\0",
					ZIndex = 0,
					Size = UDim2.new(1, 6, 1, 6),
					SliceCenter = Rect.new(vector2new(10, 10), vector2new(118, 118)),
					Parent = object
				})
				local outline = findfirstchild(object, "Equipped")
				if outline then
					spawn(outline_function, outline)
				end
				connections[i] = utility.newConnection(object.ChildAdded, outline_function)
				connections2[i] = utility.newConnection(object.ChildRemoved, applyDefaultOutline)
			end
		elseif selected == "Default" then
			local children = hotbar:GetChildren()
			for i = 1, #children do
				local object = children[i]
				local outline = findfirstchild(object, "Equipped")
				if outline then
					spawn(applyDefaultOutline, outline)
				end
				object["Number"]["Font"] = Enum.Font.SourceSans
				object["Number"]["TextSize"] = 14
			end
		end

	end)

	utility.newConnection(menu_references["custom_hotbar"].onToggleChange, function(bool)
		if temp_fix then
			temp_fix:Disconnect()
		end
		if bool then
			temp_fix = utility.newConnection(inventory:GetPropertyChangedSignal("Visible"), function()
				if inventory["Visible"] then
					delay(0, updateCustomHotbar, "Default")
				else
					delay(0, updateCustomHotbar, flags["custom_hotbar_value"][1])
				end
			end)
		end
		menu_references["custom_hotbar"]:setDropdownVisibility(bool)
		delay(0, updateCustomHotbar, bool and flags["custom_hotbar_value"][1] or "Default")
	end)
	menu_references["custom_hotbar"]:setDropdownVisibility(false)

	utility.newConnection(menu_references["custom_hotbar"].onDropdownChange, function(selected)
		if not flags["custom_hotbar"] then
			return end

		local selected = selected[1]

		spawn(updateCustomHotbar, "Default")
		spawn(updateCustomHotbar, selected)
	end)
end

do
	local bulletImpact = newObject("Part", {
		['Color'] = flags["bullet_impacts_color"],
		['Transparency'] = flags["bullet_impacts_transparency"],
		['Size'] = vector3new(0.2,0.2,0.2),
		['Anchored'] = true,
		['CanCollide'] = false,
		['Material'] = Enum.Material[flags["bullet_impacts_value"][1]],
		['Name'] = "\0",
		['Parent'] = gethui()
	})
	local bulletImpactOutline = newObject("SelectionBox", {
		Color3 = flags["bullet_impacts_outline_color"],
		Transparency = flags["bullet_impacts_outline_transparency"],
		LineThickness = 0.01;
		SurfaceTransparency = 1;
		Adornee = bulletImpact;
		Visible = true;
		Name = "Outline";
		Parent = bulletImpact
	})

	local doBulletImpact = LPH_NO_VIRTUALIZE(function(object, beam, _, position)
		local impact = bulletImpact:Clone()
		impact["CFrame"] = cframenew(position["p"])
		impact["Parent"] = ignored_folder

		local outline = impact["Outline"]
		outline["Adornee"] = impact

		wait(flags["bullet_impacts_lifetime"])

		tween(impact, newtweeninfo(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 1})
		tween(outline, newtweeninfo(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 1})

		delay(0.2, function()
			destroy(impact)
		end)
	end)

	local connection = nil

	utility.newConnection(menu_references["bullet_impacts"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
		if connection then 
			connection:Disconnect() 
			connection = nil
		end

		if bool then
			connection = utility.newConnection(newLocalPlayerBullet, doBulletImpact)
		end

		menu_references["bullet_impacts"]:setDropdownVisibility(bool)
		menu_references["bullet_impacts_lifetime"]:setVisible(bool)
		menu_references["bullet_impacts_size"]:setVisible(bool)
		menu_references["bullet_impacts_outline"]:setVisible(bool)
	end))
	menu_references["bullet_impacts"]:setDropdownVisibility(false)
	menu_references["bullet_impacts_lifetime"]:setVisible(false)
	menu_references["bullet_impacts_size"]:setVisible(false)
	menu_references["bullet_impacts_outline"]:setVisible(false)

	utility.newConnection(menu_references["bullet_impacts"].onColorChange, LPH_NO_VIRTUALIZE(function(color, transparency)
		bulletImpact["Color"] = color
		bulletImpact["Transparency"] = transparency
	end))

	utility.newConnection(menu_references["bullet_impacts_size"].onSliderChange, LPH_NO_VIRTUALIZE(function(value)
		bulletImpact["Size"] = vector3new(value,value,value)
	end))

	utility.newConnection(menu_references["bullet_impacts_outline"].onColorChange, LPH_NO_VIRTUALIZE(function(color, transparency)
		bulletImpactOutline["Color3"] = color
		bulletImpactOutline["Transparency"] = transparency
	end))

	utility.newConnection(menu_references["bullet_impacts"].onDropdownChange, LPH_NO_VIRTUALIZE(function(option)
		bulletImpact["Material"] = Enum.Material[option[1]]
	end))
end

do
	local renderDrawingBulletTracer = LPH_NO_VIRTUALIZE(function(object, beam, is_lplr, pos)
		local end_position = beam.Attachment1.WorldCFrame.p
		local start_position = object.CFrame.p

		local line = utility.newDrawing("Line", {
			Thickness = 1,
			Color = is_lplr and flags["local_bullet_tracers_color"] or flags["enemy_bullet_tracers_color"],
			Transparency = is_lplr and -flags["local_bullet_tracers_transparency"]+1 or -flags["enemy_bullet_tracers_transparency"]+1,
			ZIndex = 2,
			Visible = false
		})

		local outline = utility.newDrawing("Line", {
			Thickness = 3,
			Color = is_lplr and flags["local_bullet_tracers_outline_color"] or flags["enemy_bullet_tracers_outline_color"],
			Transparency = is_lplr and -flags["local_bullet_tracers_outline_transparency"]+1 or -flags["enemy_bullet_tracers_outline_transparency"]+1,
			ZIndex = 1,
			Visible = false
		})

		local elapsed_time = 0
		local new_elapsed = 0

		local style = Enum.EasingStyle.Sine
		local direction = Enum.EasingDirection.Out
		local old1 = line["Transparency"]
		local old2 = outline["Transparency"]

		destroy(object)

		local time = is_lplr and flags["local_bullet_tracers_lifetime"] or flags["enemy_bullet_tracers_lifetime"]

		local connection = utility.newConnection(rs.Heartbeat, function(dt)
			elapsed_time+=dt

			local pos, on_screen = wtvp(camera, start_position)
			local pos2, on_screen2 = wtvp(camera, end_position)

			if not on_screen or not on_screen2 then
				line["Visible"] = false
				outline["Visible"] = false
				return
			end

			if elapsed_time > time then
				new_elapsed+=dt
				local tween_value = getValue(tws, (new_elapsed/5), style, direction)
				line["Transparency"]-=tween_value
				outline["Transparency"]-=tween_value
			end

			local from, to = vector2new(pos.X, pos.Y), vector2new(pos2.X, pos2.Y)
			line["From"] = from
			line["To"] = to
			line["Visible"] = true
			outline["From"] = from
			outline["To"] = to
			outline["Visible"] = true
		end)

		delay(time+0.2, function()
			if line then
				line:Destroy()
			end
			if outline then
				outline:Destroy()
			end
			connection:Disconnect()
		end)
	end)

	local beam_styles = {
		["Laser"] = newObject("Beam", {
			Texture = "rbxassetid://446111271";
			TextureMode = Enum.TextureMode.Wrap;
			TextureLength = 10;
			LightEmission = 1;
			LightInfluence = 1;
			FaceCamera = true;
			ZOffset = -1;
			Enabled = true
		}),
		["Beam"] = newObject("Beam", {
			FaceCamera = true,
			LightEmission = 1,
			LightInfluence = 1,
			Segments = 1,
			Texture = [[rbxassetid://18854333763]],
			TextureLength = 0.10000000149011612,
			TextureSpeed = 0.5,
			Width0 = 0.15,
			Width1 = 0.15
		})
	}
	
	local renderBeamBulletTracer = LPH_NO_VIRTUALIZE(function(object, beam, is_lplr, pos)
		local new_beam = beam_styles[is_lplr and flags["local_bullet_tracers_texture"][1] or flags["enemy_bullet_tracers_texture"][1]]:Clone()
		local color = is_lplr and flags["local_bullet_tracers_color"] or flags["enemy_bullet_tracers_color"]

		new_beam["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0,color),ColorSequenceKeypoint.new(1,color)}
		new_beam["Transparency"] = NumberSequence.new(is_lplr and flags["local_bullet_tracers_transparency"] or flags["enemy_bullet_tracers_transparency"])

		local attachment1 = newObject("Attachment", {
			CFrame = object.CFrame,
			Parent = workspace.Terrain
		})
	
		local attachment2 = newObject("Attachment", {
			CFrame = beam.Attachment1.WorldCFrame,
			Parent = workspace.Terrain
		})	

		new_beam.Attachment0 = attachment1
		new_beam.Attachment1 = attachment2
		new_beam.Parent = ignored_folder

		destroy(object)

		wait(is_lplr and flags["local_bullet_tracers_lifetime"] or flags["enemy_bullet_tracers_lifetime"])

		local elapsed_time = 0
		local style = Enum.EasingStyle.Quad
		local direction = Enum.EasingDirection.Out 
		local connection = utility.newConnection(rs.Heartbeat, function(dt)
			elapsed_time+=dt
			new_beam["Transparency"] = NumberSequence.new(getValue(tws, (elapsed_time / 0.2), style, direction));
		end)
		delay(0.2, function()
			destroy(attachment2)
			destroy(attachment1)
			destroy(new_beam)
			connection:Disconnect()
		end)
	end)

	local connection = nil
	local connection2 = nil
	utility.newConnection(menu_references["local_bullet_tracers"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
		if connection then
			connection:Disconnect()
			connection = nil
		end

		if bool then
			connection = utility.newConnection(newLocalPlayerBullet, flags["local_bullet_tracers_value"][1] == "Drawing" and renderDrawingBulletTracer or renderBeamBulletTracer)
		end

		menu_references["local_bullet_tracers_outline"]:setVisible(bool and flags["local_bullet_tracers_value"][1] == "Drawing")
		menu_references["local_bullet_tracers_lifetime"]:setVisible(bool)
		menu_references["local_bullet_tracers_texture"]:setVisible(bool and flags["local_bullet_tracers_value"][1] == "Beam")

		menu_references["local_bullet_tracers"]:setDropdownVisibility(bool)
	end))
	menu_references["local_bullet_tracers"]:setDropdownVisibility(false)
	menu_references["local_bullet_tracers_outline"]:setVisible(false)
	menu_references["local_bullet_tracers_lifetime"]:setVisible(false)
	menu_references["local_bullet_tracers_texture"]:setVisible(false)

	utility.newConnection(menu_references["local_bullet_tracers"].onDropdownChange, LPH_NO_VIRTUALIZE(function(selected)
		local selected = selected[1]
		if connection then
			connection:Disconnect()
			connection = nil
		end

		if flags["local_bullet_tracers"] then
			connection = utility.newConnection(newLocalPlayerBullet, selected == "Drawing" and renderDrawingBulletTracer or renderBeamBulletTracer)
		end

		menu_references["local_bullet_tracers_outline"]:setVisible(flags["local_bullet_tracers"] and selected == "Drawing")
		menu_references["local_bullet_tracers_lifetime"]:setVisible(flags["local_bullet_tracers"])
		menu_references["local_bullet_tracers_texture"]:setVisible(flags["local_bullet_tracers"] and selected == "Beam")
	end))

	utility.newConnection(menu_references["enemy_bullet_tracers"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
		if connection2 then
			connection2:Disconnect()
			connection2 = nil
		end
	
		if bool then
			connection2 = utility.newConnection(newPlayerBullet, flags["enemy_bullet_tracers_value"][1] == "Drawing" and renderDrawingBulletTracer or renderBeamBulletTracer)
		end
	
		menu_references["enemy_bullet_tracers_outline"]:setVisible(bool and flags["enemy_bullet_tracers_value"][1] == "Drawing")
		menu_references["enemy_bullet_tracers_lifetime"]:setVisible(bool)
		menu_references["enemy_bullet_tracers_texture"]:setVisible(bool and flags["enemy_bullet_tracers_value"][1] == "Beam")
		menu_references["enemy_bullet_tracers"]:setDropdownVisibility(bool)
	end))
	menu_references["enemy_bullet_tracers"]:setDropdownVisibility(false)
	menu_references["enemy_bullet_tracers_outline"]:setVisible(false)
	menu_references["enemy_bullet_tracers_lifetime"]:setVisible(false)
	menu_references["enemy_bullet_tracers_texture"]:setVisible(false)
	
	utility.newConnection(menu_references["enemy_bullet_tracers"].onDropdownChange, LPH_NO_VIRTUALIZE(function(selected)
		local selected = selected[1]
		if connection2 then
			connection2:Disconnect()
			connection2 = nil
		end
	
		if flags["enemy_bullet_tracers"] then
			connection2 = utility.newConnection(newPlayerBullet, selected == "Drawing" and renderDrawingBulletTracer or renderBeamBulletTracer)
		end
	
		menu_references["enemy_bullet_tracers_outline"]:setVisible(flags["enemy_bullet_tracers"] and selected == "Drawing")
		menu_references["enemy_bullet_tracers_lifetime"]:setVisible(flags["enemy_bullet_tracers"])
		menu_references["enemy_bullet_tracers_texture"]:setVisible(flags["enemy_bullet_tracers"] and selected == "Beam")
	end))
end

local keybinds_list = {}

do
	local updateIndicators = LPH_NO_VIRTUALIZE(function()
		local position = vector2new(5, camera.ViewportSize.Y/1.4)
		local total_y = 0

		for _, indicator in keybinds_list do
			if not indicator["visible"] then
				continue end
			
			local pos = position+vector2new(0,total_y)

			indicator["gradient"]["Position"] = pos
			indicator["text"]["Position"] = pos + indicator["gradient"]["Size"]/2 - indicator["text"]["TextBounds"]/2
			indicator["text_outline"]["Position"] = indicator["text"]["Position"] + vector2new(1,1)
			total_y+=41
		end
	end)

	local indicator = {}
	indicator.__index = indicator

	function indicator.new(string, additional_info)
		local color = flags["feature_indicators_color"]
		local h,s,v = color:ToHSV()
		
		local text = utility.newDrawing("Text", {
			Text = string,
			Color = color,
			Size = 30,
			ZIndex = 3,
			Font = 1,
			Visible = false
		})
		local text_outline = utility.newDrawing("Text", {
			Text = string,
			Color = Color3.fromHSV(h,s,v * 0.42477876106),
			Size = 30,
			ZIndex = 2,
			Font = 1,
			Visible = false
		})
		local gradient = utility.newDrawing("Image", {
			["Transparency"] = 0.5,
			["Color"] = colorfromrgb(24,24,24),
			["Data"] = images["indicator_gradient"],
			["ZIndex"] = 1,
			["Size"] = vector2new(text["TextBounds"]["X"] + 60, 33),
			["Visible"] = false
		})

		local new_indicator = setmetatable({
			["text"] = text,
			["text_outline"] = text_outline,
			["gradient"] = gradient,
			["visible"] = false
		}, indicator)

		if additional_info then
			local keybind_flag, element, toggle_flag = additional_info[1], additional_info[2], additional_info[3]
			new_indicator["connection"] = utility.newConnection(element.onActiveChange, function(bool)
				new_indicator:set_visible(bool and flags[toggle_flag])
			end)
			new_indicator["connection2"] = element.onToggleChange and utility.newConnection(element.onToggleChange, function(bool)
				new_indicator:set_visible(bool and flags[keybind_flag]["active"])
			end)
		end

		return new_indicator
	end

	function indicator:set_visible(bool)
		if self["visible"] == bool then
			return end

		self["text"]["Visible"] = bool
		self["text_outline"]["Visible"] = bool
		self["gradient"]["Visible"] = bool
		self["visible"] = bool

		updateIndicators()
	end

	function indicator:set_override_color(color)
		self["override_color"] = color

		if color == nil then
			self:set_color(flags["feature_indicators_color"])
			return
		end
			
		local h,s,v = color:ToHSV()
		local outline_color = Color3.fromHSV(h,s,v * 0.42477876106)

		self["text"]["Color"] = color
		self["text_outline"]["Color"] = outline_color
	end

	function indicator:set_color(color)
		if not self["override_color"] then
			return end
			
		local h,s,v = color:ToHSV()
		local outline_color = Color3.fromHSV(h,s,v * 0.42477876106)

		self["text"]["Color"] = color
		self["text_outline"]["Color"] = outline_color
	end

	local flag_holder = {
		["Random teleport resolver"] = {"random_teleport_resolver_keybind", menu_references["random_teleport_resolver_keybind"], "RESOLVE", "random_teleport_resolver_keybind"},
		["Predict auto armor"] = "PA",
		["Destroy cheaters"] = {"destroy_cheaters_keybind", menu_references["destroy_cheaters"], "DC", "destroy_cheaters"},
		["Random teleport"] = {"random_teleport_keybind", menu_references["random_teleport"], "RT", "random_teleport"},
		["Velocity desync"] = {"velocity_desync_keybind", menu_references["velocity_desync"], "VD", "velocity_desync"},
		["Network desync"] = {"network_desync_keybind", menu_references["network_desync"], "ND", "network_desync"},
		["CFrame speed"] = {"cframe_speed_keybind", menu_references["cframe_speed"], "CS", "cframe_speed"},
		["CFrame fly"] = {"cframe_fly_keybind", menu_references["cframe_fly"], "CF", "cframe_fly"},
		["Auto shoot"] = {"auto_shoot_keybind", menu_references["auto_shoot"], "AS", "auto_shoot"},
		["Void spam"] = {"void_spam_keybind", menu_references["void_spam"], "VS", "void_spam"},
	}

	local connection = nil

	utility.newConnection(menu_references["feature_indicators"].onDropdownChange, LPH_JIT_MAX(function(selected)
		if connection then
			connection:Disconnect()
			connection = nil
		end
		if selected[1] then 
			connection = utility.newConnection(camera:GetPropertyChangedSignal("ViewportSize"), updateIndicators)
		end
		for indicator, info in keybinds_list do
			if not find(selected, indicator) then
				if info["connection"] then
					info["connection"]:Disconnect()
					info["connection"] = nil
				end
				if info["connection2"] then
					info["connection2"]:Disconnect()
					info["connection2"] = nil
				end
				info["text"]:Destroy()
				info["text_outline"]:Destroy()
				info["gradient"]:Destroy()
				info["text"] = nil
				info["text_outline"] = nil
				info["gradient"] = nil
				keybinds_list[indicator] = nil
			end
		end
		for _, selected_indicator in selected do
			if not keybinds_list[selected_indicator] then
				local flag = flag_holder[selected_indicator]
				keybinds_list[selected_indicator] = typeof(flag) == "string" and indicator.new(flag) or indicator.new(flag[3], {flag[1], flag[2], flag[4]})
			end
		end
		spawn(updateIndicators)
	end))

	utility.newConnection(menu_references["feature_indicators"].onColorChange, function(color)
		if not flags["feature_indicators"] then
			return end

		local h,s,v = color:ToHSV()
			
		local outline_color = Color3.fromHSV(h,s,v * 0.42477876106)
		for _, info in keybinds_list do
			info:set_color(color)
		end
	end)
end

do
	local doSpinbot = LPH_NO_VIRTUALIZE(function(dt, hrp)
		lplr_pos*=angles(0,rad((flags["spinbot_speed"]*20)*dt),0)

		local humanoid = lplr_parts["Humanoid"]

		if not humanoid then
			return end

		humanoid["AutoRotate"] = false
	end)

	utility.newConnection(menu_references["spinbot"].onToggleChange, function(bool)
		if find(heartbeat_callbacks, doSpinbot) then
			remove(heartbeat_callbacks, doSpinbot)
		end
		if bool then
			insert(heartbeat_callbacks, doSpinbot)
		end
		menu_references["spinbot"]:setSliderVisibility(bool)

		local humanoid = lplr_parts["Humanoid"]

		if not humanoid then
			return end

		humanoid["AutoRotate"] = true
	end)
	menu_references["spinbot"]:setSliderVisibility(false)
end

do
	local last_void = clock()

	local voidSpam = LPH_NO_VIRTUALIZE(function(dt, hrp)
		if not flags["void_spam_keybind"]["active"] then
			return end

		if not hrp then
			return end

		if clock() - last_void > 0.1+(ping/1000) and not void and not lplr_data["recently_shot"] then
			void = true
			delay(0.1, function()
				last_void = clock()
				void = false
			end)
		end
		if void then
			hrp["CFrame"]-=vector3new(mathrandom(-20,20), 9e9-1000, mathrandom(-20,20))
		end
	end)

	utility.newConnection(menu_references["void_spam"].onToggleChange, function(bool)
		if find(anti_callbacks, voidSpam) then
			remove(anti_callbacks, voidSpam)
		end
		if bool then
			menu_references["no_void_kill"]:setToggle(true)
			insert(anti_callbacks, voidSpam)
		end
	end)
end

do
	local cframeSpeed = LPH_NO_VIRTUALIZE(function(dt, hrp)
		local humanoid = lplr_parts["Humanoid"]		

		if not humanoid or not flags["cframe_speed_keybind"]["active"] then
			return end

		lplr_pos+=((humanoid.MoveDirection*dt)*flags["cframe_speed_value"]*10)
	end)

	utility.newConnection(menu_references["cframe_speed"].onToggleChange, function(bool)
		if find(heartbeat_callbacks, cframeSpeed) then
			remove(heartbeat_callbacks, cframeSpeed)
		end
		if bool then
			insert(heartbeat_callbacks, cframeSpeed)
		end
		menu_references["cframe_speed"]:setSliderVisibility(bool)
	end)
	menu_references["cframe_speed"]:setSliderVisibility(false)
end

do	
	local isKeyDown = uis.IsKeyDown
	local space = Enum.KeyCode.Space
	local w = Enum.KeyCode.W
	local s = Enum.KeyCode.S

	local cframeFly = LPH_NO_VIRTUALIZE(function(dt, hrp)
		local humanoid = lplr_parts["Humanoid"]		

		if not hrp or not humanoid or not flags["cframe_fly_keybind"]["active"] then
			return end

		local move_direction = humanoid.MoveDirection
		hrp.Velocity = vector3new(hrp.Velocity.X, 1.8, hrp.Velocity.Z)
		lplr_pos+=((vector3new(move_direction.X, isKeyDown(uis, space) and 1 or ((isKeyDown(uis, s) and -camera.CFrame.lookVector.Y) or (isKeyDown(uis, w) and camera.CFrame.lookVector.Y) or 0) * clamp(move_direction.magnitude, 0, 1), move_direction.Z)*dt)*flags["cframe_fly_value"]*10)
	end)

	utility.newConnection(menu_references["cframe_fly"].onToggleChange, function(bool)
		if find(heartbeat_callbacks, cframeFly) then
			remove(heartbeat_callbacks, cframeFly)
		end
		if bool then
			insert(heartbeat_callbacks, cframeFly)
		end
		menu_references["cframe_fly"]:setSliderVisibility(bool)
	end)
	menu_references["cframe_fly"]:setSliderVisibility(false)
end

do
	local updateHats = LPH_NO_VIRTUALIZE(function()
		local color = flags["forcefield_hats_color"]
		local transparency = flags["forcefield_hats_transparency"]
		local material = flags["forcefield_hats"] and Enum.Material.ForceField or Enum.Material.Plastic
		for name, part in lplr_parts do
			if part.ClassName == "Accessory" then
				local part = findfirstchildofclass(part, "Part") or findfirstchildofclass(part, "MeshPart")
				if part then
					part.Material = material
					part.Transparency = transparency
					part.Color = color 
				end
			end 
		end
	end)

	local forcefield_hats_connection = nil

	utility.newConnection(menu_references["forcefield_hats"].onColorChange, function(color, transparency)
		if not flags["forcefield_hats"] then
			return end

		delay(0, updateHats)
	end, true)

	utility.newConnection(menu_references["forcefield_hats"].onToggleChange, function(bool)
		if forcefield_hats_connection then
			forcefield_hats_connection:Disconnect()
			forcefield_hats_connection = nil
		end
		if bool then
			forcefield_hats_connection = utility.newConnection(characterFullyLoaded, updateHats)
		end

		delay(0, updateHats)
	end)

	local updateForcefieldBody = LPH_NO_VIRTUALIZE(function()
		local humanoid = lplr_parts["Humanoid"]

		if not humanoid then
			return end

		local humanoid_description = humanoid.HumanoidDescription

		if not humanoid_description then
			return end

		local do_forcefield_body = flags["forcefield_body"]
		if bool ~= nil then
			do_forcefield_body = bool
		end
		local material = do_forcefield_body and Enum.Material.ForceField or Enum.Material.Plastic
		local color = flags["forcefield_body_color"]
		local transparency = flags["forcefield_body_transparency"]
		local has_korblox = lplr_parts["RightUpperLeg"]["TextureID"] == "https://www.roblox.com/asset/?id=902843398"

		for name, part in lplr_parts do
			if has_korblox and (name == "RightLowerLeg" or name == "RightFoot") then
				continue end

			if name ~= "HumanoidRootPart" and part:IsA("BasePart") then
				local _color = limb_descriptions[name] and humanoid_description[limb_descriptions[name]] or colorfromrgb(163, 162, 165)
				part.Material = material
				part.Color = do_forcefield_body and color or _color
				part.Transparency = do_forcefield_body and transparency or 0
				if name == "Head" and flags["headless"] then part.Transparency = 1 end
				if flags["korblox"] then
					if name == "RightUpperLeg" or name == "RightLowerLeg" or name == "RightFoot" then
						part.Transparency = 1
					end
				end
			end 
		end
	end)

	local forcefield_body_connection = nil

	utility.newConnection(menu_references["forcefield_body"].onColorChange, function(color, transparency)
		if not flags["forcefield_body"] then
			return end
		
		delay(0, updateForcefieldBody)
	end, true)

	utility.newConnection(menu_references["forcefield_body"].onToggleChange, function(bool)
		if forcefield_body_connection then
			forcefield_body_connection:Disconnect()
			forcefield_body_connection = nil
		end
		if bool then
			forcefield_body_connection = utility.newConnection(characterFullyLoaded, updateForcefieldBody)
		end
		delay(0, updateForcefieldBody)
	end, true)

	local korblox_connection = nil

	local doKorblox = is_solara and function() end or function()
		local bool = flags["korblox"]
		local right_upper_leg = lplr_parts["RightUpperLeg"]
		local right_lower_leg = lplr_parts["RightLowerLeg"]
		local right_foot = lplr_parts["RightFoot"]

		if not right_upper_leg or not right_lower_leg or not right_foot then
			return end

		right_upper_leg.TextureID = bool and "rbxassetid://902843398" or ""
		right_upper_leg.MeshId = bool and "rbxassetid://9598310133" or "rbxassetid://532220018"
		right_lower_leg.Transparency = bool and 1 or 0
		right_foot.Transparency = bool and 1 or 0
	end

	utility.newConnection(menu_references["korblox"].onToggleChange, function(bool)
		if korblox_connection then
			korblox_connection:Disconnect()
			korblox_connection = nil
		end
		if bool then
			korblox_connection = utility.newConnection(characterFullyLoaded, doKorblox)
		end
		delay(0, doKorblox)
	end, true)

	local headless_connection = nil

	local function doHeadless()
		local head = lplr_parts["Head"]

		if not head then
			return end

		local bool = flags["headless"]
		local face = findfirstchild(head, "face")
		if face then
			face.Transparency = bool and 1 or 0
		end
		head.Transparency = bool and 1 or 0
	end

	utility.newConnection(menu_references["headless"].onToggleChange, function(bool)
		if headless_connection then
			headless_connection:Disconnect()
			headless_connection = nil
		end
		if bool then
			headless_connection = utility.newConnection(characterFullyLoaded, doHeadless)
		end
		delay(0, doHeadless)
	end, true)

	local accessory_connection = nil

	local doAddAccessories = LPH_NO_VIRTUALIZE(function()
		local head = lplr_parts["Head"]
		local humanoid = lplr_parts["Head"]

		for id, object in lplr_data["accessories"] do
			local accessory = object:Clone()
			accessory.Name = id
			humanoid:AddAccessory(accessory)
			local attachment = findfirstchildofclass(accessory.Handle, "Attachment")
			accessory.Handle.CanCollide = false
			local weld = newObject("Weld", {
				Name = "AccessoryWeld",
				Part0 = accessory.Handle,
				Part1 = head,
				C0 = attachment.CFrame,
				C1 = cframenew(0,0.6,0),
				Parent = accessory.Handle
			})
		end
	end)

	utility.newConnection(menu_references["accessory_adder"].onToggleChange, function(bool)
		menu_references["accessories"]:setVisible(bool)
		menu_references["add_accessory"]:setVisible(bool)
		menu_references["remove_accessory"]:setVisible(bool)
		menu_references["accessory_id"]:setVisible(bool)
	
		local humanoid = lplr_parts["Humanoid"]
	
		if not humanoid then
			return end
	
		for id, object in lplr_data["accessories"] do
			local part = lplr_parts[id]
	
			if part then
				destroy(part)
			end
		end

		if accessory_connection then
			accessory_connection:Disconnect()
			accessory_connection = nil
		end
	
		if bool then	
			for id, object in lplr_data["accessories"] do
				local accessory = object:Clone()
				accessory.Name = id
				humanoid:AddAccessory(accessory)
				local attachment = findfirstchildofclass(accessory.Handle, "Attachment")
				accessory.Handle.CanCollide = false
				local weld = newObject("Weld", {
					Name = "AccessoryWeld",
					Part0 = accessory.Handle,
					Part1 = lplr_parts["Head"],
					C0 = attachment.CFrame,
					C1 = cframenew(0,0.6,0),
					Parent = accessory.Handle
				})
			end
			accessory_connection = utility.newConnection(characterFullyLoaded, doAddAccessories)
		end
	end)
	menu_references["accessories"]:setVisible(false)
	menu_references["add_accessory"]:setVisible(false)
	menu_references["remove_accessory"]:setVisible(false)
	menu_references["accessory_id"]:setVisible(false)
end

do
	local part = newObject("Part", {
		CFrame = cframenew(-169.848083,0.5,-116.794434,1,0,0,0,1,0,0,0,1);
		CanCollide = false;
		Size = vector3new(1,1,1);
		TopSurface = Enum.SurfaceType.Smooth;
		Transparency = 1;
		Anchored = true;
		Parent = ignored_folder
	})
	local attachment1 = newObject("Attachment", {
		CFrame = cframenew(0,0,0.5,1,0,0,0,1,0,0,0,1),
		Parent = part
	})
	local attachment2 = newObject("Attachment", {
		CFrame = cframenew(0,0,-0.5,1,0,0,0,1,0,0,0,1),
		Parent = part
	})
	local trail = newObject("Trail", {
		Attachment0 = attachment1;
		Attachment1 = attachment2;
		Brightness = 20;
		FaceCamera = true;
		Lifetime = 0.5;
		LightEmission = 1;
		MinLength = 0;
		Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,0,0)};
		WidthScale = NumberSequence.new{NumberSequenceKeypoint.new(0,0.08,0),NumberSequenceKeypoint.new(1,0.08,0)};
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),ColorSequenceKeypoint.new(1,Color3.new(1,1,1))};
		Parent = part
	})
	part.Parent = cg

	local doTrail = LPH_NO_VIRTUALIZE(function()
		local upper_torso = lplr_parts["UpperTorso"]

		if not upper_torso then
			return end

		part.CFrame = upper_torso.CFrame
	end)

	utility.newConnection(menu_references["trail"].onToggleChange, function(bool)
		part.Parent = bool and ignored_folder or cg
		menu_references["trail_gradient"]:setVisible(bool)
		menu_references["trail_lifetime"]:setVisible(bool)
		if find(heartbeat_callbacks, doTrail) then
			remove(heartbeat_callbacks, doTrail)
		end
		if bool then
			trail["Enabled"] = false
			insert(heartbeat_callbacks, doTrail)
			delay(0, function()
				trail["Enabled"] = true
			end)
		end
	end)
	menu_references["trail_gradient"]:setVisible(false)

	utility.newConnection(menu_references["trail"].onColorChange, function(color, transparency)
		local trail_gradient = flags["trail_gradient"]

		trail["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0,color),ColorSequenceKeypoint.new(1,trail_gradient and flags["trail_gradient_color"] or color)}
		trail["Transparency"] = NumberSequence.new{NumberSequenceKeypoint.new(0,transparency),NumberSequenceKeypoint.new(1,trail_gradient and flags["trail_gradient_transparency"] or transparency)}
	end)

	utility.newConnection(menu_references["trail_gradient"].onColorChange, function(color, transparency)
		local trail_gradient = flags["trail_gradient"]

		trail["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0,flags["trail_color"]),ColorSequenceKeypoint.new(1,trail_gradient and color or flags["trail_color"])}
		trail["Transparency"] = NumberSequence.new{NumberSequenceKeypoint.new(0,flags["trail_transparency"]),NumberSequenceKeypoint.new(1,trail_gradient and transparency or flags["trail_transparency"])}
	end)

	utility.newConnection(menu_references["trail_gradient"].onToggleChange, function(bool)
		local trail_color = flags["trail_color"]
		local trail_transparency = flags["trail_transparency"]

		trail["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0,flags["trail_color"]),ColorSequenceKeypoint.new(1,bool and flags["trail_gradient_color"] or trail_color)}
		trail["Transparency"] = NumberSequence.new{NumberSequenceKeypoint.new(0,flags["trail_transparency"],0),NumberSequenceKeypoint.new(1,bool and flags["trail_gradient_transparency"] or trail_transparency)}
	end)

	utility.newConnection(menu_references["trail_lifetime"].onSliderChange, function(value)
		trail["Lifetime"] = value
	end)

	menu_references["trail_lifetime"]:setVisible(false)
end

do
	local hide_gun_crosshair_connection = nil
	
	local function hideCrosshair(bool)
		local main_screen_gui = lplr_data["main_screen_gui"]

		if not main_screen_gui then
			return end

		local aim = main_screen_gui.Aim
		local bool = bool
		if bool == nil then bool = true end

		local children = aim:GetChildren()
		local transparency = bool and 1 or 0

		aim.Size = bool and udim2new(0, 0, 0, 0) or udim2new(0, 4, 0, 4)

		for i = 1, #children do
			local child = children[i]
			if child.ClassName == "Frame" then
				child.BackgroundTransparency = transparency
			else
				child.ImageTransparency = transparency
			end 
		end
	end

	utility.newConnection(menu_references["hide_gun_crosshair"].onToggleChange, function(bool)
		if hide_gun_crosshair_connection then
			hide_gun_crosshair_connection:Disconnect()
			hide_gun_crosshair_connection = nil
		end
		if bool then
			hide_gun_crosshair_connection = utility.newConnection(characterFullyLoaded, hideCrosshair)
		end
		hideCrosshair(bool)
	end)
end

do
	local connection = nil

	local newRPGWarning = LPH_NO_VIRTUALIZE(function(part, position)
		local red = utility.newDrawing("Image", {
			["Transparency"] = 1,
			["Color"] = colorfromrgb(255,0,0),
			["ZIndex"] = 999,
			["Data"] = images["gradient_circle"],
			["Visible"] = false
		})
		local rpg = utility.newDrawing("Image", {
			["Transparency"] = 1,
			["Color"] = colorfromrgb(255,255,255),
			["ZIndex"] = 1000,
			["Data"] = images["rpg_icon"],
			["Visible"] = false
		})
		local text = utility.newDrawing("Text", {
			Transparency = 1,
			Color = colorfromrgb(255,255,255),
			ZIndex = 1001,
			Text = "",
			Size = 9,
			Font = 3,
			Outline = true,
			Visible = false
		})

		local last_update = clock()
		local position = position

		local connection2 = nil

		local function destroy()
			red:Destroy()
			rpg:Destroy()
			text:Destroy()
			connection2:Disconnect()
		end

		local target_transparency = 0
		local last_lerp_change = clock()
		local visible = false

		local old_parent = part.Parent
		
		connection2 = utility.newConnection(rs.Heartbeat, function(dt)
			local hrp = lplr_parts["HumanoidRootPart"]

			if not hrp or not part or part.Parent ~= old_parent or part.Parent == nil then
				destroy()
				return
			end

			if clock() - last_update > 0.175 then
				local lookVector = part.CFrame.lookVector
				local result = raycast(workspace, part.Position, lookVector*-1000, raycast_params)

				if result then
					position = result.Position
					last_update = clock()
				elseif visible then
					red["Visible"] = false
					rpg["Visible"] = false
					text["Visible"] = false
					return
				end
			end

			local top, _ = wtvp(camera, position + vector3new(0,1,0))
			local center, on_screen = wtvp(camera, position)

			if not on_screen then
				if visible then
					red["Visible"] = false
					rpg["Visible"] = false
					text["Visible"] = false
					visible = false
				end
				return
			end			

			visible = true

			red["Visible"] = true
			rpg["Visible"] = true
			text["Visible"] = true

			local size = (center.Y-top.Y)*1.8
			local distance = (hrp.Position - position).magnitude

			local screen_position = vector2new(center.X, center.Y) - vector2new(size/2,size/2)
			local time_left = (part.Position-position).magnitude/50

			text["Text"] = tostring(round(time_left, 1)).."s"
			text["Position"] = screen_position + vector2new(size/2 - text["TextBounds"]["X"]/2, size - text["TextBounds"]["Y"])
			local new = vector2new(size/1.8, size/1.8)
			rpg["Size"] = vector2new(size, size)
			rpg["Position"] = screen_position
			red["Size"] = rpg["Size"] + new
			red["Position"] = screen_position - new/2

			red["Transparency"] = lerp(red["Transparency"], target_transparency, dt*7)

			local transparency_multiplier = 1 - (distance >= 25 and (clamp(distance-25, 0, 100)/50) or 0)

			text["Transparency"] = transparency_multiplier
			rpg["Transparency"] = transparency_multiplier
			
			if transparency_multiplier < 0 then
				red["Transparency"] = transparency_multiplier
			end

			if clock() - last_lerp_change > 0.4 then
				target_transparency = target_transparency == 1 and 0 or 1
				last_lerp_change = clock()
			end
		end)
	end)

	local rpgAdded = LPH_NO_VIRTUALIZE(function(rpg)
		if rpg.Name == "Model" then
			local part = rpg:WaitForChild("Launcher", 1)
			if part then
				local lookVector = part.CFrame.lookVector
				local result = raycast(workspace, part.Position, lookVector*-1000, raycast_params)
		
				if result then
					spawn(newRPGWarning, part, result.Position + lookVector*-1)
				end
			end
		end
	end)

	utility.newConnection(menu_references["rpg_warnings"].onToggleChange, function(bool)
		if connection then 
			connection:Disconnect()
			connection = nil
		end
		connection = utility.newConnection(ignored_folder.ChildAdded, rpgAdded)
	end)
end

do
	local text2 = nil
	local text = nil
	local elapsed_time = 0
	local new_value = 0
	local old_value = 0
	local cooldown = true
	local cycle = false
	local total_size = 0

	local renderWatermark = LPH_NO_VIRTUALIZE(function(dt)
		elapsed_time+=dt

		local tb1 = text["TextBounds"]["X"]
		local tb2 = text2["TextBounds"]["X"]
		total_size = tb1+tb2+4

		local position = flags["watermark_position"][1] == "Center" and camera.ViewportSize/2 or getMouseLocation(uis)
		position-=vector2new(total_size/2,flags["watermark_y_offset"])

		text["Position"] = position
		text2["Position"] = position+vector2new(tb1+4,0)

		if elapsed_time < 0.4 then
			local tween_value = getValue(tws, (elapsed_time / 0.4), Enum.EasingStyle.Circular, (not cycle) and Enum.EasingDirection.Out or Enum.EasingDirection.In)
			text2.Transparency = old_value + (new_value-old_value)*tween_value
		elseif cooldown then
			cooldown = false
			text2.Transparency = cycle and 0 or 1
			cycle = not cycle
			new_value = cycle and 0 or 1
			old_value = cycle and 1 or 0
			delay(0.4, function()
				elapsed_time = 0
				cooldown = true
			end)
		end
	end)

	utility.newConnection(menu_references["watermark"].onToggleChange, function(bool)
		if text then
			text:Destroy()
			text2:Destroy()
			text = nil
			text2 = nil
		end
		if find(heartbeat_callbacks, renderWatermark) then
			remove(heartbeat_callbacks, renderWatermark)
		end
		if bool then
			local size = flags["watermark_size"]
			text = utility.newDrawing("Text", {
				Text = "juju",
				Color = colorfromrgb(226,226,226),
				Size = size,
				Font = 3,
				ZIndex = 2,
				Center = false,
				Outline = true,
				Visible = true,
			})
			text2 = utility.newDrawing("Text", {
				Text = "recode",
				Color = flags["watermark_color"],
				Size = size,
				Font = 3,
				ZIndex = 2,
				Center = false,
				Outline = true,
				Visible = true,
			})
			insert(heartbeat_callbacks, renderWatermark)
		end
		menu_references["watermark_position"]:setVisible(bool)
		menu_references["watermark_size"]:setVisible(bool)
		menu_references['watermark_y_offset']:setVisible(bool)
	end)

	utility.newConnection(menu_references["watermark"].onColorChange, function(color)
		if not flags["watermark"] then
			return end 
		
		text2["Color"] = color
	end)

	utility.newConnection(menu_references["watermark_size"].onSliderChange, function(value)
		if not flags["watermark"] then
			return end 
		
		text["Size"] = value
		text2["Size"] = value
	end)
	menu_references["watermark_position"]:setVisible(false)
	menu_references["watermark_size"]:setVisible(false)
	menu_references['watermark_y_offset']:setVisible(false)
end

do
    local type = type
    local getupvalues = getupvalues
    local setupvalue = setupvalue
    local getinfo = getinfo
	local sfind = string.find

    local old_tools = {}
    local old_upvalues = nil
    local on_tool_equipped = nil
    local on_character_added = nil

    local apply_firerate_bypass = LPH_NO_VIRTUALIZE(function(tool)
        wait()
        local name = tool and tool["Name"] or nil
        if tool and not old_tools[name] then
            local gc = getgc()
            for i = 1, #gc do
                local obj = gc[i]
                if type(obj) == "function" then
                    local source = getinfo(obj)["source"]
                    if sfind(getinfo(obj)["source"], "GunClient") and sfind(source, name) then
                        for _, upvalue in getupvalues(obj) do
                            if type(upvalue) == "number" and upvalue < 10 then
                                old_upvalues[obj] = upvalue
                                setupvalue(obj, _, 0)
                            end
                        end
                    end
                end
            end
            old_tools[name] = 1
        end
    end)

    local update_firerate_details = LPH_NO_VIRTUALIZE(function(character)
        old_tools = {}
        old_upvalues = {}
    end)

    utility.newConnection(menu_references["remove_fire_cooldown"].onToggleChange, LPH_JIT_MAX(function(bool)
        if on_tool_equipped then
            on_tool_equipped:Disconnect()
            on_tool_equipped = nil
        end
        if on_character_added then
            on_character_added:Disconnect()
            on_character_added = nil
        end
        if bool then
            old_upvalues = {}
            old_tools = {}
            if local_tool then
                apply_firerate_bypass(local_tool)
            end
            on_tool_equipped = utility.newConnection(newToolEquipped, apply_firerate_bypass)
            on_character_added = utility.newConnection(characterFullyLoaded, update_firerate_details)
        elseif old_upvalues then
            local gc = getgc()
            for i = 1, #gc do
                local obj = gc[i]
                if typeof(obj) == "function" and sfind(getinfo(obj)["source"], "GunClient") then
                    for _, upvalue in getupvalues(obj) do
                        if type(upvalue) == "number" and upvalue < 10 then
                            local new_upvalue = old_upvalues[obj]
                            if new_upvalue then
                                setupvalue(obj, _, new_upvalue)
                            end
                        end
                    end
                end
            end
            old_tools = {}
            old_upvalues = {}
        end
    end))
end

do
	local connection = nil

	local newGrenadeWarning = LPH_NO_VIRTUALIZE(function(part)
		local red = utility.newDrawing("Image", {
			["Transparency"] = 1,
			["Color"] = colorfromrgb(255,0,0),
			["ZIndex"] = 999,
			["Data"] = images["gradient_circle"],
			["Visible"] = false
		})
		local grenade = utility.newDrawing("Image", {
			["Transparency"] = 1,
			["Color"] = colorfromrgb(255,255,255),
			["ZIndex"] = 1000,
			["Data"] = images["grenade_icon"],
			["Visible"] = false
		})
		local text = utility.newDrawing("Text", {
			Transparency = 1,
			Color = colorfromrgb(255,255,255),
			ZIndex = 1001,
			Text = "",
			Size = 9,
			Font = 3,
			Outline = true,
			Visible = false
		})

		local start_time = clock()
		local position = position

		local connection2 = nil

		local function destroy()
			red:Destroy()
			grenade:Destroy()
			text:Destroy()
			connection2:Disconnect()
		end

		local target_transparency = 0
		local last_lerp_change = clock()
		local visible = false

		local old_parent = part.Parent
		
		connection2 = utility.newConnection(rs.Heartbeat, function(dt)
			local hrp = lplr_parts["HumanoidRootPart"]
			if not hrp or not part or part.Parent ~= old_parent then
				destroy()
				return
			end

			local position = part.Position

			local top, _ = wtvp(camera, position + vector3new(0,1,0))
			local center, on_screen = wtvp(camera, position)

			if not on_screen then
				if visible then
					red["Visible"] = false
					grenade["Visible"] = false
					text["Visible"] = false
					visible = false
				end
				return
			end			

			visible = true

			red["Visible"] = true
			grenade["Visible"] = true
			text["Visible"] = true

			local size = (center.Y-top.Y)*1.8
			local distance = (hrp.Position - position).magnitude

			local screen_position = vector2new(center.X, center.Y) - vector2new(size/2,size/2)

			text["Text"] = tostring(clamp(round(2.1 - (clock()-start_time), 1), 0, 9999)).."s"
			text["Position"] = screen_position + vector2new(size/2 - text["TextBounds"]["X"]/2, size - text["TextBounds"]["Y"])
			local new = vector2new(size/1.8, size/1.8)
			grenade["Size"] = vector2new(size, size)
			grenade["Position"] = screen_position
			red["Size"] = grenade["Size"] + new
			red["Position"] = grenade["Position"] - new/2

			red["Transparency"] = lerp(red["Transparency"], target_transparency, dt*7)

			local transparency_multiplier = 1 - (distance > 20 and (clamp(distance-40, 0, 100)/50) or 0)

			text["Transparency"] = transparency_multiplier
			grenade["Transparency"] = transparency_multiplier
			
			if transparency_multiplier < 0 then
				red["Transparency"] = transparency_multiplier
			end

			if clock() - last_lerp_change > 0.4 then
				target_transparency = target_transparency == 1 and 0 or 1
				last_lerp_change = clock()
			end
		end)
		
	end)

	local grenadeAdded = LPH_NO_VIRTUALIZE(function(grenade)
		if grenade.Name == "Handle" then
			local color = grenade.Color

			if color == colorfromrgb(39, 70, 45) then
				spawn(newGrenadeWarning, grenade)
			end
		end
	end)

	utility.newConnection(menu_references["grenade_warnings"].onToggleChange, function(bool)
		if connection then 
			connection:Disconnect()
			connection = nil
		end
		connection = utility.newConnection(ignored_folder.ChildAdded, grenadeAdded)
	end)
end

do
	local face_backwards = LPH_NO_VIRTUALIZE(function(dt)
		local camera_pos = camera["CFrame"]["p"]
		local hrp_pos = lplr_pos["p"]
		lplr_pos=cframenew(hrp_pos,vector3new(camera_pos.x, hrp_pos["y"], camera_pos.z))
	end)

	utility.newConnection(menu_references["face_backwards"].onToggleChange, function(bool)
		if find(heartbeat_callbacks, face_backwards) then
			remove(heartbeat_callbacks, face_backwards)
		end
		if bool then
			insert(heartbeat_callbacks, face_backwards)
		end
	end)
end

do
	local multiplier = cframenew(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
	local doAspectRatio = LPH_NO_VIRTUALIZE(function()
		render_stepped:Wait()
		camera.CFrame*=multiplier
	end)

	utility.newConnection(menu_references["aspect_ratio_changer"].onToggleChange, function(bool)
		if find(heartbeat_callbacks, doAspectRatio) then
			remove(heartbeat_callbacks, doAspectRatio)
		end
		if bool then
			insert(heartbeat_callbacks, doAspectRatio)
		end
		menu_references["aspect_ratio_changer"]:setSliderVisibility(bool)
	end)
	menu_references["aspect_ratio_changer"]:setSliderVisibility(false)

	utility.newConnection(menu_references["aspect_ratio_changer"].onSliderChange, function(value)
		multiplier = cframenew(0, 0, 0, 1, 0, 0, 0, value/100, 0, 0, 0, 1)
	end)
end

do
	local last_update = clock()
	local last_freeze = clock()
	local freeze = false

	local old_positions = {}
	local last_updatez = clock()

	local doLag = LPH_NO_VIRTUALIZE(function()
		if clock()-last_updatez < 0.02 then
			return end

		last_updatez = clock()

		local humanoid = lplr_parts["Humanoid"]

		if not humanoid then
			return end

		if clock() - last_update > flags["animation_lag_value"]/150 then
			last_update = clock()
			delay(0, function()
				last_freeze = clock()
			end)
			freeze = false
		else
			freeze = true
		end

		for _, animation in humanoid:GetPlayingAnimationTracks() do
			if not freeze then
				old_positions[animation] = animation.TimePosition + clock() - last_freeze
			else
				animation.TimePosition = (old_positions[animation] or 0)
			end
		end
	end)

	utility.newConnection(menu_references["animation_lag"].onToggleChange, function(bool)
		last_update = clock()
		if find(heartbeat_callbacks, doLag) then
			remove(heartbeat_callbacks, doLag)
		end
		if bool then
			insert(heartbeat_callbacks, doLag)
		end
		menu_references["animation_lag"]:setSliderVisibility(bool)
	end)
	menu_references["animation_lag"]:setSliderVisibility(false)
end

do
	local velocityDesync = LPH_NO_VIRTUALIZE(function(dt, hrp)
		if not flags["velocity_desync_keybind"]["active"] then
			return end

		if not hrp then
			return end

		local old_velocity = hrp["Velocity"]
		local desync = flags["velocity_desync_value"][1]
		local random_value = flags["random_value"]*5.5

		hrp["Velocity"] = desync == "Zero" and vector3new() or desync == "Max" and vector3new(63536, 63536, 63536) or desync == "Sky" and vector3new(0,10000,0) or desync == "Multiplier" and old_velocity*flags["multiplier_value"] or desync == "Underground" and vector3new(0,-10000,0) or desync == "Random" and vector3new(mathrandom(-random_value, random_value), mathrandom(-random_value, random_value), mathrandom(-random_value, random_value))

		render_stepped:Wait()

		hrp["Velocity"] = old_velocity
	end)

	utility.newConnection(menu_references["velocity_desync"].onToggleChange, function(bool)
		if find(anti_callbacks, velocityDesync) then
			remove(anti_callbacks, velocityDesync)
		end
		if bool then
			insert(anti_callbacks, velocityDesync)
		end
		menu_references["velocity_desync"]:setDropdownVisibility(bool)
		local selected = flags["velocity_desync_value"][1]
		menu_references["random_value"]:setVisible(selected == "Random" and bool)
		menu_references["multiplier_value"]:setVisible(selected == "Multiplier" and bool)
	end)

	utility.newConnection(menu_references["velocity_desync"].onDropdownChange, function(selected)
		if not flags["velocity_desync"] then
			return end

		local selected = selected[1]
		menu_references["random_value"]:setVisible(selected == "Random")
		menu_references["multiplier_value"]:setVisible(selected == "Multiplier")
	end)
	menu_references["velocity_desync"]:setDropdownVisibility(false)
	menu_references["random_value"]:setVisible(false)
	menu_references["multiplier_value"]:setVisible(false)
end

do 
	local did_void_kill = nil
	local destroyCheaters = LPH_NO_VIRTUALIZE(function(_, hrp)
		if not hrp or not flags["destroy_cheaters_keybind"]["active"] then
			did_void_kill = nil
			return 
		end

		if not did_void_kill and flags["void_kill"] then
			local position = hrp["CFrame"]
			hrp["CFrame"] = cframenew(position.X,-485,position.Z)
			did_void_kill = true
			return
		end

		hrp["CFrame"]*=cframenew(9e9,0/0,math.huge)
	end)

	utility.newConnection(menu_references["destroy_cheaters"].onToggleChange, function(bool)
		if find(anti_callbacks, destroyCheaters) then
			remove(anti_callbacks, destroyCheaters)
		end
		if bool then
			insert(anti_callbacks, destroyCheaters)
		end
		menu_references["void_kill"]:setVisible(bool)
	end)
	menu_references["void_kill"]:setVisible(false)
end

do
	local randomTeleport = LPH_NO_VIRTUALIZE(function(dt, hrp)
		if not flags["random_teleport_keybind"]["active"] then
			return end
			
		if not hrp then
			return end

		local horizontal_offset = flags["horizontal_offset"]
		local vertical_offset = flags["vertical_offset"]

		hrp["CFrame"]-=vector3new(mathrandom(-horizontal_offset,horizontal_offset), mathrandom(-vertical_offset,vertical_offset), mathrandom(-horizontal_offset,horizontal_offset))
	end)

	utility.newConnection(menu_references["random_teleport"].onToggleChange, function(bool)
		if find(anti_callbacks, randomTeleport) then
			remove(anti_callbacks, randomTeleport)
		end
		if bool then
			insert(anti_callbacks, randomTeleport)
		end
		menu_references["horizontal_offset"]:setVisible(bool)
		menu_references["vertical_offset"]:setVisible(bool)
	end)
	menu_references["horizontal_offset"]:setVisible(false)
	menu_references["vertical_offset"]:setVisible(false)
end

do
	local client_side_pitch_connection = nil

	local function setClientSidePitch(bool)
		local head = lplr_parts["Head"]
		if head then
			local bool = bool == nil and flags["client_side_pitch"] or bool
			head.Neck.C1 = bool and cframenew(-5.98023249e-08, -0.499999285, -0.000272631645, 1, 0, 0, 0, 1, 0, 0, 0, 1)*angles(rad(flags["client_side_pitch_value"]),0,0) or cframenew(-5.98023249e-08, -0.499999285, -0.000272631645, 1, 0, 0, 0, 1, 0, 0, 0, 1)
		end
	end

	utility.newConnection(menu_references["client_side_pitch"].onToggleChange, function(bool)
		if client_side_pitch_connection then
			client_side_pitch_connection:Disconnect()
			client_side_pitch_connection = nil
		end
		if bool then
			client_side_pitch_connection = utility.newConnection(characterFullyLoaded, setClientSidePitch)
		end
		setClientSidePitch(bool)
		menu_references["client_side_pitch"]:setSliderVisibility(bool)
	end)

	utility.newConnection(menu_references["client_side_pitch"].onSliderChange, function(value)
		if not flags["client_side_pitch"] then
			return end

		local head = lplr_parts["Head"]
		if head then
			head.Neck.C1 = cframenew(-5.98023249e-08, -0.499999285, -0.000272631645, 1, 0, 0, 0, 1, 0, 0, 0, 1)*angles(rad(value),0,0)
		end
	end)

	menu_references["client_side_pitch"]:setSliderVisibility(false)
	end

do
	local renderMaterialHitCham = LPH_NO_VIRTUALIZE(function(player)
		local character = player.Character
		character.Archivable = true; local character_cloned = character:Clone(); character.Archivable = false
		local all_parts = character_cloned:GetChildren()
		
		local color = flags["hit_chams_color"]
		local transparency = flags["hit_chams_transparency"]
		local material = Enum.Material[flags["hit_chams_value"][1]]

		for i = 1, #all_parts do
			local part = all_parts[i]
			local name = part.Name
			if part.ClassName == "MeshPart" then
				part.Color = color
				part.Material = material
				part.Transparency = transparency
				part.CanCollide = false
				part.Anchored = true
				if name == "Head" then
					local decal = findfirstchild(part, "face")
					if decal then destroy(decal) end
				end
			else
				destroy(part)
			end	
		end
		
		if flags["hit_chams_only_last_hit"] then
			local old_model = lplr_data["hit_cham"]
			if old_model then
				destroy(old_model)
			end
		end

		lplr_data["hit_cham"] = character_cloned

		character_cloned.Name = "\0"
		character_cloned.Parent = ignored_folder

		wait(flags["hit_chams_lifetime"])

		if not character_cloned then
			return end

		if flags["hit_chams_fade_out"] then
			local new_parts = character_cloned:GetChildren()
			for i = 1, #new_parts do
				tween(new_parts[i], tween_info, {Transparency = 1})
			end
			wait(0.2)
		end

		if character_cloned then
			destroy(character_cloned)
		end
	end)

	local renderOutlineHitCham = LPH_NO_VIRTUALIZE(function(player)
		local character = player.Character
		character.Archivable = true; local character_cloned = character:Clone(); character.Archivable = false
		local all_parts = character_cloned:GetChildren()
		
		local color = flags["hit_chams_color"]
		local transparency = flags["hit_chams_transparency"]

		for i = 1, #all_parts do
			local part = all_parts[i]
			if part.ClassName == "MeshPart" then
				part.Transparency = 1
				part.CanCollide = false
				part.Anchored = true
				newObject("SelectionBox", {
					LineThickness = 0.01,
					Parent = part,
					Color3 = color,
					Transparency = transparency,
					Name = "\0",
					Adornee = part
				})
				if part.Name == "Head" then
					local decal = findfirstchild(part, "face")
					if decal then destroy(decal) end
				end
			else
				destroy(part)
			end	
		end

		if flags["hit_chams_only_last_hit"] then
			local old_model = lplr_data["hit_cham"]
			if old_model then
				destroy(old_model)
			end
		end

		lplr_data["hit_cham"] = character_cloned

		character_cloned.Name = "\0"
		character_cloned.Parent = ignored_folder

		wait(flags["hit_chams_lifetime"])

		if not character_cloned then
			return end

		if flags["hit_chams_fade_out"] then
			local new_parts = character_cloned:GetChildren()
			for i = 1, #new_parts do
				tween(new_parts[i]["\0"], tween_info, {Transparency = 1})
			end
			wait(0.2)
		end

		if character_cloned then
			destroy(character_cloned)
		end
	end)

	local connection = nil

	utility.newConnection(menu_references["hit_chams"].onToggleChange, function(bool)
		if connection then
			connection:Disconnect()
			connection = nil
		end
		if bool then
			connection = utility.newConnection(hitPlayer, flags["hit_chams_value"][1] == "Outline" and renderOutlineHitCham or renderMaterialHitCham)
		end
		menu_references["hit_chams_only_last_hit"]:setVisible(bool)
		menu_references["hit_chams"]:setDropdownVisibility(bool)
		menu_references["hit_chams_lifetime"]:setVisible(bool)
		menu_references["hit_chams_fade_out"]:setVisible(bool)
	end)

	utility.newConnection(menu_references["hit_chams"].onDropdownChange, function(selected)
		if not flags["hit_chams"] then
			return end

		if connection then
			connection:Disconnect()
			connection = nil
		end
		if flags["hit_chams"] then
			connection = utility.newConnection(hitPlayer, selected[1] == "Outline" and renderOutlineHitCham or renderMaterialHitCham)
		end
	end)

	menu_references["hit_chams_only_last_hit"]:setVisible(false)
	menu_references["hit_chams"]:setDropdownVisibility(false)
	menu_references["hit_chams_lifetime"]:setVisible(false)
	menu_references["hit_chams_fade_out"]:setVisible(false)
end

do
	local renderSkeleton = LPH_NO_VIRTUALIZE(function(player, character_parts)
		local positions = {}
		for i = 1, #part_list do
			local part = part_list[i]
			local object = character_parts[part] 
			if not object then
				return
			end
			positions[part] = object.Position
		end

		if flags["hit_skeleton_only_last_hit"] then
			local destroy = lplr_data["skeleton_hit"]
			if destroy then
				destroy()
				lplr_data["skeleton_hit"] = nil
			end
		end

		local drawings = {}
		local color = flags["hit_skeleton_color"]
		local transparency = -flags["hit_skeleton_transparency"]+1

		drawings["head_line"] = utility.newDrawing("Line", {
			Color = color,
			Transparency = transparency,
			Thickness = 1,
			ZIndex = 2,
			Visible = true
		})
		drawings["head_outline"] = utility.newDrawing("Line", {
			Color = colorfromrgb(0,0,0),
			Transparency = transparency,
			Thickness = 3,
			ZIndex = 1,
			Visible = true
		})
		
		drawings["torso_line"] = utility.newDrawing("Line", {
			Color = color,
			Transparency = transparency,
			Thickness = 1,
			ZIndex = 2,
			Visible = true
		})
		drawings["torso_outline"] = utility.newDrawing("Line", {
			Color = colorfromrgb(0,0,0),
			Transparency = transparency,
			Thickness = 3,
			ZIndex = 1,
			Visible = true
		})
		
		drawings["left_upper_arm_line"] = utility.newDrawing("Line", {
			Color = color,
			Transparency = transparency,
			Thickness = 1,
			ZIndex = 2,
			Visible = true
		})
		drawings["left_upper_arm_outline"] = utility.newDrawing("Line", {
			Color = colorfromrgb(0,0,0),
			Transparency = transparency,
			Thickness = 3,
			ZIndex = 1,
			Visible = true
		})
		
		drawings["right_upper_arm_line"] = utility.newDrawing("Line", {
			Color = color,
			Transparency = transparency,
			Thickness = 1,
			ZIndex = 2,
			Visible = true
		})
		drawings["right_upper_arm_outline"] = utility.newDrawing("Line", {
			Color = colorfromrgb(0,0,0),
			Transparency = transparency,
			Thickness = 3,
			ZIndex = 1,
			Visible = true
		})
		
		drawings["left_hand_line"] = utility.newDrawing("Line", {
			Color = color,
			Transparency = transparency,
			Thickness = 1,
			ZIndex = 2,
			Visible = true
		})
		drawings["left_hand_outline"] = utility.newDrawing("Line", {
			Color = colorfromrgb(0,0,0),
			Transparency = transparency,
			Thickness = 3,
			ZIndex = 1,
			Visible = true
		})
		
		drawings["right_hand_line"] = utility.newDrawing("Line", {
			Color = color,
			Transparency = transparency,
			Thickness = 1,
			ZIndex = 2,
			Visible = true
		})
		drawings["right_hand_outline"] = utility.newDrawing("Line", {
			Color = colorfromrgb(0,0,0),
			Transparency = transparency,
			Thickness = 3,
			ZIndex = 1,
			Visible = true
		})
		
		drawings["left_upper_leg_line"] = utility.newDrawing("Line", {
			Color = color,
			Transparency = transparency,
			Thickness = 1,
			ZIndex = 2,
			Visible = true
		})
		drawings["left_upper_leg_outline"] = utility.newDrawing("Line", {
			Color = colorfromrgb(0,0,0),
			Transparency = transparency,
			Thickness = 3,
			ZIndex = 1,
			Visible = true
		})
		
		drawings["right_upper_leg_line"] = utility.newDrawing("Line", {
			Color = color,
			Transparency = transparency,
			Thickness = 1,
			ZIndex = 2,
			Visible = true
		})
		drawings["right_upper_leg_outline"] = utility.newDrawing("Line", {
			Color = colorfromrgb(0,0,0),
			Transparency = transparency,
			Thickness = 3,
			ZIndex = 1,
			Visible = true
		})
		
		drawings["right_foot_line"] = utility.newDrawing("Line", {
			Color = color,
			Transparency = transparency,
			Thickness = 1,
			ZIndex = 2,
			Visible = true
		})
		drawings["right_foot_outline"] = utility.newDrawing("Line", {
			Color = colorfromrgb(0,0,0),
			Transparency = transparency,
			Thickness = 3,
			ZIndex = 1,
			Visible = true
		})
		
		drawings["left_foot_line"] = utility.newDrawing("Line", {
			Color = color,
			Transparency = transparency,
			Thickness = 1,
			ZIndex = 2,
			Visible = true
		})
		drawings["left_foot_outline"] = utility.newDrawing("Line", {
			Color = colorfromrgb(0,0,0),
			Transparency = transparency,
			Thickness = 3,
			ZIndex = 1,
			Visible = true
		})

		local old_pos = character_parts["HumanoidRootPart"].Position

		local visible = false

		local elapsed_time = 0
		local lifetime = flags["hit_skeleton_lifetime"]

		local connection2 = nil; 
		local stopped = false

		local function destroy()
			stopped = true
			connection2:Disconnect()
			delay(0, function()
				for _, drawing in drawings do
					drawing:Destroy()
					drawings[_] = nil
				end
			end)
		end

		connection2 = utility.newConnection(rs.Heartbeat, function(dt)
			if stopped then
				return end

			local _, on_screen = wtvp(camera, old_pos)

			if not on_screen then
				if visible then
					for _, drawing in drawings do
						drawing["Visible"] = false
					end
					visible = false
				end
				return
			elseif not visible then
				for _, drawing in drawings do
					drawing["Visible"] = true
				end
				visible = true
			end

			elapsed_time+=dt

			if elapsed_time > lifetime then
				if flags["hit_skeleton_fade_out"] then
					local new_transparency = lerp(transparency, 0, (elapsed_time-lifetime)/0.2)
					for _, drawing in drawings do
						drawing["Transparency"] = new_transparency
					end
					if elapsed_time-lifetime > 0.2 then
						destroy()
					end
				else
					destroy()
				end				
			end

			local upper_pos, _ = wtvp(camera, old_pos + vector3new(0,0.5,0)) 
			local lower_pos, _ = wtvp(camera, positions["LowerTorso"]) 
			
			local torso_line = drawings["torso_line"]
			local torso_outline = drawings["torso_outline"]
			
			torso_line["From"] = vector2new(upper_pos.X, upper_pos.Y)
			torso_outline["From"] = torso_line["From"]
			torso_line["To"] = vector2new(lower_pos.X, lower_pos.Y)
			torso_outline["To"] = torso_line["To"]
			
			local left_upper_arm, _ = wtvp(camera, positions["LeftUpperArm"]) 
			
			local left_upper_arm_line = drawings["left_upper_arm_line"]
			local left_upper_arm_outline = drawings["left_upper_arm_outline"]
			
			left_upper_arm_line["From"] = torso_line["From"]
			left_upper_arm_outline["From"] = left_upper_arm_line["From"]
			left_upper_arm_line["To"] = vector2new(left_upper_arm.X, left_upper_arm.Y)
			left_upper_arm_outline["To"] = left_upper_arm_line["To"]
			
			local right_upper_arm, _ = wtvp(camera, positions["RightUpperArm"]) 
			
			local right_upper_arm_line = drawings["right_upper_arm_line"]
			local right_upper_arm_outline = drawings["right_upper_arm_outline"]
			
			right_upper_arm_line["From"] = torso_line["From"]
			right_upper_arm_outline["From"] = right_upper_arm_line["From"]
			right_upper_arm_line["To"] = vector2new(right_upper_arm.X, right_upper_arm.Y)
			right_upper_arm_outline["To"] = right_upper_arm_line["To"]
			
			local left_hand, _ = wtvp(camera, positions["LeftHand"]) 
			
			local left_hand_line = drawings["left_hand_line"]
			local left_hand_outline = drawings["left_hand_outline"]
			
			left_hand_line["From"] = left_upper_arm_line["To"]
			left_hand_outline["From"] = left_hand_line["From"]
			left_hand_line["To"] = vector2new(left_hand.X, left_hand.Y)
			left_hand_outline["To"] = left_hand_line["To"]
			
			local right_hand, _ = wtvp(camera, positions["RightHand"]) 
			
			local right_hand_line = drawings["right_hand_line"]
			local right_hand_outline = drawings["right_hand_outline"]
			
			right_hand_line["From"] = right_upper_arm_line["To"]
			right_hand_outline["From"] = right_hand_line["From"]
			right_hand_line["To"] = vector2new(right_hand.X, right_hand.Y)
			right_hand_outline["To"] = right_hand_line["To"]
			
			local left_upper_leg, _ = wtvp(camera, positions["LeftUpperLeg"]) 
			
			local left_upper_leg_line = drawings["left_upper_leg_line"]
			local left_upper_leg_outline = drawings["left_upper_leg_outline"]
			
			left_upper_leg_line["From"] = torso_line["To"]
			left_upper_leg_outline["From"] = left_upper_leg_line["From"]
			left_upper_leg_line["To"] = vector2new(left_upper_leg.X, left_upper_leg.Y)
			left_upper_leg_outline["To"] = left_upper_leg_line["To"]
			
			local right_upper_leg, _ = wtvp(camera, positions["RightUpperLeg"]) 
			
			local right_upper_leg_line = drawings["right_upper_leg_line"]
			local right_upper_leg_outline = drawings["right_upper_leg_outline"]
			
			right_upper_leg_line["From"] = torso_line["To"]
			right_upper_leg_outline["From"] = right_upper_leg_line["From"]
			right_upper_leg_line["To"] = vector2new(right_upper_leg.X, right_upper_leg.Y)
			right_upper_leg_outline["To"] = right_upper_leg_line["To"]
			
			local left_foot, _ = wtvp(camera, positions["LeftFoot"]) 
			
			local left_foot_line = drawings["left_foot_line"]
			local left_foot_outline = drawings["left_foot_outline"]
			
			left_foot_line["From"] = left_upper_leg_line["To"]
			left_foot_outline["From"] = left_foot_line["From"]
			left_foot_line["To"] = vector2new(left_foot.X, left_foot.Y)
			left_foot_outline["To"] = left_foot_line["To"]
			
			local right_foot, _ = wtvp(camera, positions["RightFoot"]) 
			
			local right_foot_line = drawings["right_foot_line"]
			local right_foot_outline = drawings["right_foot_outline"]
			
			right_foot_line["From"] = right_upper_leg_line["To"]
			right_foot_outline["From"] = right_foot_line["From"]
			right_foot_line["To"] = vector2new(right_foot.X, right_foot.Y)
			right_foot_outline["To"] = right_foot_line["To"]
			
			local head, _ = wtvp(camera, positions["Head"]) 
			
			local head_line = drawings["head_line"]
			local head_outline = drawings["head_outline"]
			
			head_line["From"] = torso_line["From"]
			head_outline["From"] = head_line["From"]
			head_line["To"] = vector2new(head.X, head.Y)
			head_outline["To"] = head_line["To"]
		end)

		lplr_data["skeleton_hit"] = destroy

	end)

	local connection = nil

	utility.newConnection(menu_references["hit_skeleton"].onToggleChange, function(bool)
		if connection then
			connection:Disconnect()
			connection = nil
		end
		if bool then
			connection = utility.newConnection(hitPlayer, renderSkeleton)
		end
		menu_references["hit_skeleton_only_last_hit"]:setVisible(bool)
		menu_references["hit_skeleton_lifetime"]:setVisible(bool)
		menu_references["hit_skeleton_fade_out"]:setVisible(bool)
	end)


	menu_references["hit_skeleton_only_last_hit"]:setVisible(false)
	menu_references["hit_skeleton_lifetime"]:setVisible(false)
	menu_references["hit_skeleton_fade_out"]:setVisible(false)
end

do
	local stop = false
	local doMacro = LPH_NO_VIRTUALIZE(function()
		if stop then
			return end
			
		stop = true

		keypress("0x49")
		wait() 
		wait() 
		keyrelease("0x49")
		wait() 
		wait() 
		keypress("0x4F")
		wait() 
		wait() 
		keyrelease("0x4F")
		wait() 
		wait() 

		stop = false
	end)

	utility.newConnection(menu_references["macro"].onActiveChange, function(bool)
		if find(heartbeat_callbacks, doMacro) then
			remove(heartbeat_callbacks, doMacro)
		end
		if bool then
			insert(heartbeat_callbacks, doMacro)
		end
	end)
end

do
	local renderDamageNumber = LPH_NO_VIRTUALIZE(function(player, parts, damage)
		local head = parts["Head"]
	
		if not head then
			return
		end
	
		local text = utility.newDrawing("Text", {
			Size = 12,
			Font = 2,
			Text = "-"..tostring(damage),
			Visible = false,
			Outline = true,
			Transparency = -flags["damage_number_transparency"]+1,
			Color = flags["damage_number_color"]
		})
	
		local position = head["Position"]
		local value = 0
		local old_value = text["Transparency"]

		local lifetime = flags["damage_number_lifetime"]
		local do_float = flags["damage_number_value"][1] == "Float"
	
		local elapsed_time = 0
		local connection = utility.newConnection(rs.Heartbeat, function(dt)
			elapsed_time+=dt
			local pos, on_screen = wtvp(camera, position)
			if on_screen then
				text["Position"] = vector2new(pos.X, pos.Y - (flags["hit_marker"] and 11 or 0))
				text["Visible"] = true
			else
				text["Visible"] = false
			end
	
			if elapsed_time > lifetime then
				text["Transparency"] = old_value + (value-old_value)*getValue(tws, ((elapsed_time-lifetime) / 0.2), Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
			end

			if do_float then
				position+=vector3new(0,2.1*((4 * getValue(tws, (elapsed_time/lifetime), Enum.EasingStyle.Quad, Enum.EasingDirection.Out))*dt),0)
			end
		end)

		wait(lifetime+0.2)

		connection:Disconnect()
		text:Destroy()
	end)

	local connection = nil

	utility.newConnection(menu_references["damage_number"].onToggleChange, function(bool)
		if connection then
			connection:Disconnect()
			connection = nil
		end
		if bool then
			connection = utility.newConnection(hitPlayer, renderDamageNumber)
		end
		menu_references["damage_number"]:setDropdownVisibility(bool)
		menu_references["damage_number_lifetime"]:setVisible(bool)
	end)
	menu_references["damage_number"]:setDropdownVisibility(false)
	menu_references["damage_number_lifetime"]:setVisible(false)
end

do
	local updateBodyMaterial = LPH_NO_VIRTUALIZE(function(parts)
		local humanoid = parts["Humanoid"]

		if not humanoid then
			return end
	
		local humanoid_description = humanoid.HumanoidDescription
	
		if not humanoid_description then
			return end
		
		local char = humanoid.Parent

		local bool = flags["body_material"]
		local material = bool and Enum.Material[flags["body_material_value"][1]] or Enum.Material.Plastic
		local color = flags["body_material_color"]
		local transparency = flags["body_material_transparency"]
		local parent = bool and humanoid or char
		for name, part in parts do
			if name == "[CarHitBox]" then
				continue end
				
			if name ~= "HumanoidRootPart" and part:IsA("BasePart") then
				part.Material = material
				part.Color = bool and color or (limb_descriptions[name] and humanoid_description[limb_descriptions[name]] or colorfromrgb(163, 162, 165))
				part.Transparency = bool and transparency or 0

				if name == "Head" then
					local decal = findfirstchildofclass(part, "Decal")
					if decal then
						decal.Parent = bool and humanoid or part
					end
				end
			elseif name == "Pants" then
				part.Parent = parent
			elseif name == "Shirt" then
				part.Parent = parent
			elseif name == "Shirt Graphic" then
				part.Parent = parent
			end 
		end
		if not bool then
			local shirt = findfirstchild(humanoid, "Shirt")

			if shirt then
				shirt.Parent = char
			end

			local pants = findfirstchild(humanoid, "Pants")

			if pants then
				pants.Parent = char
			end

			local t_shirt = findfirstchild(humanoid, "Shirt Graphic")

			if t_shirt then
				t_shirt.Parent = char
			end

			local decal = findfirstchildofclass(humanoid, "Decal")

			if decal then
				local head = parts["Head"]
				if head then
					decal.Parent = head
				end
			end
		end
	end)

	utility.newConnection(menu_references["body_material"].onToggleChange, function(bool)
		for player, data in player_data do
			delay(0, updateBodyMaterial, data["character_parts"])
		end
		menu_references["body_material"]:setDropdownVisibility(bool)
	end)

	utility.newConnection(menu_references["body_material"].onDropdownChange, function()
		if not flags["body_material"] then
			return end

		for player, data in player_data do
			delay(0, updateBodyMaterial, data["character_parts"])
		end
	end)


	utility.newConnection(menu_references["body_material"].onColorChange, function()
		if not flags["body_material"] then
			return end

		for player, data in player_data do
			delay(0, updateBodyMaterial, data["character_parts"])
		end
	end)

	menu_references["body_material"]:setDropdownVisibility(false)
end

do
	local updateHatsMaterial = LPH_NO_VIRTUALIZE(function(parts)
		local bool = flags["forcefield_hats_2"]
		local color = bool and flags["forcefield_hats_2_color"] or colorfromrgb(163, 162, 165)
		local transparency = bool and flags["forcefield_hats_2_transparency"] or 0
		local material = bool and Enum.Material.ForceField or Enum.Material.Plastic
		for _, accessory in parts do
			if accessory["ClassName"] == "Accessory" then
				local part = findfirstchild(accessory, "Handle")
				if part then
					part["Transparency"] = transparency
					part["Material"] = material
					part["Color"] = color
				end
			end
		end
	end)

	utility.newConnection(menu_references["forcefield_hats_2"].onToggleChange, function(bool)
		for player, data in player_data do
			delay(0, updateHatsMaterial, data["character_parts"])
		end
	end)

	utility.newConnection(menu_references["forcefield_hats_2"].onColorChange, function()
		if not flags["forcefield_hats_2"] then
			return end

		for player, data in player_data do
			delay(0, updateHatsMaterial, data["character_parts"])
		end
	end)
end

utility.newConnection(menu_references["no_void_kill"].onToggleChange, function(bool)
	workspace.FallenPartsDestroyHeight = bool and -9e9 or -500
end)

do
	local doHitsound = LPH_NO_VIRTUALIZE(function()
		local path = "juju/assets/"..flags["hit_sound_id"]

		destroy(newObject("Sound", {
			SoundId = flags["hit_sound_value"][1] == "Custom" and (isfile(path) and getcustomasset(path, false) or flags["hit_sound_id"]) or sounds[flags["hit_sound_value"][1]],
			Volume = flags["hit_sound_volume"]/20,
			Name = "\0",
			PlayOnRemove = true,
			Parent = cg
		}))
	end)

	local connection = nil

	utility.newConnection(menu_references["hit_sound"].onToggleChange, function(bool)
		if connection then
			connection:Disconnect()
			connection = nil
		end
		if bool then
			connection = utility.newConnection(hitPlayer, doHitsound)
		end
		menu_references["hit_sound"]:setDropdownVisibility(bool)
		menu_references["hit_sound_id"]:setVisible(bool and flags["hit_sound_value"][1] == "Custom")
		menu_references["hit_sound_volume"]:setVisible(bool)
	end)

	utility.newConnection(menu_references["hit_sound"].onDropdownChange, function(selected)
		if not flags["hit_sound"] then
			return end

		menu_references["hit_sound_id"]:setVisible(selected[1] == "Custom")
	end)
	menu_references["hit_sound"]:setDropdownVisibility(false)
	menu_references["hit_sound_id"]:setVisible(false)
	menu_references["hit_sound_volume"]:setVisible(false)
end

do
	local offsets = {
		vector2new(1,1),
		vector2new(-1,1),
		vector2new(1,-1),
		vector2new(-1,-1)
	}	
	
	local render2DHitmarker = LPH_NO_VIRTUALIZE(function(player)
		local hitmarker = {}
		
		for i = 1, 4 do
			hitmarker[i] = {
				outline = utility.newDrawing("Line", {
					Thickness = 3,
					ZIndex = 1,
					Transparency = 1,
					Visible = true,
					Color = colorfromrgb(0,0,0)
				}),
				line = utility.newDrawing("Line", {
					Thickness = 1,
					ZIndex = 2,
					Transparency = 1,
					Visible = true,
					Color = flags["hit_marker_color"]
				})
			}
		end
	
		local time_elapsed = 0

		local connection = utility.newConnection(rs.Heartbeat, function(dt)
			time_elapsed+=dt
			local mouse_pos = getMouseLocation(uis)
			local tween_value = 0

			if time_elapsed > 0.6 then
				tween_value = getValue(tws, ((time_elapsed-0.6) / .12), Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
			end

			for i = 1, 4 do
				local lines = hitmarker[i]
				local outline = lines.outline
				local line = lines.line
				local offset = offsets[i]
				local offset_pos = offset * 5

				line.Visible = true
				outline.Visible = true
				line.From = mouse_pos + offset_pos
				line.To = line.From + offset * 4
				line.Transparency = 1-tween_value
				outline.Transparency = 1-tween_value
				outline.From = line.From
				outline.To = line.To
			end
		end)
	
		wait(0.73)
	
		for _, info in hitmarker do
			for _, drawing in info do
				drawing:Destroy()
				info[_] = nil
			end
		end
	
		connection:Disconnect()
	end)

	local render3DHitmarker = LPH_NO_VIRTUALIZE(function(player)
		local hrp = player_data[player]["character_parts"]["HumanoidRootPart"]

		if not hrp then
			return end

		local position = hrp["Position"]

		local hitmarker = {}
		
		for i = 1, 4 do
			hitmarker[i] = {
				outline = utility.newDrawing("Line", {
					Thickness = 3,
					ZIndex = 1,
					Color = colorfromrgb(0,0,0)
				}),
				line = utility.newDrawing("Line", {
					Thickness = 1,
					ZIndex = 2,
					Color = flags["hit_marker_color"]
				})
			}
		end
	
		local time_elapsed = 0

		local connection = nil; connection = utility.newConnection(rs.Heartbeat, function(dt)
			time_elapsed+=dt
			local position_on_screen, on_screen = wtvp(camera, position)
			if on_screen and hitmarker then
				local mouse_pos = vector2new(position_on_screen.X, position_on_screen.Y)
				local tween_value = 0
				if time_elapsed > 0.6 then
					tween_value = getValue(tws, ((time_elapsed-0.6) / .12), Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
				end

				for i = 1, 4 do
					local lines = hitmarker[i]
					local outline = lines.outline
					local line = lines.line
					local offset = offsets[i]
					local offset_pos = offset * 5

					line.Visible = true
					outline.Visible = true
					line.From = mouse_pos + offset_pos
					line.To = line.From + offset * 4
					line.Transparency = 1-tween_value
					outline.Transparency = 1-tween_value
					outline.From = line.From
					outline.To = line.To
				end
			else
				connection:Disconnect()
				delay(function()
					if hitmarker then
						for _, info in hitmarker do
							for _, drawing in info do
								drawing:Destroy()
								info[_] = nil
							end
						end
						hitmarker = nil
					end
				end)
			end
		end)
	
		wait(0.73)
	
		if connection and hitmarker then
			for _, info in hitmarker do
				for _, drawing in info do
					drawing:Destroy()
					info[_] = nil
				end
			end
		
			connection:Disconnect()
		end
	end)

	local connection = nil

	utility.newConnection(menu_references["hit_marker"].onToggleChange, function(bool)
		menu_references["hit_marker"]:setDropdownVisibility(bool)
		if connection then
			connection:Disconnect()
			connection = nil
		end
		if bool then
			connection = utility.newConnection(hitPlayer, flags["hit_marker_value"][1] == "3D" and render3DHitmarker or render2DHitmarker)
		end
	end)

	utility.newConnection(menu_references["hit_marker"].onDropdownChange, function(selected)
		if not flags["hit_marker"] then
			return end

		if connection then
			connection:Disconnect()
			connection = nil
		end
		connection = utility.newConnection(hitPlayer, selected[1] == "3D" and render3DHitmarker or render2DHitmarker)
	end)
	menu_references["hit_marker"]:setDropdownVisibility(false)
end

do
	local antiStomp = LPH_NO_VIRTUALIZE(function()
		local humanoid = lplr_parts["Humanoid"]

		if humanoid then
			humanoid.Health = 0
		end
	end)

	local anti_stomp_connection = nil

	utility.newConnection(menu_references["anti_stomp"].onToggleChange, function(bool)
		if anti_stomp_connection then
			anti_stomp_connection:Disconnect()
			anti_stomp_connection = nil
		end
		if bool then 
			anti_stomp_connection = utility.newConnection(localPlayerKnocked, antiStomp)
		end
	end)
end

do
	utility.newConnection(menu_references["desynced_position"].onToggleChange, function(bool)
		local model = lplr_data["desynced_position"]
		if model then
			destroy(model)
			lplr_data["desynced_position"] = nil
		end
		menu_references["desynced_position_highlight"]:setVisible(bool)
		menu_references["desynced_position"]:setDropdownVisibility(bool)
		menu_references["desynced_position_outline"]:setVisible(bool and flags["desynced_position_highlight"])
		if bool then
			if char then
				local color = flags["desynced_position_color"]
				local material = Enum.Material[flags["desynced_position_value"][1]]
				local transparency = flags["desynced_position_transparency"]
		
				char.Archivable = true; local model = char:Clone(); char.Archivable = false
		
				local all_parts = model:GetChildren()
				model.Archivable = true
		
				for i = 1, #all_parts do
					local part = all_parts[i]
					if part.ClassName == "MeshPart" then
						part.Color = color
						part.Material = material
						part.Transparency = transparency
						part.CanCollide = false
						part.Anchored = true
						if part.Name == "Head" then
							local decal = findfirstchild(part, "face")
							if decal then destroy(decal) end
						end
					else
						destroy(part)
					end	
				end
		
				lplr_data["desynced_position"] = model

				model["Parent"] = #anti_callbacks <= 1 and cg or ignored_folder

				if flags["desynced_position_highlight"] then
					delay(0, newObject, "Highlight", {
						Adornee = model,
						Enabled = true,
						OutlineColor = flags["desynced_position_outline_color"],
						OutlineTransparency = flags["desynced_position_outline_transparency"],
						FillColor = flags["desynced_position_highlight_color"],
						FillTransparency = flags["desynced_position_highlight_transparency"],
						Parent = model,
					})
				end
			end
		end
	end)

	utility.newConnection(menu_references["desynced_position"].onColorChange, function(color, transparency)
		if not flags["desynced_position"] then
			return end

		local all_parts = lplr_data["desynced_position"]:GetChildren()
	
		for i = 1, #all_parts do
			local part = all_parts[i]
			if part.ClassName == "MeshPart" then
				part.Color = color
				part.Transparency = transparency
			end	
		end
	end)

	utility.newConnection(menu_references["desynced_position"].onDropdownChange, function(selected)
		if not flags["desynced_position"] then
			return end

		local all_parts = lplr_data["desynced_position"]:GetChildren()
		local material = Enum.Material[selected[1]]
		for i = 1, #all_parts do
			local part = all_parts[i]
			if part.ClassName == "MeshPart" then
				part.Material = material
			end	
		end
	end)

	utility.newConnection(menu_references["desynced_position_highlight"].onColorChange, function(color, transparency)
		if not flags["desynced_position"] then
			return end

		local highlight = findfirstchildofclass(lplr_data["desynced_position"], "Highlight")

		if highlight then
			highlight["FillColor"] = color
			highlight["FillTransparency"] = transparency
		end
	end)

	utility.newConnection(menu_references["desynced_position_outline"].onColorChange, function(color, transparency)
		if not flags["desynced_position"] then
			return end

		local highlight = findfirstchildofclass(lplr_data["desynced_position"], "Highlight")

		if highlight then
			highlight["OutlineColor"] = color
			highlight["OutlineTransparency"] = transparency
		end
	end)

	utility.newConnection(menu_references["desynced_position_highlight"].onToggleChange, function(bool)
		menu_references["desynced_position_outline"]:setVisible(bool and flags["desynced_position"])

		if not flags["desynced_position"] then
			return end

		local model = lplr_data["desynced_position"]
		local highlight = findfirstchildofclass(model, "Highlight")
		if highlight then
			destroy(highlight)
		end
		if bool then
			newObject("Highlight", {
				Adornee = model,
				Enabled = true,
				OutlineColor = flags["desynced_position_outline_color"],
				OutlineTransparency = flags["desynced_position_outline_transparency"],
				FillColor = flags["desynced_position_highlight_color"],
				FillTransparency = flags["desynced_position_highlight_transparency"],
				Parent = model,
			})
		end
	end)
	menu_references["desynced_position_highlight"]:setVisible(false)
	menu_references["desynced_position"]:setDropdownVisibility(false)
	menu_references["desynced_position_outline"]:setVisible(false)
end

do
	local connection = nil

	local use = "GetChildren"
	local doNoclip = LPH_NO_VIRTUALIZE(function()
		for _, part in char[use](char) do
			local class_name = part.ClassName
			if class_name == "Part" or class_name == "MeshPart" then
				part.CanCollide = false
			end
		end
	end)

	utility.newConnection(menu_references["noclip"].onToggleChange, function(bool)
		if connection then
			connection:Disconnect()
		end
		if bool then
			connection = utility.newConnection(rs.Stepped, doNoclip)
		end
		menu_references["prevent_fling"]:setVisible(bool)
	end)
	menu_references["prevent_fling"]:setVisible(false)
	
	utility.newConnection(menu_references["prevent_fling"].onToggleChange, function(bool)
		use = bool and "GetDescendants" or "GetChildren"
	end)
end

do
	local particle_part = newObject("Part", {
		Size = vector3new(0.01,0.01,0.01),
		Transparency = 1,
		CanCollide = false,
		Anchored = true,
		Parent = cg
	})
	
	newObject("ParticleEmitter", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0.784314,0.411765,1)),ColorSequenceKeypoint.new(1,Color3.new(0.784314,0.411765,1))};
		Lifetime = NumberRange.new(0.5,0.5);
		LightEmission = 1;
		LockedToPart = true;
		Enabled = false;
		Orientation = Enum.ParticleOrientation.VelocityPerpendicular;
		Rate = 0;
		Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,10,0)};
		Speed = NumberRange.new(1.5,1.5);
		Texture = [[rbxassetid://1084991215]];
		Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.0996047,0,0),NumberSequenceKeypoint.new(0.602372,0,0),NumberSequenceKeypoint.new(1,1,0)};
		ZOffset = 1;
		Name = "bubble1";
		Parent = particle_part
	})
	
	newObject("ParticleEmitter", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0.784314,0.411765,1)),ColorSequenceKeypoint.new(1,Color3.new(0.784314,0.411765,1))};
		Lifetime = NumberRange.new(0.5,0.5);
		LightEmission = 1;
		LockedToPart = true;
		Enabled = false;
		Rate = 0;
		Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,10,0)};
		Speed = NumberRange.new(0,0);
		Texture = [[rbxassetid://1084991215]];
		Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.0996047,0,0),NumberSequenceKeypoint.new(0.601581,0,0),NumberSequenceKeypoint.new(1,1,0)};
		ZOffset = 1;
		Name = "bubble2";
		Parent = particle_part
	})
	
	newObject("ParticleEmitter", {
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0,0,0)),ColorSequenceKeypoint.new(1,Color3.new(0,0,0))};
		Lifetime = NumberRange.new(0.2,0.5);
		LockedToPart = true;
		Orientation = Enum.ParticleOrientation.VelocityParallel;
		Rate = 0;
		Enabled = false;
		Rotation = NumberRange.new(-90,90);
		Size = NumberSequence.new{NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(1,8.5,1.5)};
		Speed = NumberRange.new(0.1,0.1);
		SpreadAngle = vector2new(180,180);
		Texture = [[http://www.roblox.com/asset/?id=6820680001]];
		Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.200791,0,0),NumberSequenceKeypoint.new(0.699605,0,0),NumberSequenceKeypoint.new(1,1,0)};
		ZOffset = 1.5;
		Name = "bubble3";
		Parent = particle_part
	})
	
	newObject("ParticleEmitter", {
		Acceleration = vector3new(0,-50,0);
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(1,0.999969,0.999985)),ColorSequenceKeypoint.new(0.25,Color3.new(0.333333,1,0)),ColorSequenceKeypoint.new(1,Color3.new(0.333333,1,0.498039))};
		Lifetime = NumberRange.new(0.5,1);
		LightEmission = 1;
		Enabled = false;
		Orientation = Enum.ParticleOrientation.VelocityParallel;
		Rate = 0;
		Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0.6,0),NumberSequenceKeypoint.new(0.5,0.6,0),NumberSequenceKeypoint.new(1,0,0)};
		Speed = NumberRange.new(15,15);
		SpreadAngle = vector2new(50,-50);
		Texture = [[http://www.roblox.com/asset/?id=18540695516]];
		Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.5,0,0),NumberSequenceKeypoint.new(1,1,0)};
		Name = "sparks";
		Parent = particle_part
	})

	newObject("ParticleEmitter", {
		Acceleration = vector3new(0,-50,0);
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(1,0.384314,0.498039)),ColorSequenceKeypoint.new(1,Color3.new(1,0.384314,0.498039))};
		Lifetime = NumberRange.new(0.75,1);
		LightEmission = 0.625;
		Rate = 0;
		Enabled = false;
		RotSpeed = NumberRange.new(-180,180);
		Rotation = NumberRange.new(-180,180);
		Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.025,1.75,0.5),NumberSequenceKeypoint.new(1,3.5,1)};
		Speed = NumberRange.new(25,27.5);
		SpreadAngle = vector2new(7.5,7.5);
		Texture = [[rbxassetid://304113188]];
		Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.025,0,0),NumberSequenceKeypoint.new(0.9,0,0),NumberSequenceKeypoint.new(1,1,0)};
		Name = "lava";
		Parent = particle_part
	})

	newObject("ParticleEmitter", {
		Acceleration = vector3new(0,-25,0),
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0.666667,1,1)),ColorSequenceKeypoint.new(1,Color3.new(0,0.333333,1))},
		Enabled = false,
		FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4,
		FlipbookMode = Enum.ParticleFlipbookMode.OneShot,
		Lifetime = NumberRange.new(0.5,0.5),
		LightEmission = 0.5,
		LightInfluence = 1,
		Orientation = Enum.ParticleOrientation.VelocityParallel,
		Rate = 0,
		Shape = Enum.ParticleEmitterShape.Sphere,
		Size = NumberSequence.new{NumberSequenceKeypoint.new(0,2.19,0),NumberSequenceKeypoint.new(0.891,3.65,0),NumberSequenceKeypoint.new(1,0,0)},
		Speed = NumberRange.new(10,50),
		SpreadAngle = vector2new(25,25),
		Squash = NumberSequence.new{NumberSequenceKeypoint.new(0,-1,0),NumberSequenceKeypoint.new(1,0,0)},
		Texture = [[rbxassetid://11163755167]],
		Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,1,0)},
		Name = "air",
		Parent = particle_part
	})

	newObject("ParticleEmitter", {
		Acceleration = vector3new(0,-50,0),
		Enabled = false,
		Lifetime = NumberRange.new(1,1),
		LightEmission = 0.25,
		LightInfluence = 1,
		Orientation = Enum.ParticleOrientation.VelocityParallel,
		Rate = 100,
		RotSpeed = NumberRange.new(-360,360),
		Rotation = NumberRange.new(-360,360),
		Shape = Enum.ParticleEmitterShape.Sphere,
		Speed = NumberRange.new(25,50),
		SpreadAngle = vector2new(25,25),
		Texture = [[rbxassetid://15580169769]],
		Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,1,0)},
		Name = "air2",
		Parent = particle_part
	})

	newObject("ParticleEmitter", {
		Acceleration = vector3new(0,-6,0),
		Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0.258824,0.780392,1)),ColorSequenceKeypoint.new(1,Color3.new(0.298039,0.45098,1))},
		Enabled = false,
		Lifetime = NumberRange.new(0.5,1),
		LightEmission = 0.5,
		Rate = 0,
		RotSpeed = NumberRange.new(500,500),
		Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0.4,0),NumberSequenceKeypoint.new(0.0997506,0.515,0),NumberSequenceKeypoint.new(1,0,0)},
		SpreadAngle = vector2new(50,50),
		Parent = particle_part,
		Name = "bits"
	})

	newObject("ParticleEmitter", {
		Drag = 1,
		Enabled = false,
		FlipbookFramerate = NumberRange.new(3,3),
		FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4,
		FlipbookMode = Enum.ParticleFlipbookMode.OneShot,
		Lifetime = NumberRange.new(0.67,0.67),
		LightEmission = -5,
		RotSpeed = NumberRange.new(-10,10),
		Rotation = NumberRange.new(-1000,1000),
		Size = NumberSequence.new{NumberSequenceKeypoint.new(0,3,0),NumberSequenceKeypoint.new(1,3,0)},
		Speed = NumberRange.new(0,0),
		SpreadAngle = vector2new(-1000,1000),
		Texture = [[rbxassetid://11517935503]],
		Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(1,1,0)},
		Parent = particle_part,
		Name = "flame"
	})
	
	local hit_particles = {
		["Bubble"] = {
			{
				"bubble1",
				"bubble2",
				"bubble3"
			},
			1,
			false
		},
		["Sparks"] = {
			{
				"sparks"
			},
			30,
			false
		},
		["Air"] = {
			{
				"air",
				"air2"
			},
			15,
			false
		},
		["Splash"] = {
			{
				"splash"
			},
			7,
			false
		},
		["Bits"] = {
			{
				"bits"
			},
			9,
			false
		},
		["Flame"] = {
			{
				"flame"
			},
			1,
			false
		}
	}

	local renderHitParticle = LPH_NO_VIRTUALIZE(function(player, parts)
		local hit_particle = hit_particles[flags["hit_particle_value"][1]]
		particle_part.CFrame = parts["HumanoidRootPart"]["CFrame"]
		for _, particle in hit_particle[1] do
			particle_part[particle]:Emit(hit_particle[2])
		end
	end)

	local connection = nil

	utility.newConnection(menu_references["hit_particle"].onToggleChange, function(bool)
		if connection then
			connection:Disconnect()
			connection = nil
		end
		if bool then
			connection = utility.newConnection(hitPlayer, renderHitParticle)
		end
		particle_part["Parent"] = bool and ignored_folder or cg
		menu_references["hit_particle"]:setDropdownVisibility(bool)
	end)

	utility.newConnection(menu_references["hit_particle"].onColorChange, function(color)
		for _, emitter in particle_part:GetDescendants() do
			if emitter["ClassName"] == "ParticleEmitter" then
				emitter["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.00, color), ColorSequenceKeypoint.new(1.00, color)}
			end
		end
	end)

	for _, emitter in particle_part:GetDescendants() do
		if emitter["ClassName"] == "ParticleEmitter" then
			emitter["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.00, colorfromrgb(255,255,255)), ColorSequenceKeypoint.new(1.00, colorfromrgb(255,255,255))}
		end
	end
	menu_references["hit_particle"]:setDropdownVisibility(false)
end

do
	local aura_part = newObject("Part", {
		Size = vector3new(0.01,0.01,0.01),
		Transparency = 1,
		CanCollide = false,
		Anchored = true,
		Parent = cg
	})

	local auras = {
		["Swirl"] = {
			{
				Brightness = 10,
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0.101961,1,0.101961)),ColorSequenceKeypoint.new(1,Color3.new(0.101961,1,0.101961))},
				Lifetime = NumberRange.new(1,1),
				LightEmission = 0.4000000059604645,
				LockedToPart = true,
				Orientation = Enum.ParticleOrientation.VelocityPerpendicular,
				Rate = 10,
				RotSpeed = NumberRange.new(200,400),
				Rotation = NumberRange.new(-180,180),
				Size = NumberSequence.new{NumberSequenceKeypoint.new(0,3.0625,1.8806),NumberSequenceKeypoint.new(0.642055,2,1.76194),NumberSequenceKeypoint.new(1,0.75,0.75)},
				Speed = NumberRange.new(3,6),
				SpreadAngle = vector2new(10,-10),
				Texture = [[rbxassetid://8047533775]],
				Parent = cg,
				Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.170245,0.7,0.014881),NumberSequenceKeypoint.new(0.22546,0.03125,0.03125),NumberSequenceKeypoint.new(0.285276,0,0),NumberSequenceKeypoint.new(0.702454,0,0),NumberSequenceKeypoint.new(0.837423,0.9125,0.0601461),NumberSequenceKeypoint.new(1,1,0)},
				Name = "\0"
			},
			{
				Brightness = 10,
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0.129412,1,0.129412)),ColorSequenceKeypoint.new(1,Color3.new(0.129412,1,0.129412))},
				Lifetime = NumberRange.new(1,1),
				LightEmission = 1,
				LockedToPart = true,
				Orientation = Enum.ParticleOrientation.VelocityPerpendicular,
				Rate = 10,
				RotSpeed = NumberRange.new(100,300),
				Rotation = NumberRange.new(-180,180),
				Size = NumberSequence.new{NumberSequenceKeypoint.new(0,3.125,0),NumberSequenceKeypoint.new(0.416533,1.375,1.375),NumberSequenceKeypoint.new(1,0.9375,0.9375)},
				Speed = NumberRange.new(3,5),
				SpreadAngle = vector2new(10,-10),
				Parent = cg,
				Texture = [[rbxassetid://8047796070]],
				Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.22546,0.03125,0.03125),NumberSequenceKeypoint.new(0.628834,0.25625,0.0593491),NumberSequenceKeypoint.new(0.837423,0.9125,0.0601461),NumberSequenceKeypoint.new(1,1,0)},
				Name = "\0"
			},
			{
				Acceleration = vector3new(0,3,0),
				Brightness = 10,
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0,1,0.14902)),ColorSequenceKeypoint.new(1,Color3.new(0,1,0.14902))},
				Drag = 3,
				Lifetime = NumberRange.new(0.3,1),
				LightEmission = 1,
				Orientation = Enum.ParticleOrientation.VelocityParallel,
				Rate = 30,
				RotSpeed = NumberRange.new(-30,30),
				Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.14687,0.4375,0.1875),NumberSequenceKeypoint.new(1,0,0)},
				Speed = NumberRange.new(5,15),
				SpreadAngle = vector2new(180,-180),
				Texture = [[rbxassetid://8611887361]],
				ZOffset = -1,
				Parent = cg,
				Name = "\0"
			},
			{
				Acceleration = vector3new(0,3,0),
				Brightness = 10,
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0,1,0.14902)),ColorSequenceKeypoint.new(1,Color3.new(0,1,0.14902))},
				Drag = 3,
				Lifetime = NumberRange.new(1,1),
				LightEmission = 1,
				RotSpeed = NumberRange.new(-30,30),
				Rotation = NumberRange.new(-30,30),
				Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.149278,0.6875,0.6875),NumberSequenceKeypoint.new(1,0,0)},
				Speed = NumberRange.new(5,10),
				SpreadAngle = vector2new(180,-180),
				Texture = [[rbxassetid://8611887703]],
				ZOffset = 2,
				Parent = cg,
				Name = "\0"
			}
		},
		["Bubble"] = {
			{
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(1,1,0.588235)),ColorSequenceKeypoint.new(0.5,Color3.new(1,0.901961,0.396078)),ColorSequenceKeypoint.new(1,Color3.new(1,1,0.588235))},
				Lifetime = NumberRange.new(0.333,0.333),
				LightEmission = 1,
				LockedToPart = true,
				Rate = 12,
				Rotation = NumberRange.new(-180,180),
				Size = NumberSequence.new{NumberSequenceKeypoint.new(0,4.8,0.4),NumberSequenceKeypoint.new(1,4.8,0.4)},
				Speed = NumberRange.new(0,0),
				Texture = [[rbxassetid://1084955012]],
				Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0.883114,0),NumberSequenceKeypoint.new(0.0555,0.982574,0),NumberSequenceKeypoint.new(0.111,0.170537,0),NumberSequenceKeypoint.new(0.1665,0.393078,0),NumberSequenceKeypoint.new(0.222,0.129063,0),NumberSequenceKeypoint.new(0.2775,0.920743,0),NumberSequenceKeypoint.new(0.333,0.415693,0),NumberSequenceKeypoint.new(0.3885,0.215033,0),NumberSequenceKeypoint.new(0.444,0.782067,0),NumberSequenceKeypoint.new(0.4995,0.232032,0),NumberSequenceKeypoint.new(0.555,0.789819,0),NumberSequenceKeypoint.new(0.6105,0.810999,0),NumberSequenceKeypoint.new(0.666,0.911618,0),NumberSequenceKeypoint.new(0.7215,0.874569,0),NumberSequenceKeypoint.new(0.777,0.419294,0),NumberSequenceKeypoint.new(0.8325,0.300272,0),NumberSequenceKeypoint.new(0.888,0.164006,0),NumberSequenceKeypoint.new(0.9435,0.396039,0),NumberSequenceKeypoint.new(0.999,0.700339,0),NumberSequenceKeypoint.new(1,1,0)},
				Name = "\0"
			},
			{
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),ColorSequenceKeypoint.new(0.49481,Color3.new(1,0.815686,0.254902)),ColorSequenceKeypoint.new(1,Color3.new(1,1,1))},
				Lifetime = NumberRange.new(1,1),
				LightEmission = 1,
				LockedToPart = true,
				Rate = 6,
				Rotation = NumberRange.new(-180,180),
				Size = NumberSequence.new{NumberSequenceKeypoint.new(0,4,0),NumberSequenceKeypoint.new(1,4,0)},
				Speed = NumberRange.new(0,0),
				Texture = [[rbxassetid://1084955488]],
				Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.5,0.7,0),NumberSequenceKeypoint.new(1,1,0)},
				Name = "\0"
			}
		},
		["Air"] = {
			{
				Brightness = 15,
				Lifetime = NumberRange.new(2,2),
				LightEmission = 1,
				Orientation = Enum.ParticleOrientation.VelocityParallel,
				Rate = 75,
				RotSpeed = NumberRange.new(200,200),
				ShapeInOut = Enum.ParticleEmitterShapeInOut.InAndOut,
				Size = NumberSequence.new{NumberSequenceKeypoint.new(0,7,0),NumberSequenceKeypoint.new(1,7,0)},
				Speed = NumberRange.new(0.01,0.01),
				SpreadAngle = vector2new(-360,360),
				Squash = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0.163934),NumberSequenceKeypoint.new(1,0,0)},
				Texture = [[rbxassetid://10558425570]],
				Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.500623,0.93125,0.01875),NumberSequenceKeypoint.new(1,1,0)},
				ZOffset = -1,
				LockedToPart = true,
				Name = "\0"
			}
		},
		["Ritual"] = {
			{
				Brightness = 7,
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(1,0,0)),ColorSequenceKeypoint.new(1,Color3.new(1,0,0))},
				Lifetime = NumberRange.new(1,1),
				LightEmission = 1,
				LockedToPart = true,
				Orientation = Enum.ParticleOrientation.VelocityPerpendicular,
				Rate = 1,
				RotSpeed = NumberRange.new(300,300),
				Size = NumberSequence.new{NumberSequenceKeypoint.new(0,5,0),NumberSequenceKeypoint.new(1,5,0)},
				Speed = NumberRange.new(0.001,0.001),
				Texture = [[rbxassetid://8920073892]],
				Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.166879,0.617143,0),NumberSequenceKeypoint.new(0.831847,0.6,0),NumberSequenceKeypoint.new(1,1,0)},
				ZOffset = 1
			},
			{
				Brightness = 7,
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(1,0,0)),ColorSequenceKeypoint.new(1,Color3.new(1,0,0))},
				Lifetime = NumberRange.new(1,1),
				LightEmission = 1,
				LockedToPart = true,
				Orientation = Enum.ParticleOrientation.VelocityPerpendicular,
				Rate = 1,
				RotSpeed = NumberRange.new(360,360),
				Size = NumberSequence.new{NumberSequenceKeypoint.new(0,5,0),NumberSequenceKeypoint.new(1,5,0)},
				Speed = NumberRange.new(0.001,0.001),
				Texture = [[http://www.roblox.com/asset/?id=564938805]],
				Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,1,0),NumberSequenceKeypoint.new(0.107643,0,0),NumberSequenceKeypoint.new(0.828025,0,0),NumberSequenceKeypoint.new(1,1,0)},
			}
		},
		["Rain"] = {
			{
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.new(0.67451,0.815686,0.85098)),ColorSequenceKeypoint.new(1,Color3.new(0.67451,0.815686,0.85098))},
				EmissionDirection = Enum.NormalId.Bottom,
				Lifetime = NumberRange.new(200,200),
				LightInfluence = 1,
				Rate = 100,
				Size = NumberSequence.new{NumberSequenceKeypoint.new(0,0.5,0),NumberSequenceKeypoint.new(1,0.5,0)},
				Speed = NumberRange.new(25,25),
				Texture = [[rbxassetid://419625073]],
				Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0.5,0),NumberSequenceKeypoint.new(1,0.5,0)},
				VelocityInheritance = 100
			}
		}
	}

	local offsets = {
		["Ritual"] = vector3new(0,-2.99,0),
		["Rain"] = vector3new(0,3.5,0)
	}

	local offset = vector3new()

	local renderAura = LPH_NO_VIRTUALIZE(function(dt, hrp)
		if not hrp then
			return end

		aura_part["CFrame"] = lplr_pos+offset
	end)

	local updateAura = LPH_NO_VIRTUALIZE(function(selected, bool)
		local selected = selected[1]
		for _, part in aura_part:GetChildren() do
			destroy(part)
		end
		if flags["particle_aura"] or bool then
			for _, properties in auras[selected] do
				newObject("ParticleEmitter", properties)["Parent"] = aura_part
			end
		end
		aura_part["Size"] = selected == "Rain" and vector3new(5,0.01,5) or vector3new(0.01,0.01,0.01)
		offset = offsets[selected] or vector3new()
	end)

	utility.newConnection(menu_references["particle_aura"].onToggleChange, function(bool)
		if find(heartbeat_callbacks, renderAura) then
			remove(heartbeat_callbacks, renderAura)
		end
		if bool then
			insert(heartbeat_callbacks, renderAura)
		end
		aura_part["Parent"] = bool and ignored_folder or cg
		menu_references["particle_aura"]:setDropdownVisibility(bool)
		updateAura(flags["particle_aura_value"], bool)
	end)

	utility.newConnection(menu_references["particle_aura"].onColorChange, function(color)
		local color = ColorSequence.new{ColorSequenceKeypoint.new(0,color),ColorSequenceKeypoint.new(1,color)}
		for _, aura in auras do
			for _, emitter in aura do
				emitter["Color"] = color
			end
		end
		for _, part in aura_part:GetChildren() do
			part["Color"] = color
		end
	end)

	utility.newConnection(menu_references["particle_aura"].onDropdownChange, updateAura)
	menu_references["particle_aura"]:setDropdownVisibility(false)

	local color = flags["particle_aura_color"]
	for _, aura in auras do
		for _, emitter in aura do
			emitter["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0,color),ColorSequenceKeypoint.new(1,color)}
		end
	end
end

local ragebot_data = {}


do
	local animation_spam_animations = {
		["Floss"] = "rbxassetid://10714340543",
		["Hype"] = "rbxassetid://10714369624"
	}

	local animation_spam_connection = nil
	local loaded_animation = nil
	local animation = nil

	local function doAnimationSpam()
		if animation then
			destroy(animation)
			loaded_animation:Stop()
			animation = nil
		end

		local humanoid = lplr_parts["Humanoid"]

		if humanoid then
			animation = newObject("Animation", {
				AnimationId = animation_spam_animations[flags["animation_spam_value"][1]]
			})

			loaded_animation = humanoid:LoadAnimation(animation)

			loaded_animation:Play()
			lplr_data["animation_spam"] = loaded_animation
		end
	end

	utility.newConnection(menu_references["animation_spam"].onToggleChange, function(bool)
		if animation_spam_connection then
			animation_spam_connection:Disconnect()
			animation_spam_connection = nil
		end

		if bool then
			doAnimationSpam()
			animation_spam_connection = utility.newConnection(characterFullyLoaded, doAnimationSpam)
		elseif animation then
			loaded_animation:Stop()
			destroy(animation)
			animation = nil
		end
		menu_references["animation_spam"]:setDropdownVisibility(bool)
	end)

	utility.newConnection(menu_references["animation_spam"].onDropdownChange, function(selected)
		if not flags["animation_spam"] then
			return end

		local selected = selected[1]
		local animation = lplr_data["animation_spam"] 
		if animation then
			loaded_animation:Stop()
			destroy(animation)
			animation = nil
		end

		local humanoid = lplr_parts["Humanoid"]

		if humanoid then
			local animation = newObject("Animation", {
				AnimationId = animation_spam_animations[selected]
			})

			loaded_animation = humanoid:LoadAnimation(animation)

			loaded_animation:Play()
			lplr_data["animation_spam"] = loaded_animation
		end
	end)

	menu_references["animation_spam"]:setDropdownVisibility(false)
end

local silent_fov_circle = nil
local silent_fov_outline = nil

local mouse_positions = {}

do
	local connection = nil

	utility.newConnection(menu_references["view_target"].onToggleChange, function(bool)
		if connection then
			connection:Disconnect()
			connection = nil
		end
		
		local target = aimbot_data["target"]
		if target then
			local bool = bool and flags["view_target_keybind"]["active"]
			lplr_data["viewing"] = bool and target or nil
			camera.CameraSubject = bool and target["Character"] or char
		end
		if bool then
			connection = utility.newConnection(newAimbotTarget, function(player)
				if not flags["view_target_keybind"]["active"] then
					return end

				camera.CameraSubject = player and player["Character"] or char
				lplr_data["viewing"] = player
			end)
		end
	end)

	utility.newConnection(menu_references["view_target"].onActiveChange, function(bool)
		if not flags["view_target"] then
			return end 
		
		local target = aimbot_data["target"]
		if target then
			lplr_data["viewing"] = bool and target or nil
			camera.CameraSubject = bool and target["Character"] or char
		end
	end)
end

do
	local line_drawings = {}
	local spin_angle = 0
	local angles = {0.0, 1.57, 3.14, 4.71}
	local sin = math.sin
	local cos = math.cos
	local old_location = camera.ViewportSize/2
	local clicked = false

	local renderCrosshair = LPH_NO_VIRTUALIZE(function(dt)
		local length = flags["line_length"]
		local gap = flags["line_gap"]
		spin_angle = flags["line_spin"] == 0 and 0 or spin_angle + rad((flags["line_spin"] * 5) * dt)
		local location = flags["drawing_crosshair_location"][1] == "Mouse" and getMouseLocation(uis) or flags["drawing_crosshair_location"][1] == "Center" and camera.ViewportSize/2 or nil
		if flags["drawing_crosshair_follow_target"] then
			local pos = aimbot_data["silent_aim_pos"]

			if pos then		
				local pos, on_screen = wtvp(camera, aimbot_data["silent_aim_pos"])
				
				if on_screen then
					location = vector2new(pos["X"], pos["Y"])
				end
			end
		end
		old_location = lerp(old_location, location, flags["drawing_crosshair_smoothness"] == 0 and 1 or dt*(20*(1.25-flags["drawing_crosshair_smoothness"]/100)))
		for i = 1, 4 do
			local crosshair = line_drawings[i]
			local line = crosshair[1]
			local outline = crosshair[2]
			local pos = vector2new(cos(spin_angle + angles[i]), sin(spin_angle + angles[i]))
			line["From"] = old_location + pos * gap
			line["To"] = line["From"] + pos * (length)
			outline["From"] = old_location + pos * (gap - 1)
			outline["To"] = outline["From"] + pos * (length + 2 )
		end 
	end)

	utility.newConnection(menu_references["drawing_crosshair"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
		for i = 1, 4 do
			local line = line_drawings[i]
			if not line then 
				continue end
			
			line[1]:Destroy()
			line[2]:Destroy()
			line_drawings[i] = nil
		end
		if find(heartbeat_callbacks, renderCrosshair) then
			remove(heartbeat_callbacks, renderCrosshair)
		end
		if bool then
			for i = 1, 4 do
				line_drawings[i] = {
					utility.newDrawing("Line", {
						ZIndex = 10000,
						Visible = true,
						Thickness = 1,
						Color = flags["drawing_crosshair_color"],
						Transparency = -flags["drawing_crosshair_transparency"]+1,
						Filled = true,
					}),
					utility.newDrawing("Line", {
						Visible = true,
						ZIndex = 9999,
						Thickness = 3,
						Color = colorfromrgb(0,0,0),
						Transparency = -flags["drawing_crosshair_transparency"]+1,
						Filled = true,
					})
				}
			end
			insert(heartbeat_callbacks, renderCrosshair)
		end
		menu_references["line_length"]:setVisible(bool)
		menu_references["line_gap"]:setVisible(bool)
		menu_references["line_spin"]:setVisible(bool)
		menu_references["drawing_crosshair_smoothness"]:setVisible(bool)
		menu_references["drawing_crosshair_location"]:setVisible(bool)
		menu_references["drawing_crosshair_follow_target"]:setVisible(bool)
	end))

	utility.newConnection(menu_references["drawing_crosshair"].onColorChange, LPH_NO_VIRTUALIZE(function(color, transparency)
		local transparency = -transparency+1
		for i = 1, 4 do
			local line = line_drawings[i]
			if not line then 
				break end
			
			line[1]["Color"] = color
			line[1]["Transparency"] = transparency
			line[2]["Transparency"] = transparency
		end
	end))

	menu_references["line_length"]:setVisible(false)
	menu_references["line_gap"]:setVisible(false)
	menu_references["line_spin"]:setVisible(false)
	menu_references["drawing_crosshair_smoothness"]:setVisible(false)
	menu_references["drawing_crosshair_location"]:setVisible(false)
	menu_references["drawing_crosshair_follow_target"]:setVisible(false)
end

do
	local doNetworkDesync = LPH_JIT_MAX(function(dt, hrp)
		if not flags["network_desync_keybind"]["active"] then
			return end
			
		local value = flags["network_desync_value"][1]
		if value == "Invisible" then
			setfflag("S2PhysicsSenderRate", 2)
			sethiddenproperty(hrp, "NetworkIsSleeping", do_sleep)
			setfflag("PhysicsSenderMaxBandwidthBps", math.pi/3)
			
			local old_linear_velocity = hrp.AssemblyLinearVelocity
			local old_velocity = hrp.Velocity

			hrp.AssemblyLinearVelocity = vector3new(mathrandom(-16384, 16384),mathrandom(-16384, 16384) ,mathrandom(-16384, 16384))
			hrp.Velocity = vector3new(mathrandom(-16384, 16384),mathrandom(-16384, 16384) ,mathrandom(-16384, 16384))

			render_stepped:Wait()

			hrp.Velocity = old_velocity
			hrp.AssemblyLinearVelocity = old_linear_velocity

			setfflag("S2PhysicsSenderRate", 1)
		
			do_sleep = not do_sleep
		elseif value == "Lag step" then
			setfflag("S2PhysicsSenderRate", 1)
			sethiddenproperty(hrp, "NetworkIsSleeping", do_sleep)
			sethiddenproperty(hrp, "NetworkIsSleeping", not do_sleep)
			sethiddenproperty(hrp, "NetworkIsSleeping", do_sleep)

			setfflag("PhysicsSenderMaxBandwidthBps", 28.274333882)

			local old_linear_velocity = hrp.AssemblyLinearVelocity
			local old_velocity = hrp.Velocity

			hrp.AssemblyLinearVelocity = vector3new(0,0,0)
			hrp.Velocity = math.random(1,100) == 5 and vector3new(mathrandom(-16384, 65536),mathrandom(-16384, 65536) ,mathrandom(-16384, 65536)) or vector3new(0,0,0)

			render_stepped:Wait()

			hrp.Velocity = old_velocity
			hrp.AssemblyLinearVelocity = old_linear_velocity

			setfflag("S2PhysicsSenderRate", mathrandom(1,5) == 5 and 15 or 1)
			setfflag("PhysicsSenderMaxBandwidthBps", mathrandom(1,10) == 1 and 28.274333882 or math.pi/3)

			sethiddenproperty(hrp, "NetworkIsSleeping", do_sleep)
			do_sleep = not do_sleep
		elseif value == "Random" then
			setfflag("S2PhysicsSenderRate", mathrandom(1,15) == 1 and 6 or 1)
			setfflag("PhysicsSenderMaxBandwidthBps", mathrandom(1,100) == 1 and math.pi/3 or 28.274333882)

			local old_linear_velocity = hrp.AssemblyLinearVelocity
			local old_velocity = hrp.Velocity
			local old = hrp.CFrame
			hrp.Velocity = math.random(1,100) == 1 and vector3new(mathrandom(-16384, 65536),mathrandom(-16384, 65536) ,mathrandom(-16384, 65536)) or vector3new(mathrandom(-16384, 16384),mathrandom(-16384, 16384) ,mathrandom(-16384, 16384))
			hrp.AssemblyLinearVelocity = hrp.Velocity

			hrp.CFrame+=vector3new(mathrandom(-16384, 65536),mathrandom(-16384, 65536) ,mathrandom(-16384, 65536))/60000
			hrp.CFrame*=angles(0,rad(mathrandom(1,359)),0)
			sethiddenproperty(hrp, "NetworkIsSleeping", do_sleep)
			do_sleep = not do_sleep

			render_stepped:Wait()
			hrp.CFrame = old

			hrp.Velocity = old_velocity
			hrp.AssemblyLinearVelocity = old_linear_velocity

			setfflag("S2PhysicsSenderRate", mathrandom(1,15) == 5 and 9e9 or 1)
		elseif value == "Teleport move" then
			do_sleep = not do_sleep
			sethiddenproperty(hrp, "NetworkIsSleeping", do_sleep)
			spawn(function()
				local old = hrp["Velocity"]
				hrp["Velocity"]+=vector3new(mathrandom(-16000,16000), mathrandom(-16000,16000), mathrandom(-16000,16000))
				render_stepped:Wait()
				hrp["Velocity"] = old
			end)
			setfflag("S2PhysicsSenderRate", "1000")
			rs.PreSimulation:Wait()
			setfflag("S2PhysicsSenderRate", "3")
			sethiddenproperty(hrp, "NetworkIsSleeping", false)
			sethiddenproperty(hrp, "NetworkIsSleeping", true)
			sethiddenproperty(hrp, "NetworkIsSleeping", false)
		else
			sethiddenproperty(hrp, "NetworkIsSleeping", do_sleep)
			do_sleep = not do_sleep
		end
	end)

	utility.newConnection(menu_references["network_desync"].onToggleChange, function(bool)
		menu_references["network_desync"]:setDropdownVisibility(bool)
		if find(anti_callbacks, doNetworkDesync) then
			remove(anti_callbacks, doNetworkDesync)
		end
		if bool then
			insert(anti_callbacks, doNetworkDesync)
		else
			render_stepped:Wait()
			render_stepped:Wait()
			render_stepped:Wait()
			render_stepped:Wait()
			setfflag("S2PhysicsSenderRate", 15)
			setfflag("PhysicsSenderMaxBandwidthBps", 38760)
		end
	end)
	menu_references["network_desync"]:setDropdownVisibility(false)
end

do
	local autoSort = LPH_NO_VIRTUALIZE(function()
		local sort_positions = {}
	
		for i = 1, 9 do
			sort_positions[i] = lower(tostring(flags["slot_"..tostring(i)]))
		end
	
		local backpack = lplr.Backpack
	
		if not backpack then return end
	
	
		local children = backpack:GetChildren()
		local done = {}
	
		for i = 1, #children do
			children[i].Parent = lplr
		end
	
		for i = 1, 9 do
			local item = sort_positions[i]
			for i = 1, #children do
				local child = children[i]
				local name = lower(tostring(child))
				if name:find(item) then
					child.Parent = backpack
					done[tostring(child)] = true
				end
			end
		end
	
		for i = 1, #children do
			local child = children[i]
			if not done[child.Name] then
				child.Parent = backpack
			end
		end
	end)
	
	utility.newConnection(menu_references["auto_sort"].onToggleChange, function(bool)
		for i = 1, 9 do
			menu_references["slot_"..i]:setVisible(bool)
		end
	end, true)
	for i = 1, 9 do
		menu_references["slot_"..i]:setVisible(false)
	end
	
	utility.newConnection(menu_references["auto_sort"].onActiveChange, function(active)
		if not flags["auto_sort"] then
			return end
	
		if lplr_parts["Humanoid"] then
			spawn(autoSort)
		end
	end)
end

do
	local doCashAura = LPH_NO_VIRTUALIZE(function()
		local hrp = lplr_parts['HumanoidRootPart']
	
		if not hrp then
			return end
	
		local children = ignored_folder.Drop:GetChildren()
		for i = 1, #children do
			local cash = children[i]
			if cash.Name == "MoneyDrop" then
				if (cash.Position-hrp.Position).magnitude < 11.5 then
					local click_detector = findfirstchild(cash, "ClickDetector")
					if click_detector then 
						fireclickdetector(click_detector) 
					end
				end
			end
		end 
	end)
	
	utility.newConnection(menu_references["cash_aura"].onToggleChange, function(bool)
		if find(heartbeat_callbacks, doCashAura) then
			remove(heartbeat_callbacks, doCashAura)
		end
		if bool then
			insert(heartbeat_callbacks, doCashAura)
		end
	end)
end

do
	local all_notifications = 0
	local notification_removed = signal.new()

	local createNotification = LPH_NO_VIRTUALIZE(function(text)
		all_notifications+=1
		local style = flags["notifications_style"][1]
		if style == "Gamesense" then
			local background = utility.newDrawing("Square", {
				Position = vector2new(0,500);
				Size = vector2new(180,28);
				Color = colorfromrgb(12,12,12);
				Transparency = 0;
				ZIndex = 1;
				Visible = true;
				Filled = true
			})
			local background2 = utility.newDrawing("Square", {
				Position = vector2new(0,500);
				Size = vector2new(178,26);
				Color = colorfromrgb(60,60,60);
				Transparency = 0;
				ZIndex = 2;
				Visible = true;
				Filled = true
			})
			local background3 = utility.newDrawing("Square", {
				Position = vector2new(0,500);
				Size = vector2new(172,20);
				Color = colorfromrgb(40,40,40);
				Transparency = 0;
				ZIndex = 3;
				Visible = true;
				Filled = true
			})
			local background4 = utility.newDrawing("Square", {
				Position = vector2new(0,500);
				Size = vector2new(170,18);
				Color = colorfromrgb(60,60,60);
				Transparency = 0;
				ZIndex = 4;
				Visible = true;
				Filled = true
			})
			local background5 = utility.newDrawing("Square", {
				Position = vector2new(0,500);
				Size = vector2new(168,16);
				Color = colorfromrgb(20,20,20);
				Transparency = 0;
				ZIndex = 5;
				Visible = true;
				Filled = true
			})
			local line = utility.newDrawing("Image", {
				["Data"] = images["line"];
				["Color"] = colorfromrgb(255,255,255);
				["Transparency"] = 0;
				["ZIndex"] = 6;
				Visible = true;
				["Size"] = vector2new(0,2)
			})
			local text = utility.newDrawing("Text", {
				Center = false;
				Color = colorfromrgb(255,255,255);
				Transparency = 0;
				Size = 9;
				Text = text;
				Outline = true;
				ZIndex = 7;
				Visible = true;
				Font = 3
			})

			local x_size = text["TextBounds"]["X"]+16
			background["Size"] = vector2new(x_size, 28)
			background2["Size"] = vector2new(x_size - 2, 26)
			background3["Size"] = vector2new(x_size - 4, 24)
			background4["Size"] = vector2new(x_size - 10, 18)
			background5["Size"] = vector2new(x_size - 12, 16)
			line["Size"] = vector2new(x_size - 12, 2)

			local notification = all_notifications
			local elapsed_time = 0
			local is_first = true

			local connection3 = utility.newConnection(rs.Heartbeat, function(dt)
				elapsed_time+=dt
				local viewport_size = camera.ViewportSize
				local position = vector2new(viewport_size.X/2 - x_size/2, is_first and (flags["notifications_vertical_offset"] + viewport_size.Y/2 + 125) + notification*30 or (flags["notifications_vertical_offset"] + viewport_size.Y/2 + 100) + notification*30)

				if is_first then
					background["Position"] = position
					text["Position"] = position + vector2new(8,11)
					background2["Position"] = position + vector2new(1,1)
					background3["Position"] = position + vector2new(2,2)
					background4["Position"] = position + vector2new(5,5)
					background5["Position"] = position + vector2new(6,6)

					line["Position"] = background5["Position"]
				else
					local dt = dt*7 
					
					background["Position"] = lerp(background["Position"], position, dt)
					text["Position"] = lerp(text["Position"], position + vector2new(8,11), dt)
					background2["Position"] = lerp(background2["Position"], position + vector2new(1,1), dt)
					background3["Position"] = lerp(background3["Position"], position + vector2new(2,2), dt)
					background4["Position"] = lerp(background4["Position"], position + vector2new(5,5), dt)
					background5["Position"] = lerp(background5["Position"], position + vector2new(6,6), dt)

					line["Position"] = background5["Position"]
				end

				if elapsed_time < 0.2 then
					local transparency = getValue(tws, (elapsed_time / 0.2), Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
					background["Transparency"] = transparency
					background2["Transparency"] = transparency
					background3["Transparency"] = transparency
					background4["Transparency"] = transparency
					background5["Transparency"] = transparency
					line["Transparency"] = transparency
					text["Transparency"] = transparency
				elseif elapsed_time > 2.8 then
					local transparency = 1 - getValue(tws, ((elapsed_time-2.8) / 0.2), Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
					background["Transparency"] = transparency
					background2["Transparency"] = transparency
					background3["Transparency"] = transparency
					background4["Transparency"] = transparency
					background5["Transparency"] = transparency
					line["Transparency"] = transparency
					text["Transparency"] = transparency
				end

				is_first = false
			end)

			local connection = utility.newConnection(notification_removed, function(int)
				if notification > int then
					notification-=1
				end
			end)

			local connection2 = utility.newConnection(camera:GetPropertyChangedSignal("ViewportSize"), function()
				is_first = true
			end)

			wait(3)


			all_notifications-=1
			notification_removed:Fire(notification)
			connection:Disconnect() 
			connection2:Disconnect()
			connection3:Disconnect()
			background:Destroy()
			text:Destroy()
			line:Destroy()
			background4:Destroy()
			background2:Destroy()
			background3:Destroy()
			background5:Destroy()
		elseif style == "Simple" then
			local drawings = {}
			local total_words = 0
			local total_size = 0

			for word in string.gmatch(text, "%S+") do
				total_words+=1
				drawings[total_words] = utility.newDrawing("Text", {
					Center = false;
					Color = total_words % 2 == 0 and flags["notifications_color"] or colorfromrgb(255,255,255);
					Transparency = 0;
					Size = 10;
					Text = word;
					Outline = true;
					ZIndex = 1;
					Visible = true;
					Font = 3
				})
				total_size+=(drawings[total_words]["TextBounds"]["X"] + 4)
			end

			local notification = all_notifications
			local elapsed_time = 0

			local connection3 = utility.newConnection(rs.Heartbeat, function(dt)
				elapsed_time+=dt
				local viewport_size = camera.ViewportSize
				local position = vector2new(viewport_size.X/2 - (total_size/2), flags["notifications_vertical_offset"] + viewport_size.Y/2 + 125 + notification*12)

				for _, text in drawings do
					text["Position"] = position
					position+=vector2new(text["TextBounds"]["X"]+4, 0)
				end

				if elapsed_time < 0.2 then
					local transparency = getValue(tws, (elapsed_time / 0.2), Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
					for _, text in drawings do
						text["Transparency"] = transparency
					end
				elseif elapsed_time > 2.8 then
					local transparency = 1 - getValue(tws, ((elapsed_time-2.8) / 0.2), Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
					for _, text in drawings do
						text["Transparency"] = transparency
					end
				end

				is_first = false
			end)

			local connection = utility.newConnection(notification_removed, function(int)
				if notification > int then
					notification-=1
				end
			end)

			local connection2 = utility.newConnection(camera:GetPropertyChangedSignal("ViewportSize"), function()
				is_first = true
			end)

			wait(3)

			all_notifications-=1
			notification_removed:Fire(notification)
			connection:Disconnect() 
			connection2:Disconnect()
			connection3:Disconnect()
			for _, text in drawings do
				text:Destroy()
			end
		elseif style == "Gamesensical" then
			local background = utility.newDrawing("Image", {
				["Data"] = images["indicator_gradient"],
				["Transparency"] = 0,
				["Color"] = colorfromrgb(24,24,24),
				["Size"] = vector2new(100,15),
				["Visible"] = true,
				["ZIndex"] = 1,
			})
			
			local text_drawings = {}
			local total_words = 0
			local do_color = {
				[2] = true,
				[5] = true,
				[7] = true
			}
			local total_size = 0
			local color = flags["notifications_color"]
			for word in string.gmatch(text, "%S+") do
				total_words+=1
				text_drawings[total_words] = utility.newDrawing("Text", {
					Center = false;
					Color = do_color[total_words] and color or colorfromrgb(255,255,255);
					Transparency = 0;
					Size = 12;
					Text = word;
					Outline = true;
					Visible = true;
					ZIndex = 2;
					Font = 5
				})
				total_size+=(text_drawings[total_words]["TextBounds"]["X"] + 4)
			end

			background["Size"] = vector2new(total_size + 10, 15)

			local notification = all_notifications
			local elapsed_time = 0
			local is_first = true
			local offset = vector2new(0,2)
			local connection3 = utility.newConnection(rs.Heartbeat, function(dt)
				elapsed_time+=dt
				if is_first then
					local position = vector2new(1, 42 + notification*17)

					background["Position"] = position
					position+=vector2new(5,0)
					for _, text in text_drawings do
						text["Position"] = position + offset
						position+=vector2new(text["TextBounds"]["X"]+4, 0)
					end
				else
					local position = elapsed_time > 2.88 and vector2new(1, 42 + notification*17) or vector2new(16, 42 + notification*17)
					local dt = dt*5
					background["Position"] = lerp(background["Position"], position, dt)
					position+=vector2new(5,0)
					for _, text in text_drawings do
						text["Position"] = lerp(text["Position"], position + offset, dt)
						position+=vector2new(text["TextBounds"]["X"]+4, 0)
					end
				end

				if elapsed_time < 0.05 then
					local transparency = getValue(tws, (elapsed_time / 0.05), Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
					background["Transparency"] = 1 * transparency
					for _, text in text_drawings do
						text["Transparency"] = transparency
					end
				elseif elapsed_time > 2.88 then
					local transparency = getValue(tws, ((elapsed_time-2.88) / 0.12), Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
					background["Transparency"] = 1 - transparency/2
					transparency = 1 - transparency
					for _, text in text_drawings do
						text["Transparency"] = transparency
					end
				end

				is_first = false
			end)

			local connection = utility.newConnection(notification_removed, function(int)
				if notification > int then
					notification-=1
				end
			end)

			local connection2 = utility.newConnection(camera:GetPropertyChangedSignal("ViewportSize"), function()
				is_first = true
			end)

			wait(2.88)

			all_notifications-=1
			notification_removed:Fire(notification)

			wait(0.12)

			connection:Disconnect() 
			connection2:Disconnect()
			connection3:Disconnect()
			background:Destroy()
			for _, text in text_drawings do
				text:Destroy()
			end
		end
	end)

	local newHitNotification = LPH_JIT_MAX(function(player, parts, damage)
		local style = flags["notifications_style"][1]
		local health = floor(parts["Humanoid"]["Health"])
		local text = ""
		local name = tostring(player)

		if style == "Simple" then
			text = "juju > hit "..name.." for "..tostring(damage).." ("..tostring(health).." health remaining)"
		elseif style == "Gamesense" then
			text = "hit "..name.." for "..tostring(damage).." ("..tostring(health).." health remaining)"
		elseif style == "Gamesensical" then
			local part = "unknown"
			for name, instance in parts do
				local is_accessory = instance["ClassName"] == "Accessory"
				local emitter = findfirstchild((is_accessory and instance["Handle"] or instance), "BloodSplatter")
				if emitter then
					part = is_accessory and "accessory" or name
					break
				end
			end
			
			part = part == "[CarHitbox]" and "unknown" or part
			
			text = "Hit "..name.." in the "..lower(part).." for "..tostring(damage).." ("..tostring(health).." health remaining)"
		end
		spawn(createNotification, text)
	end)

	local newTargetNotification = LPH_JIT_MAX(function(player)
		local style = flags["notifications_style"][1]
		local text = ""
		local name = tostring(player)
		if style == "Simple" then
			text = player and ("juju > locked onto "..name) or "juju > unlocked"
		else
			text = player and (style == "Gamesensical" and "Locked" or "locked".." onto "..name) or (style == "Gamesensical" and "Aimbot unlocked" or "aimbot unlocked")
		end
		spawn(createNotification, text)
	end)

	local connection = nil
	local connection2 = nil

	utility.newConnection(menu_references["notifications"].onDropdownChange, function(selected)
		if connection then
			connection:Disconnect()
			connection = nil
		end
		if connection2 then
			connection2:Disconnect()
			connection2 = nil
		end
		if find(selected, "On hit") then
			connection = utility.newConnection(hitPlayer, newHitNotification)
		end
		if find(selected, "On target change") then
			connection2 = utility.newConnection(newAimbotTarget, newTargetNotification)
		end
		local visible = selected[1] ~= nil and true or false
		menu_references["notifications_style"]:setVisible(visible)
		menu_references["notifications_vertical_offset"]:setVisible(flags["notifications_style"][1] ~= "Gamesensical" and visible)
	end)
	menu_references["notifications_style"]:setVisible(false)
	menu_references["notifications_vertical_offset"]:setVisible(false)
end

local setAimbotTarget = LPH_NO_VIRTUALIZE(function(player)
	aimbot_data["silent_aim_pos"] = nil
	aimbot_data["velocity"] = vector3new()
	aimbot_data["target"] = player
	aimbot_data["target_data"] = player_data[player]
	aimbot_data["last_move_direction"] = nil
	aimbot_data["last_position"] = nil
	aimbot_data["highest_offset"] = 0
	aimbot_data["targeted_silent_hitbox"] = nil
	aimbot_data["targeted_assist_hitbox"] = nil

	newAimbotTarget:Fire(player)
	return player
end)

do
	local max_distance_value = flags["max_distance_value"]
	local check_functions = {
		["Behind wall"] = LPH_NO_VIRTUALIZE(function(data, hrp, camera_pos)
			local distance = hrp["Position"]-camera_pos
			raycast_params.FilterDescendantsInstances = {data["character"], char, ignored_folder, vehicles}
			return raycast(workspace, camera_pos, distance.unit * distance.magnitude, raycast_params)
		end),
		["Grabbed"] = LPH_NO_VIRTUALIZE(function(data)
			return data["grabbed"]
		end),
		["Forcefield"] = LPH_NO_VIRTUALIZE(function(data)
			return data["forcefield"]
		end),
		["Distance"] = LPH_NO_VIRTUALIZE(function(data, hrp, camera_pos)
			return (hrp["Position"]-camera_pos).magnitude > max_distance_value
		end),
		["Knocked"] = LPH_NO_VIRTUALIZE(function(data)
			return data["knocked"]
		end),
		["Crew"] = LPH_NO_VIRTUALIZE(function(data)
			return data["crew"] == lplr_data["crew"]
		end),
	}

	local getClosest = LPH_NO_VIRTUALIZE(function(mouse_position)
		local closest_distance = 9e9
		local screen_position = nil
		local target_checks = flags["target_checks"]
		local camera_pos = camera.CFrame.p
		local closest = nil
		local assist_fov = (flags["aim_assist"] and flags["aim_assist_keybind"]["active"]) and aimbot_data["aim_assist_field_of_view"] or 0
		local silent_fov = (flags["silent_aim"] and flags["silent_aim_keybind"]["active"]) and aimbot_data["silent_aim_field_of_view"] or 0
		local fov = assist_fov > silent_fov and assist_fov or silent_fov

		for player, data in player_data do
			local hrp = data["character_parts"]["UpperTorso"]

			if not hrp or data["whitelisted"] then
				continue end

			local pos, on_screen = wtvp(camera, hrp["Position"])

			if not on_screen then
				continue end

			local pos = vector2new(pos.X, pos.Y)
			local distance = (mouse_position - pos).magnitude

			if distance > fov then
				continue end

			local failed = false
			for _, check in target_checks do
				if check_functions[check](data, hrp, camera_pos) then
					failed = true
					break
				end
			end

			if failed then
				continue end

			if distance < closest_distance then
				closest_distance = distance
				screen_position = pos
				closest = player
			end
		end

		return closest, screen_position
	end)

	local closest_shot = nil
	local terminate = nil
	local last_select = clock()
	
	local doAimbot = LPH_NO_VIRTUALIZE(function()
		local mouse_position = getMouseLocation(uis)
		local target = aimbot_data["target"]

		if not flags["aimbot_keybind"]["active"] then
			if target then
				setAimbotTarget(nil)
			end
			return
		end

		local time = clock()
		if flags["auto_select_target"] and (time-last_select) >= flags["auto_select_target_delay"] then
			last_select = time
			if not (flags["sticky"] and target) then
				local new_target = getClosest(mouse_position)

				if new_target ~= target then
					target = setAimbotTarget(new_target)
				end
			end
		end

		if not target then
			return end

		local data = player_data[target]
		local parts = data["character_parts"]
		local hrp = parts["HumanoidRootPart"]

		if not hrp then
			return end

		if flags["resolver"] and flags["resolver_keybind"]["active"] then
			local refresh_time = clock()-aimbot_data["last_refresh"]
			local do_refresh = refresh_time > flags["refresh_rate"]
			if do_refresh then
				if not aimbot_data["last_position"] then 
					aimbot_data["last_position"] = hrp.Position
				else
					local distance = (hrp.Position - aimbot_data["last_position"])
					local last_position = aimbot_data["last_position"]
					aimbot_data["last_position"] = hrp.Position

					local total = distance.magnitude

					if flags["random_teleport_resolver_keybind"]["active"] then
						local humanoid = parts["Humanoid"]

						local move_direction = humanoid.MoveDirection
						local offset = hrp["Position"] - last_position
						local valid = offset.Unit*(aimbot_data["last_move_direction"] or move_direction)
						local valid_offset = valid.magnitude > 0 and (valid*offset) or offset
						local highest_offset = aimbot_data["highest_offset"]
						local magnitude = valid_offset.magnitude
						if magnitude > highest_offset then
							aimbot_data["highest_offset"] = magnitude
							highest_offset = magnitude
						end
						local placeholder = highest_offset*100
						local new_pos = hrp["Position"] - (valid_offset * (highest_offset ~= 0 and (magnitude/((mathrandom(floor(placeholder/8),floor(placeholder))/100))) or 1))
						aimbot_data["force_pos"] = new_pos

						aimbot_data["velocity"] = vector3new()
						aimbot_data["last_move_direction"] = move_direction

						delay(0.03, function()
							if aimbot_data["force_pos"] == new_pos then
								aimbot_data["force_pos"] = nil
							end
						end)
					end

					local network_resolver = flags["network_resolver"]
					if network_resolver then
						local is_sleeping = gethiddenproperty(hrp, "NetworkIsSleeping")
						if is_sleeping then
							aimbot_data["last_sleeping"] = clock()
						end
						if clock()-aimbot_data["last_sleeping"] < 0.3 then
							local old_closest_shot = closest_shot
							aimbot_data["velocity"] = vector3new()
							aimbot_data["force_pos"] = old_closest_shot or nil
							delay(0.3, function()
								if aimbot_data["force_pos"] == old_closest_shot then
									aimbot_data["force_pos"] = nil
								end
							end)
						end
					end
						
					if (hrp.Position-(last_position or vector3new())).magnitude >= 9e9 then
						aimbot_data["velocity"] = vector3new()
						aimbot_data["force_pos"] = last_position
						return
					end

					if not network_resolver then
						aimbot_data["force_pos"] = nil
					end
					
					aimbot_data["velocity"] = distance / refresh_time
				end
			end
			if do_refresh then
				aimbot_data["last_refresh"] = clock()
			end
		else
			aimbot_data["velocity"] = hrp["Velocity"]
		end
	end)

	local updateSettings = LPH_NO_VIRTUALIZE(function(tool, force)
		local gun_type = tool and gun_types[tool.Name] or "global"

		if gun_type ~= "global" then
			gun_type = flags[gun_type.."_override_global_config"] and gun_type or "global"
		end

		if gun_type == aimbot_data["type"] and not force then
			return end

		aimbot_data["type"] = gun_type
		local field_of_view = flags[gun_type.."_silent_aim_field_of_view"]
		aimbot_data["silent_aim_field_of_view"] = flags["silent_aim_use_fov"] and field_of_view or 9e9
		if silent_fov_circle then
			silent_fov_circle["Radius"] = field_of_view
			silent_fov_outline["Radius"] = field_of_view
		end
		aimbot_data["silent_aim_hit_chance"] = flags[gun_type.."_silent_aim_hit_chance"]
		aimbot_data["silent_aim_anti_curve"] = flags[gun_type.."_silent_aim_anti_curve"]
		aimbot_data["silent_aim_anti_curve_value"] = flags[gun_type.."_silent_aim_anti_curve_value"]
		aimbot_data["silent_aim_ignore_max_curve"] = flags[gun_type.."_silent_aim_ignore_max_curve"]
		aimbot_data["silent_aim_max_curve"] = flags[gun_type.."_silent_aim_max_curve"]
		aimbot_data["silent_aim_max_curve_value"] = flags[gun_type.."_silent_aim_max_curve_value"]
		aimbot_data["silent_aim_dont_curve_vertically"] = flags[gun_type.."_silent_aim_dont_curve_vertically"]
		aimbot_data["silent_aim_multipoint"] = flags[gun_type.."_silent_aim_multipoint"]
		aimbot_data["silent_aim_air_hitbox"] = flags[gun_type.."_silent_aim_air_hitbox"][1]
		aimbot_data["silent_aim_hitbox"] = flags[gun_type.."_silent_aim_hitbox"][1]

		local field_of_view = flags[gun_type.."_aim_assist_field_of_view"]
		aimbot_data["aim_assist_field_of_view"] = flags["aim_assist_use_fov"] and field_of_view or 9e9
		if assist_fov_circle then
			assist_fov_circle["Radius"] = field_of_view
			assist_fov_outline["Radius"] = field_of_view
		end
		aimbot_data["aim_assist_horizontal_smoothness"] = flags[gun_type.."_aim_assist_horizontal_smoothness"]/100
		aimbot_data["aim_assist_vertical_smoothness"] = flags[gun_type.."_aim_assist_vertical_smoothness"]/100
		aimbot_data["aim_assist_smoothing_direction"] = Enum.EasingDirection[flags[gun_type.."_aim_assist_smoothing_direction"][1]]
		aimbot_data["aim_assist_smoothing_style"] = Enum.EasingStyle[flags[gun_type.."_aim_assist_smoothing_style"][1]]
		aimbot_data["aim_assist_multipoint"] = flags[gun_type.."_aim_assist_multipoint"]
		aimbot_data["aim_assist_air_hitbox"] = flags[gun_type.."_aim_assist_air_hitbox"][1]
		aimbot_data["aim_assist_hitbox"] = flags[gun_type.."_aim_assist_hitbox"][1]
		aimbot_data["triggerbot_cooldown"] = flags[gun_type.."_triggerbot_cooldown"]
		aimbot_data["triggerbot_delay"] = flags[gun_type.."_triggerbot_delay"]
		aimbot_data["triggerbot_use_silent_aim_position"] = flags[gun_type.."_use_silent_aim_position"]
		aimbot_data["triggerbot_dont_follow_vertically"] = flags[gun_type.."_triggerbot_dont_follow_vertically"]
		aimbot_data["triggerbot_horizontal_radius"] = flags[gun_type.."_triggerbot_horizontal_radius"]
		aimbot_data["triggerbot_vertical_radius"] = flags[gun_type.."_triggerbot_vertical_radius"]
		aimbot_data["triggerbot_air_hitbox"] = flags[gun_type.."_triggerbot_air_hitbox"][1]
		aimbot_data["triggerbot_hitbox"] = flags[gun_type.."_triggerbot_hitbox"][1]
		aimbot_data["aim_assist_dont_aim_vertically"] = flags[gun_type.."_aim_assist_dont_aim_vertically"]
	end)

	local count = 0
	for _, gun in {"global", "pistol", "shotgun", "automatic"} do
		local updateLocally = LPH_NO_VIRTUALIZE(function()
			wait()
			if gun == aimbot_data["type"] then
				spawn(updateSettings, lplr_data["tool"], true)
			end
		end)

		count+=1
		local subtab = legit:getSubtab(_+1)
		local add = ""
		for i = 1, count do
			add = add.." "
		end
		local silent_aim = subtab:newSection({name = "Silent aim"..add, scale = 1})
			if _ > 1 then
				utility.newConnection(silent_aim:newElement({name = "Override global config", types = {toggle = {flag = gun.."_override_global_config"}}}).onToggleChange, function(bool)
					local tool = lplr_data["tool"]
					
					if not tool then
						return end

					local name = tool["Name"]

					if gun_types[name] ~= aimbot_data["type"] then
						spawn(updateSettings, tool)
					end
				end)
			end
			local anti_curve = silent_aim:newElement({name = "Anti curve", types = {toggle = {flag = gun.."_silent_aim_anti_curve"}, slider = {flag = gun.."_silent_aim_anti_curve_value", min = 10, max = 500, default = 95, suffix = "px", prefix = ""}}})
			local ignore_max_curve = silent_aim:newElement({name = "Ignore max curve", types = {toggle = {flag = gun.."_silent_aim_ignore_max_curve"}}})
			utility.newConnection(anti_curve.onToggleChange, function(bool)
				ignore_max_curve:setVisible(bool)
				anti_curve:setSliderVisibility(bool)
				updateLocally()
			end)
			local max_curve = silent_aim:newElement({name = "Max curve", types = {toggle = {flag = gun.."_silent_aim_max_curve"}, slider = {flag = gun.."_silent_aim_max_curve_value", min = 10, max = 100, default = 100, suffix = "%", prefix = "", decimal = 1}}})
			local dont_curve_vertically = silent_aim:newElement({name = "Don't curve vertically", types = {toggle = {flag = gun.."_silent_aim_dont_curve_vertically"}}})
			utility.newConnection(max_curve.onToggleChange, function(bool)
				local show = not bool or not flags["dont_curve_vertically"] 
				max_curve:setSliderVisibility(bool)
				dont_curve_vertically:setVisible(bool)
				updateLocally()
			end)
			utility.newConnection(max_curve.onSliderChange, updateLocally)
			utility.newConnection(anti_curve.onSliderChange, updateLocally)
			utility.newConnection(ignore_max_curve.onToggleChange, updateLocally)
			ignore_max_curve:setVisible(false)
			anti_curve:setSliderVisibility(false)
			utility.newConnection(silent_aim:newElement({name = "Air hitbox", types = {dropdown = {flag = gun.."_silent_aim_air_hitbox", no_none = true, default = {"LowerTorso"}, options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "Closest"}}}}).onDropdownChange, updateLocally)
			utility.newConnection(silent_aim:newElement({name = "Hitbox", types = {dropdown = {flag = gun.."_silent_aim_hitbox", no_none = true, default = {"Head"}, options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "Closest"}}}}).onDropdownChange, updateLocally)
			utility.newConnection(silent_aim:newElement({name = "Field of view", types = {slider = {flag = gun.."_silent_aim_field_of_view", min = 1, max = 1000, default = 20, suffix = "°", prefix = "", changers = 1}}}).onSliderChange, updateLocally)
			utility.newConnection(silent_aim:newElement({name = "Hit chance", types = {slider = {flag = gun.."_silent_aim_hit_chance", min = 0, max = 100, default = 100, suffix = "%", prefix = ""}}}).onSliderChange, updateLocally)
			
			max_curve:setSliderVisibility(false)
			dont_curve_vertically:setVisible(false)
			
			utility.newConnection(dont_curve_vertically.onToggleChange, function(bool)
				local show = not bool
				updateLocally()
			end)
			utility.newConnection(silent_aim:newElement({name = "Multipoint", types = {slider = {flag = gun.."_silent_aim_multipoint", min = 0, max = 100, default = 80, suffix = "%", prefix = "", changers = 0.1, decimal = 1}}}).onSliderChange, updateLocally)
		local aim_assist = subtab:newSection({name = "Aim assist"..add, scale = 0.5, x = 0.5})
			local dont_aim_vertically = aim_assist:newElement({name = "Don't aim vertically", types = {toggle = {flag = gun.."_aim_assist_dont_aim_vertically"}}})
			utility.newConnection(aim_assist:newElement({name = "Smoothing direction", types = {dropdown = {flag = gun.."_aim_assist_smoothing_direction", default = {"Out"}, options = {"InOut", "Out", "In"}}}}).onDropdownChange, updateLocally)
			utility.newConnection(aim_assist:newElement({name = "Smoothing style", types = {dropdown = {flag = gun.."_aim_assist_smoothing_style", default = {"Exponential"}, options = {"Exponential", "Circular", "Elastic", "Bounce", "Linear", "Quint", "Cubic", "Back", "Sine", "Quad"}}}}).onDropdownChange, updateLocally)
			utility.newConnection(aim_assist:newElement({name = "Air hitbox", types = {dropdown = {flag = gun.."_aim_assist_air_hitbox", no_none = true, default = {"LowerTorso"}, options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "Closest"}}}}).onDropdownChange, updateLocally)
			utility.newConnection(aim_assist:newElement({name = "Hitbox", types = {dropdown = {flag = gun.."_aim_assist_hitbox", no_none = true, default = {"Head"}, options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "Closest"}}}}).onDropdownChange, updateLocally)
			utility.newConnection(aim_assist:newElement({name = "Horizontal smoothness", types = {slider = {flag = gun.."_aim_assist_horizontal_smoothness", default = 99, min = 0, decimal = 1, max = 100, min_text = "Off", suffix = "%", prefix = ""}}}).onSliderChange, updateLocally)
			local vertical_smoothness = aim_assist:newElement({name = "Vertical smoothness", types = {slider = {flag = gun.."_aim_assist_vertical_smoothness", default = 99, min = 0, decimal = 1, max = 100, min_text = "Off", suffix = "%", prefix = ""}}})
			utility.newConnection(vertical_smoothness.onSliderChange, updateLocally)
			utility.newConnection(aim_assist:newElement({name = "Field of view", types = {slider = {flag = gun.."_aim_assist_field_of_view", min = 1, max = 1000, default = 20, suffix = "°", prefix = "", changers = 1}}}).onSliderChange, updateLocally)
			utility.newConnection(dont_aim_vertically.onToggleChange, function(bool)
				local show = not bool
				vertical_smoothness:setVisible(show)
				updateLocally()
			end)
			utility.newConnection(aim_assist:newElement({name = "Multipoint", types = {slider = {flag = gun.."_aim_assist_multipoint", min = 0, max = 100, default = 0, suffix = "%", prefix = "", changers = 0.1, decimal = 1}}}).onSliderChange, updateLocally)
		local triggerbot = subtab:newSection({name = "Triggerbot"..add, scale = 0.5, x = 0.5, y = 0.5})
			local use_silent_aim_position = triggerbot:newElement({name = "Use silent aim position", types = {toggle = {flag = gun.."_triggerbot_use_silent_aim_position"}}})
			local dont_follow_vertically = triggerbot:newElement({name = "Don't follow vertically", types = {toggle = {flag = gun.."_triggerbot_dont_follow_vertically"}}})
			local air_hitbox = triggerbot:newElement({name = "Air hitbox", types = {dropdown = {flag = gun.."_triggerbot_air_hitbox", no_none = true, default = {"LowerTorso"}, options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "Closest"}}}})
			local hitbox = triggerbot:newElement({name = "Hitbox", types = {dropdown = {flag = gun.."_triggerbot_hitbox", no_none = true, default = {"Head"}, options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "Closest"}}}})
			local trigger_horizontal_radius = triggerbot:newElement({name = "Trigger horizontal radius", types = {slider = {flag = gun.."_triggerbot_horizontal_radius", min = 1, max = 30, default = 0, suffix = "", prefix = "", decimal = 1}}})	
			local trigger_vertical_radius = triggerbot:newElement({name = "Trigger vertical radius", types = {slider = {flag = gun.."_triggerbot_vertical_radius", min = 1, max = 30, default = 0, suffix = "", prefix = "", decimal = 1}}})
			local trigger_cooldown = triggerbot:newElement({name = "Trigger cooldown", types = {slider = {flag = gun.."_triggerbot_cooldown", min = 0, max = 0.5, default = 0, decimal = 3, suffix = "s", prefix = ""}}})			
			local trigger_delay = triggerbot:newElement({name = "Trigger delay", types = {slider = {flag = gun.."_triggerbot_delay", min = 0, max = 0.5, default = 0, decimal = 3, suffix = "s", prefix = ""}}})			
			utility.newConnection(trigger_cooldown.onSliderChange, updateLocally)
			utility.newConnection(trigger_horizontal_radius.onSliderChange, updateLocally)
			utility.newConnection(trigger_vertical_radius.onSliderChange, updateLocally)
			utility.newConnection(trigger_delay.onSliderChange, updateLocally)

			utility.newConnection(dont_follow_vertically.onToggleChange, function(bool)
				local show = not bool
				updateLocally()
			end)
			utility.newConnection(hitbox.onDropdownChange, updateLocally)
			utility.newConnection(air_hitbox.onDropdownChange, updateLocally)
			utility.newConnection(hitbox.onDropdownChange, updateLocally)
			
			utility.newConnection(use_silent_aim_position.onToggleChange, function(bool)
				local show = not bool
				air_hitbox:setVisible(show)
				dont_follow_vertically:setVisible(show)
				hitbox:setVisible(show)
				updateLocally()
			end)
	end

	utility.newConnection(menu_references["target_bind"].onActiveChange, LPH_NO_VIRTUALIZE(function(bool)
		if not flags["aimbot"] then
			return end
	
		local old_closest = aimbot_data["target"]
		local new_target = getClosest(getMouseLocation(uis))

		if old_closest == nil and new_target == nil then
			return 
		end

		setAimbotTarget(not old_closest and new_target or nil)
	end))

	local connection = nil

	utility.newConnection(menu_references["aimbot_enabled"].onToggleChange, LPH_NO_VIRTUALIZE(function(bool)
		aimbot_data["silent_aim_pos"] = nil
		if connection then 
			connection:Disconnect()
			connection = nil
		end
		if find(heartbeat_callbacks, doAimbot) then
			remove(heartbeat_callbacks, doAimbot)
		end
		aimbot_data["position"] = nil
		setAimbotTarget(nil)
		if bool then
			insert(heartbeat_callbacks, doAimbot)
			connection = utility.newConnection(newToolEquipped, updateSettings)
			spawn(updateSettings, lplr_data["tool"])
		end
	end))

	utility.newConnection(menu_references["aimbot_enabled"].onActiveChange, function(bool)
		aimbot_data["silent_aim_pos"] = nil
		if not bool and aimbot_data["target"] then
			setAimbotTarget(nil)
		end
	end)

	utility.newConnection(menu_references["target_checks"].onDropdownChange, function(selected)
		menu_references["max_distance"]:setVisible(find(selected, "Distance"))
	end)
	menu_references["max_distance"]:setVisible(false)

	utility.newConnection(menu_references["max_distance"].onSliderChange, function(value)
		max_distance_value = value
	end)

	local resolver_connection = nil

	local doNetworkResolver = LPH_NO_VIRTUALIZE(function(object, beam, _, hit)
		local target = aimbot_data["target"]

		if not target then
			return end

		local data = player_data[target]
		local hrp = data["character_parts"]["HumanoidRootPart"]

		if not hrp or not data["tool"] then
			return end

		local client_hrp = lplr_parts["HumanoidRootPart"]

		if not client_hrp then
			return end
			
		local old = object.Position + hrp.CFrame.LookVector*vector3new(-6, 0, -6)

		if (client_hrp.Position - old).magnitude > 250 then
			return end

		closest_shot = old

		delay(1, function()
			if closest_shot == old then
				closest_shot = nil
				aimbot_data["force_pos"] = nil
			end
		end)
		
	end)

	utility.newConnection(menu_references["network_resolver"].onToggleChange, function(bool)
		aimbot_data["force_pos"] = nil
		closest_shot = nil
		if resolver_connection then
			resolver_connection:Disconnect()
			resolver_connection = nil
		end
		if bool then
			resolver_connection = utility.newConnection(newPlayerBullet, doNetworkResolver)
		end
	end)

	spawn(updateSettings, nil, true)

	utility.newConnection(menu_references["silent_aim_use_fov"].onToggleChange, function(bool)
		delay(0, updateSettings, lplr_data["tool"], true)
	end)

	utility.newConnection(menu_references["aim_assist_use_fov"].onToggleChange, function(bool)
		delay(0, updateSettings, lplr_data["tool"], true)
	end)
end

local getClosestHitbox = LPH_NO_VIRTUALIZE(function(mouse_pos, character_parts)
	local closest = 9e9
	local closest_part = character_parts["HumanoidRootPart"]

	for i = 1, #part_list do
		local part_name = part_list[i]
		local part = character_parts[part_name]
		
		if not part then 
			continue end

		local pos, on_screen = wtvp(camera, part.Position)
		if on_screen then
			local distance = (mouse_pos - vector2new(pos.X, pos.Y)).magnitude
			if distance < closest then
				closest = distance
				closest_part = part
			end
		end
	end

	return closest_part
end)
	
do
	local silent_out_of_fov = find(flags["silent_aim_disablers"], "Outside of fov")
	local silent_behind_wall = find(flags["silent_aim_disablers"], "Behind wall")
	local silent_off_screen = find(flags["silent_aim_disablers"], "Off screen")
	local render_from_character = true
	local silent_highlight = nil
	local silent_line = nil
	local was_visible = false

	local doSilent = LPH_NO_VIRTUALIZE(function(dt, lplr_hrp)
		local aimbot_position = aimbot_data["silent_aim_pos"]

		if not aimbot_position and was_visible then
			if silent_line then
				silent_line["Visible"] = false
			end
			if silent_highlight then
				silent_highlight["Adornee"] = nil
			end
			aimbot_data["hrp_position"] = nil
			was_visible = false
		end

		was_visible = aimbot_position ~= nil

		local mouse_position = getMouseLocation(uis)
		if silent_fov_circle then
			silent_fov_circle["Position"] = mouse_position
			silent_fov_outline["Position"] = mouse_position
		end
			
		if not flags["silent_aim_keybind"]["active"] then
			aimbot_data["silent_aim_pos"] = nil
			return end

		local target = aimbot_data["target"]

		if not target then
			return end

		local data = player_data[target]

		local character_parts = data["character_parts"]
		local humanoid = character_parts["Humanoid"]
		local hrp = character_parts["HumanoidRootPart"]

		if not humanoid or not hrp then
			aimbot_data["silent_aim_pos"] = nil
			return end
		
		aimbot_data["hrp_position"] = hrp["CFrame"]

		local silent_part = (humanoid.FloorMaterial == Enum.Material.Air and abs(hrp.Velocity.Y) > 0) and aimbot_data["silent_aim_air_hitbox"] or aimbot_data["silent_aim_hitbox"]
		silent_part = silent_part == "Closest" and getClosestHitbox(mouse_position, character_parts) or character_parts[silent_part]
		
		if silent_highlight then
			if silent_highlight["Adornee"] ~= silent_part and silent_part ~= nil then
				silent_highlight["Adornee"] = silent_part
				silent_highlight["Size"] = silent_part.Size + vector3new(0.01,0.01,0.01)
			end
		end

		if not silent_part then
			aimbot_data["silent_aim_pos"] = nil
			return end

		local silent_cframe = silent_part.CFrame
		local silent_multipoint = aimbot_data["silent_aim_multipoint"]

		if silent_multipoint ~= 0 then
			local cf = silent_cframe:PointToObjectSpace(mouse.Hit.p)
			local size = silent_part.Size*(silent_multipoint/200)
	
			silent_cframe*=vector3new(clamp(cf.X, -size.X, size.X),clamp(cf.Y, -size.Y, size.Y),clamp(cf.Z, -size.Z, size.Z))
		end
	
		silent_cframe = vector3new(silent_cframe.X, silent_cframe.Y, silent_cframe.Z)
	
		if silent_out_of_fov then
			local pos = wtvp(camera, silent_cframe)
			pos = vector2new(pos.X, pos.Y)
			if (pos-mouse_position).magnitude > aimbot_data["silent_aim_field_of_view"] then
				aimbot_data["silent_aim_pos"] = nil
				return end
		end
	
		if silent_off_screen then
			local _, on_screen = wtvp(camera, silent_cframe)
			if not on_screen then
				aimbot_data["silent_aim_pos"] = nil
				return end
		end
	
		if silent_behind_wall then
			local position = camera.CFrame.p
			
			raycast_params.FilterDescendantsInstances = {data["character"], char, camera, ignored_folder, vehicles}
	
			if raycast(workspace, position, (silent_cframe - position).unit * (silent_cframe - position).magnitude, raycast_params) then
				aimbot_data["silent_aim_pos"] = nil
				return end
		end
			
		local max_curve = aimbot_data["silent_aim_max_curve_value"]
		local dont_curve_vertically = aimbot_data["silent_aim_dont_curve_vertically"]
		local anti_curve = aimbot_data["silent_aim_anti_curve_value"]
		local anti_curve_enabled = aimbot_data["silent_aim_anti_curve"]
		local ignore_max_curve = aimbot_data["silent_aim_ignore_max_curve"]
	
		if anti_curve_enabled and ignore_max_curve then
			local pos = wtvp(camera, silent_cframe)
			if (mouse_position-vector2new(pos.X, pos.Y)).magnitude > anti_curve then
				aimbot_data["silent_aim_pos"] = nil
				return end
		end
	
		if aimbot_data["silent_aim_max_curve"] or dont_curve_vertically then
			local pos = wtvp(camera, silent_cframe)
			local world_position = mouse_position+((vector2new(pos.X, pos.Y)-mouse_position)*(max_curve/100))
			local ray = vptr(camera, world_position.X, dont_curve_vertically and mouse_position.Y or world_position.Y)
			silent_cframe = ray.Origin + ray.Direction * (ray.Origin-silent_cframe).magnitude
		end
	
		if anti_curve_enabled and not ignore_max_curve then
			local pos = wtvp(camera, silent_cframe)
			if (mouse_position-vector2new(pos.X, pos.Y)).magnitude > anti_curve then
				aimbot_data["silent_aim_pos"] = nil
				return end
		end

		if silent_line then
			local pos, on_screen = wtvp(camera, silent_cframe)
			
			if not on_screen then
				silent_line["Visible"] = false
			else
				local from_pos = render_from_character and wtvp(camera, lplr_hrp["Position"]) or mouse_position

				silent_line["Visible"] = true
				silent_line["From"] = vector2new(from_pos.X, from_pos.Y)
				silent_line["To"] = vector2new(pos.X, pos.Y)
			end
		end

		aimbot_data["silent_aim_pos"] = silent_cframe

		if is_solara and not flags["anti_aim_viewer"] then
			fire_server(event, arg, silent_cframe)

			if flags["aim_backtrack"] then
				local index = insert(mouse_positions, mouse.Hit.p)
				delay(flags["backtrack_lifetime"], function()
					mouse_positions[index] = nil
				end)
			end
		end
	end)

	utility.newConnection(menu_references["silent_aim"].onToggleChange, function(bool)
		aimbot_data["silent_aim_pos"] = nil
		menu_references["silent_aim_use_fov"]:setVisible(bool)
		menu_references["silent_aim_fov_filled"]:setVisible(flags["silent_aim_use_fov"] and bool)
		menu_references["silent_aim_fov_outline"]:setVisible(flags["silent_aim_use_fov"] and bool)
		menu_references["silent_aim_disablers"]:setVisible(bool)
		menu_references["anti_aim_viewer"]:setVisible(bool)
		menu_references["aim_backtrack"]:setVisible(bool and flags["anti_aim_viewer"] or false)
		menu_references["backtrack_lifetime"]:setVisible(bool and flags["aim_backtrack"] or false)
		menu_references["backtrack_max_distance"]:setVisible(bool and flags["aim_backtrack"] or false)
		menu_references["backtrack_fallback"]:setVisible(bool and flags["aim_backtrack"] or false)

		if silent_fov_circle then
			silent_fov_circle:Destroy()
			silent_fov_circle = nil
		end
		if silent_fov_outline then
			silent_fov_outline:Destroy()
			silent_fov_outline = nil
		end
		if find(heartbeat_callbacks, doSilent) then
			remove(heartbeat_callbacks, doSilent)
		end
		if bool then
			if flags["silent_aim_use_fov"] then
				silent_fov_circle = utility.newDrawing("Circle", {
					Visible = true,
					Thickness = 1,
					NumSides = 26,
					Radius = 30,
					Transparency = -flags["silent_aim_fov_transparency"]+1,
					Color = flags["silent_aim_fov_color"],
					Filled = flags["silent_aim_fov_filled"],
				})
				silent_fov_outline = utility.newDrawing("Circle", {
					Visible = flags["silent_aim_fov_outline"],
					Thickness = 3,
					NumSides = 26,
					Radius = 30,
					Transparency = -flags["silent_aim_fov_transparency"]+1,
					Color = flags["silent_aim_fov_outline_color"],
					Filled = false,
				})
			end
			insert(heartbeat_callbacks, doSilent)
		end
	end)

	local doRPG = LPH_NO_VIRTUALIZE(function(dt, lplr_hrp)
		local target = aimbot_data["target"]

		if not target or not lplr_hrp then
			return end

		local data = player_data[target]

		local pos = aimbot_data["force_pos"] or aimbot_data["silent_aim_pos"]
		local children = ignored_folder:GetChildren()
		for i = 1, #children do
			local instance = children[i]
			if instance.Name == "Model" then
				local part = findfirstchild(instance, "Launcher")
				if part then
					if isnetworkowner(part) then
						local body_velocity = findfirstchild(part, "BodyVelocity")
						if body_velocity then
							destroy(body_velocity)
						end
						local touch_interest = findfirstchild(part, "TouchInterest")
						if touch_interest then
							destroy(touch_interest)
						end
						part.CFrame = cframenew(pos+vector3new(0,mathrandom(-75,75)/100,0))
						part.Velocity = vector3new(0,1.85,0)
					end
				end
			end
		end
	end)

	utility.newConnection(menu_references["teleport_rockets"].onToggleChange, function(bool)
		if find(heartbeat_callbacks, doRPG) then
			remove(heartbeat_callbacks, doRPG)
		end
		if bool then
			insert(heartbeat_callbacks, doRPG)
		end
	end)

	local aav_connection = nil
	local aav_connection2 = nil

	local getClosestPosition = LPH_NO_VIRTUALIZE(function(target)
		local closest = nil
		local distance = 9e9
	
		local max_distance = flags["backtrack_max_distance"]
		local screen_pos = wtvp(camera, target)
		screen_pos = vector2new(screen_pos.X, screen_pos.Y)
	
		for _, pos in mouse_positions do
			local on_screen_pos = wtvp(camera, pos)
			local dist = (vector2new(on_screen_pos.X, on_screen_pos.Y)-screen_pos).magnitude
			if dist < distance and dist <= max_distance then
				distance = dist
				closest = pos
			end
		end
		return closest or (flags["backtrack_fallback"][1] == "Mouse position" and mouse_positions[#mouse_positions] or target)
	end)

	local doAntiAimViewer = LPH_NO_VIRTUALIZE(function(gun)
		if aav_connection2 then
			aav_connection2:Disconnect()
			aav_connection2 = nil
		end

		if gun then
			aav_connection2 = utility.newConnection(gun.Activated, function()
				local silent_aim_pos = aimbot_data["silent_aim_pos"]
				if silent_aim_pos then
					local hit_chance = aimbot_data["silent_aim_hit_chance"]
					if hit_chance < 100 and hit_chance <= mathrandom(1, 100) then
						return nil
					end

					event:FireServer(arg, not flags["aim_backtrack"] and silent_aim_pos or getClosestPosition(silent_aim_pos))
				end
			end)
		end
	end)

	utility.newConnection(menu_references["anti_aim_viewer"].onToggleChange, function(bool)
		if aav_connection then
			aav_connection:Disconnect()
			aav_connection = nil
		end
		if aav_connection2 then
			aav_connection2:Disconnect()
			aav_connection2 = nil
		end
		menu_references["aim_backtrack"]:setVisible(bool)
		menu_references["backtrack_lifetime"]:setVisible(bool and flags["aim_backtrack"] or false)
		menu_references["backtrack_max_distance"]:setVisible(bool and flags["aim_backtrack"] or false)
		menu_references["backtrack_fallback"]:setVisible(bool and flags["aim_backtrack"] or false)
		if bool then
			aav_connection = utility.newConnection(newGunEquipped, doAntiAimViewer)
			local gun = lplr_data["gun"]
			if gun then
				doAntiAimViewer(gun)
			end
		end
	end)

	utility.newConnection(menu_references["aim_backtrack"].onToggleChange, function(bool)
		menu_references["backtrack_lifetime"]:setVisible(bool)
		menu_references["backtrack_max_distance"]:setVisible(bool)
		menu_references["backtrack_fallback"]:setVisible(bool)
	end)

	utility.newConnection(menu_references["silent_aim_disablers"].onDropdownChange, function(selected)
		silent_out_of_fov = find(selected, "Outside of fov")
		silent_behind_wall = find(selected, "Behind wall")
		silent_off_screen = find(selected, "Off screen")
	end)
	menu_references["silent_aim_use_fov"]:setVisible(false)
	menu_references["silent_aim_fov_filled"]:setVisible(false)
	menu_references["silent_aim_fov_outline"]:setVisible(false)
	menu_references["silent_aim_disablers"]:setVisible(false)
	menu_references["aim_backtrack"]:setVisible(false)
	menu_references["anti_aim_viewer"]:setVisible(false)
	menu_references["backtrack_lifetime"]:setVisible(false)
	menu_references["backtrack_max_distance"]:setVisible(false)
	menu_references["backtrack_fallback"]:setVisible(false)

	utility.newConnection(menu_references["silent_aim_use_fov"].onToggleChange, function(bool)
		if silent_fov_circle then
			silent_fov_circle:Destroy()
			silent_fov_circle = nil
		end
		if silent_fov_outline then
			silent_fov_outline:Destroy()
			silent_fov_outline = nil
		end

		if not flags["silent_aim"] then
			return end

		if bool then
			silent_fov_circle = utility.newDrawing("Circle", {
				Visible = true,
				Thickness = 1,
				NumSides = 26,
				Radius = 30,
				Transparency = -flags["silent_aim_fov_transparency"]+1,
				Color = flags["silent_aim_fov_color"],
				Filled = flags["silent_aim_fov_filled"],
			})
			silent_fov_outline = utility.newDrawing("Circle", {
				Visible = flags["silent_aim_fov_outline"],
				Thickness = 3,
				NumSides = 26,
				Radius = 30,
				Transparency = -flags["silent_aim_fov_transparency"]+1,
				Color = flags["silent_aim_fov_outline_color"],
				Filled = false,
			})
		end
		menu_references["silent_aim_fov_filled"]:setVisible(bool)
		menu_references["silent_aim_fov_outline"]:setVisible(bool)
	end)

	utility.newConnection(menu_references["silent_aim_use_fov"].onColorChange, function(color, transparency)
		if not silent_fov_circle then
			return end

		silent_fov_circle["Color"] = color
		silent_fov_circle["Transparency"] = -transparency+1
	end)

	utility.newConnection(menu_references["silent_aim_fov_outline"].onToggleChange, function(bool)
		if not silent_fov_outline then
			return end

		silent_fov_outline["Visible"] = bool
	end)

	utility.newConnection(menu_references["silent_aim_fov_filled"].onToggleChange, function(bool)
		if not silent_fov_circle then
			return end

		silent_fov_circle["Filled"] = bool
	end)

	utility.newConnection(menu_references["silent_aim_fov_outline"].onColorChange, function(color, transparency)
		if not silent_fov_outline then
			return end

		silent_fov_outline["Color"] = color
		silent_fov_outline["Transparency"] = -transparency+1
	end)

	local connection100 = nil

	utility.newConnection(menu_references["highlight_silent_hitbox"].onToggleChange, function(bool)
		if silent_highlight then
			silent_highlight:Destroy()
		end
		if connection100 then 
			connection100:Disconnect()
			connection100 = nil
		end
		if bool then
			silent_highlight = newObject("BoxHandleAdornment", {
				ZIndex = 1,
				Color3 = flags["highlight_silent_hitbox_color"],
				Transparency = flags["highlight_silent_hitbox_transparency"],
				Size = vector3new(),
				AlwaysOnTop = true,
				Parent = cg
			})
			connection100 = utility.newConnection(newAimbotTarget, function()
				silent_highlight["Adornee"] = nil
			end)
		end
	end)

	utility.newConnection(menu_references["highlight_silent_hitbox"].onColorChange, function(color, transparency)
		if silent_highlight then
			silent_highlight["Color3"] = color
			silent_highlight["Transparency"] = transparency
 		end
	end)

	local connection200 = nil

	utility.newConnection(menu_references["silent_aim_line"].onToggleChange, function(bool)
		if silent_line then
			silent_line:Destroy()
			silent_line = nil
 		end
		if connection200 then
			connection200:Disconnect()
			connection200 = nil
		end
		if bool then
			silent_line = utility.newDrawing("Line", {
				Color = flags["silent_aim_line_color"],
				Transparency = -flags["silent_aim_line_transparency"]+1,
				Thickness = 1,
				Visible = false,
				ZIndex = 100,
			})
			connection200 = utility.newConnection(newAimbotTarget, function()
				silent_line["Visible"] = false
			end)
		end
		menu_references["silent_aim_line"]:setDropdownVisibility(bool)
	end)
	menu_references["silent_aim_line"]:setDropdownVisibility(false)

	utility.newConnection(menu_references["silent_aim_line"].onColorChange, function(color, transparency)
		if silent_line then
			silent_line["Color"] = color
			silent_line["Transparency"] = -transparency+1
 		end
	end)

	utility.newConnection(menu_references["silent_aim_line"].onDropdownChange, function(selected)
		render_from_character = selected[1] == "From character"
	end)
end

do
	local radius_square = nil
	local radius_outline = nil
	local can_shoot = true
	local terminate = nil
	local doTriggerbot = LPH_NO_VIRTUALIZE(function()
		if terminate then
			terminate = nil
			if radius_square then
				radius_square["Visible"] = false
				radius_outline["Visible"] = false
			end
			aimbot_data["triggerbot_position"] = nil
			return
		end

		if not flags["triggerbot_keybind"]["active"]then
			terminate = 1
			return
		end

		local target = aimbot_data["target"]

		if not target then
			terminate = 1
			return
		end

		local triggerbot_cframe = nil
		if aimbot_data["triggerbot_use_silent_aim_position"] then
			triggerbot_cframe = aimbot_data["force_pos"] or aimbot_data["silent_aim_pos"]

			if not triggerbot_cframe then
				terminate = 1
				return 
			end
		end

		local data = player_data[target]

		if data["forcefield"] or data["knocked"] or data["grabbed"] then
			terminate = 1
			return
		end

		local mouse_position = getMouseLocation(uis)

		if not triggerbot_cframe then
			local character_parts = data["character_parts"]
			local humanoid = character_parts["Humanoid"]
			local hrp = character_parts["HumanoidRootPart"]
	
			if not humanoid or not hrp then
				terminate = 1
				return end
	
			local triggerbot_part = (humanoid.FloorMaterial == Enum.Material.Air and abs(hrp.Velocity.Y) > 0) and aimbot_data["triggerbot_air_hitbox"] or aimbot_data["triggerbot_hitbox"]
			triggerbot_part = triggerbot_part == "Closest" and getClosestHitbox(mouse_position, character_parts) or character_parts[triggerbot_part]
			 
			triggerbot_cframe = triggerbot_part.CFrame

			triggerbot_cframe = triggerbot_cframe["p"]
		end

		local position = camera.CFrame.p
		raycast_params.FilterDescendantsInstances = {data["character"], char, camera, ignored_folder, vehicles}

		if raycast(workspace, position, (triggerbot_cframe - position).unit * (triggerbot_cframe - position).magnitude, raycast_params) then
			terminate = 1
			return end

		local pos = wtvp(camera, triggerbot_cframe)
		local pos2 = wtvp(camera, triggerbot_cframe + vector3new(0,1,0))

		local radius = ((pos.Y-pos2.Y)*0.5)
		local horizontal_size = radius*aimbot_data["triggerbot_horizontal_radius"]
		local vertical_size = radius*aimbot_data["triggerbot_vertical_radius"]
		local size = vector2new(horizontal_size, vertical_size)

		pos = vector2new(pos.X, aimbot_data["triggerbot_dont_follow_vertically"] and mouse_position.Y or pos.Y)

		local new_position = pos - size/2

		if radius_square then
			radius_square["Position"] = new_position
			radius_square["Size"] = size
			radius_square["Visible"] = true 
			radius_outline["Position"] = new_position
			radius_outline["Size"] = size
			radius_outline["Visible"] = true 
		end

		
		local gun = lplr_data["gun"]

		if not gun or getFocusedTextBox(uis) or (flags["triggerbot_only_in_first_person"] and uis.MouseBehavior ~= Enum.MouseBehavior.LockCenter) then
			terminate = 1
			return
		end

		if can_shoot then
			if (mouse_position.X > new_position.X) and (mouse_position.X < new_position.X + horizontal_size) and (mouse_position.Y > new_position.Y) and (mouse_position.Y < new_position.Y + vertical_size) then
				can_shoot = false
				delay(aimbot_data["triggerbot_cooldown"], function()
					can_shoot = true
				end)
				delay(aimbot_data["triggerbot_delay"], function()
					gun:Activate()
					gun:Deactivate()
				end)
			end
		end
	end)

	utility.newConnection(menu_references["show_radius"].onColorChange, function(color, transparency)
		if radius_square then
			radius_square["Color"] = color
			radius_square["Transparency"] = -transparency+1
		end
	end)

	utility.newConnection(menu_references["show_radius"].onToggleChange, function(bool)
		if radius_square then
			radius_square:Destroy()
			radius_square = nil
		end
		if bool then
			local is_gradient = flags["show_radius_gradient"]
			radius_square = utility.newDrawing(is_gradient and "Image" or "Square", {
				["Color"] = flags["show_radius_color"],
				["Transparency"] = -flags["show_radius_transparency"]+1,
				["Thickness"] = 1,
				["Visible"] = false,
				[is_gradient and "Data" or "Filled"] = is_gradient and images["upward_gradient"] or flags["show_radius_filled"],
				["ZIndex"] = 1000
			})
			radius_outline = utility.newDrawing("Square", {
				["Color"] = flags["show_radius_outline"],
				["Transparency"] = -flags["show_radius_outline_transparency"]+1,
				["Thickness"] = 1,
				["Visible"] = false,
				["Filled"] = false,
				["ZIndex"] = 999
			})
		end
		menu_references["show_radius_filled"]:setVisible(bool)
		menu_references["show_radius_outline"]:setVisible(bool)
		menu_references["show_radius_gradient"]:setVisible(bool and flags["show_radius_filled"])
	end)

	utility.newConnection(menu_references["show_radius_filled"].onToggleChange, function(bool)
		if radius_square then
			if flags["show_radius_gradient"] then
				radius_square:Destroy()
				radius_square = nil
				if bool then
					radius_square = utility.newDrawing("Image", {
						["Color"] = flags["show_radius_color"],
						["Transparency"] = -flags["show_radius_transparency"]+1,
						["Thickness"] = 1,
						["Visible"] = false,
						["Image"] = images["upward_gradient"],
						["ZIndex"] = 1000
					})
				end
			else
				radius_square["Filled"] = bool
			end
		end
	end)

	utility.newConnection(menu_references["show_radius_gradient"].onToggleChange, function(bool)
		if radius_square then
			radius_square:Destroy()
			radius_square = nil

			if not flags["show_radius"] then
				return end

			radius_square = utility.newDrawing(bool and "Image" or "Square", {
				["Color"] = flags["show_radius_color"],
				["Transparency"] = -flags["show_radius_transparency"]+1,
				["Thickness"] = 1,
				["Visible"] = false,
				[bool and "Data" or "Filled"] = bool and images["upward_gradient"] or flags["show_radius_filled"],
				["ZIndex"] = 1000
			})
		end
	end)

	utility.newConnection(menu_references["triggerbot"].onToggleChange, function(bool)
		menu_references["triggerbot_only_in_first_person"]:setVisible(bool)
		if find(heartbeat_callbacks, doTriggerbot) then
			remove(heartbeat_callbacks, doTriggerbot)
		end
		if radius_square then
			radius_square:Destroy()
			radius_square = nil
		end
		if radius_outline then
			radius_outline:Destroy()
			radius_outline = nil
		end
		if bool then
			if flags["show_radius"] then
				local is_gradient = flags["show_radius_gradient"]
				radius_square = utility.newDrawing(is_gradient and "Image" or "Square", {
					["Color"] = flags["show_radius_color"],
					["Transparency"] = -flags["show_radius_transparency"]+1,
					["Thickness"] = 1,
					["Visible"] = false,
					[is_gradient and "Data" or "Filled"] = is_gradient and images["upward_gradient"] or flags["show_radius_filled"],
					["ZIndex"] = 1000
				})
				radius_outline = utility.newDrawing("Square", {
					["Color"] = flags["show_radius_outline"],
					["Transparency"] = -flags["show_radius_outline_transparency"]+1,
					["Thickness"] = 1,
					["Visible"] = false,
					["Filled"] = false,
					["ZIndex"] = 999
				})
			end
			insert(heartbeat_callbacks, doTriggerbot)
		end
		menu_references["show_radius_filled"]:setVisible(bool and flags["show_radius"])
		menu_references["show_radius_gradient"]:setVisible(bool and (flags["show_radius"] and flags["show_radius_filled"]))
		menu_references["show_radius_outline"]:setVisible(bool and flags["show_radius"])
		menu_references["show_radius"]:setVisible(bool)
	end)
	menu_references["triggerbot_only_in_first_person"]:setVisible(false)

	utility.newConnection(menu_references["show_radius_outline"].onColorChange, function(color, transparency)
		if radius_outline then
			radius_outline["Color"] = color
			radius_outline["Transparency"] = -transparency+1
		end
	end)
	menu_references["show_radius"]:setVisible(false)
	menu_references["show_radius_filled"]:setVisible(false)
	menu_references["show_radius_gradient"]:setVisible(false)	
	menu_references["show_radius_outline"]:setVisible(false)
end

utility.newConnection(menu_references["auto_select_target"].onToggleChange, function(bool)
	menu_references["auto_select_target"]:setSliderVisibility(bool)
	menu_references["target_bind"]:setVisible(not bool)
	menu_references["sticky"]:setVisible(bool)
end)
menu_references["sticky"]:setVisible(false)
menu_references["auto_select_target"]:setSliderVisibility(false)

do
	local connection2 = nil
	local newGunAdded = LPH_NO_VIRTUALIZE(function(gun)
		if connection2 then
			connection2:Disconnect() 
			connection2 = nil
		end

		if not gun then
			return end

		local ammo = findfirstchild(gun, "Ammo")

		if not ammo then
			return end

		connection2 = utility.newConnection(ammo:GetPropertyChangedSignal("Value"), function()
			if ammo["Value"] == 0 then
				if flags["smart_auto_reload"] then
					wait(flags["smart_auto_reload_delay"])

					if lplr_data["gun"] ~= gun then
						return
					end
				end
				event:FireServer("Reload", gun)
			end
		end)
	end)

	utility.newConnection(menu_references["auto_reload"].onToggleChange, function(bool)
		if connection then
			connection:Disconnect() 
			connection = nil
		end
		if connection2 then
			connection2:Disconnect() 
			connection2 = nil
		end
		if bool then
			connection = utility.newConnection(newGunEquipped, newGunAdded)
			local gun = lplr_data["gun"]
			if gun then
				spawn(newGunAdded, gun)
			end
		end
		menu_references["smart_auto_reload"]:setVisible(bool)
	end)

	utility.newConnection(menu_references["smart_auto_reload"].onToggleChange, function(bool)
		menu_references["smart_auto_reload"]:setSliderVisibility(bool)
	end)
	menu_references["smart_auto_reload"]:setVisible(false)
	menu_references["smart_auto_reload"]:setSliderVisibility(false)

end

do
	local rpg_added_connection = nil

	local avoidRPG = LPH_NO_VIRTUALIZE(function(rpg)
		local old_parent = rpg.Parent.Parent
		while char and rpg and rpg.Parent and rpg.Parent.Parent == old_parent and flags["anti_rpg"] do
			local hrp = lplr_parts["HumanoidRootPart"]

			if not hrp then
				break 
			end

			if (rpg.Position-hrp.Position).magnitude < 30 then
				if flags["anti_rpg_method"][1] == "Avoid" then
					hrp.CFrame = hrp.CFrame + (rpg.CFrame.lookVector*35 * vector3new(1,0,1))
				else
					local target = (flags["reflect_to"][1] == "Target" and (aimbot_data["silent_aim_position"] or 2) or 1)
					if target == 1 then
						local distance = 9e9
						local closest = nil
						for player, data in player_data do
							local player_hrp = data["character_parts"]["HumanoidRootPart"]

							if not player_hrp then
								continue end

							local magnitude = (player_hrp.Position-hrp.Position).magnitude
							if magnitude < distance then
								distance = magnitude
								closest = player_hrp
							end
						end
						target = closest
					end
					
					if not target then
						return end

					local body_velocity = findfirstchild(rpg, "BodyVelocity")
					if body_velocity then
						destroy(body_velocity)
					end
					local touch_interest = findfirstchild(rpg, "TouchInterest")
					if touch_interest then
						destroy(touch_interest)
					end
					rpg.CFrame = cframenew(target + vector3new(0,mathrandom(-75,75)/100,0))
					rpg.Velocity = vector3new(0,0.01,0)
				end
			end

			wait(0.03)
		end
	end)

	utility.newConnection(menu_references["anti_rpg"].onToggleChange, function(bool)
		if rpg_added_connection then
			rpg_added_connection:Disconnect()
		end
		if bool then
			rpg_added_connection = utility.newConnection(ignored_folder.ChildAdded, LPH_NO_VIRTUALIZE(function(object)
				if object.Name == "Model" then
					local part = object:WaitForChild("Launcher", 1)
					if part then
						spawn(avoidRPG, part)
					end
				end
			end))
		end
	end)

	utility.newConnection(menu_references["anti_rpg"].onDropdownChange, function(selected)
		menu_references["reflect_to"]:setVisible(selected[1] == "Reflect")
	end)
	menu_references["reflect_to"]:setVisible(false)
end

do
	local use_mouse = false
	local assist_highlight = nil
	local assist_out_of_fov = find(flags["aim_assist_disablers"], "Outside of fov")
	local assist_holding_tool = find(flags["aim_assist_disablers"], "No tool equipped")
	local assist_third_person = find(flags["aim_assist_disablers"], "In third person")
	local assist_behind_wall = find(flags["aim_assist_disablers"], "Behind wall")
	local assist_typing = find(flags["aim_assist_disablers"], "Typing")
	local assist_off_screen = find(flags["aim_assist_disablers"], "Off screen")
	local was_visible = false
	
	local doAimAssist = LPH_NO_VIRTUALIZE(function(dt)
		if not was_visible then
			if assist_highlight then
				assist_highlight["Adornee"] = nil
			end
		end

		was_visible = false

		local mouse_position = getMouseLocation(uis)

		if assist_fov_circle then
			assist_fov_circle["Position"] = mouse_position
			assist_fov_outline["Position"] = mouse_position
		end

		if not flags["aim_assist_keybind"]["active"] then
			return 
		end

		local target = aimbot_data["target"]

		if not target then
			return end

		local data = player_data[target]

		local character_parts = data["character_parts"]
		local humanoid = character_parts["Humanoid"]
		local hrp = character_parts["HumanoidRootPart"]

		if not humanoid or not hrp then
			return end
		
		local in_air = (humanoid.FloorMaterial == Enum.Material.Air and abs(hrp.Velocity.Y) > 0) 
		local assist_part = in_air and aimbot_data["aim_assist_air_hitbox"] or aimbot_data["aim_assist_hitbox"]
		assist_part = assist_part == "Closest" and getClosestHitbox(mouse_position, character_parts) or character_parts[assist_part]

		if assist_highlight then
			if assist_highlight["Adornee"] ~= assist_part then
				assist_highlight["Adornee"] = assist_part
				assist_highlight["Size"] = assist_part.Size + vector3new(0.01,0.01,0.01)
			end
		end

		if not assist_part then
			return end
	
		local assist_cframe = assist_part.CFrame
		local assist_multipoint = aimbot_data["aim_assist_multipoint"]
	
		if assist_multipoint ~= 0 then
			local cf = assist_cframe:PointToObjectSpace(mouse.Hit.p)
			local size = assist_part.Size*(assist_multipoint/200)
	
			assist_cframe*=vector3new(clamp(cf.X, -size.X, size.X),clamp(cf.Y, -size.Y, size.Y),clamp(cf.Z, -size.Z, size.Z))
		end
	
		assist_cframe = vector3new(assist_cframe.X, assist_cframe.Y, assist_cframe.Z)

		if assist_holding_tool and not lplr_data["tool"] then
			return end
	
		if assist_third_person and uis.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
			return end
	
		if assist_typing and getFocusedTextBox(uis) then
			return end
	
		if assist_out_of_fov then
			local pos = wtvp(camera, assist_cframe)
			pos = vector2new(pos.X, pos.Y)
			if (pos-mouse_position).magnitude > aimbot_data["aim_assist_field_of_view"] then
				return end
		end
	
		if assist_off_screen then
			local _, on_screen = wtvp(camera, assist_cframe)
			if not on_screen then
				return end
		end
	
		if assist_behind_wall then
			local position = camera.CFrame.p
			
			raycast_params.FilterDescendantsInstances = {data["character"], char, camera, ignored_folder, vehicles}
	
			if raycast(workspace, position, (assist_cframe - position).unit * (assist_cframe - position).magnitude, raycast_params) then
				return end
		end

		if use_mouse then
			local pos = wtvp(camera, assist_cframe)
			local new_pos = vector2new(pos.X, pos.Y)
			local distance = new_pos-mouse_position
			local style = aimbot_data["aim_assist_smoothing_style"]
			local direction = aimbot_data["aim_assist_smoothing_direction"]
			mousemoverel(distance.X * getValue(tws, (1.0001-aimbot_data["aim_assist_horizontal_smoothness"]) * (dt*15), style, direction), aimbot_data["aim_assist_dont_aim_vertically"] and 0 or distance.Y * getValue(tws, (1.0001-aimbot_data["aim_assist_vertical_smoothness"]) * (dt*15), style, direction))	
		else
			camera.CFrame = camera.CFrame:Lerp(cframenew(camera.CFrame.p, assist_cframe), getValue(tws, ((1.0001-aimbot_data["aim_assist_horizontal_smoothness"])) * (dt*15), aimbot_data["aim_assist_smoothing_style"], aimbot_data["aim_assist_smoothing_direction"]))
		end

		was_visible = true
	end)

	utility.newConnection(menu_references["aim_assist"].onToggleChange, function(bool)
		menu_references["aim_assist"]:setDropdownVisibility(bool)
		menu_references["aim_assist_use_fov"]:setVisible(bool)
		menu_references["aim_assist_fov_filled"]:setVisible(flags["aim_assist_use_fov"] and bool)
		menu_references["aim_assist_fov_outline"]:setVisible(flags["aim_assist_use_fov"] and bool)
		menu_references["aim_assist_disablers"]:setVisible(bool)
		if assist_fov_circle then
			assist_fov_circle:Destroy()
			assist_fov_circle = nil
		end
		if assist_fov_outline then
			assist_fov_outline:Destroy()
			assist_fov_outline = nil
		end
		if find(heartbeat_callbacks, doAimAssist) then
			remove(heartbeat_callbacks, doAimAssist)
		end
		if bool then
			if flags["aim_assist_use_fov"] then
				assist_fov_circle = utility.newDrawing("Circle", {
					Visible = true,
					Thickness = 1,
					NumSides = 26,
					Radius = 30,
					Transparency = -flags["aim_assist_fov_transparency"]+1,
					Color = flags["aim_assist_fov_color"],
					Filled = flags["aim_assist_fov_filled"],
				})
				assist_fov_outline = utility.newDrawing("Circle", {
					Visible = flags["aim_assist_fov_outline"],
					Thickness = 3,
					NumSides = 26,
					Radius = 30,
					Transparency = -flags["aim_assist_fov_transparency"]+1,
					Color = flags["aim_assist_fov_outline_color"],
					Filled = false,
				})
			end
			insert(heartbeat_callbacks, doAimAssist)
		end
	end)

	utility.newConnection(menu_references["aim_assist"].onDropdownChange, function(selected)
		use_mouse = selected[1] == "Mouse"
	end)
	menu_references["aim_assist_use_fov"]:setVisible(false)
	menu_references["aim_assist_fov_filled"]:setVisible(false)
	menu_references["aim_assist_fov_outline"]:setVisible(false)
	menu_references["aim_assist_disablers"]:setVisible(false)
	menu_references["aim_assist"]:setDropdownVisibility(false)

	utility.newConnection(menu_references["aim_assist_use_fov"].onToggleChange, function(bool)
		if assist_fov_circle then
			assist_fov_circle:Destroy()
			assist_fov_circle = nil
		end
		if assist_fov_outline then
			assist_fov_outline:Destroy()
			assist_fov_outline = nil
		end

		if not flags["aim_assist"] then
			return end

		if bool then
			assist_fov_circle = utility.newDrawing("Circle", {
				Visible = true,
				Thickness = 1,
				NumSides = 26,
				Radius = 30,
				Transparency = -flags["aim_assist_fov_transparency"]+1,
				Color = flags["aim_assist_fov_color"],
				Filled = flags["aim_assist_fov_filled"],
			})
			assist_fov_outline = utility.newDrawing("Circle", {
				Visible = flags["aim_assist_fov_outline"],
				Thickness = 3,
				NumSides = 26,
				Radius = 30,
				Transparency = -flags["aim_assist_fov_transparency"]+1,
				Color = flags["aim_assist_fov_outline_color"],
				Filled = false,
			})
		end
		menu_references["aim_assist_fov_filled"]:setVisible(bool)
		menu_references["aim_assist_fov_outline"]:setVisible(bool)
	end)

	utility.newConnection(menu_references["aim_assist_disablers"].onDropdownChange, function(selected)
		assist_out_of_fov = find(selected, "Outside of fov")
		assist_behind_wall = find(selected, "Behind wall")
		assist_holding_tool = find(selected, "No tool equipped")
		assist_third_person = find(selected, "In third person")
		assist_behind_wall = find(selected, "Behind wall")
		assist_typing = find(selected, "Typing")
		assist_off_screen = find(selected, "Off screen")
	end)

	utility.newConnection(menu_references["aim_assist_use_fov"].onColorChange, function(color, transparency)
		if not assist_fov_circle then
			return end

		assist_fov_circle["Color"] = color
		assist_fov_circle["Transparency"] = -transparency+1
	end)

	utility.newConnection(menu_references["aim_assist_fov_outline"].onToggleChange, function(bool)
		if not assist_fov_outline then
			return end

		assist_fov_outline["Visible"] = bool
	end)

	utility.newConnection(menu_references["aim_assist_fov_filled"].onToggleChange, function(bool)
		if not assist_fov_circle then
			return end

		assist_fov_circle["Filled"] = bool
	end)

	utility.newConnection(menu_references["aim_assist_fov_outline"].onColorChange, function(color, transparency)
		if not assist_fov_outline then
			return end

		assist_fov_outline["Color"] = color
		assist_fov_outline["Transparency"] = -transparency+1
	end)

	local connection100 = nil

	utility.newConnection(menu_references["highlight_assist_hitbox"].onToggleChange, function(bool)
		if assist_highlight then
			assist_highlight:Destroy()
		end
		if connection100 then 
			connection100:Disconnect()
			connection100 = nil
		end
		if bool then
			assist_highlight = newObject("BoxHandleAdornment", {
				ZIndex = 1,
				Color3 = flags["highlight_assist_hitbox_color"],
				Transparency = flags["highlight_assist_hitbox_transparency"],
				Size = vector3new(),
				AlwaysOnTop = true,
				Parent = cg
			})
			connection100 = utility.newConnection(newAimbotTarget, function()
				assist_highlight["Adornee"] = nil
			end)
		end
	end)

	utility.newConnection(menu_references["highlight_assist_hitbox"].onColorChange, function(color, transparency)
		if assist_highlight then
			assist_highlight["Color3"] = color
			assist_highlight["Transparency"] = transparency
 		end
	end)
end

do
	local last_position = nil
	local last_remote_fire = clock()
	local doAutoStomp = LPH_NO_VIRTUALIZE(function(dt, hrp)
		local is_one_knocked = nil

		for player, _ in ragebot_data do
			local data = player_data[player]

			if data["knocked"] and not data["dead"] then
				is_one_knocked = data["character_parts"]["UpperTorso"]
				break
			end
		end

		if is_one_knocked then
			if not last_position then
				last_position = lplr_pos
			end
			lplr_pos = cframenew(is_one_knocked["Position"] + vector3new(0,2.5,0))
			if clock()-last_remote_fire > 0.03 then
				event:FireServer("Stomp")
			end
		elseif last_position then
			if flags["teleport_back"] then
				lplr_pos = last_position
			end
			last_position = nil
		end
	end)
	utility.newConnection(menu_references["auto_stomp"].onToggleChange, function(bool)
		if find(heartbeat_callbacks, doAutoStomp) then
			remove(heartbeat_callbacks, doAutoStomp)
		end
		if bool then
			insert(heartbeat_callbacks, doAutoStomp)
		end
		menu_references["teleport_back"]:setVisible(bool)
	end)
	menu_references["teleport_back"]:setVisible(false)

	local terminate = nil
	local do_terminate = nil

	local doAutoShoot = LPH_NO_VIRTUALIZE(function(dt, lplr_hrp)
		local target = aimbot_data["target"]
		local gun = lplr_data["gun"]

		if not gun or gun["Name"] == "[RPG]" then
			return end

		
		if terminate and do_terminate then
			if clock() - terminate > 0.5 or data["knocked"] then
				do_terminate = false
				gun:Deactivate()
			end
			terminate = nil
		end

		if not flags["auto_shoot_keybind"]["active"] then
			terminate = clock()
			return end

		if not target or not lplr_hrp then
			terminate = clock()
			return end

		local pos = aimbot_data["force_pos"] or aimbot_data["silent_aim_pos"]

		if not pos then
			terminate = clock()
			return end

		local data = player_data[target]

		if data["forcefield"] or data["knocked"] or data["grabbed"] then
			terminate = clock()
			return end

		local handle_position = gun["Handle"]["Position"]
		local distance = pos-handle_position
		local magnitude = distance.magnitude

		if magnitude > 500 then
			terminate = clock()
			return end

		raycast_params.FilterDescendantsInstances = {data["character"], char, workspace.Players, ignored_folder, vehicles}

		local z = raycast(workspace, handle_position, distance.unit * magnitude, raycast_params) 
		if z then
			terminate = clock()
			return end

		gun:Activate()
		do_terminate = true
		terminate = nil
	end)

	utility.newConnection(menu_references["auto_shoot"].onToggleChange, function(bool)
		local gun = lplr_data["gun"]

		if gun then
			gun:Deactivate()
		end
		if find(heartbeat_callbacks, doAutoShoot) then
			remove(heartbeat_callbacks, doAutoShoot)
		end
		if bool then
			insert(heartbeat_callbacks, doAutoShoot)
		end
	end)

	local connection = nil

	utility.newConnection(menu_references["include_aimbot_target"].onToggleChange, function(bool)
		if connection then
			connection:Disconnect()
			connection = nil
		end

		local target = aimbot_data["target"]

		if bool then
			if target then
				ragebot_data[target] = 1
			end 

			local old_target = target

			connection = utility.newConnection(newAimbotTarget, function(player)
				if old_target then
					ragebot_data[old_target] = nil
				end
				if player then
					ragebot_data[player] = 1
				end
				old_target = player
			end)
		elseif target and not player_data[target]["ragebot"] then
			ragebot_data[target] = nil
		end
	end)
end

do
	local strafe_angle = 0
	local only_on_serverside = false
	local attachToTarget = LPH_NO_VIRTUALIZE(function(dt, lplr_hrp)
		if not flags["attach_to_target_keybind"]["active"] or not lplr_hrp then
			return end
			
		local target = aimbot_data["target"]

		if not target then
			return end
			
		local data = player_data[target]
		local hrp = data["character_parts"]["HumanoidRootPart"]

		if not hrp or (data["knocked"] and flags["disable_when_knocked"]) then
			return end

		local style = flags["attach_to_target_value"][1]

		if style == "Random teleport" then
			local horizontal_offset = flags["attach_horizontal_offset"]
			local vertical_offset = flags["attach_vertical_offset"]
	
			local new_position = hrp["CFrame"]-vector3new(mathrandom(-horizontal_offset,horizontal_offset), mathrandom(-vertical_offset,vertical_offset), mathrandom(-horizontal_offset,horizontal_offset))
			if only_on_serverside then
				lplr_hrp["CFrame"] = new_position
			else
				lplr_pos = new_position
			end
		else
			local hrp_pos = hrp["CFrame"] + vector3new(0, flags["attach_vertical_strafe"], 0)
			strafe_angle+=clamp((flags["attach_strafe_speed"]*15)*dt, 0, 360)

			if strafe_angle > 360 then 
				strafe_angle = 0 
			end

			local new_position = angles(0,rad(strafe_angle),0) * cframenew(0,0,flags["attach_horizontal_strafe"]) + hrp_pos["p"]
			if only_on_serverside then
				lplr_hrp["CFrame"] = new_position
			else
				lplr_pos = new_position
			end
		end
	end)

	utility.newConnection(menu_references["attach_to_target"].onToggleChange, function(bool)
		local selected = flags["attach_to_target_value"][1]
		if find(heartbeat_callbacks, attachToTarget) then
			remove(heartbeat_callbacks, attachToTarget)
		elseif find(anti_callbacks, attachToTarget) then
			remove(anti_callbacks, attachToTarget)
		end
		if bool then
			insert(flags["only_on_serverside"] and anti_callbacks or heartbeat_callbacks, attachToTarget)
		end
		menu_references["attach_vertical_offset"]:setVisible(selected ~= "Strafe" and bool)
		menu_references["attach_horizontal_offset"]:setVisible(selected ~= "Strafe" and bool)
		menu_references["attach_vertical_strafe"]:setVisible(selected == "Strafe" and bool)
		menu_references["attach_horizontal_strafe"]:setVisible(selected == "Strafe" and bool)
		menu_references["attach_strafe_speed"]:setVisible(selected == "Strafe" and bool)
		menu_references["disable_when_knocked"]:setVisible(bool)
		menu_references["only_on_serverside"]:setVisible(bool)
		menu_references["attach_to_target"]:setDropdownVisibility(bool)
	end)

	utility.newConnection(menu_references["only_on_serverside"].onToggleChange, function(bool)
		only_on_serverside = bool
		if find(heartbeat_callbacks, attachToTarget) then
			remove(heartbeat_callbacks, attachToTarget)
		elseif find(anti_callbacks, attachToTarget) then
			remove(anti_callbacks, attachToTarget)
		end
		if flags["attach_to_target"] then
			insert(bool and anti_callbacks or heartbeat_callbacks, attachToTarget)
		end
	end)

	utility.newConnection(menu_references["attach_to_target"].onDropdownChange, function(selected)
		if not flags["attach_to_target"] then
			return end

		local selected = selected[1]
		local is_strafe = selected == "Strafe"
		menu_references["attach_vertical_offset"]:setVisible(not is_strafe)
		menu_references["attach_horizontal_offset"]:setVisible(not is_strafe)
		menu_references["attach_vertical_strafe"]:setVisible(is_strafe)
		menu_references["attach_horizontal_strafe"]:setVisible(is_strafe)
		menu_references["attach_strafe_speed"]:setVisible(is_strafe)
	end)
	menu_references["attach_vertical_offset"]:setVisible(false)
	menu_references["attach_horizontal_offset"]:setVisible(false)
	menu_references["attach_vertical_strafe"]:setVisible(false)
	menu_references["attach_horizontal_strafe"]:setVisible(false)
	menu_references["attach_strafe_speed"]:setVisible(false)
	menu_references["attach_to_target"]:setDropdownVisibility(false)
	menu_references["disable_when_knocked"]:setVisible(false)
	menu_references["only_on_serverside"]:setVisible(false)
end

--[[
	     _                                
        | |                               
  _ __  | |  __ _  _   _   ___  _ __  ___ 
 | '_ \ | | / _` || | | | / _ \| '__|/ __|
 | |_) || || (_| || |_| ||  __/| |   \__ \
 | .__/ |_| \__,_| \__, | \___||_|   |___/
 | |                __/ |                 
 |_|               |___/                  
]]

local playerCharacterAdded = LPH_NO_VIRTUALIZE(function(character)
	local humanoid = character:WaitForChild("Humanoid", 60)

	if not humanoid then
		return end

	local player = findfirstchild(plrs, character.Name)

	if not player then
		return end

	local data = player_data[player]
	local drawings = data["drawings"]

	data["character"] = character

	if lplr_data["viewing"] == player then
		camera.CameraSubject = character
	end

	spawn(tweenProperty, data, "health", humanoid.Health ~= 0 and humanoid.Health or 100)
	data["max_health"] = humanoid.MaxHealth
	
	local tool = drawings["tool"]
	if tool then
		tool["Text"] = " "
	end
	local health_bar = drawings["health_bar"]
	local health_text = drawings["health_text"]

	if health_bar and do_dynamic_health_color then
		health_bar["Color"] = flags["player_esp_health_bar_dynamic_color"]:Lerp(flags["player_esp_health_bar_color"], humanoid.Health ~= 0 and humanoid.Health or 100/data["max_health"])
	end
	if health_text then
		health_text["Text"] = round(humanoid.Health ~= 0 and humanoid.Health or 100, 0)
		if do_dynamic_health_text_color then
			health_text["Color"] = flags["player_esp_health_text_dynamic_color"]:Lerp(flags["player_esp_health_text_color"], humanoid.Health ~= 0 and humanoid.Health or 100/data["max_health"])
		end
	end
	
	local super_gun_warning = drawings["super_gun_warning"]

	if super_gun_warning then
		super_gun_warning["Text"] = " "
	end

	local weapon_icon = drawings["weapon_icon"]

	if weapon_icon then
		weapon_icon["Data"] = ""
	end

	data["character_parts"] = {}
	data["character"] = character
	data["tool"] = nil
	data["has_super_gun"] = false

	local children = character:GetChildren() 
	for i = 1, #children do
		local object = children[i]
		data["character_parts"][object.Name] = object
		if object.ClassName == "Tool" then
			local drawings = drawings
			local tool = drawings["tool"]
			local tool_name = utility.removeBrackets(object.Name)

			data["tool"] = tool_name

			if tool then
				tool["Text"] = data["tool"]
			end

			local image = images[tool_name]
			if image then
				data["weapon"] = tool_name

				if weapon_icon then
					weapon_icon["Data"] = image
				end
			end

			if (tool_name == "flamethrower" or tool_name == "rpg") then
				local super_gun_warning = drawings["super_gun_warning"]
				data["has_super_gun"] = true

				if not super_gun_warning then
					continue end

				super_gun_warning["Text"] = "SG"
			end
		elseif object.ClassName == "ForceField" then
			data["forcefield"] = true
		end
	end

	local children = player.Backpack:GetChildren()

	for i = 1, #children do
		local tool = children[i]
		local tool_name = utility.removeBrackets(tool.Name)

		if (tool_name == "flamethrower" or tool_name == "rpg") then
			local super_gun_warning = drawings["super_gun_warning"]
			data["has_super_gun"] = true

			if not super_gun_warning then
				break 
			end

			super_gun_warning["Text"] = "SG"
		end
	end

	local fix = nil; fix = utility.newConnection(humanoid:GetPropertyChangedSignal("MaxHealth"), function()
		data["max_health"] = humanoid.MaxHealth
		fix:Disconnect()
	end)

	utility.newConnection(character.ChildAdded, function(object)
		data["character_parts"][object.Name] = object
		if object.ClassName == "Tool" then
			local tool = drawings["tool"]
			local tool_name = utility.removeBrackets(object.Name)

			data["tool"] = tool_name

			if tool then
				tool["Text"] = data["tool"]
			end

			local image = images[tool_name]
			if image then
				data["weapon"] = tool_name

				local weapon_icon = drawings["weapon_icon"]

				if weapon_icon then
					weapon_icon["Data"] = image
				end
			end
		elseif object.ClassName == "ForceField" then
			data["forcefield"] = true
		elseif object.ClassName == "Accessory" then
			if flags["forcefield_hats_2"] then
				local part = findfirstchild(object, "Handle")
				if part then
					part["Material"] = Enum.Material.ForceField
					part["Color"] = flags["forcefield_hats_2_color"]
					part["Transparency"] = flags["forcefield_hats_2_transparency"]
				end
			end
		end
	end, true)

	utility.newConnection(character.ChildRemoved, function(object)
		data["character_parts"][object.Name] = nil
		if object.ClassName == "Tool" then
			data["tool"] = nil
			local tool = drawings["tool"]
			local tool_name = utility.removeBrackets(object.Name)
			if tool then
				tool["Text"] = " "
			end
			local image = images[tool_name]
			data["weapon"] = nil

			if image then
				local weapon_icon = drawings["weapon_icon"]

				if weapon_icon then
					weapon_icon["Data"] = ""
				end
			end
		elseif object.ClassName == "ForceField" then
			data["forcefield"] = false
		end
	end)

	local old_health = humanoid.Health
	utility.newConnection(humanoid:GetPropertyChangedSignal("Health"), function()
		local health = humanoid.Health
		spawn(tweenProperty, data, "health", health)
		local health_bar = drawings["health_bar"]
		if health_bar and do_dynamic_health_color then
			health_bar["Color"] = flags["player_esp_health_bar_dynamic_color"]:Lerp(flags["player_esp_health_bar_color"], health/data["max_health"])
		end
		local health_text = drawings["health_text"]
		if health_text then
			health_text["Text"] = floor(health)
			if do_dynamic_health_text_color then
				health_text["Color"] = flags["player_esp_health_text_dynamic_color"]:Lerp(flags["player_esp_health_text_color"], health/data["max_health"]) or flags["player_esp_health_text_color"]
			end
		end
		local remainder = old_health-health
		if lplr_data["recently_shot"] and remainder > 1 then
			hitPlayer:Fire(player, data["character_parts"], floor(remainder))
		end
		old_health = humanoid.Health
	end)

	utility.newConnection(player.Backpack.ChildAdded, function(tool)
		local tool_name = utility.removeBrackets(tool.Name)

		if tool_name == "flamethrower" or tool_name == "rpg" then
			data["has_super_gun"] = true

			local super_gun_warning = drawings["super_gun_warning"]

			if not super_gun_warning then
				return end
				
			super_gun_warning["Text"] = "SG"
		end
	end)

	if data["highlight"] then
		delay(0, function()
			data["highlight"]["Adornee"] = nil
			data["highlight"]["Adornee"] = character
			data["highlight"]["Adornee"] = nil
			data["highlight"]["Adornee"] = character
		end)
	end

	if flags["player_esp"] then
		spawn(tweenESP, data, true)
	end

	local body_effects = character:WaitForChild("BodyEffects", 240)

	if not body_effects then
		return end

	local dead = body_effects:WaitForChild("Dead", 120)
	data["dead"] = dead.Value

	utility.newConnection(dead:GetPropertyChangedSignal("Value"), function()
		data["dead"] = dead.Value
		if data["dont_render"] then
			return end

		data["last_position"] = data["character_parts"]["UpperTorso"]["Position"]
		
		if flags["player_esp"] then
			spawn(tweenESP, data, false)
		end
	end)

	local knocked = body_effects:WaitForChild("K.O", 120)

	utility.newConnection(knocked:GetPropertyChangedSignal("Value"), function()
		data["knocked"] = knocked.Value
		if aimbot_data["target"] == player then
			if find(flags["untarget_when"], "Target knocked") then
				setAimbotTarget(nil)
			end
		end
	end)
	data["knocked"] = knocked.Value

	local grabbed = body_effects:WaitForChild("Grabbed", 120)

	utility.newConnection(grabbed:GetPropertyChangedSignal("Value"), function()
		data["grabbed"] = grabbed.Value
	end)
	data["grabbed"] = grabbed.Value

	local armor = body_effects:WaitForChild("Armor", 120)

	spawn(tweenProperty, data, "armor", armor.Value)
	utility.newConnection(armor:GetPropertyChangedSignal("Value"), function()
		local armor = armor.Value
		spawn(tweenProperty, data, "armor", armor)
		local armor_bar = drawings["armor_bar"]
		if armor_bar and do_dynamic_armor_color then
			armor_bar["Color"] = flags["player_esp_armor_bar_dynamic_color"]:Lerp(flags["player_esp_armor_bar_color"], armor/130)
		end
	end)

	local armor_bar = drawings["armor_bar"]
	if armor_bar and do_dynamic_armor_color then
		armor_bar["Color"] = flags["player_esp_armor_bar_dynamic_color"]:Lerp(flags["player_esp_armor_bar_color"], armor.Value/130)
	end

	wait(1)

	if flags["body_material"] then
		local parts = data["character_parts"]

		local material = Enum.Material[flags["body_material_value"][1]]
		local color = flags["body_material_color"]
		local transparency = flags["body_material_transparency"]
		for name, part in parts do
			if name == "[CarHitBox]" then
				continue end

			if name ~= "HumanoidRootPart" and part:IsA("BasePart") then
				part.Material = material
				part.Color = color
				part.Transparency = transparency
			end 
		end
		
		local shirt, pants, t_shirt, head = parts["Shirt"], parts["Pants"], parts["Shirt Graphic"], data["Head"]

		if shirt then
			shirt.Parent = humanoid
		end

		if pants then
			pants.Parent = humanoid
		end

		if t_shirt then
			t_shirt.Parent = humanoid
		end

		if head then
			local decal = findfirstchildofclass(head, "Decal")
			if decal then
				decal.Parent = humanoid
			end
		end
	end

	if flags["forcefield_hats_2"] then
		local color = flags["forcefield_hats_2_color"]
		local material = Enum.Material.ForceField
		for _, accessory in data["character_parts"] do
			if accessory["ClassName"] == "Accessory" then
				local part = findfirstchild(accessory, "Handle")
				if part then
					part["Material"] = material
					part["Color"] = color
				end
			end
		end
	end
end)

local playerAdded;
do
	local whitelisted, all, target, ragebot = false, true, false, false

	playerAdded = LPH_NO_VIRTUALIZE(function(player)
		player_data[player] = {
			character = player["Character"],
			health = 100,
			tool = nil,
			character_parts = {},
			connections = {},
			drawings = {},
			dont_render = true,
			max_health = 100,
			name = player.Name,
			whitelisted = lplr_data["whitelisted"][player.Name] ~= nil,
			ragebot = lplr_data["ragebot"][player.Name] ~= nil,
			armor = 0,
			instance = player,
			tweens = {}
		}

		local data = player_data[player]

		data["rendering"] = all and true or whitelisted and data["whitelisted"] or ragebot and data["ragebot"] or target and tostring(aimbot_data["target"]) == data["name"]


		if flags["player_esp"] then
			createESP(player_data[player])
		end

		utility.newConnection(player.CharacterAdded, playerCharacterAdded)

		if player.Character then
			spawn(playerCharacterAdded, player.Character)
		end

		local data = player_data[player]
		
		if data["ragebot"] then
			ragebot_data[player] = 1
		end

		menu_references["players_box"]:addOption(player.Name)

		local data_folder = player:WaitForChild("DataFolder", 240)
		if not data_folder then
			return end
		local information = data_folder:WaitForChild("Information", 20)
			if not information then
				return end
			local crew = information:WaitForChild("Crew", 20)

		if crew then
			player_data[player]["crew"] = crew.Value

			utility.newConnection(crew:GetPropertyChangedSignal("Value"), function()
				player_data[player]["crew"] = crew.Value
			end, true)
		end
	end)

	utility.newConnection(menu_references["view_aim"].onToggleChange, function(bool)
		local player = findfirstchild(plrs, menu_references["players_box"]["selected_option"] or "")
	
		if not player then
			return end 
	
		local info = player_data[player]
	
		local old_info = lplr_data["aim_viewing"][player]

		if old_info then
			local old_function = old_info[1]
			local old_line = old_info[2]

			if find(heartbeat_callbacks, old_function) then
				remove(heartbeat_callbacks, old_function)
			end
			if old_line then
				old_line:Destroy()
			end
			lplr_data["aim_viewing"][player] = nil
		end

		if bool then
			local line = utility.newDrawing("Line", {
				Color = flags["view_aim_color"],
				Transparency = -flags["view_aim_transparency"]+1,
				Visible = true,
				ZIndex = 1
			})
			local new_function = LPH_NO_VIRTUALIZE(function(dt)
				local character_parts = info["character_parts"]
				local body_effects = character_parts["BodyEffects"]

				if not body_effects or info["forcefield"] or not info["tool"] then
					line["Visible"] = false
					return end

				local hrp = character_parts["HumanoidRootPart"]

				if not hrp then
					line["Visible"] = false
					return end

				local mouse_pos = body_effects["MousePos"]

				local pos, on_screen = wtvp(camera, hrp["Position"])
				local pos2, on_screen2 = wtvp(camera, mouse_pos["Value"])

				if not on_screen and not on_screen2 then
					line["Visible"] = false
					return end

				line["Visible"] = true

				line["From"] = vector2new(pos.X, pos.Y)
				line["To"] = vector2new(pos2.X, pos2.Y)
			end)
			insert(heartbeat_callbacks, new_function)
			lplr_data["aim_viewing"][player] = {new_function, line}
		end
	end, true)

	utility.newConnection(menu_references["ragebot"].onToggleChange, function(bool)
		local player = findfirstchild(plrs, menu_references["players_box"]["selected_option"])
	
		if not player then
			return end 
	
		local data = player_data[player]
		local ragebot_value = bool and 1 or nil
		data["rendering"] = all and true or whitelisted and whitelisted_value or ragebot and ragebot_value or target and tostring(aimbot_data["target"]) == data["Name"]
		local highlight = data["highlight"]
		if highlight then
			data["highlight"]["Enabled"] = data["rendering"]
		end
		lplr_data["ragebot"][player] = bool and 1 or nil
	end, true)

	utility.newConnection(menu_references["whitelisted"].onToggleChange, function(bool)
		local player = findfirstchild(plrs, menu_references["players_box"]["selected_option"] or "")
	
		if not player then
			return end 

		local data = player_data[player]
		local whitelisted_value = bool and 1 or nil
		data["rendering"] = all and true or whitelisted and whitelisted_value or ragebot and data["ragebot"] or target and tostring(aimbot_data["target"]) == data["Name"]
		local highlight = data["highlight"]
		if highlight then
			data["highlight"]["Enabled"] = data["rendering"]
		end
		lplr_data["whitelisted"][player] = bool and 1 or nil
	end, true)

	utility.newConnection(menu_references["view_aim"].onColorChange, function(color, transparency)
		for _, info in lplr_data["aim_viewing"] do
			local line = info[2]
			if line then
				line["Color"] = color
				line["Transparency"] = -transparency+1
			end
		end
	end, true)
	
	utility.newConnection(menu_references["players_box"].onSelectionChange, LPH_JIT_MAX(function(selected)
		local player = findfirstchild(plrs, selected or "")
	
		if not player then
			return end 
	
		menu_references["view_aim"]:setToggle(lplr_data["aim_viewing"][player] ~= nil, true)
		menu_references["ragebot"]:setToggle(lplr_data["ragebot"][player] ~= nil, true)
		menu_references["whitelisted"]:setToggle(lplr_data["whitelisted"][player] ~= nil, true)

	end), true)
		
	utility.newConnection(menu_references["player_esp_render_for"].onDropdownChange, function(selected)
		whitelisted = find(selected, "Whitelisted")
		all = find(selected, "All")
		target = find(selected, "Aimbot target")
		ragebot = find(selected, "Ragebot targets")
		for player, data in player_data do
			data["rendering"] = all and true or whitelisted and data["whitelisted"] or ragebot and data["ragebot"] or target and tostring(aimbot_data["target"]) == data["name"]
			local highlight = data["highlight"]
			if highlight then
				data["highlight"]["Enabled"] = data["rendering"]
			end
		end
	end)
	
	local last_target = aimbot_data["target"]

	utility.newConnection(newAimbotTarget, function(new)
		if last_target then
			local data = player_data[last_target]
			data["rendering"] = all and true or whitelisted and data["whitelisted"] or ragebot and data["ragebot"] or target and tostring(aimbot_data["target"]) == data["name"]
			local highlight = data["highlight"]
			if highlight then
				data["highlight"]["Enabled"] = data["rendering"]
			end
		end
		last_target = new
		if new then
			local data = player_data[new]
			data["rendering"] = all and true or whitelisted and data["whitelisted"] or ragebot and data["ragebot"] or target and tostring(aimbot_data["target"]) == data["name"]
			local highlight = data["highlight"]
			if highlight then
				data["highlight"]["Enabled"] = data["rendering"]
			end
		end
	end)
end

local playerRemoving = LPH_NO_VIRTUALIZE(function(player)
	local data = player_data[player]
	local drawings = data["drawings"]
	for _, drawing in drawings do
		drawing:Destroy()
		drawings[_] = nil
	end
	local tween1 = data["tweenhealth"]
	if tween1 then
		tween1[1]:Disconnect()
	end
	local tween2 = data["tweenarmor"]
	if tween2 then
		tween2[1]:Disconnect()
	end
	local highlight = data["highlight"]
	if data["highlight"] then
		highlight["Adornee"] = nil
		destroy(data["highlight"])
	end
	if aimbot_data["target"] == player then
		setAimbotTarget(nil)
	end
	if lplr_data["viewing"] == player then
		camera.CameraSubject = char
		lplr_data["viewing"] = nil
	end
	local old_info = lplr_data["aim_viewing"][player]
	if old_info then
		remove(heartbeat_callbacks, old_info[1])
		old_info[2]:Destroy()
	end
	menu_references["players_box"]:removeOption(player.Name)
	player_data[player] = nil
end)

utility.newConnection(plrs.PlayerAdded, playerAdded)
utility.newConnection(plrs.PlayerRemoving, playerRemoving)

--[[
	    _  _               _   
       | |(_)             | |  
   ___ | | _   ___  _ __  | |_ 
  / __|| || | / _ \| '_ \ | __|
 | (__ | || ||  __/| | | || |_ 
  \___||_||_| \___||_| |_| \__|
]]

do
	local skin_object = nil
	local old_texture = ""
	local old_default = nil

	local connection = nil
	local connection2 = nil
	local connection3 = nil
	local connection4 = nil
	local connection5 = nil

	local onShotAdded = LPH_NO_VIRTUALIZE(function(sound)
		if sound.ClassName == "Sound" then
			local id = skin_object["ShootSounds"][lplr_data["tool"]["Name"]]
			if id then
				sound.SoundId = id
			end
		end
	end)

	local stopNewTexture = LPH_NO_VIRTUALIZE(function()
		if old_default then
			old_default["TextureID"] = old_texture
		end
	end)

	local applySkin = LPH_NO_VIRTUALIZE(function(tool, skin, knife)
		local default = tool.Default

		for _, child in default:GetChildren() do
			destroy(child)
		end

		if skin == nil then
			default.Transparency = 0
			return
		end

		local skin_object = skins[skin]

		if not skin_table[tool.Name] then
			return end

		local skin_table_object = skin_table[tool.Name][skin]

		local texture_id = skin_table_object["TextureID"]
		local cframe = skin_table_object["CFrame"]
		local particle = skin_object and skin_object.Particle
		if particle then
			local new_particle = particle:Clone()
			new_particle.Name = "\0"
			new_particle.Parent = default
		end

		local skin = skin_object and skin_object["Convert"] or skin
		local size = skin_table_object["Scale"]

		if typeof(texture_id) == "string" and not size then
			old_texture = texture_id
			default.TextureID = texture_id
			default.Transparency = 0
			old_default = default
			connection5 = utility.newConnection(default:GetPropertyChangedSignal("TextureID"), stopNewTexture)
		else
			local new_default = findfirstchild(reps.SkinModules[knife and "Knives" or "Meshes"], skin)
			
			if skin_table_object["MeshId"] and size then
				new_default = newObject("Part", {
					CanCollide = false,
					Name = "\0",
					Color = skin_table_object["Color"] or colorfromrgb(255,255,255),
					Material = skin_table_object["Material"] or Enum.Material.Plastic,
					Massless = true,
				})
				newObject("SpecialMesh", {
					MeshId = skin_table_object["MeshId"],
					Scale = size,
					TextureId = skin_table_object["TextureId"],
					Parent = new_default
				})
				local old = new_default
				delay(1, function()
					if old then
						destroy(old)
					end
				end)
			elseif not new_default then
				for _, child in default:GetChildren() do
					destroy(child)
				end
		
				default.Transparency = 0
				return
			end

			if knife then
				default.Transparency = 1
			end

			new_default = knife and new_default:Clone() or (#new_default.Name == 0 and new_default:Clone() or new_default[texture_id.Name]:Clone())
			local new_weld = newObject("Weld", {})
			
			new_default.Parent = default
			new_weld.Parent = new_default

			new_weld.Part0 = default
			new_weld.Part1 = new_default
			new_weld.C0 = cframe or new_weld.C0
			default.Transparency = 1
		end
	end)

	local doSkinChangerBeam = LPH_NO_VIRTUALIZE(function(object, beam)
		if flags["local_bullet_tracers"] then
			return end

		local _beam = skin_object.Beam
		if _beam then
			for prop, value in _beam do
				beam[prop] = value
			end
		end
		local _tween = skin_object.Tween
		if _tween then
			tween(beam, _tween[1], _tween[2])
		end
		local _particle = skin_object.ShotParticle
		for _, particle in object:GetDescendants() do
			if particle.ClassName == "ParticleEmitter" then
				particle["Transparency"] = NumberSequence.new{NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 1)}
				particle:Clear()
				destroy(particle)
			end
		end
		if _particle and lplr_data["do_emit"] then
			local _particle2 = skin_object.ShotParticle2
			lplr_data["do_emit"] = false
			if _particle and _particle2 then
				_particle = mathrandom(1,2) == 1 and _particle or _particle2
			end
			local particle = newObject("ParticleEmitter", _particle)
			particle.Parent = object
			particle:Emit(skin_object.ParticleEmit)
		end
	end)

	local destroyOld = LPH_NO_VIRTUALIZE(function(object)
		wait()
		if object["Name"] ~= "\0" then
			destroy(object)
		end
	end)

	local onToolAdded = LPH_NO_VIRTUALIZE(function(tool)
		if connection then
			connection:Disconnect()
			connection = nil
		end
		if connection3 then
			connection3:Disconnect()
			connection3 = nil
		end
		if connection4 then
			connection4:Disconnect()
			connection4 = nil
		end
		if connection5 then
			connection5:Disconnect()
			connection5 = nil
		end
		skin_object = nil
		if tool then
			local handle = findfirstchild(tool, "Handle") 

			if not handle then
				return end

			local name = tool.Name
			local skin = skins["equipped"][name]
			if skin then
				skin_object = skins[skin]
				if skin_object and skin_object["ShootSounds"] then
					local shoot_sound = handle:WaitForChild("ShootSound", 1)
					onShotAdded(shoot_sound)
					connection = utility.newConnection(handle.ChildAdded, onShotAdded)
				end
				delay(0, function()
					local is_knife = name == "[Knife]"
					applySkin(tool, skin, is_knife)
					local default = findfirstchild(tool, "Default")
					if default then
						connection4 = utility.newConnection(default.ChildAdded, destroyOld)
					end
					if is_knife and skin_object then
						local animation_id = skin_object["PulloutAnimation"]
						local sound = skin_object["PulloutSound"]
						if sound then
							destroy(newObject("Sound", {
								SoundId = sound,
								PlayOnRemove = true,
								Volume = skin_object["PulloutVolume"],
								Parent = handle
							}))
						end
						local animation = flags["pullout_animation"][1]
						if animation ~= "None" then
							local humanoid = lplr_parts["Humanoid"]
							if humanoid then
								local new_animation = newObject("Animation", {
									AnimationId = animation == "Skin" and animation_id or skins[animation]["PulloutAnimation"]
								})
								local anim = humanoid:LoadAnimation(new_animation)
								anim:Play()
								destroy(new_animation)
							end
						end
					else
						connection3 = utility.newConnection(newLocalPlayerBullet, doSkinChangerBeam)
					end
				end)
			end
		end
	end)

	utility.newConnection(menu_references["skin_changer"].onToggleChange, function(bool)
		if connection then
			connection:Disconnect()
			connection = nil
		end
		if connection2 then
			connection2:Disconnect()
			connection2 = nil
		end
		if connection3 then
			connection3:Disconnect()
			connection3 = nil
		end
		if connection4 then
			connection4:Disconnect()
			connection4 = nil
		end
		if connection5 then
			connection5:Disconnect()
			connection5 = nil
		end
		if bool then
			connection2 = utility.newConnection(newToolEquipped, onToolAdded)
			local tool = lplr_data["tool"]
			if tool then
				spawn(onToolAdded, tool)
			end
		else
			local data_folder = findfirstchild(lplr, "DataFolder")

			if not data_folder then
				return end

			local information = findfirstchild(data_folder, "Information")

			if not information then
				return end

			local equip_skins = findfirstchild(information, "EquipSkins")

			if not equip_skins then
				return end

			local skin_value = hs:JSONDecode(equip_skins.Value)
			for tool, _ in lplr_data["tools"] do
				local gun = tool["Name"]

				if tool and skins["equipped"][gun] then
					local default = findfirstchild(tool, "Default")

					if not default then
						continue end

					for _, object in default:GetChildren() do
						destroy(object)
					end

					local skin = skin_value[gun]

					if not skin_value[gun] then
						default.Transparency = 0
						default.TextureID = reps.SkinModules.GunModels[gun]["TextureID"]
						continue 
					end

					local real_skin = skin_table[gun][skin]
					if real_skin then
						local texture_id = real_skin["TextureID"]
						if typeof(texture_id) == "string" then
							default.Transparency = 0
							default.TextureID = texture_id
						else
							default.Transparency = 1
						end
					end
				end
			end
		end
	end)
end

do
	local peekCircle = nil
	local peekDecal = nil
	local do_return = false
	local doAutoPeek = LPH_NO_VIRTUALIZE(function(dt, hrp)
		if not hrp then
			return end

		local auto_peek_value = flags["auto_peek_value"]
		local return_delay = flags["return_delay"]
		local humanoid = lplr_parts["Humanoid"]

		if find(auto_peek_value, "Not moving") then
			if return_delay == 0 then
				do_return = humanoid["MoveDirection"] == vector3new()
			else
				delay(return_delay, function()
					do_return = humanoid["MoveDirection"] == vector3new()
				end)
			end
		end
		if find(auto_peek_value, "On shot") then
			if lplr_data["recently_shot"] then
				if return_delay == 0 then
					do_return = true
				else
					delay(return_delay, function()
						do_return = true
					end)
				end
			end
		end
		if do_return then
			if (lplr_pos["p"]-peekCircle["CFrame"]["p"]).magnitude < 3.3 then
				do_return = false
				return
			end
			peekDecal["Color3"] = flags["return_color"]
			peekDecal["Transparency"] = flags["return_transparency"]

			if flags["return_method"][1] == "Teleport" then
				lplr_pos = peekCircle["CFrame"]+vector3new(0,2.5,0)
			else
				sethiddenproperty(humanoid, "WalkToPoint", peekCircle["CFrame"]["p"])
			end
		else
			peekDecal["Color3"] = flags["auto_peek_color"]
			peekDecal["Transparency"] = flags["auto_peek_transparency"]
		end
	end)

	utility.newConnection(menu_references["auto_peek"].onActiveChange, function(bool)
		if find(heartbeat_callbacks, doAutoPeek) then
			remove(heartbeat_callbacks, doAutoPeek)
		end
		if peekCircle then
			destroy(peekCircle)
		end
		if bool then
			do_return = false
			local hrp = lplr_parts["HumanoidRootPart"]

			if not hrp then
				menu_references["auto_peek"]:setActive(false)
				return
			end

			local pos = lplr_pos["p"]

			raycast_params.FilterDescendantsInstances = {ignored_folder, vehicles, camera, char}
			local result = raycast(workspace, pos, pos-vector3new(0,1000,0), raycast_params)

			if not result then
				menu_references["auto_peek"]:setActive(false)
				return
			end

			local pos2 = result.Position

			peekCircle = newObject("Part", {
				Anchored = true;
				CFrame = cframenew(vector3new(pos["X"], pos2["Y"], pos["Z"]));
				CanCollide = false;
				Size = vector3new(3.25,0.001,3.25);
				Parent = ignored_folder;
				Transparency = 1;
			})
			peekDecal = newObject("Decal", {
				Texture = "http://www.roblox.com/asset/?id=11999950713";
				Face = Enum.NormalId.Top;
				Parent = peekCircle
			})
					
			insert(heartbeat_callbacks, doAutoPeek)
		end
	end)

	utility.newConnection(menu_references["auto_peek"].onToggleChange, function(bool)
		if find(heartbeat_callbacks, doAutoPeek) then
			remove(heartbeat_callbacks, doAutoPeek)
		end
		if peekCircle then
			destroy(peekCircle)
		end
		menu_references["auto_peek"]:setDropdownVisibility(bool)
		menu_references["return_color"]:setVisible(bool)
		menu_references["return_delay"]:setVisible(bool)
		menu_references["return_method"]:setVisible(bool)
	end)
	menu_references["auto_peek"]:setDropdownVisibility(false)
	menu_references["return_delay"]:setVisible(false)
	menu_references["return_method"]:setVisible(false)
	menu_references["return_color"]:setVisible(false)

end

do
	local onShotAdded = LPH_NO_VIRTUALIZE(function(sound)
		if sound.ClassName == "Sound" then
			local path = "juju/assets/"..flags["custom_shoot_sound_id"]
			sound.SoundId = flags["custom_shoot_sound_value"][1] == "Custom" and (isfile(path) and getcustomasset(path, false) or flags["custom_shoot_sound_id"]) or sounds[flags["custom_shoot_sound_value"][1]]
			sound.Volume = flags["custom_shoot_sound_volume"]
		end
	end)

	local onGunAdded = LPH_NO_VIRTUALIZE(function(gun)
		local connection = lplr_data["shoot_connection"] 
		if connection then
			connection:Disconnect()
			connection = nil
		end
		if gun then
			lplr_data["shoot_connection"] = utility.newConnection(gun.Handle.ChildAdded, onShotAdded)
			local shoot_sound = gun.Handle:WaitForChild("ShootSound", 1)

			if shoot_sound then
				onShotAdded(shoot_sound)
			end
		end
	end)

	local connection2 = nil

	utility.newConnection(menu_references["custom_shoot_sound"].onToggleChange, function(bool)
		menu_references["custom_shoot_sound_id"]:setVisible(bool and flags["custom_shoot_sound_value"][1] == "Custom")
		menu_references["custom_shoot_sound_volume"]:setVisible(bool)
		menu_references["custom_shoot_sound"]:setDropdownVisibility(bool)

		local connection = lplr_data["shoot_connection"] 
		if connection then
			connection:Disconnect()
			connection = nil
		end
		if connection2 then
			connection2:Disconnect()
			connection2 = nil
		end
		if bool then
			local gun = lplr_data["gun"]

			if gun then
				lplr_data["shoot_connection"] = utility.newConnection(gun.Handle.ChildAdded, onShotAdded)
			end
			connection2 = utility.newConnection(newGunEquipped, onGunAdded)
		else
			for gun, old in lplr_data["tools"] do
				local handle = findfirstchild(gun, "Handle")
				if handle then
					local shoot_sound = findfirstchild(handle, "ShootSound")

					if shoot_sound then
						shoot_sound.SoundId = old[1]
						shoot_sound.Volume = old[2]
					end
				end
			end
		end
	end)

	utility.newConnection(menu_references["custom_shoot_sound"].onDropdownChange, function(selected)
		menu_references["custom_shoot_sound_id"]:setVisible(flags["custom_shoot_sound"] and selected[1] == "Custom")
	end)
	menu_references["custom_shoot_sound_id"]:setVisible(false)
	menu_references["custom_shoot_sound_volume"]:setVisible(false)
	menu_references["custom_shoot_sound"]:setDropdownVisibility(false)
	
	local no_slowdown_connection = nil
	local no_slowdown_connection2 = nil

	local removeSlowdown = LPH_NO_VIRTUALIZE(function()
		local humanoid = lplr_parts["Humanoid"]

		if not humanoid then
			return end

		local old = humanoid["WalkSpeed"]

		if old < 16 then
			humanoid["WalkSpeed"] = 16
			old = 16
		end

		no_slowdown_connection2 = utility.newConnection(humanoid:GetPropertyChangedSignal("WalkSpeed"), function()
			if humanoid["WalkSpeed"] < 16 then
				humanoid["WalkSpeed"] = old
				return
			end
			old = humanoid["WalkSpeed"]
		end)
	end)

	utility.newConnection(menu_references["remove_slowdowns"].onToggleChange, function(bool)
		if no_slowdown_connection then
			no_slowdown_connection:Disconnect()
			no_slowdown_connection = nil
		end
		if no_slowdown_connection2 then
			no_slowdown_connection2:Disconnect()
			no_slowdown_connection2 = nil
		end
		if bool then
			removeSlowdown()
			no_slowdown_connection = utility.newConnection(characterFullyLoaded, removeSlowdown)
		end
	end)

	local remove_jump_cooldown_connection = nil
	local remove_jump_cooldown_connection2 = nil

	local removeJumpCooldown = LPH_NO_VIRTUALIZE(function()
		local humanoid = lplr_parts["Humanoid"]

		if not humanoid then
			return end

		local old = humanoid["JumpPower"]

		if old < 50 then
			humanoid["JumpPower"] = 50
			old = 50
		end

		remove_jump_cooldown_connection2 = utility.newConnection(humanoid:GetPropertyChangedSignal("JumpPower"), function()
			if humanoid["JumpPower"] < 50 then
				humanoid["JumpPower"] = old
				return
			end
			old = humanoid["JumpPower"]
		end)
	end)

	utility.newConnection(menu_references["remove_jump_cooldown"].onToggleChange, function(bool)
		if remove_jump_cooldown_connection then
			remove_jump_cooldown_connection:Disconnect()
			remove_jump_cooldown_connection = nil
		end
		if remove_jump_cooldown_connection2 then
			remove_jump_cooldown_connection2:Disconnect()
			remove_jump_cooldown_connection2 = nil
		end
		if bool then
			removeJumpCooldown()
			remove_jump_cooldown_connection = utility.newConnection(characterFullyLoaded, removeJumpCooldown)
		end
	end)

	local lplrCharacterAdded = LPH_JIT_MAX(function(character)
		local hrp = character:WaitForChild("HumanoidRootPart", 5)
		local humanoid = character:WaitForChild("Humanoid", 5)

		if not hrp or not humanoid then
			return end

		spoof_properties[hrp] = {}
		char = character
		lplr_parts = {}
		lplr_data["tools"] = {}
	
		local children = character:GetChildren()
		local ammo_connection = nil
	
		for i = 1, #children do
			local object = children[i]
			lplr_parts[object.Name] = object
		end
	
		utility.newConnection(character.ChildAdded, function(object)
			lplr_parts[object.Name] = object
			if object.ClassName == "Tool" then
				lplr_data["tool"] = object
	
				local ammo = findfirstchild(object, "Ammo")
				if ammo then
					lplr_data["gun"] = object
	
					local old_ammo = ammo.Value
	
					ammo_connection = utility.newConnection(ammo:GetPropertyChangedSignal("Value"), function()
						if ammo.Value < old_ammo then
							local old = clock()
							lplr_data["recently_shot"] = old
							lplr_data["do_emit"] = true

							delay(0.018, function()
								if lplr_data["recently_shot"] == old then
									lplr_data["recently_shot"] = false
								end
							end)
						end
						old_ammo = ammo.Value
					end)

					if not lplr_data["tools"][object] then
						local handle = object.Handle
						local shoot_sound = findfirstchild(handle, "ShootSound")

						if shoot_sound then
							local default = findfirstchild(object, "Default")
							lplr_data["tools"][object] = {shoot_sound.SoundId, shoot_sound.Volume, default and default.TextureID or "", handle.ClassName == "MeshPart" and handle.TextureID or ""}
						end
					end

					newGunEquipped:Fire(object)
				end
				if not lplr_data["tools"][object] then
					local handle = findfirstchild(object, "Handle")
					local default = findfirstchild(object, "Default")
					lplr_data["tools"][object] = {0, 0, default and default.TextureID or "", handle and (handle.ClassName == "MeshPart" and handle.TextureID) or ""}
				end
				newToolEquipped:Fire(object)
			end
		end)
	
		utility.newConnection(character.ChildRemoved, function(object)
			lplr_parts[object.Name] = nil
			if object.ClassName == "Tool" then
				lplr_data["tool"] = nil
				lplr_data["gun"] = nil
				if ammo_connection then
					ammo_connection:Disconnect()
					ammo_connection = nil
				end
				newToolEquipped:Fire(nil)
				newGunEquipped:Fire(nil)
			end
		end)
	
		lplr_gui = lplr.PlayerGui
	
		local main_screen_gui = findfirstchild(lplr_gui, "MainScreenGui") or lplr_gui:WaitForChild("MainScreenGui", 120)
	
		if not main_screen_gui then
			return end
	
		local pepper_spray = findfirstchild(main_screen_gui, "PepperSpray") or main_screen_gui:WaitForChild("PepperSpray", 120)

		if pepper_spray then
			spoof_properties[pepper_spray] = {
				["Visible"] = false
			}
		end

		if flags["suppress_flashbang_effect"] and flags["suppress_flashbang_effect_value"][1] == "Flash" then
			local connection = lplr_data["flashbang_connection"]
			if connection then
				connection:Disconnect()
				lplr_data["flashbang_connection"] = nil
			end
		
			lplr_data["flashbang_connection"] = utility.newConnection(lplr_data["main_screen_gui"].ChildAdded, function(flash)
				if flash.Name == "whiteScreen" then
					wait()
					destroy(flash)
				end
			end)
		end

		lplr_data["main_screen_gui"] = main_screen_gui

		local body_effects = lplr_parts["BodyEffects"] or char:WaitForChild("BodyEffects", 240)

		if not body_effects then
			return end

		local knocked = body_effects["K.O"]

		utility.newConnection(knocked:GetPropertyChangedSignal("Value"), function()
			local knocked = knocked.Value
			if knocked and aimbot_data["target"] and find(flags["untarget_when"], "Self knocked") then
				setAimbotTarget(nil)
			end
			if knocked then
				localPlayerKnocked:Fire()
			end
			lplr_data["knocked"] = knocked
		end)
		lplr_data["knocked"] = knocked.Value

		characterFullyLoaded:Fire()
	end)
	
	utility.newConnection(lplr.CharacterAdded, lplrCharacterAdded)	

	if lplr.Character then
		spawn(lplrCharacterAdded, lplr.Character)
	end
end

do
	local onToolAdded = LPH_NO_VIRTUALIZE(function(tool)
		wait()

		if not tool then
			return end

		local handle = findfirstchild(tool, "Handle")
		if handle then
			local material = flags["material_tools"] and flags["material_tools_value"][1] or Enum.Material.Plastic
			local color = flags["material_tools"] and flags["material_tools_color"] or colorfromrgb(163, 162, 165)
			local tool_table = lplr_data["tools"][tool]
			local default = findfirstchild(tool, "Default")
			handle.Material = material
			handle.Color = color 
			if handle.ClassName == "MeshPart" then
				handle.TextureID = flags["material_tools"] and "" or (tool_table and tool_table[4] or "")
			end
			if default then
				default.Material = material
				default.Color = color
				default.TextureID = flags["material_tools"] and "" or (tool_table and tool_table[3] or "")
				local part = findfirstchild(default, "")
				if part then
					part.Material = material
					part.Color = color
				end
			end
		end
	end)

	local connection = nil

	utility.newConnection(menu_references["material_tools"].onToggleChange, function(bool)
		if connection then
			connection:Disconnect()
			connection = nil
		end
		if bool then
			connection = utility.newConnection(newToolEquipped, onToolAdded)
			local tool = lplr_data["tool"]
			if tool then
				delay(0, onToolAdded, tool)
			end
		else
			delay(0, function()
				for _, tool in lplr.Backpack:GetChildren() do
					local handle = findfirstchild(tool, "Handle")
					if handle then
						spawn(onToolAdded, tool)
					end
				end
				local tool = lplr_data["tool"]
				if tool then
					spawn(onToolAdded, tool)
				end
			end)
		end
		menu_references["material_tools"]:setDropdownVisibility(bool)
	end)
	menu_references["material_tools"]:setDropdownVisibility(false)

	utility.newConnection(menu_references["material_tools"].onDropdownChange, function(selected)
		if not flags["material_tools"] then
			return end

		local tool = lplr_data["tool"]
		if tool then
			delay(0, onToolAdded, tool)
		end
	end)
	
	utility.newConnection(menu_references["material_tools"].onColorChange, function(color, transparency)
		if not flags["material_tools"] then
			return end

		local tool = lplr_data["tool"]
		if tool then
			delay(0, onToolAdded, tool)
		end
	end)
end

--[[
 _                    _         
 | |                  | |        
 | |__    ___    ___  | | __ ___ 
 | '_ \  / _ \  / _ \ | |/ // __|
 | | | || (_) || (_) ||   < \__ \
 |_| |_| \___/  \___/ |_|\_\|___/                     
]]

local index = nil; index = hookmetamethod(game, "__index", LPH_NO_VIRTUALIZE(function(self, key)
	if not checkcaller() and self and key then
		local property = spoof_properties[self]
		if property then
			return property[key] or index(self, key)
		elseif self == mouse and (key == "Hit" or key == "hit") then
			local position = aimbot_data["silent_aim_pos"]
			if flags["anti_aim_viewer"] then
				local old = index(self, key)
				if flags["aim_backtrack"] then
					if old then
						local position = old.p
						local index = insert(mouse_positions, position)
						delay(flags["backtrack_lifetime"], function()
							mouse_positions[index] = nil
						end)
					end
					return old
				end
				return old
			end
			if position and flags["silent_aim"] and flags["silent_aim_keybind"]["active"] then
				local hit_chance = aimbot_data["silent_aim_hit_chance"]
				if hit_chance < 100 and hit_chance <= mathrandom(1, 100) then
					return index(self, key)
				end
				return cframenew(aimbot_data["force_pos"] or position)
			end
		elseif key == "ZIndex" and self["ClassName"] == "UICorner" and getcallingscript()["Name"] == "BackpackScript" then
			return 1
		end
	end
	return index(self, key)
end))

do
	local new_namecall = nil; new_namecall = hookmetamethod(game, "__namecall", LPH_NO_VIRTUALIZE(function(self, ...)
		if self == event and getnamecallmethod() == "FireServer" then
			local args = {...}
			if args[1] == "ShootGun" and flags["send_hit_packet_always"] then
				local target = aimbot_data["target"]
				if target then
					if final_cframe then
						args[3] = final_cframe
					end
					args[4] = target["Character"]["Head"]["Position"]
					args[5] = target["Character"]["Head"]
					return new_namecall(self, unpack(args))
				end
			end
		end
		return new_namecall(self, ...)
	end))
end

local new_index = nil; new_index = hookmetamethod(game, "__newindex", LPH_NO_VIRTUALIZE(function(self, key, value)
	if not checkcaller() and self and key and value then
		local property = spoof_properties[self]
		if property and key then
			property[key] = value

			if flags[spoof_skip[key]] then 
				return
			end

			return new_index(self, key, value)
		elseif self == camera and key == "CFrame" and flags["remove_recoil"] and getcallingscript()["Name"] == "Framework" then
			return
		elseif key == "ZIndex" and self["ClassName"] == "UICorner" and getcallingscript()["Name"] == "BackpackScript" then
			return
		end
	end
	return new_index(self, key, value)
end))

--[[
  _         _  _   
 (_)       (_)| |  
  _  _ __   _ | |_ 
 | || '_ \ | || __|
 | || | | || || |_ 
 |_||_| |_||_| \__|
]]

local data_ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
local final_cframe = nil
local ping_data = {}
local last_ping_check = clock()

do
	local split = string.split
	utility.newConnection(rs.Heartbeat, LPH_NO_VIRTUALIZE(function(dt)
		local hrp = lplr_parts["HumanoidRootPart"]

		if clock()-last_ping_check > 2 then
			last_ping_check = clock()
			local new_ping = tonumber(split(data_ping:GetValueString(),'(')[1])
			if #ping_data >= 15 then
				remove(ping_data, 1)
			end
			ping_data[#ping_data+1] = new_ping
			local total = 0
			for _, ping in ping_data do
				total+=ping
			end
			ping = floor(total/#ping_data) - 10
		end

		if hrp then
			lplr_pos = hrp["CFrame"]
			local connections = getconnections(hrp:GetPropertyChangedSignal("CFrame"))
			for i = 1, #connections do
				connections[i]:Disconnect()
				connections[i] = nil
			end
		end

		for _, callback in heartbeat_callbacks do
			spawn(callback, dt, hrp)
		end

		for _, callback in anti_callbacks do
			spawn(callback, dt, hrp)
		end

		if hrp then
			final_cframe = hrp["CFrame"]
		end
	end))
end

if is_solara then
	local cframe_fix = newObject("Part", {
		Name = "\128",
		Parent = ignored_folder,
		CanCollide = false,
		Size = vector3new(0.001,0.001,0.001),
		Transparency = 1,
		CFrame = cframenew(),
		Anchored = true
	})
	local last = false

	insert(anti_callbacks, LPH_NO_VIRTUALIZE(function(dt, hrp)		
		if not hrp or lplr_data["knocked"] then
			return end

		if #anti_callbacks ~= 1 then
			local body = lplr_data["desynced_position"]
			if not last then
				if body then
					body["Parent"] = ignored_folder
				end
			end

			last = true

			if camera.CameraSubject == lplr_parts["Humanoid"] then
				camera.CameraSubject = cframe_fix
			end
	
			cframe_fix["CFrame"] = lplr_pos+vector3new(0,2,0)

			render_stepped:Wait()
			if body then
				local show = (hrp["CFrame"]["p"]-lplr_pos["p"]).magnitude > 3.5
				for part, _ in limb_descriptions do
					local lplr_part = lplr_parts[part]
					
					body[part]["CFrame"] = show and (lplr_part and lplr_part["CFrame"]) or cframenew(0,9e9,0)
				end
			end
			hrp["CFrame"] = lplr_pos
		else
			if last then
				local body = lplr_data["desynced_position"]

				if body then
					body["Parent"] = cg
				end
			end
			last = false
			hrp["CFrame"] = lplr_pos
			if camera.CameraSubject == cframe_fix then
				camera.CameraSubject = lplr_parts["Humanoid"]
			end
		end	
	end))
else
	local last = false
	insert(anti_callbacks, LPH_NO_VIRTUALIZE(function(dt, hrp)		
		if not hrp or lplr_data["knocked"] then
			return end

		if #anti_callbacks ~= 1 then
			local body = lplr_data["desynced_position"]
			if not last then
				if body then
					body["Parent"] = ignored_folder
				end
			end

			last = true
			spoof_properties[hrp]["CFrame"] = lplr_pos
			render_stepped:Wait()
			if body then
				local show = (hrp["CFrame"]["p"]-lplr_pos["p"]).magnitude > 3.5
				for part, _ in limb_descriptions do
					local lplr_part = lplr_parts[part]

					if not lplr_part then
						continue end
					
					body[part]["CFrame"] = show and (lplr_part and lplr_part["CFrame"]) or cframenew(0,9e9,0)
				end
			end
			hrp["CFrame"] = lplr_pos
		else
			if last then
				local body = lplr_data["desynced_position"]

				if body then
					body["Parent"] = cg
				end
			end
			last = false
			hrp["CFrame"] = lplr_pos
			spoof_properties[hrp]["CFrame"] = nil
		end	
	end))
end

getgenv().unload_juju = function()
	for flag, value in pairs(flags) do
		if typeof(value) == "boolean" then
			flags[flag] = false
		end
	end
	menu.on_load:Fire()
	for _, connection in utility.connections do
		if connection then
			connection:Disconnect()
			utility.connections[_] = nil
		end
	end
	destroy(_screenGui)
	for lua, _ in script_environment do
		task.cancel(script_environment[lua])
	end
	camera.CameraSubject = lplr_parts["Humanoid"]
	delay(1, cleardrawcache)
	getgenv().unload_juju = nil
end

for _, player in plrs:GetPlayers() do
	if player == lplr then
		continue 
	end

	spawn(playerAdded, player)
end

for _, config in old_list do
	config_list:addOption(config)
end

if is_solara then
	local endings = {
		"_end",
		"_start",
		"_color",
		"_value"
	}

	for self, properties in spoof_properties do
		for property, value in properties do
			local flag = spoof_skip[property]
			if flag then	
				local value_flag = flag
				for _, ending in endings do
					local flag = value_flag..ending
					if flags[flag] ~= nil then
						value_flag = flag
					end
				end

				if value_flag == flag then
					continue end

				utility.newConnection(self:GetPropertyChangedSignal(property), LPH_NO_VIRTUALIZE(function()
					if flags[flag] then 
						local flag = flags[value_flag]
						self[property] = typeof(flag) == "table" and flag[1] or flag
						return
					end

					properties[property] = value
				end))
			end
		end
	end
end

for _, file in listfiles(config_location.."/assets/") do
	if string.sub(file, -5) ~= ".skin" then
		continue end

	local data = readfile(file)

	local new_skin = nil
	local s, err = pcall(function()
		new_skin = loadstring(data)()
	end)

	if err then
		continue end
	
	local name = new_skin["Name"]

	if skins[name] and not custom_skins[name]  then
		continue end

	skins[name] = {
		Beam = new_skin["Beam"],
		ShootSounds = {
			[new_skin["Gun"]] = new_skin["Sound"]
		},
		Tween = new_skin["Tween"],
	}

	if new_skin["Particle"] then
		local object = nil
		local s, err = pcall(function()
			object = is:LoadLocalAsset(new_skin["Particle"])
		end)

		if not object or not s then
			continue end
		
		skins[name]["Particle"] = object[1]
	end

	skin_table[new_skin["Gun"]][name] = {
		CFrame = new_skin["CFrame"],
		TextureID = new_skin["TextureID"],
		TextureId = new_skin["TextureId"],
		MeshId = new_skin["MeshId"],
		Color = new_skin["Color"],
		Material = new_skin["Material"],
		Scale = new_skin["Scale"]
	}

	custom_skins[name] = ""

	menu_references["selected_weapon"].onDropdownChange:Fire("[Revolver]")
end

local armorcount = 0
local inventory = nil

do
	local shop_names = {}
	local shop_items = {}
	local shop_ignore = {
		["foodscart"] = true,
		["flowers"] = true,
		["antibodies"] = true,
		["defaultmoveset"] = true,
		["tele"] = true,
	}

	for _, shop in ignored_folder.Shop:GetChildren() do
		local name = string.match(shop.Name, "%b[]")

		if not name or name:find("Phone") then
			continue end

		name = sub(lower(gsub(name, "%s", "")), 2, -2)

		if shop_ignore[name] then
			continue end

		if shop_names[name] then
			if name == "mediumarmor" then
				armorcount+=1
				name = name..tostring(armorcount)
			else
				continue
			end
		end

		local head = findfirstchild(shop, "Head")

		if not head then
			continue end

		if head.Position.Y < -30 then
			continue end

		insert(shop_items, 
		{
			name = name, 
			button = head, 
			detector = shop.ClickDetector,
			price = tonumber(string.match(shop.Name, "%d+"))
		})

		shop_names[name] = true
	end

	table.sort(shop_items, function(a, b)
		return a["price"] > b["price"]
	end)

	for _, object in shop_items do
		shop_names[object["name"]] = object
	end

	for _, object in shop_items do
		local name = object["name"]

		if name:find("ammo") or tonumber(string.sub(name, #name, #name)) then
			continue end
		
		menu_references["purchases"]:addOption(name)
	end

	local connection = nil

	local purchasing = nil

	local rage_offsets = {
		vector3new(0,8.8,0),
		vector3new(0,-8.8,0),
		vector3new(8.8,0,0),
		vector3new(-8.8,0,0),
		vector3new(0,0,8.8),
		vector3new(0,0,-8.8)
	}

	local looking_for = "lmg"
	
	local doAutoEquip = LPH_JIT_MAX(function(tool)
		if tool["ClassName"] ~= "Tool" then
			return end

		if utility.removeBrackets(tool["Name"]):find(looking_for) then
			if tool["Parent"] == lplr["Backpack"] then
				if purchasing then
					return end

				delay(0, function()
					tool["Parent"] = char
				end)
			end
		end
	end)

	local purchaseItem = LPH_JIT_MAX(function(item, amount)
		if purchasing then
			return end

		if item == "high-mediumarmor" then
			local old = lplr_data["last_bought_high_medium"]
	
			if clock()-old > 30 then
				lplr_data["last_bought_high_medium"] = clock()
			else
				if clock()-lplr_data["last_bought_medium"] < 30 then
					lplr_data["last_bought_medium"] = clock()

					item = "mediumarmor"..tostring(mathrandom(1, armorcount))
				else
					purchasing = false
					return
				end
			end
		end

		local object = shop_names[item]
		local position = object["button"]["CFrame"]
		local terminate = nil
		local ammo = shop_names[item.."ammo"]
		local ammo_count = amount or flags["purchase_ammo"]
		local old_money = lplr_data["money"]
		local did_ammo = nil

		local bought = nil
		local tool = findfirstchildofclass(char, "Tool")
		if tool then
			bought = utility.removeBrackets(tool.Name) == item and 1 or nil
		end

		delay(0, function()
			if tool then
				tool["Parent"] = lplr["Backpack"]
			end
		end)

		if not bought then
			if tool then
				bought = utility.removeBrackets(tool.Name) == item
			end

			for _, tool in lplr.Backpack:GetChildren() do
				if utility.removeBrackets(tool.Name) == item then
					bought = 1
					break
				end
			end
		end

		if bought then
			if not ammo then
				return
			end
			object = ammo
			position = object["button"]["CFrame"]
			did_ammo = true
		end
		
		local count = 0
		local start_time = clock()

		local new_function = nil; new_function = function()
			if terminate or not purchasing or not char or clock() - start_time > (3 + ammo_count*0.5) then
				if connection then
					connection:Disconnect()
					connection = nil
				end
				purchasing = nil
				remove(anti_callbacks, new_function)
				if flags["auto_equip"] then
					for _, tool in lplr["Backpack"]:GetChildren() do
						spawn(doAutoEquip, tool)
					end
				end
				return 
			end

			local hrp = lplr_parts["HumanoidRootPart"]

			if not hrp then
				terminate = 1
				return
			end
			
			hrp["CFrame"] = position - (flags["purchase_style"][1] == "Hidden" and vector3new(0,8.8,0) or rage_offsets[mathrandom(1,6)])

			fireclickdetector(object["detector"])
			local money = lplr_data["money"]

			if money < object["price"] then
				terminate = 1
				return 
			end
				
			if money ~= old_money then
				if money < old_money then
					old_money = money
					if ammo then
						if did_ammo then
							count+=1
						end
						
						if count >= ammo_count then
							terminate = 1
							return 
						end

						if not did_ammo then
							did_ammo = 1
							object = ammo
							position = object["button"]["CFrame"]
						end
					else
						terminate = 1
					end
				end
			end
		end

		purchasing = 1
		insert(anti_callbacks, new_function)
	end)

	menu_references["purchases_section"]:newElement({name = "Purchase", types = {button = {text = "Purchase", callback = function()
		local selected = menu_references["purchases"].selected_option

		if not selected then
			return end

		if shop_names[selected]["price"] > lplr_data["money"] then
			return end

		spawn(purchaseItem, selected)
	end}}})

	utility.newConnection(menu_references["purchases"].onSelectionChange, function(selected)
		menu_references["ammo_"]:setVisible(shop_names[selected.."ammo"])
	end)
	menu_references["ammo_"]:setVisible(false)

	local auto_ammo_connection = nil
	local auto_ammo_connection2 = nil
	local last_check = clock() 
	local doAutoAmmo = LPH_NO_VIRTUALIZE(function()
		local new = clock()
		if new - last_check < 0.1 then
			return end

		last_check = new
		local gun = lplr_data["gun"]

		if not gun then
			return end

		if inventory[gun.Name]["Value"] == "0" then
			purchaseItem(utility.removeBrackets(gun.Name), flags["buy_amount"])
		end
	end)

	utility.newConnection(menu_references["auto_ammo"].onToggleChange, function(bool)
		if find(heartbeat_callbacks, doAutoAmmo) then
			remove(heartbeat_callbacks, doAutoAmmo)
		end
		if bool then
			insert(heartbeat_callbacks, doAutoAmmo)
		end
		menu_references["buy_amount"]:setVisible(bool)
	end)
	menu_references["buy_amount"]:setVisible(false)

	local auto_armor_connection = nil
	local auto_armor_connection2 = nil
	local auto_armor_connection3 = nil

	local doAutoArmor = LPH_NO_VIRTUALIZE(function()
		local body_effects = lplr_parts["BodyEffects"]
		local humanoid = lplr_parts["Humanoid"]

		if not body_effects then
			return end

		local armor = body_effects["Armor"]

		if armor.Value/130 <= flags["armor_purchase_at"]/100 then
			if not purchasing then
				purchaseItem("high-mediumarmor")
			end
		end

		auto_armor_connection2 = utility.newConnection(armor:GetPropertyChangedSignal("Value"), function()
			if armor.Value/130 <= flags["armor_purchase_at"]/100 then
				if not purchasing then
					purchaseItem("high-mediumarmor")
				end
			end
		end)

		auto_armor_connection3 = utility.newConnection(humanoid:GetPropertyChangedSignal("Health"), function()
			if armor.Value/130 <= flags["armor_purchase_at"]/100 then
				if not purchasing then
					purchaseItem("high-mediumarmor")
				end
			end
		end)
	end)

	utility.newConnection(menu_references["auto_armor"].onToggleChange, function(bool)
		menu_references["armor_purchase_at"]:setVisible(bool)
		if auto_armor_connection then
			auto_armor_connection:Disconnect()
			auto_armor_connection = nil
		end
		if auto_armor_connection2 then
			auto_armor_connection2:Disconnect()
			auto_armor_connection2 = nil
		end
		if auto_armor_connection3 then
			auto_armor_connection3:Disconnect()
			auto_armor_connection3 = nil
		end
		if bool then
			auto_armor_connection = utility.newConnection(characterFullyLoaded, doAutoArmor)
			doAutoArmor()
		end
	end)
	menu_references["armor_purchase_at"]:setVisible(false)

	local auto_fire_armor_connection = nil
	local auto_fire_armor_connection2 = nil

	local doAutoFireArmor = LPH_NO_VIRTUALIZE(function()
		local body_effects = lplr_parts["BodyEffects"]

		if not body_effects then
			return end

		local armor = body_effects["FireArmor"]

		if armor.Value <= flags["fire_armor_purchase_at"] then
			if not purchasing then
				purchaseItem("firearmor")
			end
		end

		auto_fire_armor_connection2 = utility.newConnection(armor:GetPropertyChangedSignal("Value"), function()
			if armor.Value <= flags["fire_armor_purchase_at"] then
				if not purchasing then
					purchaseItem("firearmor")
				end
			end
		end)
	end)

	utility.newConnection(menu_references["auto_fire_armor"].onToggleChange, function(bool)
		menu_references["fire_armor_purchase_at"]:setVisible(bool)
		if auto_fire_armor_connection then
			auto_fire_armor_connection:Disconnect()
			auto_fire_armor_connection = nil
		end
		if auto_fire_armor_connection2 then
			auto_fire_armor_connection2:Disconnect()
			auto_fire_armor_connection2 = nil
		end
		if bool then
			auto_fire_armor_connection = utility.newConnection(characterFullyLoaded, doAutoFireArmor)
			doAutoFireArmor()
		end
	end)
	menu_references["fire_armor_purchase_at"]:setVisible(false)

	local is_ready = true

	local armor_names = {
		"high-mediumarmor",
		"mediumarmor"
	}

	for i = 1, armorcount do
		insert(armor_names, "mediumarmor"..tostring(i))
	end
		
	local predictAutoArmor = LPH_NO_VIRTUALIZE(function(dt, lplr_hrp)
		local target = aimbot_data["target"]
		local indicator = keybinds_list["Predict auto armor"]

		if indicator then
			indicator:set_visible(false)
		end

		if not target or not lplr_hrp or lplr_parts["ForceField"] or not final_cframe then
			return end

		local data = player_data[target]

		local rpg = findfirstchild(lplr.Backpack, "[RPG]")

		if not rpg then
			return end

		local hrp = data["character_parts"]["HumanoidRootPart"]

		if not hrp or (hrp["Position"]-lplr_hrp["Position"]).magnitude <= 25.1 then
			return end

		local last_position = hrp["Position"]
		local is_in_position = nil

		for _, armor_name in armor_names do
			local position = shop_names[armor_name]["button"]["Position"]
			if (last_position-position).magnitude <= 9 then
				is_in_position = position
				break
			end
		end

		local dont = false
		if data["forcefield"] then
			is_in_position = nil
			dont = true
		end

		local children = ignored_folder:GetChildren()
		local has_one = false
		for i = 1, #children do
			local instance = children[i]
			if instance.Name == "Model" then
				local part = findfirstchild(instance, "Launcher")
				if part then
					if isnetworkowner(part) then
						has_one = true
					end
					local body_velocity = findfirstchild(part, "BodyVelocity")
					if body_velocity then
						destroy(body_velocity)
					end
					local touch_interest = findfirstchild(part, "TouchInterest")
					if touch_interest then
						destroy(touch_interest)
					end
					part.CFrame = is_in_position and cframenew(is_in_position + vector3new(0,mathrandom(-185,-150)/100,0)) or final_cframe+vector3new(0,100,0)
					part.Velocity = vector3new(0,1.85,0)
				end
			end
		end

		if indicator then
			indicator:set_visible(true)
			indicator:set_override_color(has_one and flags["feature_indicators_color"] or colorfromrgb(225, 0, 0))
		end

		if not has_one and is_ready and not dont then
			is_ready = false
			
			spawn(function()
				local old_tool = lplr_data["tool"]
				if old_tool then
					old_tool.Parent = lplr.Backpack
					wait(2)
				end
				if rpg then
					rpg.Parent = char
					wait(0.03)
					if rpg then
						rpg:Activate()
					end
					delay(2.5, function()
						is_ready = true
					end)
					wait(0.03)
					event:FireServer("Reload", rpg)
					if rpg then
						rpg.Parent = lplr.Backpack
					end
					wait(0.03)
					if old_tool then
						old_tool.Parent = char
					end
				end
			end)
		end
	end)

	utility.newConnection(menu_references["predict_auto_armor"].onToggleChange, function(bool)
		local indicator = keybinds_list["Predict auto armor"]

		if indicator then
			indicator:set_visible(false)
		end

		if find(anti_callbacks, predictAutoArmor) then
			remove(anti_callbacks, predictAutoArmor)
		end
		if bool then
			insert(anti_callbacks, predictAutoArmor)
		end
	end)

	utility.newConnection(menu_references["auto_equip"].onDropdownChange, function(selected)
		local selected = selected[1]
		local is_custom = selected == "custom"

		if is_custom then
			looking_for = flags["auto_equip_text"]
		else
			looking_for = selected 
		end
		menu_references["auto_equip_text"]:setVisible(is_custom)

		if flags["auto_equip"] then
			for _, tool in lplr["Backpack"]:GetChildren() do
				spawn(doAutoEquip, tool)
			end
		end
	end)

	utility.newConnection(menu_references["auto_equip_text"].onTextChange, function(text)
		local selected = flags["auto_equip_value"][1]
		
		if selected == "custom" then
			looking_for = text
		end

		if flags["auto_equip"] then
			for _, tool in lplr["Backpack"]:GetChildren() do
				spawn(doAutoEquip, tool)
			end
		end
	end)
	menu_references["auto_equip_text"]:setVisible(false)

	utility.newConnection(menu_references["auto_equip"].onToggleChange, function(bool)
		if auto_equip_connection then
			auto_equip_connection:Disconnect()
			auto_equip_connection = nil
		end

		if auto_equip_connection1 then
			auto_equip_connection1:Disconnect()
			auto_equip_connection1 = nil
		end

		if bool then
			auto_equip_connection = utility.newConnection(lplr.Backpack.ChildAdded, doAutoEquip)
			auto_equip_connection1 = utility.newConnection(lplr.Backpack.ChildRemoved, doAutoEquip)

			for _, tool in lplr["Backpack"]:GetChildren() do
				spawn(doAutoEquip, tool)
			end
		end
	end)
end

local data_folder = lplr:WaitForChild("DataFolder", 240)

if not data_folder then
	return end

local information = data_folder:WaitForChild("Information", 240)
inventory = data_folder:WaitForChild("Inventory", 240)

if not information then
	return end

local currency = data_folder:WaitForChild("Currency", 240)

if currency then
	lplr_data["money"] = currency.Value
	utility.newConnection(currency:GetPropertyChangedSignal("Value"), LPH_NO_VIRTUALIZE(function()
		lplr_data["money"] = currency.Value
	end))
end

local crew = information:WaitForChild("Crew", 240)

if crew then
	lplr_data["crew"] = crew.Value

	utility.newConnection(crew:GetPropertyChangedSignal("Value"), function()
		lplr_data["crew"] = crew.Value
	end)
end