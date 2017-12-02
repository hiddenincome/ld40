extends Node2D

var cursor_pos = Vector2(5, 3)
var cursor_top_left = Vector2(0, 0)
var cursor_bottom_right = Vector2(10, 6)
var player_area_border = Vector2(4, 4)
var tile_size = 15

onready var play_area = get_node('play_area')
onready var cursor = get_node('play_area/cursor')
onready var queue = get_node('queue')
onready var new_tile_timer = get_node('new_tile_timer')
onready var queue_tiles = get_node('queue/tiles')
onready var play_area_tiles = get_node('play_area/tiles')

var tile_v = preload('res://scenes/tile_v.tscn')
var tile_h = preload('res://scenes/tile_h.tscn')
var tile_cross = preload('res://scenes/tile_cross.tscn')
var tile_rot_1 = preload('res://scenes/tile_rot_1.tscn')
var tile_rot_2 = preload('res://scenes/tile_rot_2.tscn')
var tile_rot_3 = preload('res://scenes/tile_rot_3.tscn')
var tile_rot_4 = preload('res://scenes/tile_rot_4.tscn')

var tile_class = {
	0: tile_v, 
	1: tile_h, 
	2: tile_cross,
	3: tile_rot_1,
	4: tile_rot_2,
	5: tile_rot_3,
	6: tile_rot_4
}

func _ready():
	place_cursor()
	set_process_input(true)
	
	new_tile_timer.start()

func _input(event):
	var new_cursor_pos = cursor_pos
		
	if event.is_action_pressed('ui_left'):
		new_cursor_pos += Vector2(-1, 0)
	elif event.is_action_pressed('ui_right'):
		new_cursor_pos += Vector2(1, 0)
	elif event.is_action_pressed('ui_up'):
		new_cursor_pos += Vector2(0, -1)
	elif event.is_action_pressed('ui_down'):
		new_cursor_pos += Vector2(0, 1)
	elif event.is_action_pressed('ui_select'):
		move_tile_from_queue_to_board()
	
	if new_cursor_pos.x >= cursor_top_left.x and \
		new_cursor_pos.y >= cursor_top_left.y and \
		new_cursor_pos.x <= cursor_bottom_right.x and \
		new_cursor_pos.y <= cursor_bottom_right.y:
		cursor_pos = new_cursor_pos
		place_cursor()

func place_cursor():
	cursor.set_pos(player_area_border + cursor_pos * tile_size)

func create_random_tile():
	randomize()
	return tile_class[randi()%7].instance()	

func _on_new_tile_timer_timeout():
	var number_of_tiles_in_queue = queue_tiles.get_child_count()

	if number_of_tiles_in_queue < 6:
		var tile = create_random_tile()
		
		for tile in queue_tiles.get_children():
			tile.set_pos(tile.get_pos() + Vector2(0, tile_size + 1))
		
		queue_tiles.add_child(tile)
		tile.set_pos(Vector2(4,4))
	else:
		print('END OF GAME')

func move_tile_from_queue_to_board():
	var number_of_tiles_in_queue = queue_tiles.get_child_count()
	
	if number_of_tiles_in_queue > 0:
		var tile = queue_tiles.get_child(0)
		queue_tiles.remove_child(tile)
		play_area_tiles.add_child(tile)
		tile.set_pos(cursor.get_pos())
	