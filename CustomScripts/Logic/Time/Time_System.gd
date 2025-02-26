extends Node
@export_category("Time System")
@export var date_time : Node
@export var TimeLabel : RichTextLabel
@export var ticks_pr_second : int = 6
@export var formated_time : String
var seconds
var minutes
var hours

func _process(delta: float) -> void:
	date_time.increase_by_sec(delta * ticks_pr_second)
	seconds = add_leading_zero(date_time.seconds)
	minutes = add_leading_zero(date_time.minutes)
	hours = add_leading_zero(date_time.hours)
	formated_time = hours + ":" + minutes + ":" + seconds
	TimeLabel.text = "[shake rate=10][center]" + formated_time

func add_leading_zero(value: int):
		if value < 10:
			return "0" + str(value)
		else:
			return str(value)
