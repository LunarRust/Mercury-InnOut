extends Node
@export var DimTo : float = 0.0
@export var BrightenTo : float = 0.0
@export var BrightnessCurve : Curve
@export var Brighten : bool = false
@export var Dim : bool = false

var t : float = 0
var Speed : float = 1
var LightCurrentEnergy

var OmniLights : Array[OmniLight3D]
var SpotLights : Array[SpotLight3D]
var DirectionalLights : Array[DirectionalLight3D]

func LightChange():
	if !OmniLights.is_empty():
		LightCurrentEnergy = OmniLights.front().light_energy
	elif !SpotLights.is_empty():
		LightCurrentEnergy = SpotLights.front().light_energy
	elif !DirectionalLights.is_empty():
		LightCurrentEnergy = DirectionalLights.front().light_energy
		
func IncreaseLight():
	LightChange()
	Brighten = true
	Dim = false

func DecreaseLight():
	LightChange()
	Brighten = false
	Dim = true
	
func ToggleLight():
	if Brighten == true:
		Brighten = false
		Dim = true
	else:
		Brighten = true
		Dim = false
	LightChange()

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_children():
		if i is OmniLight3D:
			OmniLights.append(i)
		elif i is SpotLight3D:
			SpotLights.append(i)
		elif i is DirectionalLight3D:
			DirectionalLights.append(i)
	LightChange()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Brighten && t <= BrightenTo:
		t += delta * Speed
		for i in OmniLights:
			i.light_energy = lerp(LightCurrentEnergy,BrightenTo,BrightnessCurve.sample(t))
	elif Dim && t >= DimTo:
		t -= delta * Speed
		for i in OmniLights:
			i.light_energy = lerp(DimTo,LightCurrentEnergy,BrightnessCurve.sample(t))
