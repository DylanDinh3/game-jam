extends Node2D
class_name Apple

@onready var ray_cast_2d := $RayCast2D
@onready var sprite_2d := $Sprite2D
@onready var area_2d := $Area2D

@export var sliding_time := 0.3

var tween := create_tween()
var is_sliding := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func push(direction: Vector2, tile_map: TileMapLayer) -> void:
	if is_sliding:
		return
	
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y
	)
	
	var tile_data: TileData = tile_map.get_cell_tile_data(target_tile)
	if tile_data.get_custom_data("walkable") == false:
		return
		
	
	ray_cast_2d.target_position = direction * 16
	ray_cast_2d.force_raycast_update()
	if ray_cast_2d.is_colliding():
		return
	
	is_sliding = true
	
	global_position = tile_map.map_to_local(target_tile)
	sprite_2d.global_position = tile_map.map_to_local(current_tile)


func can_move(direction: Vector2) -> bool:
	ray_cast_2d.target_position = direction * 16
	ray_cast_2d.force_raycast_update()
	return !ray_cast_2d.is_colliding()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if is_sliding == false:
		return
	
	if global_position == sprite_2d.global_position:
		is_sliding = false
		return
		
	sprite_2d.global_position = sprite_2d.global_position.move_toward(global_position, 1)

func eat() -> void:	
	await get_tree().create_timer(0.25).timeout
	self.queue_free()
