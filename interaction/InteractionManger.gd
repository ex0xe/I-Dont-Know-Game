extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var label = $Label

const base_text_keyb = "[E] to "
const base_text_sony = "[X] to "

var active_areas = []
var can_interact = true

var last_input_type = ""


func register_area(area: InteractionArea):
	active_areas.push_back(area)
	
	
func unregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)
		
func _process(delta):
	if active_areas.size() > 1 && can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		if last_input_type == "keyboard":
			label.text = base_text_keyb + active_areas[0].action_name
		else:
			label.text = base_text_sony + active_areas[0].action_name
		
		label.global_position = active_areas[0].global_position
		label.global_position.y -= 36
		label.global_position.x -= label.size.x / 2
		label.show()
	else:
		label.hide()
		
func get_button_count():
	return 20
		
func _sort_by_distance_to_player(area1, area2):
	
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player

func _input(event):
	if event is InputEventKey:
		last_input_type = "keyboard"
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		last_input_type = "controller"
	if event.is_action_pressed("interact") && can_interact:
		if active_areas.size() > 1:

			can_interact = false
			label.hide()

			await active_areas[0].interact.call()
			can_interact = true
			
