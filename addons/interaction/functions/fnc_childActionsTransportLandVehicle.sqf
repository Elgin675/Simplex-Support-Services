#include "script_component.hpp"

params ["_target","_player","_entity"];

[
	[["SSS_RTB","RTB",ICON_HOME,{
		(_this # 2) call EFUNC(support,requestTransportLandVehicle);
	},{(_this # 2 # 0) getVariable "SSS_awayFromBase"},{},[_entity,"RTB"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Move","Move",ICON_MOVE,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"MOVE"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_MoveEngOff","Move - Engine Off",ICON_MOVE_ENG_OFF,{
		_this call FUNC(selectPosition);
	},{true},{},[_entity,"MOVE_ENG_OFF"]] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_ImmediateStop","Stop",ICON_STOP_VEHICLE,{
		(_this # 2) call EFUNC(common,stopVehicle);
	},{(_this # 2) getVariable "SSS_onTask"},{},_entity] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_Behavior","Change Behavior",ICON_GEAR,{
		private _entity = _this # 2;

		["Change Behavior",[
			["COMBOBOX","Speed Mode",[["LIMITED","NORMAL","FULL"],_entity getVariable "SSS_speedMode"]],
			["COMBOBOX","Combat Mode",[["Fire At will","Hold Fire"],_entity getVariable "SSS_combatMode"]],
			["CHECKBOX","Headlight",_entity getVariable "SSS_lightsOn"],
			["BUTTON","Shut up!",SHUP_UP_BUTTON_CODE]
		],{
			_this call EFUNC(common,changeBehavior);
		},{},_entity] call EFUNC(CDS,dialog);
	},{true},{},_entity] call ace_interact_menu_fnc_createAction,[],_target],

	[["SSS_SITREP","SITREP",ICON_SITREP,{
		private _entity = _this # 2;
		private _vehicle = _entity getVariable ["SSS_vehicle",objNull];
		private _message = format ["Location: Grid %1<br />%2",mapGridPosition _vehicle,switch true do {
			case (!canMove _vehicle) : {"Status: Disabled"};
			case (damage _vehicle > 0) : {"Status: Damaged"};
			default {"Status: Green"};
		}];

		NOTIFY_LOCAL(_entity,_message);

		private _marker = createMarkerLocal [format ["SSS_%1$%2$%3",_vehicle,CBA_missionTime,random 1],getPos _vehicle];
		_marker setMarkerShapeLocal "ICON";
		_marker setMarkerTypeLocal "mil_box";
		_marker setMarkerColorLocal "ColorGrey";
		_marker setMarkerTextLocal (_entity getVariable "SSS_callsign");
		_marker setMarkerAlphaLocal 1;
		
		[{
			params ["_args","_PFHID"];
			_args params ["_vehicle","_marker"];

			private _alpha = markerAlpha _marker - 0.005;
			_marker setMarkerAlphaLocal _alpha;

			if (alive _vehicle) then {
				_marker setMarkerPosLocal getPosVisual _vehicle;
			};

			if (_alpha <= 0) then {
				_PFHID call CBA_fnc_removePerFrameHandler;
				deleteMarkerLocal _marker;
			};
		},0.1,[_vehicle,_marker]] call CBA_fnc_addPerFrameHandler;
	},{true},{},_entity] call ace_interact_menu_fnc_createAction,[],_target]
]
