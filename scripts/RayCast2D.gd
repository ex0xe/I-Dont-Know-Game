extends RayCast2D

@onready var interaction_label : Label
var is_reset : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_colliding():
		var interactable = get_collider()
		if interactable != null and interactable.has_method("interact"):
			interaction_label.text = "Press E to interact"
		else:
			interaction_label.text = ""

	else:
		if !is_reset:
			interaction_label.text = ""
			is_reset = true
	
func _input(event):
	if event.is_action_pressed("interact"): #Adjust to match your InputMap
		if is_colliding():
			var interactable = get_collider()
			if interactable.has_method("interact"):
				interactable.interact(self)
