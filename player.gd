extends Node2D
class_name Player

@onready var tile_map = $"../TileMap"
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var ray_cast_2d = $RayCast2D

var is_moving = false
var last_move_direction := Vector2.RIGHT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	if is_moving == false:
		return
	
	if global_position == animated_sprite_2d.global_position:
		is_moving = false
		return
		
	animated_sprite_2d.global_position = animated_sprite_2d.global_position.move_toward(global_position, 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !DataTracker.tutorial_completed:
		return
	
	if is_moving:
		return

	var motion := Vector2()
	if Input.is_action_pressed("up"):
		motion = Vector2.UP
		animated_sprite_2d.play("Hop_U")
	elif Input.is_action_pressed("down"):
		motion = Vector2.DOWN
		animated_sprite_2d.play("Hop_D")
	elif Input.is_action_pressed("left"):
		motion = Vector2.LEFT
		animated_sprite_2d.play("Hop_L")
	elif Input.is_action_pressed("right"):
		motion = Vector2.RIGHT
		animated_sprite_2d.play("Hop_R")
	else:
		if last_move_direction == Vector2.RIGHT:
			animated_sprite_2d.play("Idle_R")
		elif last_move_direction == Vector2.LEFT:
			animated_sprite_2d.play("Idle_L")
		elif last_move_direction == Vector2.UP:
			animated_sprite_2d.play("Idle_U")
		elif last_move_direction == Vector2.DOWN:
			animated_sprite_2d.play("Idle_D")
	
	if !move(motion):
		return
	
	if ray_cast_2d.is_colliding():
		var collider = ray_cast_2d.get_collider().get_parent()
		if collider is Apple and collider.can_move(motion):
			collider.push(motion, tile_map)


func move(direction: Vector2) -> bool:
	if direction == Vector2.ZERO:
		return true
		
	last_move_direction = direction
	
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y
	)
	
	var tile_data: TileData = tile_map.get_cell_tile_data(target_tile)
	if tile_data.get_custom_data("walkable") == false:
		return false
	
	ray_cast_2d.target_position = direction * 16
	ray_cast_2d.force_raycast_update()
	
	if ray_cast_2d.is_colliding():
		return true
	
	is_moving = true
	
	global_position = tile_map.map_to_local(target_tile)
	animated_sprite_2d.global_position = tile_map.map_to_local(current_tile)
	
	return true
