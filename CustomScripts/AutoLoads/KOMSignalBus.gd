# signal_bus.gd
extends Node

signal Activate_Pomp_Target
signal Activate_Player_Target
signal Kill_pomp
signal Item_Grab
signal Light_Toggle
signal Light_Off
signal Light_On
signal NavToPoint(id : int,doLook : bool,NavNodeTarget : Node,distance : float,ActionOnArrive : int,LookTargetFromBus : String)
signal ItemSpef(id : int,NavNodeTargetFromSignalBus : Node,Action : int)
signal CreateNpc(ID : int)

@export_category("Data Handles")
@export var PompNpcInstances : Array
# ... add any other signals you may want.
