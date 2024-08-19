local CurrentInstrument
local isPlaying = false
local PromptGroup = GetRandomIntInRange(0, 0xffffff)
local StartPrompt
local StopPrompt
local CancelPrompt
-------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------

---- Command Registration 
RegisterCommand('instrument', function(source, args, raw)
	if args[1] == 'stop' then
		StopInstrument()
	else
		if args[1] then
			if not CurrentInstrument then 
				SetupPlayInstrumentPrompts()
				StartInstrument(args[1])
			else
				EndInstrument()
			end
		end
	end
end)
-------------------------------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/instrument', 'Play an instrument', {
		{name = 'instrument', help = table.concat(GetInstrumentList(), ', ') .. ', or stop to stop playing an instrument'}
	})

	while true do
		Wait(500)

		if CurrentInstrument then
			local ped = PlayerPedId()
			local anim = GetAnimation(ped, CurrentInstrument)

			if not IsEntityPlayingAnim(ped, anim.dict, anim.name, anim.flag) then
				PlayAnimation(ped, anim)
			end


			if CurrentInstrument.props then
				for i, prop in ipairs(CurrentInstrument.props) do
					if not (prop.handle and DoesEntityExist(prop.handle)) then
						CreateInstrumentObject(prop)
						AttachInstrumentObject(ped, prop)
					elseif not IsEntityAttachedToEntity(prop.handle, ped) then
						AttachInstrumentObject(ped, prop)
					end
				end
			end
		end
	end
end)

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------

---- Controls
function SetupPlayInstrumentPrompts()
	if StartPrompt then PromptDelete(StartPrompt) end 
	if StopPrompt then PromptDelete(StopPrompt) end 
	if CancelPrompt then PromptDelete(CancelPrompt) end 
	local str = "Start"
	StartPrompt = PromptRegisterBegin()
	PromptSetControlAction(StartPrompt, 0xE30CD707)
	str = CreateVarString(10, 'LITERAL_STRING', str)
	PromptSetText(StartPrompt, str)
	PromptSetEnabled(StartPrompt, true)
	PromptSetVisible(StartPrompt, true)
	PromptSetStandardMode(StartPrompt, true)
	PromptSetGroup(StartPrompt, PromptGroup)
	Citizen.InvokeNative(0xC5F428EE08FA7F2C, StartPrompt, true)
	PromptRegisterEnd(StartPrompt)

	str = "Stop"
	StopPrompt = PromptRegisterBegin()
	PromptSetControlAction(StopPrompt, 0xCEFD9220)
	str = CreateVarString(10, 'LITERAL_STRING', str)
	PromptSetText(StopPrompt, str)
	PromptSetEnabled(StopPrompt, false)
	PromptSetVisible(StopPrompt, true)
	PromptSetStandardMode(StopPrompt, true)
	PromptSetGroup(StopPrompt, PromptGroup)
	Citizen.InvokeNative(0xC5F428EE08FA7F2C, StopPrompt, true)
	PromptRegisterEnd(StopPrompt)

	str = "Cancel"
	CancelPrompt = PromptRegisterBegin()
	PromptSetControlAction(CancelPrompt, 0x05CA7C52)
	str = CreateVarString(10, 'LITERAL_STRING', str)
	PromptSetText(CancelPrompt, str)
	PromptSetEnabled(CancelPrompt, true)
	PromptSetVisible(CancelPrompt, true)
	PromptSetStandardMode(CancelPrompt, true)
	PromptSetGroup(CancelPrompt, PromptGroup)
	Citizen.InvokeNative(0xC5F428EE08FA7F2C, CancelPrompt, true)
	PromptRegisterEnd(CancelPrompt)
end


Citizen.CreateThread(function()
    while true do
        Wait(0)
		if CurrentInstrument then 
			local label = CreateVarString(10, 'LITERAL_STRING', "Instrument")
			PromptSetActiveGroupThisFrame(PromptGroup, label)

			if PromptHasStandardModeCompleted(StopPrompt) then --[E key]
				isPlaying = false
				PromptSetEnabled(StopPrompt, false)
				PromptSetEnabled(StartPrompt, true)
				Wait(1000)
			end

			if PromptHasStandardModeCompleted(StartPrompt) then -- [R key] 
				isPlaying = true
				PromptSetEnabled(StartPrompt, false)
				PromptSetEnabled(StopPrompt, true)
				Wait(1000)
			end
			if PromptHasStandardModeCompleted(CancelPrompt) then -- [BACKSPACE key] 
				isPlaying = false
				EndInstrument()
				Wait(1000)
			end
		else
			Wait(800)
		end
    end
end)

