#include "script_component.hpp"

params ["_target","_player"];

private _actions = [];
private _assignedTransport = if (ADMIN_ACCESS_CONDITION) then {
	if (SSS_setting_adminLimitSide) then {
		private _side = side _target;
		SSS_entities select {!isNull _x && {(_x getVariable "SSS_service") == "transport" && {_x getVariable "SSS_side" == _side}}}
	} else {
		SSS_entities select {!isNull _x && {(_x getVariable "SSS_service") == "transport"}}
	};
} else {
	(_target getVariable ["SSS_assignedEntities",[]]) select {!isNull _x && {(_x getVariable "SSS_service") == "transport"}}
};

{
	private _action = switch (_x getVariable "SSS_supportType") do {
		case "transportHelicopter" : {
			["SSS_transport:" + str _x,_x getVariable "SSS_callsign","",{},{SSS_showTransportHelicopters},{},_x,ACTION_DEFAULTS,{
				params ["_target","_player","_entity","_actionData"];

				if (alive (_entity getVariable "SSS_vehicle")) then {
					_actionData set [2,[_entity getVariable "SSS_icon",_entity getVariable "SSS_iconGreen"] select (_entity getVariable "SSS_awayFromBase")];
					_actionData set [3,{}];
					_actionData set [5,{_this call FUNC(childActionsTransportHelicopter)}];
				} else {
					_actionData set [2,_entity getVariable "SSS_iconYellow"];
					_actionData set [3,{
						NOTIFY_LOCAL(_this # 2,"<t color='#f4ca00'>No vehicle available at this time. A replacement is on the way.</t>");
					}];
					_actionData set [5,{}];
				};
			},_x] call ace_interact_menu_fnc_createAction
		};

		case "transportLandVehicle" : {
			["SSS_transport:" + str _x,_x getVariable "SSS_callsign","",{},{SSS_showTransportLandVehicles},{},_x,ACTION_DEFAULTS,{
				params ["_target","_player","_entity","_actionData"];

				if (alive (_entity getVariable "SSS_vehicle")) then {
					_actionData set [2,[_entity getVariable "SSS_icon",_entity getVariable "SSS_iconGreen"] select (_entity getVariable "SSS_awayFromBase")];
					_actionData set [3,{}];
					_actionData set [5,{_this call FUNC(childActionsTransportLandVehicle)}];
				} else {
					_actionData set [2,_entity getVariable "SSS_iconYellow"];
					_actionData set [3,{
						NOTIFY_LOCAL(_this # 2,"<t color='#f4ca00'>No vehicle available at this time. A replacement is on the way.</t>");
					}];
					_actionData set [5,{}];
				};
			},_x] call ace_interact_menu_fnc_createAction
		};

		case "transportMaritime" : {
			["SSS_transport:" + str _x,_x getVariable "SSS_callsign","",{},{SSS_showTransportLandVehicles},{},_x,ACTION_DEFAULTS,{
				params ["_target","_player","_entity","_actionData"];

				if (alive (_entity getVariable "SSS_vehicle")) then {
					_actionData set [2,[_entity getVariable "SSS_icon",_entity getVariable "SSS_iconGreen"] select (_entity getVariable "SSS_awayFromBase")];
					_actionData set [3,{}];
					_actionData set [5,{_this call FUNC(childActionsTransportMaritime)}];
				} else {
					_actionData set [2,_entity getVariable "SSS_iconYellow"];
					_actionData set [3,{
						NOTIFY_LOCAL(_this # 2,"<t color='#f4ca00'>No vehicle available at this time. A replacement is on the way.</t>");
					}];
					_actionData set [5,{}];
				};
			},_x] call ace_interact_menu_fnc_createAction
		};

		case "transportVTOL" : {
			["SSS_transport:" + str _x,_x getVariable "SSS_callsign","",{},{SSS_showTransportVTOLs},{},_x,ACTION_DEFAULTS,{
				params ["_target","_player","_entity","_actionData"];

				if (alive (_entity getVariable "SSS_vehicle")) then {
					_actionData set [2,[_entity getVariable "SSS_icon",_entity getVariable "SSS_iconGreen"] select (_entity getVariable "SSS_awayFromBase")];
					_actionData set [3,{}];
					_actionData set [5,{_this call FUNC(childActionsTransportVTOL)}];
				} else {
					_actionData set [2,_entity getVariable "SSS_iconYellow"];
					_actionData set [3,{
						NOTIFY_LOCAL(_this # 2,"<t color='#f4ca00'>No vehicle available at this time. A replacement is on the way.</t>");
					}];
					_actionData set [5,{}];
				};
			},_x] call ace_interact_menu_fnc_createAction
		};
	};

	_actions pushBack [_action,[],_target];
} forEach ([_assignedTransport,true,{_this getVariable "SSS_callsign"}] call EFUNC(common,sortBy));

_actions
