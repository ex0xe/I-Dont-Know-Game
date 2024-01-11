extends CharacterBody2D

var speed = 75
var player_chase = false
var player = null
@onready var sprite = $AnimatedSprite2D

var health = 60
var player_inattack_zone = false
var can_take_damage = true


func enemy():
	pass
	
func _physics_process(delta):
	deal_with_damage()
	
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




func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_zone = true


func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_zone = false
		
		
func deal_with_damage():
	if player_inattack_zone and Global.player_current_attack == true:
		if can_take_damage == true:
			#print(can_take_damage, player_inattack_zone, Global.player_current_attack)
			health = health - 20
			$take_damage_cooldown.start()
			can_take_damage = false
			Global.player_current_attack = false
			print("slime health = ", health)
			if health <= 0:
				self.queue_free()


func _on_take_damage_cooldown_timeout():
	can_take_damage = true
