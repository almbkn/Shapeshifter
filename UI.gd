extends Control

var caller

# Called when the node enters the scene tree for the first time.
func enter_dialog(dialog, c):
	caller = c
	$Tint.visible = true
	$LowerBG/Dialog.dialogPath = dialog
	$LowerBG/Inventory.visible = false
	$LowerBG/Dialog.visible = true
	$LowerBG/Dialog.talk()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_dialog_finished():
	caller.visible = true
	caller.monitoring = true
	$LowerBG/Dialog.visible = false
	$Tint.visible = false
	$LowerBG/Inventory.visible = true
