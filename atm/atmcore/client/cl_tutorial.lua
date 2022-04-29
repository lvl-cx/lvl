local IsDriving = false

RegisterNetEvent('ATM:StartCutscene')
AddEventHandler('ATM:StartCutscene', function()
    Citizen.Wait(500)
    if tutorialcfg.Clothes then
        SetPedComponentVariation(GetPlayerPed(-1), 11, 62, 0, 0)
        SetPedComponentVariation(GetPlayerPed(-1), 8, 76, 0, 0)
        SetPedComponentVariation(GetPlayerPed(-1), 3, 1,0,0)
        SetPedComponentVariation(GetPlayerPed(-1), 4, 1,1,0)
        SetPedComponentVariation(GetPlayerPed(-1), 6, 1,1,0)
        SetPedComponentVariation(GetPlayerPed(-1), 2, 1,1,0)
    end
    TriggerEvent('ATM:PlaneCutscene')
end)

Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(0)
		    if IsDriving then
                DisableControlAction(0,21,true) 
                DisableControlAction(0,22,true) 
                DisableControlAction(0,23,true) 
                DisableControlAction(0,24,true) 
                DisableControlAction(0,25,true)
                DisableControlAction(0,47,true) 
                DisableControlAction(0,58,true) 
                DisableControlAction(0,75,true)
                DisableControlAction(0,263,true) 
                DisableControlAction(0,264,true) 
                DisableControlAction(0,257,true) 
                DisableControlAction(0,140,true) 
                DisableControlAction(0,141,true) 
                DisableControlAction(0,142,true) 
                DisableControlAction(0,143,true) 
            end
	end
end)

function GoToTaxiSoYouCanGoSomewhere()
    local taxiModel = GetHashKey(tutorialcfg.TaxaModel)
	local driverModel = GetHashKey(tutorialcfg.PedModel)
    TriggerServerEvent('ATM:SetBucket', 'source')
    Wait(500)
	if not DoesEntityExist(taxiVeh) then
		RequestModel(taxiModel)
		RequestModel(driverModel)
		
		while not HasModelLoaded(taxiModel) do
			Wait(0)
		end

		while not HasModelLoaded(driverModel) do
			Wait(0)
		end
		taxiVeh = CreateVehicle(taxiModel, -1033.7006835938,-2730.8793945312,19.89764213562, 240.51, true, false)
		taxiPed = CreatePedInsideVehicle(taxiVeh, 26, driverModel, -1, true, false)

		SetEntityAsMissionEntity(taxiVeh, true, true)
		SetVehicleEngineOn(taxiVeh, true)

        Citizen.CreateThread(function()
            while true do 
                Citizen.Wait(3000)
                local pos = GetEntityCoords(GetPlayerPed(-1), true)
                if(Vdist(pos.x, pos.y, pos.z, tutorialcfg.drivetolocation) < 10)then
                    IsDriving = false
                    local ped = GetPlayerPed(-1)
                    if IsPedSittingInAnyVehicle(ped) then
                        local veh = GetVehiclePedIsIn(ped,false)
                        TaskLeaveVehicle(ped, veh, 1)
                        DeleteEntity(taxiPed)
                        DeleteEntity(taxiVeh)
                        TriggerServerEvent('ATM:SetBucket', '0')
                    end
                    Citizen.Wait(3000)
                    TaskVehicleDriveToCoordLongrange(taxiPed, taxiVeh, tutorialcfg.drivetolocation, 200.0, 786603, 15.0) -- Drives to line below
                elseif(Vdist(pos.x, pos.y, pos.z, tutorialcfg.drivetolocation) < 10)then
                    DeleteEntity(taxiPed)
                    DeleteEntity(taxiVeh)
                    SetModelAsNoLongerNeeded(taxiModel)
                    SetModelAsNoLongerNeeded(driverModel)
                    TriggerServerEvent('ATM:SetBucket', '0')
                end
            end
        end)

		SetAmbientVoiceName(taxiPed, "A_M_M_EASTSA_02_LATINO_FULL_01")
        TaskEnterVehicle( GetPlayerPed(-1), taxiVeh, 30000, 0, 1.0, 3, 0)
        IsDriving = true
        Citizen.Wait(1000)
        PlayAmbientSpeech1(taxiPed, "TAXID_BEGIN_JOURNEY", "SPEECH_PARAMS_FORCE_NORMAL")
		TaskVehicleDriveToCoordLongrange(taxiPed, taxiVeh, tutorialcfg.drivetolocation, 200.0, 786603, 5.0) -- Drives to line 88
		SetPedKeepTask(taxiPed, true)
	else
		print("error")
	end
