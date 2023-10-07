extends TileMap


const LAYER_ID := 0
const SOURCE_ID := 0


const ELEMENTS := {
	"IMORTAL" : Vector2i(3, 0),
	"Air": Vector2i(-1, -1),
	"Sand": Vector2i(0, 0),
	"Stone": Vector2i(1, 0),
	"Whater": Vector2i(2, 0),
}
var selected_element := ELEMENTS.Sand

func _ready() -> void:
	randomize()


func sand_process() -> void:
	var sands := get_used_cells_by_id(LAYER_ID, SOURCE_ID, ELEMENTS.Sand)
	sands.sort_custom(func(a,b): return a.y > b.y)
	for sand in sands:
		var bottom_cell := sand + Vector2i.DOWN
		var left_cell := sand + Vector2i.LEFT
		var left_bottom_cell := left_cell + Vector2i.DOWN
		var right_cell := sand + Vector2i.RIGHT
		var right_bottom_cell = right_cell + Vector2i.DOWN
		
		
		
		if get_cell_atlas_coords(LAYER_ID, bottom_cell) == ELEMENTS.Air:
			erase_cell(LAYER_ID, sand)
			set_cell(LAYER_ID, bottom_cell, SOURCE_ID, ELEMENTS.Sand)
		
		elif get_cell_atlas_coords(LAYER_ID, left_cell) == ELEMENTS.Air and\
		get_cell_atlas_coords(LAYER_ID, left_bottom_cell) == ELEMENTS.Air and\
		get_cell_atlas_coords(LAYER_ID, right_cell) == ELEMENTS.Air and\
		get_cell_atlas_coords(LAYER_ID, right_bottom_cell) == ELEMENTS.Air:
			if randi_range(0, 1) == 0:
				erase_cell(LAYER_ID, sand)
				set_cell(LAYER_ID, left_bottom_cell, SOURCE_ID, ELEMENTS.Sand)
			else:
				erase_cell(LAYER_ID, sand)
				set_cell(LAYER_ID, right_bottom_cell, SOURCE_ID, ELEMENTS.Sand)
		
		elif get_cell_atlas_coords(LAYER_ID, left_cell) == ELEMENTS.Air and\
		get_cell_atlas_coords(LAYER_ID, left_bottom_cell) == ELEMENTS.Air:
			erase_cell(LAYER_ID, sand)
			set_cell(LAYER_ID, left_bottom_cell, SOURCE_ID, ELEMENTS.Sand)
		
		
		elif get_cell_atlas_coords(LAYER_ID, right_cell) == ELEMENTS.Air and\
		get_cell_atlas_coords(LAYER_ID, right_bottom_cell) == ELEMENTS.Air:
			erase_cell(LAYER_ID, sand)
			set_cell(LAYER_ID, right_bottom_cell, SOURCE_ID, ELEMENTS.Sand)
		
		elif get_cell_atlas_coords(LAYER_ID, bottom_cell) == ELEMENTS.Whater:
			erase_cell(LAYER_ID, sand)
			erase_cell(LAYER_ID, bottom_cell)
			set_cell(LAYER_ID, bottom_cell, SOURCE_ID, ELEMENTS.Sand)
			set_cell(LAYER_ID, sand, SOURCE_ID, ELEMENTS.Whater)
		
		elif get_cell_atlas_coords(LAYER_ID, left_cell) == ELEMENTS.Whater and get_cell_atlas_coords(LAYER_ID, left_bottom_cell) == ELEMENTS.Whater:
			erase_cell(LAYER_ID, sand)
			erase_cell(LAYER_ID, left_bottom_cell)
			set_cell(LAYER_ID, left_bottom_cell, SOURCE_ID, ELEMENTS.Sand)
			set_cell(LAYER_ID, sand, SOURCE_ID, ELEMENTS.Whater)
		
		elif get_cell_atlas_coords(LAYER_ID, right_cell) == ELEMENTS.Whater and get_cell_atlas_coords(LAYER_ID, right_bottom_cell) == ELEMENTS.Whater:
			erase_cell(LAYER_ID, sand)
			erase_cell(LAYER_ID, right_bottom_cell)
			set_cell(LAYER_ID, right_bottom_cell, SOURCE_ID, ELEMENTS.Sand)
			set_cell(LAYER_ID, sand, SOURCE_ID, ELEMENTS.Whater)


