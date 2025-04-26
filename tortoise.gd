extends Node2D

@onready var tile_map = $"../TileMap"
@onready var ray_cast_right1 := $RayCastRight1
@onready var ray_cast_right2 := $RayCastRight2
@onready var ray_cast_left1 := $RayCastLeft1
@onready var ray_cast_left2 := $RayCastLeft2
@onready var ray_cast_up1 := $RayCastUp1
@onready var ray_cast_up2 := $RayCastUp2
@onready var ray_cast_down1 := $RayCastDown1
@onready var ray_cast_down2 := $RayCastDown2
@onready var ray_cast_right_player := $RayCastRightPlayer
@onready var ray_cast_left_player := $RayCastLeftPlayer
@onready var ray_cast_up_player := $RayCastUpPlayer
@onready var ray_cast_down_player := $RayCastDownPlayer
@onready var animated_sprite_2d := $AnimatedSprite2D
@onready var area_2d := $Area2D

@export var sliding_time := 0.3

var tween := create_tween()
var is_moving := false
var last_move_direction = Vector2.RIGHT
var level_completed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_moving:
		return
	
	if ray_cast_right1.is_colliding() or ray_cast_right2.is_colliding():
		if ray_cast_right_player.is_colliding():
			return
		
		var collider1 : Node2D = get_collider_parent(ray_cast_right1)
		var collider2 : Node2D = get_collider_parent(ray_cast_right2)
		var new_position = Vector2i(self.global_position.x + 16, self.global_position.y)
		if move_and_eat(new_position, collider1, collider2):
			last_move_direction = Vector2.RIGHT
			if animated_sprite_2d.animation != "Move_R":
				animated_sprite_2d.play("Move_R")
			return
	if ray_cast_left1.is_colliding() or ray_cast_left2.is_colliding():
		if ray_cast_left_player.is_colliding():
			return
		
		var collider1 : Node2D = get_collider_parent(ray_cast_left1)
		var collider2 : Node2D = get_collider_parent(ray_cast_left2)
		var new_position = Vector2i(self.global_position.x - 16, self.global_position.y)
		if move_and_eat(new_position, collider1, collider2):
			last_move_direction = Vector2.LEFT
			if animated_sprite_2d.animation != "Move_L":
				animated_sprite_2d.play("Move_L")
			return
	if ray_cast_up1.is_colliding() or ray_cast_up2.is_colliding():
		if ray_cast_up_player.is_colliding():
			return
		
		var collider1 : Node2D = get_collider_parent(ray_cast_up1)
		var collider2 : Node2D = get_collider_parent(ray_cast_up2)
		var new_position = Vector2i(self.global_position.x, self.global_position.y - 16)
		if move_and_eat(new_position, collider1, collider2):
			last_move_direction = Vector2.UP
			if animated_sprite_2d.animation != "Move_U":
				animated_sprite_2d.play("Move_U")
			return
	if ray_cast_down1.is_colliding() or ray_cast_down2.is_colliding():
		if ray_cast_down_player.is_colliding():
			return
		
		var collider1 : Node2D = get_collider_parent(ray_cast_down1)
		var collider2 : Node2D = get_collider_parent(ray_cast_down2)
		var new_position = Vector2i(self.global_position.x, self.global_position.y + 16)
		if move_and_eat(new_position, collider1, collider2):
			last_move_direction = Vector2.DOWN
			if animated_sprite_2d.animation != "Move_D":
				animated_sprite_2d.play("Move_D")
			return
	
	if last_move_direction == Vector2.RIGHT:
		animated_sprite_2d.play("Idle_R")
	elif last_move_direction == Vector2.LEFT:
		animated_sprite_2d.play("Idle_L")
	elif last_move_direction == Vector2.UP:
		animated_sprite_2d.play("Idle_U")
	elif last_move_direction == Vector2.DOWN:
		animated_sprite_2d.play("Idle_D")

func move_and_eat(new_position: Vector2i, collider1: Node2D, collider2: Node2D) -> bool:
	if collider1 is Apple or collider2 is Apple:
		if move(new_position):
			if collider1 != null:
				collider1.eat()
			if collider2 != null:
				collider2.eat()
			return true
	
	return false

func move(new_position: Vector2i) -> bool:
	var target_tile1: Vector2i = Vector2i(new_position.x / 16, new_position.y / 16)
	var tile_data1: TileData = tile_map.get_cell_tile_data(target_tile1)
	if tile_data1.get_custom_data("walkable") == false:
		return false
		
	var target_tile2: Vector2i = Vector2i(new_position.x / 16 - 1, new_position.y / 16)
	var tile_data2: TileData = tile_map.get_cell_tile_data(target_tile2)
	if tile_data2.get_custom_data("walkable") == false:
		return false
		
	var target_tile3: Vector2i = Vector2i(new_position.x / 16, new_position.y / 16 - 1)
	var tile_data3: TileData = tile_map.get_cell_tile_data(target_tile3)
	if tile_data3.get_custom_data("walkable") == false:
		return false
		
	var target_tile4: Vector2i = Vector2i(new_position.x / 16 - 1, new_position.y / 16 - 1)
	var tile_data4: TileData = tile_map.get_cell_tile_data(target_tile4)
	if tile_data4.get_custom_data("walkable") == false:
		return false
	
	is_moving = true
	
	var current_position = Vector2i(self.global_position.x, self.global_position.y)
	global_position = new_position
	animated_sprite_2d.global_position = current_position
	return true


func _physics_process(delta: float) -> void:
	if is_moving == false:
		return
	
	if global_position == animated_sprite_2d.global_position:
		is_moving = false
		return
	
	animated_sprite_2d.global_position = animated_sprite_2d.global_position.move_toward(global_position, 1)
	
	var target_tile1: Vector2i = Vector2i(global_position.x / 16, global_position.y / 16)
	var tile_data1: TileData = tile_map.get_cell_tile_data(target_tile1)
	var target_tile2: Vector2i = Vector2i(global_position.x / 16 - 1, global_position.y / 16)
	var tile_data2: TileData = tile_map.get_cell_tile_data(target_tile2)
	var target_tile3: Vector2i = Vector2i(global_position.x / 16, global_position.y / 16 - 1)
	var tile_data3: TileData = tile_map.get_cell_tile_data(target_tile3)
	var target_tile4: Vector2i = Vector2i(global_position.x / 16 - 1, global_position.y / 16 - 1)
	var tile_data4: TileData = tile_map.get_cell_tile_data(target_tile4)
	
	if (tile_data1.get_custom_data("isGoal") or tile_data2.get_custom_data("isGoal") or tile_data3.get_custom_data("isGoal") or tile_data4.get_custom_data("isGoal")) and !level_completed:
		level_completed = true
		await get_tree().create_timer(0.5).timeout
		$"..".show_level_completed_textbox()
	
func get_collider_parent(raycast: RayCast2D) -> Node2D:
	if raycast.get_collider() != null:
		return raycast.get_collider().get_parent()
	else:
		return null
