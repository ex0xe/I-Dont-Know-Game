extends TileMap
@onready var interaction_area: InteractionArea = $InteractionArea
@onready var label_left_right: Label = $LabelFadeOff
@onready var label_left_right_anim = $LabelFadeOff/Animation
# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	
func _on_interact():
	label_left_right.text = "left or right..."
	label_left_right_anim.play("FadeOut")
	
