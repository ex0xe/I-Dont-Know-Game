extends CharacterBody2D

var enemy_inattack_range = false
var enemy_attack_cooldown = true
@export var max_health: int = 100
var health = max_health
var player_alive = true





@export var speed: float = 300
@export var accel: float = 30

@onready var animations = $Character/AnimationPlayer
@onready var sprite = $Character
@onready var previousDirection: String = "side"
@onready var attackbox_side = $player_attackbox/attackbox_side
@onready var attackbox_updown = $player_attackbox/attackbox_updown
@onready var attackbox = $player_attackbox
#attackbox.get_node("attackbox_updown").disabled = false
#attackbox.get_node("attackbox_side").disabled = true
#attackbox.scale.y = -1

var is_attacking = false

#BUG:
#Sprite moves a bit up when walking right or left (noticeable with keyboard)
#When attacking, only attacking animation will be played, not walking aniamtion


func _ready():
	
	update_attackbox("right")

func handle_input():
	var move_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	velocity.x = move_toward(velocity.x, speed * move_direction.x, accel)
	velocity.y = move_toward(velocity.y, speed * move_direction.y, accel)
	if Input.is_action_just_pressed("attack") and not is_attacking:
		if Global.player_attackbox_touching_enemy == true:
			Global.player_current_attack = true
		attack()
	
func attack():
	is_attacking = true
	animations.play("attack_" + previousDirection)
	# Add a delay corresponding to the animation length, then set is_attacking back to false
	await get_tree().create_timer(animations.get_current_animation_length()).timeout
	is_attacking = false
	
func update_attackbox(attack_direction):
	var is_side_attack = attack_direction in ["left", "right"]
	attackbox.get_node("attackbox_updown").disabled = is_side_attack
	attackbox.get_node("attackbox_side").disabled = !is_side_attack

# 
func update_animation():
	if is_attacking:
		return
		
	var direction = "side"
	var threshold: float = 0.01  # A small threshold to account for minor inaccuracies

	if abs(velocity.x) > threshold and abs(velocity.x) > abs(velocity.y):
		if velocity.x < 0:
			update_attackbox("left")
			direction = "side"  
			sprite.flip_h = true
			attackbox.scale.x = -1
		else:
			update_attackbox("right")
			direction = "side"
			sprite.flip_h = false
			attackbox.scale.x = 1

	elif abs(velocity.y) > threshold:
		if velocity.y < 0:
			update_attackbox("up")
			direction = "up"
			attackbox.scale.y = 1
		else:
			update_attackbox("down")
			direction = "down"
			attackbox.scale.y = -1
	
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
	update_health()
	
	if health <= 0:
		player_alive = false # player dies, reponse needed
		health = 0
		print("player has been killed")
		#animations.play("die_side")
		self.queue_free() # only for demonstration that player can die
		
		
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
		health = health - 10
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(health)


func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true



func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	Global.player_current_attack = false
	is_attacking = false
	

func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	if health >= max_health:
		healthbar.visible = false
	else:
		healthbar.visible = true


func _on_regen_timer_timeout():
	if health < max_health:
		health = health + 10
		if health > max_health:
			health = max_health
	if health <= 0:
		health = 0
	print(health)
