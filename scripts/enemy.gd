extends CharacterBody2D

var speed = 75
var player_chase = false
var player = null
@onready var sprite = $AnimatedSprite2D


func _physics_process(delta):
	if player_chase:
		#velocity = position.direction_to(player.position) * speed
		#move_and_slide()
		
		position += (player.position - position).normalized() * speed * delta
		move_and_collide(Vector2(0,0))
		#move_and_slide()
		
		sprite.play("walk")
		
		if(player.position.x - position.x) < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
	else:
		sprite.play(("idle"))
		

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true


func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
