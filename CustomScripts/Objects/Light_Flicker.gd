extends Node3D

@export var SpotLights : Array[SpotLight3D]
@export var OmniLights : Array[OmniLight3D]
@export var noise: NoiseTexture3D
@export var EnegeryMultiplier : float = 1
var time_passed := 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_passed += delta
	#print(time_passed)
	
	var sampled_noise = noise.noise.get_noise_1d(time_passed * 2)
	sampled_noise = abs(sampled_noise) 
	
	if !SpotLights.is_empty():
		for i in SpotLights:
			i.light_energy = sampled_noise * EnegeryMultiplier
	if !OmniLights.is_empty():
		for i in OmniLights:
			i.light_energy = sampled_noise * EnegeryMultiplier
	pass
