tool
extends EditorScenePostImport

func post_import(scene):
	if scene.get_child(0) is MeshInstance:
		return scene

	var tmp = scene.get_node("tmpParent")

	var mesh_parent = tmp
	var meshes := []

	if not tmp.get_child(0) is MeshInstance:
		mesh_parent = tmp.get_child(0)

	meshes = mesh_parent.get_children()

	if meshes.size() == 0:
		push_error("Error: meshes were empty for scene: " + scene.name)
	else:
		for mesh in meshes:
			if mesh.get_children().size() > 0:
				for mesh_child in mesh.get_children():
					reparent_mesh(mesh_child, mesh, scene)

			reparent_mesh(mesh, mesh_parent, scene)

		scene.remove_child(tmp)
		tmp.free()

	return scene


func reparent_mesh(mesh, old_parent, new_parent):
	old_parent.remove_child(mesh)
	new_parent.add_child(mesh)
	mesh.owner = new_parent
