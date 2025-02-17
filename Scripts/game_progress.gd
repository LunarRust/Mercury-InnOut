extends Node
class_name GameProgress

static var keysCollected = 0;
static var SchoolDone = false;
static var SewerDone = false;
static var HospitalDone = false;
static var BuildingDone = false;
static var DnaDone = false;
static var SymbolDone = false;
static var MapLayer = 1;
static var EmeraldKeys = 0;

@export var SchoolButton : Node2D
@export var SewerButton : Node2D
@export var HospitalButton : Node2D
@export var BuildingButton : Node2D;
@export var dnaButton : Node2D;
@export var symbolButton : Node2D;

@export var FinalButton: Node2D
@export var FinalButton2: Node2D
@export var FinalButton3: Node2D

func _ready():
	if SchoolDone && SchoolButton != null:
		SchoolButton.queue_free()
	if SewerDone && SewerButton != null:
		SewerButton.queue_free()
	if HospitalDone && HospitalButton != null:
		HospitalButton.queue_free()
	if BuildingDone && BuildingButton != null:
		BuildingButton.queue_free()
	if DnaDone && dnaButton != null:
		dnaButton.queue_free()		
	if SymbolDone && symbolButton != null:
		symbolButton.queue_free()

	if FinalButton != null:
		if keysCollected > 2:
			FinalButton.show()
		else:
			FinalButton.hide()

	if FinalButton2 != null:
		if keysCollected > 4:
			FinalButton2.show()
		else:
			FinalButton2.hide()			

	if FinalButton3 != null:
		if keysCollected > 5:
			FinalButton3.show()
		else:
			FinalButton3.hide()
	pass 

static func _reset():
	print("Erased All Progress")
	keysCollected = 0;
	SchoolDone = false;
	SewerDone = false;
	HospitalDone = false;
	BuildingDone = false;
	DnaDone = false;
	SymbolDone = false;
	MapLayer = 1;
	EmeraldKeys = 0;