end

AddEventHandler('ATM:PlaneCutscene', function()
    PrepareMusicEvent("FM_INTRO_START")
	TriggerMusicEvent("FM_INTRO_START")
         local plyrId = PlayerPedId()
         local playerClone = ClonePed_2(plyrId, 0.0, false, true, 1) ----
         ExecuteCommand('toggleui')
         -----------------------------------------------
         RequestCutscene("MP_INTRO_CONCAT", 8)
         while not HasCutsceneLoaded() do 
            Wait(10) 
         end
         DoScreenFadeIn(250)
         SetCutsceneEntityStreamingFlags('MP_Male_Character', 0, 1) 
         local female = RegisterEntityForCutscene(0,"MP_Female_Character",3,0,64)
         RegisterEntityForCutscene(PlayerPedId(), 'MP_Male_Character', 0, GetEntityModel(PlayerPedId()), 64)
         GetEntityIndexOfCutsceneEntity('MP_Female_Character', GetHashKey(GetEntityModel('MP_Female_Character')))
         NetworkSetEntityInvisibleToNetwork(female, true)
    --     -----------------------------------------------
         SetCutsceneEntityStreamingFlags("MP_Plane_Passenger_1", 0, 1)
         SetCutsceneEntityStreamingFlags("MP_Plane_Passenger_2", 0, 1)
         SetCutsceneEntityStreamingFlags("MP_Plane_Passenger_3", 0, 1)
         SetCutsceneEntityStreamingFlags("MP_Plane_Passenger_4", 0, 1)
         SetCutsceneEntityStreamingFlags("MP_Plane_Passenger_5", 0, 1)
         SetCutsceneEntityStreamingFlags("MP_Plane_Passenger_6", 0, 1)
         SetCutsceneEntityStreamingFlags("MP_Plane_Passenger_7", 0, 1)
         RegisterEntityForCutscene(0, 'MP_Plane_Passenger_1', 3, GetHashKey('mp_f_freemode_01'), 0)
         RegisterEntityForCutscene(0, 'MP_Plane_Passenger_2', 3, GetHashKey('mp_f_freemode_01'), 0)
         RegisterEntityForCutscene(0, 'MP_Plane_Passenger_3', 3, GetHashKey('mp_f_freemode_01'), 0)
         RegisterEntityForCutscene(0, 'MP_Plane_Passenger_4', 3, GetHashKey('mp_f_freemode_01'), 0)
         RegisterEntityForCutscene(0, 'MP_Plane_Passenger_5', 3, GetHashKey('mp_f_freemode_01'), 0)
         RegisterEntityForCutscene(0, 'MP_Plane_Passenger_6', 3, GetHashKey('mp_f_freemode_01'), 0)
         RegisterEntityForCutscene(0, 'MP_Plane_Passenger_7', 3, GetHashKey('mp_f_freemode_01'), 0)
         RegisterEntityForCutscene(0, 'MP_Plane_Passenger_1', 3, GetHashKey('mp_m_freemode_01'), 0)
         RegisterEntityForCutscene(0, 'MP_Plane_Passenger_2', 3, GetHashKey('mp_m_freemode_01'), 0)
         RegisterEntityForCutscene(0, 'MP_Plane_Passenger_3', 3, GetHashKey('mp_m_freemode_01'), 0)
         RegisterEntityForCutscene(0, 'MP_Plane_Passenger_4', 3, GetHashKey('mp_m_freemode_01'), 0)
         RegisterEntityForCutscene(0, 'MP_Plane_Passenger_5', 3, GetHashKey('mp_m_freemode_01'), 0)
         RegisterEntityForCutscene(0, 'MP_Plane_Passenger_6', 3, GetHashKey('mp_m_freemode_01'), 0)
         RegisterEntityForCutscene(0, 'MP_Plane_Passenger_7', 3, GetHashKey('mp_m_freemode_01'), 0)
         NewLoadSceneStartSphere(-1212.79, -1673.52, 7, 1000, 0)
         StartCutscene(4)
    
        Wait(31000)
        StopCutsceneImmediately()
        DoScreenFadeOut(90)
        SetEntityCoordsNoOffset(PlayerPedId(), -1045.5275878906,-2751.1530761719,21.363418579102, 0)
        SetEntityHeading(PlayerPedId(), 330.40)
        Wait(4000)
        PrepareMusicEvent("AC_STOP")
	    TriggerMusicEvent("AC_STOP")
        DoScreenFadeIn(500)
        GoToTaxiSoYouCanGoSomewhere()
        ExecuteCommand('toggleui')
end)
