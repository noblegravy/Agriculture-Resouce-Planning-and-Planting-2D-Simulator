extends Node2D

func _on_player_tool_use(tool: Enum.Tool, pos: Vector2) -> void:
	var grid_cord = Vector2i(int(pos.x/Data.TILE_SIZE),int(pos.y/Data.TILE_SIZE))
	var has_soil = grid_cord in $Layers/SoilLayer.get_used_cells()
	match tool:
		Enum.Tool.HOE:
			var cell = $Layers/GrassLayer.get_cell_tile_data(grid_cord) as TileData
			if cell and cell.get_custom_data("farmable"):
				$Layers/SoilLayer.set_cells_terrain_connect( [grid_cord],0,0)
			 
		Enum.Tool.WATER:
			if has_soil:
				$Layers/WaterPatchLayer.set_cell(grid_cord,0,Vector2i(randi_range(0,2),0))
		
		Enum.Tool.FISH:
			if not grid_cord in $Layers/GrassLayer.get_used_cells():
				print("fishing")
		
		Enum.Tool.SEED:
			if has_soil:
				pass
				
			
