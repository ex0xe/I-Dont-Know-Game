extends CharacterBody2D

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true

@export var speed: float = 300
@export var accel: float = 30

@onready var animations = $Character/AnimationPlayer
@onready var sprite = $Character
@onready var previousDirection: String = "down"

var is_attacking = false

#BUG:
#Sprite moves a bit up when walking right or left (noticeable with keyboard)
#When attacking, only attacking animation will be played, not walking aniamtion


func handle_input():
	var move_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	#var target_velocity: Vector2 = move_direction * speed
	
	velocity.x = move_toward(velocity.x, speed * move_direction.x, accel)
	velocity.y = move_toward(velocity.y, speed * move_direction.y, accel)
	if Input.is_action_just_pressed("attack") and not is_attacking:
		Global.player_current_attack = true
		attack()
	
func attack():
	is_attacking = true
	animations.play("attack_" + previousDirection)
	# Add a delay corresponding to the animation length, then set is_attacking back to false
	await get_tree().create_timer(animations.get_current_animation_length()).timeout
	is_attacking = false


func update_animation():
	if is_attacking:
		return
		
	var direction = "down"	
	var threshold: float = 0.01  # A small threshold to account for minor inaccuracies

	if abs(velocity.x) > threshold and abs(velocity.x) > abs(velocity.y):
		direction = "side"  # Keep the direction as "right" for both left and right movements
		sprite.flip_h = velocity.x < 0

	elif abs(velocity.y) > threshold:
		if velocity.y < 0:
			direction = "up"
		else:
			direction = "down"
	
	if velocity.length() <= threshold:
		animations.play("idle_" + previousDirection)
	else:
		animations.play("walk_" + direction)
		previousDirection = direction


func _physics_process(delta):
	
	enemy_attack()
	handle_input()
	move_and_slide()
	update_animation()
	
	if health <= 0:
		player_alive = false # player dies, reponse needed
		health = 0
		print("player has been killed")
		self.queue_free()
		
		
func player():
	pass


func _on_player_hitbox_body_entered(body):
		if body.has_method("enemy"):
			enemy_inattack_range = true


func _on_player_hitbox_body_exited(body):
		if body.has_method("enemy"):
			enemy_inattack_range = false
	
		
		
func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health - 20
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(health)


func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true
