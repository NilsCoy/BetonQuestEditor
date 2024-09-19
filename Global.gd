extends Node

# learn https://gdscript.com/solutions/godot-graphnode-and-graphedit-tutorial/ !!!!!!!!!!!!!!

func _save(directorySave, node_tree, NpcList, PlayerList):
	var scene = get_tree().get_root().get_node("MainScene")
	var save_file = File.new()
	
	save_file.open(directorySave, File.WRITE)
	
	save_file.store_line(to_json(node_tree))
	for node_data in NpcList:
		var data = get_tree().get_root().get_node("MainScene/GraphEdit/"+node_data).save()
		save_file.store_line(to_json(data))
	for node_data in PlayerList:
		var data = get_tree().get_root().get_node("MainScene/GraphEdit/"+node_data).save()
		save_file.store_line(to_json(data))
	
	save_file.close()

func _load(path):
	var scene = get_tree().get_root().get_node("MainScene")
	var save_file = File.new()
	
	save_file.open(path, File.READ)
	while save_file.get_position() < save_file.get_len():
		if save_file.get_position() == 0:
			scene.node_tree = parse_json(save_file.get_line())
			continue
		var node_data = parse_json(save_file.get_line())
		var new_object_data = load("res://Scenes/Node.tscn").instance()
		for i in node_data.keys():
			new_object_data.set(i, node_data[i])
		var new_object = new_object_data
		get_tree().get_root().get_node("MainScene/GraphEdit").add_child(new_object)
		new_object.offset.x = node_data["offset.x"]
		new_object.offset.y = node_data["offset.y"]
		if node_data["state"] == "player": scene.PlayerList.append(new_object.name)
		elif node_data["state"] == "npc": scene.NpcList.append(new_object.name)
	for i in scene.node_tree:
		for j in scene.node_tree[i]:
			get_tree().get_root().get_node("MainScene/GraphEdit").connect_node(str(i), 0, str(j), 0)
		
	save_file.close()
