--
-- Domoticz passes information to scripts through a number of global tables
--
-- otherdevices, otherdevices_lastupdate and otherdevices_svalues are arrays for all devices: 
--   otherdevices['yourotherdevicename'] = "On"
--   otherdevices_lastupdate['yourotherdevicename'] = "2015-12-27 14:26:40"
--   otherdevices_svalues['yourotherthermometer'] = string of svalues
--
-- uservariables and uservariables_lastupdate are arrays for all user variables: 
--   uservariables['yourvariablename'] = 'Test Value'
--   uservariables_lastupdate['yourvariablename'] = '2015-12-27 11:19:22'
--
-- other useful details are contained in the timeofday table
--   timeofday['Nighttime'] = true or false
--   timeofday['SunriseInMinutes'] = number
--   timeofday['Daytime'] = true or false
--   timeofday['SunsetInMinutes'] = number
--   globalvariables['Security'] = 'Disarmed', 'Armed Home' or 'Armed Away'
--
-- To see examples of commands see: http://www.domoticz.com/wiki/LUA_commands#General
-- To get a list of available values see: http://www.domoticz.com/wiki/LUA_commands#Function_to_dump_all_variables_supplied_to_the_script
--
-- Based on your logic, fill the commandArray with device commands. Device name is case sensitive. 
--
commandArray = {}

print ("All based event fired");
-- loop through all the devices
for deviceName,deviceValue in pairs(otherdevices) do
    -- print ("Device based event fired on '"..deviceName.."', value '"..tostring(deviceValue).."'");
    
    
    if (deviceName == 'Heating') then
        local HeatItTemp = tonumber(otherdevices_svalues[deviceName]);
        
        local idx = otherdevices_idx[deviceName];
        print ("HeatIt device "..idx.." temperature: "..HeatItTemp); 
        
        local setTemp = 20;
        local highTemp = 20;
        local lowTemp = 17;
        local changeTemp = false;
        
      --  commandArray[tempDeviceIdx] = { ['UpdateDevice'] = tempDeviceIdx..'|0|'..temp }
        local t = os.date("*t");
        
    --    if ((t.hour > 5) and (HeatItTemp ~= highTemp)) then
        if ((t.hour == 6) and (t.min == 0)) then
            print ("Adjusting high temperature");
            setTemp = highTemp;
            changeTemp = true;
    --    elseif ((t.hour > 20) and (HeatItTemp ~= lowTemp)) then
        elseif ((t.hour == 19) and (t.min == 0)) then    
            print ("Adjusting low temperature");
            setTemp = lowTemp;
            changeTemp = true;
        end
        
        if (changeTemp) then
            commandArray['UpdateDevice'] = tostring(idx) .. "|0|" .. tostring(setTemp);
        end
        
    end
    
--    if (deviceName=='myDevice') then
--        if deviceValue == "On" then
--            print("Device is On")
--        elseif deviceValue == "Off" then
--            commandArray['a device name'] = "On"
--            commandArray['Scene:MyScene'] = "Off"
--        end
--    end
end

-- loop through all the variables
for variableName,variableValue in pairs(uservariables) do
--    if (variableName=='myVariable') then
--        if variableValue == 1 then
--            commandArray['a device name'] = "On"
--            commandArray['Group:My Group'] = "Off AFTER 30"
--        end
--    end
end

return commandArray
