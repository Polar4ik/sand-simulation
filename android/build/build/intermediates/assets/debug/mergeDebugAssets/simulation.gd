extends TileMap


const LAYER_ID := 0
const SOURCE_ID := 0


const BLOCKS := {
	"Air": Vector2i(-1, -1),
	"Sand": Vector2i(0,0),
	"Stone": Vector2i(1, 0),
}
var selected_block := BLOCKS.Sand

var toch_press := false
var toch_pos

func _on_update() -> void:
	sand_check()


func sand_check() -> void:
	for sand in get_used_cells_by_id(LAYER_ID, SOURCE_ID, BLOCKS.Sand):
		if map_to_local(sand).y <= 477 and map_to_local(sand).x <= 510 and map_to_local(sand).x >= 0:
			sand_process(sand)


func sand_process(cord_in_world: Vector2i) -> void:
	var bottom_neighbour := cord_in_world + Vector2i.DOWN
	var left_bottom_neighbour := bottom_neighbour + Vector2i.LEFT
	var right_bottom_neighbour := bottom_neighbour + Vector2i.RIGHT
	
	if get_cell_atlas_coords(LAYER_ID, bottom_neighbour) == BLOCKS.Air:
		erase_cell(LAYER_ID, cord_in_world)
		set_cell(LAYER_ID, bottom_neighbour, SOURCE_ID, BLOCKS.Sand)
	
	elif get_cell_atlas_coords(LAYER_ID, left_bottom_neighbour) == BLOCKS.Air:
		erase_cell(LAYER_ID, cord_in_world)
		set_cell(LAYER_ID, left_bottom_neighbour, SOURCE_ID, BLOCKS.Sand)
	
	elif get_cell_atlas_coords(LAYER_ID, right_bottom_neighbour) == BLOCKS.Air:
		erase_cell(LAYER_ID, cord_in_world)
		set_cell(LAYER_ID, right_bottom_neighbour, SOURCE_ID, BLOCKS.Sand)


func set_block(pos) -> void:
	if toch_press:
		set_cell(LAYER_ID, local_to_map(pos), SOURCE_ID, selected_block)



func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		if event.get_relative():
			toch_press = true
			toch_pos = event.position
		else:
			toch_press = false
			toch_pos = event.position
	if event is InputEventScreenTouch:
		if event.is_pressed():
			toch_press = true
			toch_pos = event.position
		else:
			toch_press = false
			toch_pos = event.position


func _process(_delta: float) -> void:
	if toch_press:
		set_block(toch_pos)


func _on_button_pressed() -> void:
	match selected_block:
		BLOCKS.Air:
			selected_block = BLOCKS.Sand
			$"../CanvasLayer/Control/Button".text = "SAND"
		BLOCKS.Sand:
			selected_block = BLOCKS.Stone
			$"../CanvasLayer/Control/Button".text = "STONE"
		BLOCKS.Stone:
			selected_block = BLOCKS.Air
			$"../CanvasLayer/Control/Button".text = "AIR"