function EndInstrument()
	if CurrentInstrument then 
		for i,v in pairs(CurrentInstrument.props) do 
			DeleteEntity(v.handle)
		end
		ClearPedTasks(PlayerPedId())
		CurrentInstrument = false
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------

function GetAnimation(ped, instrument)
	local anim


	if isPlaying then
		anim = instrument.activeAnimation
	else
		anim = instrument.inactiveAnimation
	end


	local isMale = IsPedMale(ped)


	if anim.female and not isMale then
		return anim.female
	elseif anim.male and isMale then
		return anim.male
	else
		return anim
	end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------

---- Get functions
function GetInstrumentList()
	local instruments = {}


	for instrument, _ in pairs(Config.Instruments) do
		table.insert(instruments, instrument)
	end


	table.sort(instruments)


	return instruments
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------
function GetClosestInstrumentObject(ped, info)
	local pos = GetEntityCoords(ped)


	local minDist, closest


	for _, object in ipairs(GetNearbyObjects(pos)) do
		if IsInstrument(object, info) then
			local instrumentPos = GetEntityCoords(object)
			local distance = #(pos - instrumentPos)


			if not minDist or distance < minDist then
				minDist = distance
				closest = object
			end
		end
	end


	return closest
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------
function GetNearbyObjects(coords)
	local itemset = CreateItemset(true)
	local size = Citizen.InvokeNative(0x59B57C4B06531E1E, coords, Config.MaxInteractDistance, itemset, 3, Citizen.ResultAsInteger())


	local objects = {}


	if size > 0 then
		for i = 0, size - 1 do
			table.insert(objects, GetIndexedItemInItemset(i, itemset))
		end
	end


	if IsItemsetValid(itemset) then
		DestroyItemset(itemset)
	end


	return objects
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------

---- Prop Attatch Functions
function CreateInstrumentObject(prop)
	prop.handle = CreateObjectNoOffset(GetHashKey(prop.model), 0.0, 0.0, 0.0, true, false, false, false)
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------
function AttachInstrumentObject(ped, prop)
	local bone = prop.bone


	if type(bone) == 'string' then
		bone = GetEntityBoneIndexByName(ped, bone)
	end


	AttachEntityToEntity(prop.handle, ped, bone, prop.position, prop.rotation, false, false, true, false, 0, true, false, false)
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------
function IsInstrument(object, info)
	local model = GetEntityModel(object)


	for _, instrumentModel in ipairs(info.models) do
		if model == GetHashKey(instrumentModel) then
			return true
		end
	end


	return false
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------
function AttachToInstrument(ped, info)
	local object = GetClosestInstrumentObject(ped, info)


	if object then
		AttachEntityToEntity(ped, object, 0, info.position, info.rotation, false, false, true, false, 0, true, false, false)
		return true
	else
		return false
	end
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------
function DetachFromInstrument(ped)
	DetachEntity(ped)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------

---- Play Functions
function PlayAnimation(ped, anim)
	if not DoesAnimDictExist(anim.dict) then
		return
	end


	RequestAnimDict(anim.dict)


	while not HasAnimDictLoaded(anim.dict) do
		Wait(0)
	end


	TaskPlayAnim(ped, anim.dict, anim.name, 1.0, 1.0, -1, anim.flag, 0, false, false, false, '', false)


	RemoveAnimDict(anim.dict)
end
-------------------------------------------------------------------------------------------------------------------------------------------------------------
function StartInstrument(instrument)
	if CurrentInstrument then
		StopInstrument()
	end


	CurrentInstrument = Config.Instruments[instrument]


	if not CurrentInstrument then
		return
	end


	local ped = PlayerPedId()


	if CurrentInstrument.attachTo and not AttachToInstrument(ped, CurrentInstrument.attachTo) then
		CurrentInstrument = nil
		return
	end

end
-------------------------------------------------------------------------------------------------------------------------------------------------------------
function StopInstrument()

	local instrument = CurrentInstrument
	CurrentInstrument = nil


	local ped = PlayerPedId()


	if instrument.attachTo then
		DetachFromInstrument(ped)
	end


	if instrument.props then
		for _, prop in ipairs(instrument.props) do
			if prop.handle then
				DeleteObject(prop.handle)
			end
		end
	end


	local anim = GetAnimation(ped, instrument)


	StopAnimTask(ped, anim.dict, anim.name)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------




--------------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
	if StartPrompt then PromptDelete(StartPrompt) end 
	if StopPrompt then PromptDelete(StopPrompt) end 
	if CancelPrompt then PromptDelete(CancelPrompt) end 
	if CurrentInstrument then 
		for i,v in pairs(CurrentInstrument.props) do 
			DeleteEntity(v.handle)
		end
		ClearPedTasks(PlayerPedId())
	end
end)
