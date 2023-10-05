extends TileMap


const LAYER_ID := 0
const SOURCE_ID := 0


const ELEMENTS := {
	"Air": Vector2i(-1, -1),
	"Sand": Vector2i(0, 0),
	"Stone": Vector2i(1, 0),
}


func sand_process() -> void:
	for sand in get_used_cells_by_id(LAYER_ID, SOURCE_ID, ELEMENTS.Sand):
		var bottom_cell := sand + Vector2i.DOWN
		var left_cell := sand + Vector2i.LEFT
		var left_bottom_cell := left_cell + Vector2i.DOWN
		var right_cell := sand + Vector2i.RIGHT
		var right_bottom_cell = right_cell + Vector2i.DOWN
		
		if get_cell_atlas_coords(LAYER_ID, bottom_cell) == ELEMENTS.Air:
			erase_cell(LAYER_ID, sand)
			set_cell(LAYER_ID, bottom_cell, SOURCE_ID, ELEMENTS.Sand)
		
		elif get_cell_atlas_coords(LAYER_ID, left_cell) == ELEMENTS.Air and\
		get_cell_atlas_coords(LAYER_ID, left_bottom_cell) == ELEMENTS.Air:
			erase_cell(LAYER_ID, sand)
			set_cell(LAYER_ID, left_bottom_cell, SOURCE_ID, ELEMENTS.Sand)
		
		elif get_cell_atlas_coords(LAYER_ID, right_cell) == ELEMENTS.Air and get_cell_atlas_coords(LAYER_ID, right_bottom_cell) == ELEMENTS.Air:
			erase_cell(LAYER_ID, sand)
			set_cell(LAYER_ID, right_bottom_cell, SOURCE_ID, ELEMENTS.Sand)


func _on_update() -> void:
	sand_process()
