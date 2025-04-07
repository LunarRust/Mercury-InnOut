extends Node
@export_category("Time System")
@export var date_time : Node
@export var TimeLabel : RichTextLabel
@export var ticks_pr_second : int = 6
@export var formated_time : String
var seconds = "0"
var minutes = "0"
var hours = "0"
var InnOutBus

func _ready():
	InnOutBus = get_tree().get_first_node_in_group("InnOutSignalBus")

func _process(delta: float) -> void:
	#
	#if player has timer disabled, do not record time.
	#
	if InnOutBus.DoTimer:
		date_time.increase_by_sec(delta * ticks_pr_second)
		
	seconds = add_leading_zero(date_time.seconds)
	minutes = add_leading_zero(date_time.minutes)
	hours = add_leading_zero(date_time.hours)
	formated_time = hours + ":" + minutes + ":" + seconds
	TimeLabel.text = "[shake rate=10]" + formated_time
	if !InnOutBus.DoTimer:
		TimeLabel.text = "[shake rate=10]" + formated_time + "[/shake] Timer disabled. Time will not be recorded."
		

func add_leading_zero(value: int):
		if value < 10:
			return "0" + str(value)
		else:
			return str(value)