func whater_process() -> void:
	var whaters := get_used_cells_by_id(LAYER_ID, SOURCE_ID, ELEMENTS.Whater)
	whaters.sort_custom(func(a,b): return a.y > b.y)
	for whater in whaters:
		var bottom_cell := whater + Vector2i.DOWN
		var left_cell := whater + Vector2i.LEFT
		var left_bottom_cell := left_cell + Vector2i.DOWN
		var right_cell := whater + Vector2i.RIGHT
		var right_bottom_cell = right_cell + Vector2i.DOWN
		
		
		if get_cell_atlas_coords(LAYER_ID, bottom_cell) == ELEMENTS.Air:
			erase_cell(LAYER_ID, whater)
			set_cell(LAYER_ID, bottom_cell, SOURCE_ID, ELEMENTS.Whater)
		
		
		elif get_cell_atlas_coords(LAYER_ID, left_cell) == ELEMENTS.Air and\
		get_cell_atlas_coords(LAYER_ID, left_bottom_cell) == ELEMENTS.Air:
			erase_cell(LAYER_ID, whater)
			set_cell(LAYER_ID, left_bottom_cell, SOURCE_ID, ELEMENTS.Whater)
		
		elif get_cell_atlas_coords(LAYER_ID, right_cell) == ELEMENTS.Air and\
		get_cell_atlas_coords(LAYER_ID, right_bottom_cell) == ELEMENTS.Air:
			erase_cell(LAYER_ID, whater)
			set_cell(LAYER_ID, right_bottom_cell, SOURCE_ID, ELEMENTS.Whater)
		
		elif get_cell_atlas_coords(LAYER_ID, left_cell) == ELEMENTS.Air:
			erase_cell(LAYER_ID, whater)
			set_cell(LAYER_ID, left_cell, SOURCE_ID, ELEMENTS.Whater)
		
		elif get_cell_atlas_coords(LAYER_ID, right_cell) == ELEMENTS.Air:
			erase_cell(LAYER_ID, whater)
			set_cell(LAYER_ID, right_cell, SOURCE_ID, ELEMENTS.Whater)


func _on_update() -> void:
	queue_redraw()
	sand_process()
	whater_process()

var is_touch := false
var touch_position

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.is_pressed():
			is_touch = true
			touch_position = event.position
		else: 
			is_touch = false
	if event is InputEventScreenDrag:
		if event.get_velocity() != Vector2.ZERO:
			is_touch = true
			touch_position = event.position

func _process(_delta: float) -> void:
	if is_touch:
		set_block_on_mouse(touch_position)


func set_block_on_mouse(toch_pos) -> void:
	var mouse_pos_tile = local_to_map(toch_pos)
	if selected_element != ELEMENTS.Air:
		if get_cell_atlas_coords(LAYER_ID, mouse_pos_tile) == ELEMENTS.Air\
		and get_cell_atlas_coords(LAYER_ID, mouse_pos_tile + Vector2i.DOWN) == ELEMENTS.Air\
		and get_cell_atlas_coords(LAYER_ID, mouse_pos_tile + Vector2i.LEFT) == ELEMENTS.Air\
		and get_cell_atlas_coords(LAYER_ID, mouse_pos_tile + Vector2i.RIGHT) == ELEMENTS.Air\
		and get_cell_atlas_coords(LAYER_ID, mouse_pos_tile + Vector2i.UP) == ELEMENTS.Air:
			set_cell(LAYER_ID, mouse_pos_tile, SOURCE_ID, selected_element)
			set_cell(LAYER_ID, mouse_pos_tile + Vector2i.LEFT, SOURCE_ID, selected_element)
			set_cell(LAYER_ID, mouse_pos_tile + Vector2i.RIGHT, SOURCE_ID, selected_element)
			set_cell(LAYER_ID, mouse_pos_tile + Vector2i.UP, SOURCE_ID, selected_element)
			set_cell(LAYER_ID, mouse_pos_tile + Vector2i.DOWN, SOURCE_ID, selected_element)
	else:
		if get_cell_atlas_coords(LAYER_ID, mouse_pos_tile) != ELEMENTS.IMORTAL and\
		get_cell_atlas_coords(LAYER_ID, mouse_pos_tile + Vector2i.LEFT) != ELEMENTS.IMORTAL and\
		get_cell_atlas_coords(LAYER_ID, mouse_pos_tile + Vector2i.RIGHT) != ELEMENTS.IMORTAL and\
		get_cell_atlas_coords(LAYER_ID, mouse_pos_tile + Vector2i.DOWN) != ELEMENTS.IMORTAL and\
		get_cell_atlas_coords(LAYER_ID, mouse_pos_tile + Vector2i.UP) != ELEMENTS.IMORTAL:
			set_cell(LAYER_ID, mouse_pos_tile, SOURCE_ID, selected_element)
			set_cell(LAYER_ID, mouse_pos_tile + Vector2i.LEFT, SOURCE_ID, selected_element)
			set_cell(LAYER_ID, mouse_pos_tile + Vector2i.RIGHT, SOURCE_ID, selected_element)
			set_cell(LAYER_ID, mouse_pos_tile + Vector2i.UP, SOURCE_ID, selected_element)
			set_cell(LAYER_ID, mouse_pos_tile + Vector2i.DOWN, SOURCE_ID, selected_element)


func _on_button_pressed() -> void:
	match selected_element:
		ELEMENTS.Air:
			selected_element = ELEMENTS.Sand
			$"../CanvasLayer/Control/VBoxContainer/Button".text = "SAND"
		ELEMENTS.Sand:
			selected_element = ELEMENTS.Stone
			$"../CanvasLayer/Control/VBoxContainer/Button".text = "STONE"
		ELEMENTS.Stone:
			selected_element = ELEMENTS.Whater
			$"../CanvasLayer/Control/VBoxContainer/Button".text = "WHATER"
		ELEMENTS.Whater:
			selected_element = ELEMENTS.Air
			$"../CanvasLayer/Control/VBoxContainer/Button".text = "AIR"


### AFK LOL
