extends Area2D

var dialogPath = "dialog.json"

func _process(_delta):
	if Input.is_action_just_pressed("left_click") and \
		$AnimatedSprite2D.animation == "hovered":
		monitoring = false
		visible = false
		UI.enter_dialog(dialogPath, self)
		

func _on_mouse_entered():
	$AnimatedSprite2D.play("hovered")

func _on_mouse_exited():
	$AnimatedSprite2D.play("normal")
	

