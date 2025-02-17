class_name QuickTweens extends Node
#optional is a dictionary carrying optional parapeters



#useinitial:bool, uses the initial value of the property as the starting point.
#	reminder that this will probably lead to the object being completely off where it started if a new
#	tween interrupts it.
#inital:Variant, sets the starting point for the value as something other than the default 
#callback:Callable, an optional callback for the flip animation. 
#tween:Tween, an optional tween to provide the function

static func tween_check(node:Node,params:Dictionary)->Tween:
	if params.has('tween'):
		return params['tween']
	else:
		return node.get_tree().create_tween()

static func init_check(node:Node,propertyname:NodePath,default,params:Dictionary):
	if params.has('useposition'):
		return node.get_indexed(propertyname.get_as_property_path())
	elif params.has('inital'):
		return params['inital']
	else:
		return default

static func flip(node:Node,propertyname:NodePath,speed=.05,optional:Dictionary={})->Tween:
	var tween:Tween = tween_check(node,optional)
	var value = init_check(node,propertyname,1,optional)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(node, propertyname,0,speed)
	if optional.has('callback'):
		tween.tween_callback(optional['callback'])
	tween.tween_property(node, propertyname,value,speed)
	return tween

static func bounce(node:Node,propertyname:NodePath,bounceheight = 10.0,upspeed=.1,downspeed=.5,optional:Dictionary={})->Tween:
	var value
	if typeof(bounceheight) == TYPE_VECTOR2:
		value = init_check(node,propertyname,Vector2.ONE,optional)
	else:
		value = init_check(node,propertyname,0,optional)
	var tween:Tween = node.get_tree().create_tween()
	tween.tween_property(node, propertyname,value-bounceheight,upspeed)
	tween.tween_property(node, propertyname,value,downspeed).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	return tween

static func smooth_rise_and_fall(node:Node,propertyname:NodePath,rise_height:float=10,fall_height:float=40,speed=1,optional:Dictionary={})->Tween:
	var speed_ratio:float = rise_height/(rise_height+fall_height)
	var rise_speed = speed * speed_ratio
	var fall_speed = speed * (1-rise_speed)
	var tween = tween_check(node,optional)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(node,propertyname,-1*rise_height,rise_speed)
	if optional.has('callback'):
		tween.tween_callback(optional['callback'])
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(node,propertyname,fall_height,fall_speed)
	return tween

static func knock_off_arc_2D(node:Node2D,rise_height:float=10,fall_height:float=40,arc_range:float=20,rotation_range:float=12,speed=1,optional:Dictionary={})->Tween:
	var arc_size = randf_range(-arc_range,arc_range)
	var horizontal_tween = node.create_tween()
	horizontal_tween.pause()
	horizontal_tween.tween_property(node,"position:x",node.position.x + arc_size,speed)
	horizontal_tween.parallel().tween_property(node,'rotation',randf_range(-rotation_range,rotation_range),speed)
	
	var vertical_tween = tween_check(node,optional)
	vertical_tween.tween_callback(func():horizontal_tween.play())
	if !optional.has('tween'):
		optional['tween'] = vertical_tween
	else:
		print("THIS IS THE ONE")
	QuickTweens.smooth_rise_and_fall(node,"position:y",rise_height,fall_height,speed,optional)
#	vertical_tween.tween_callback(func():
#		horizontal_tween.kill())
	return vertical_tween


