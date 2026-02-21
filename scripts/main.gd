extends Node2D

var keys = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen"]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for key in keys:
		set_visibility(key, false)  # Ensure sprites are not visible at the start


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for key in keys:
		if Input.is_action_just_pressed(key):
			set_visibility(key, true)
			
		if Input.is_action_just_released(key):
			set_visibility(key, false)


func set_visibility(key, visible):
	var ting = get_node_or_null("things/" + key)
	if ting:
		ting.modulate.a = 1.0 if visible else 0.0
		
func button_pressed(key):
	var ting = get_node("things/" + key)		
	ting.modulate.a = 1.0
