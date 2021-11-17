local obj={}
obj.__index = obj

function obj:updateMicMute()
	local mic = hs.audiodevice.defaultInputDevice():inputVolume()
	if mic == 0.0 then
		obj.mute_menu:setTitle("📵 Muted")
	else
		obj.mute_menu:setTitle("🎙 On")
	end
end

function obj:toggleMicMute()
	local mic = hs.audiodevice.defaultInputDevice():inputVolume()
    local allInputDevices = hs.audiodevice.allInputDevices()
	if mic == 0.0 then
        for k,v in ipairs(allInputDevices) do v:setInputVolume(100) end
	else
        for k,v in ipairs(allInputDevices) do v:setInputVolume(0) end
	end
	obj:updateMicMute()
end

function obj:init()
	obj.mute_menu = hs.menubar.new()
	obj.mute_menu:setClickCallback(function()
		obj:toggleMicMute()
	end)
	obj:updateMicMute()

	hs.audiodevice.watcher.setCallback(function(arg)
        print(arg)
		if string.find(arg, "dIn ") then
			obj:updateMicMute()
		end
	end)
	hs.audiodevice.watcher.start()
end

obj:init()
return obj
