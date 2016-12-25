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

print ("Time based event fired");
-- loop through all the devices
for deviceName, deviceValue in pairs(otherdevices) do
    
    local str = tostring(deviceValue);
     print ("Device based event fired on '"..deviceName.."', value '"..str.."'");
    
    
    -- 'Chambre Juliette (2)', value '15.9;50;0'
    if (deviceName == 'Chambre Juliette (2)') then
        
        local temp, humidity, nada = str:match("([%d%.]+);([%d%.]+);([%d%.]+)");
        local idx = otherdevices_idx["Chauffage juju"]; -- this is the command
        
        print ("Juliette temperature: "..temp.."°C humidity: " ..humidity.."%");
        
        local realTemp = tonumber(temp);
        local counterHi = tonumber(uservariables["CounterHi"]);
        local counterLo = tonumber(uservariables["CounterLow"]);
        
        if (counterHi == nil) then
            -- First Time init
            counterHi = 0;
        end
        
        if (counterLo == nil) then
            -- First Time init
            counterLo = 0;
        end
        
        print ("Juliette counters (Hi, Lo): "..counterHi..", "..counterLo);
        
        local command = "Off";

        if (realTemp > 19) then
            counterHi = counterHi + 1;
            counterLo = 0;
            
            if (counterHi > 1800) then
                command = "Off";
            end
        else
            counterLo = counterLo + 1;
            counterHi = 0;
            
            if (counterLo > 1800) then
                command = "On";
            end
        end
        
        
        print ("Juliette cmd: "..command);
        -- Save counterHi
        uservariables["CounterHi"] = tostring(counterHi);
        uservariables["CounterLow"] = tostring(counterLo);
        -- Set command
        commandArray['UpdateDevice'] = tostring(idx) .. "|0|" .. tostring(command);
        
        
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