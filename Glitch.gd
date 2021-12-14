extends CanvasLayer

func apply(length, off = 5):
	$shaderholder.visible = true
	$shaderholder.get_material().set_shader_param("offset", off)
	yield(get_tree().create_timer(length), "timeout")
	$shaderholder.visible = false
	$shaderholder.get_material().set_shader_param("offset", 5)
