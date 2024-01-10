extends CharacterBody2D


@export var speed: float = 300
@export var accel: float = 30

@onready var animations = $Character/AnimationPlayer
@onready var sprite = $Character
@onready var previousDirection: String = "down"


#var is_touching_border = false
var is_attacking = false

#BUG:
#Sprite moves a bit up when walking right or left (noticeable with keyboard)
#When attacking, only attacking animation will be played, not walking aniamtion

#func
#func border_collision():
	#var touching_border = false
#
	#for i in range(get_slide_collision_count()):
		#var collision = get_slide_collision(i)
		#var collider = collision.get_collider()
		#if collider and collider is StaticBody2D: # Check if colliding with StaticBody2D
			#touching_border = true
			#break # No need to check further collisions
#
	#if touching_border:
		## Play the animation only if it's not already playing
		#if animations.current_animation != "idle_" + previousDirection:
			#animations.play("idle_" + previousDirection)
	#else:
		## Optionally, stop the animation or switch to another if not touching the border
		#if animations.current_animation == "idle_"  + previousDirection:
			#animations.stop() # Or play another animation

func handle_input():
	var move_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	#var target_velocity: Vector2 = move_direction * speed
	
	velocity.x = move_toward(velocity.x, speed * move_direction.x, accel)
	velocity.y = move_toward(velocity.y, speed * move_direction.y, accel)
	if Input.is_action_just_pressed("attack") and not is_attacking:
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

	
	#if abs(velocity.x) > threshold and abs(velocity.x) > abs(velocity.y):
		#if velocity.x < 0:
			##direction = "right"
			#sprite.flip_h = true
		#else:
			#direction = "right"
			#sprite.flip_h = false
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
	
	#border_collision()
	handle_input()
	move_and_slide()
	update_animation()
	
	

#const speed = 100
#var current_dir = "none"
#
#func _ready():
	#$Character/AnimationPlayer.play("idle_down")
	#
	#
#func _physics_process(delta):
	#player_movement(delta)
	#
#func player_movement(delta):
	#
	#if Input.is_action_pressed("right"):
		#current_dir = "right"
		#play_anim(1)
		#velocity.x = speed
		#velocity.y = 0
