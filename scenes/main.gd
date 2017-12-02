extends Node2D

var play_area_top_left = Vector2(280, 100)
var cursor_pos = Vector2(5, 3)
var cursor_top_left = Vector2(0, 0)
var cursor_bottom_right = Vector2(10, 6)

onready var play_area = get_node('play_area')
onready var cursor = get_node('play_area/cursor')

func _ready():
	play_area.set_pos(play_area_top_left)
	place_cursor()
	set_process_input(true)

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
	
	if new_cursor_pos.x >= cursor_top_left.x and \
		new_cursor_pos.y >= cursor_top_left.y and \
		new_cursor_pos.x <= cursor_bottom_right.x and \
		new_cursor_pos.y <= cursor_bottom_right.y:
		cursor_pos = new_cursor_pos
		place_cursor()

func place_cursor():
	cursor.set_pos(Vector2(4, 4) + cursor_pos * 15)