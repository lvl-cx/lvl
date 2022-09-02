local jobGroups = {}

RegisterNetEvent("ARMA:sendJobGroups")
AddEventHandler("ARMA:sendJobGroups",function(zzz)
    jobGroups = zzz
end)

local a=false
local b={}
SetNuiFocus(false,false)
local c={
    ["Chief Medical Officer"]=true,
    ["Deputy CMO"]=true,
    ["Assistant CMO"]=true,
    ["Captain"]=true,
    ["Consultant"]=true,
    ["Specialist"]=true,
    ["Senior Doctor"]=true,
    ["Doctor"]=true,
    ["Junior Doctor"]=true,
    ["Critical Care"]=true,
    ["Paramedic"]=true,
    ["Trainee Paramedic"]=true
}
local d={
    ["Chief Fire Officer"]=true,
    ["Deputy Chief Fire Officer"]=true,
    ["Assistant Chief Fire Officer"]=true,
    ["Senior Divisional Officer"]=true,
    ["Divisional Officer"]=true,
    ["Leading Firefighter"]=true,
    ["Specialist Firefighter"]=true,
    ["Advanced Firefighter"]=true,
    ["Senior Firefighter"]=true,
    ["Firefighter"]=true,
    ["Junior Firefighter"]=true,
    ["Provisional Firefighter"]=true
}
local e={
    ["Commissioner Clocked"]=true,
    ["Deputy Commissioner Clocked"] =true,
    ["Assistant Commissioner Clocked"]=true,
    ["Deputy Assistant Commissioner Clocked"] =true,
    ["Commander Clocked"]=true,
    ["Chief Superintendent Clocked"]=true,
    ["Superintendent Clocked"]=true,
    ["Chief Inspector Clocked"]=true,
    ["Inspector Clocked"]=true,
    ["Sergeant Clocked"]=true,
    ["Senior Constable Clocked"]=true,
    ["Police Constable Clocked"]=true,
    ["PCSO Clocked"]=true,
    ["Special Constable Clocked"]=true,
}
local f={
    ["Governor"]=true,
    ["Deputy Governor"]=true,
    ["Assistant Governor"]=true,
    ["Custodial Supervisor"]=true,
    ["Supervising Officer"]=true,
    ["Principal Officer"]=true,
    ["Specialist Officer"]=true,
    ["Senior Officer"]=true,
    ["Prison Officer"]=true,
    ["Trainee Prison Officer"]=true
}

function tARMA.getJobType(h)
    if jobGroups[h] then 
        for k,v in pairs(jobGroups[h].jobs) do
            if c[k] then 
                return "nhs"
            elseif d[i] then 
                return "lfb"
            elseif f[i] then 
                return "hmp" 
            elseif e[k] then 
                return "metpd"
            end 
        end
    else 
        return"",""
    end 
end