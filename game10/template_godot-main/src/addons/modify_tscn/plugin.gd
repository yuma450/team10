@tool
extends EditorPlugin

func _enter_tree() -> void:
	print("_enter_tree(ModifyTscn)")
	scene_saved.connect(_on_scene_saved)

func _exit_tree() -> void:
	pass
	
func _on_scene_saved(filepath: String) -> void:
	var local_path = ProjectSettings.localize_path(filepath)
	var resource = load(local_path)
	if resource is PackedScene:
		print("_on_scene_saved(ModifyTscn): local path = "+local_path)
		print()
		var savefile = false
		var node_count = resource.get_state().get_node_count()
		for i in range(node_count):
			# replace id of PackedScene with its path
			var instance = resource.get_state().get_node_instance(i)
			if instance != null and instance is PackedScene and instance.get_id_for_path(local_path) != instance.get_path():
				print(resource.get_state().get_node_name(i))
				print("path = "+instance.get_path())
				print("id = "+instance.get_id_for_path(local_path))
				instance.set_id_for_path(local_path,instance.get_path())
				print("-> "+instance.get_id_for_path(local_path))
				print()
				savefile = true
		if savefile == true:
			print("saved")
			ResourceSaver.save(resource,local_path,0)
