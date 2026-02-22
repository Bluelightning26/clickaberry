extends Node2D

var keys = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen"]

var note_scene = preload("res://scenes/note.tscn")
var active_notes := {}
var hint_label: Label  

var patterns = [
	{ "key": "one" },
	{ "key": "two" },
	{ "key": "three" },
	{ "key": "four" },
	{ "key": "five" },
	{ "key": "six" },
	{ "key": "seven" },
	{ "key": "eight" },
	{ "key": "nine" },
	{ "key": "ten" },
	{ "key": "eleven" },
	{ "key": "twelve" },
	{ "key": "thirteen" },
	{ "key": "fourteen" },
	{ "key": "fifteen" },
	{ "key": "eighteen" },
]

func _ready() -> void:
	# Create hint label
	hint_label = Label.new()
	hint_label.position = Vector2(250, -4)
	hint_label.add_theme_font_size_override("font_size", 32)
	add_child(hint_label)
	
	for key in keys:
		active_notes[key] = []
		set_visibility(key, true)  
	spawn_note("nine")
	update_hint_label()

func _process(_delta):
	for key in keys:
		if Input.is_action_just_pressed(key):
			handle_input(key)

func set_visibility(key, asf):
	var ting = get_node_or_null("things/" + key)
	if ting:
		ting.modulate.a = 1.0 if asf else 0.0
		
func spawn_note(key):
	var note = note_scene.instantiate()
	
	var key_node = get_node("things/" + key)
	
	# Use the key's REAL position
	var x = key_node.global_position.x
	var target_y = key_node.global_position.y
	
	add_child(note)
	note.global_position = Vector2(x, -250)
	note.target_y = target_y
	note.key = key
	
	active_notes[key].append(note)
	update_hint_label()

func remove_note(note):
	if note.key in active_notes:
		active_notes[note.key].erase(note)
	update_hint_label()
	
	await get_tree().create_timer(0.3).timeout  # 👈 ADD DELAY
	spawn_random_note.call_deferred()
	
func handle_input(key):
	# Check only the active notes for this key
	if key in active_notes:
		for note in active_notes[key]:
			if is_instance_valid(note) and not note.is_queued_for_deletion():
				if note.try_hit(key):
					flash_key(key)
					return
	
	print("MISS (no valid note):", key)
func flash_key(key):
	var ting = get_node_or_null("things/" + key)
	if ting:
		ting.modulate.a = 0.0  # hide
		
		await get_tree().create_timer(0.1).timeout  # 0.1 sec flash
		
		ting.modulate.a = 1.0  # show again


func update_hint_label():
	var active_keys = []
	for key in keys:
		if active_notes[key].size() > 0:
			active_keys.append(key.to_upper())
	
	if active_keys.is_empty():
		hint_label.text = "Get Ready!"
	else:
		hint_label.text = "Click: " + ", ".join(active_keys)

func spawn_random_note():
	var pattern = patterns.pick_random()
	spawn_note.call_deferred(pattern.key)	
