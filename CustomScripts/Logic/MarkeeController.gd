extends Node3D
var TextDisplays : Array[RichTextLabel]
var SignalBusInnOut
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBusInnOut = get_tree().get_first_node_in_group("InnOutSignalBus")
	await SignalBusInnOut.is_node_ready()
	SignalBusInnOut.connect("GameOver",GameOver)
	for i in get_children():
		if i.get_node("SubViewport/MarkeeLabel") is RichTextLabel:
			TextDisplays.append(i.get_node("SubViewport/MarkeeLabel"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_physical_key_pressed(KEY_F5):
		clearText()
	if Input.is_physical_key_pressed(KEY_F6):
		ChangeText()
	if Input.is_physical_key_pressed(KEY_F7):
		ChangeDisplaySettings(0.5,1)
	if Input.is_physical_key_pressed(KEY_8):
		ResetDisplaySettings()
	if Input.is_physical_key_pressed(KEY_9):
		ChangeText("[center] Get Back To Work!",20)
		ChangeDisplaySettings(1,1)


func GameOver():
	ChangeText("[center]GAME OVER",28)
	ChangeDisplaySettings(0.1,1,true,0.7)

func clearText():
	for i in TextDisplays:
		i.Disable()
		
func ChangeText(newText : String = "[center] ERROR",FontSize : int = 28,):
	for i in TextDisplays:
		i.text = newText
		i.add_theme_font_size_override("normal_font_size", FontSize)
		
func ChangeDisplaySettings(newSpeed : float = 1,newLoops : int = -1,DoBlink : bool = false,BlinkRate : float = 0.5):
	for i in TextDisplays:
		i.update(newSpeed,newLoops)
		i.DoBlinking = DoBlink
		i.BlinkSpeed = BlinkRate

func ResetDisplaySettings():
	for i in TextDisplays:
		i.push_font_size(28)
		i.update(1,-1)
		i.Enable()
