extends Control

var dialogPath: String = ""
@export var textSpeed: float = 0.05
 
var dialog
 
var phraseNum = 0
var finished = false

signal dialog_finished
 
func talk():
	connect("dialog_finished", UI._on_dialog_finished)
	$Timer.wait_time = textSpeed
	dialog = getDialog()
	assert(dialog, "Dialog not found")
	nextPhrase()
 
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		if finished:
			nextPhrase()
		else:
			$Text.visible_characters = len($Text.text)
 
func getDialog() -> Array:
	assert(FileAccess.file_exists(dialogPath), "File path does not exist")
	var file = FileAccess.open(dialogPath, FileAccess.READ)
	
	var json_string = file.get_as_text()
	
	var json = JSON.new()
	
	var error = json.parse(json_string)
	if error == OK:
		var data_received = json.data
		if typeof(data_received) == TYPE_ARRAY:
			return data_received
		else:
			print("Unexpected data")
			return []
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return []

 
func nextPhrase() -> void:
	if phraseNum >= len(dialog):
		emit_signal("dialog_finished")
		disconnect("dialog_finished", UI._on_dialog_finished)
		return
	
	finished = false
	
	$Name.text = dialog[phraseNum]["Name"]
	$Text.text = dialog[phraseNum]["Text"]
	
	$Text.visible_characters = 0
	
	var img = dialog[phraseNum]["Name"] + dialog[phraseNum]["Emotion"] + ".png"
	if FileAccess.file_exists(img):
		var real_img = Image.load_from_file(img)
		$Portrait.texture = ImageTexture.create_from_image(real_img)
	else: $Portrait.texture = null
	
	while $Text.visible_characters < len($Text.text):
		$Text.visible_characters += 1
		
		$Timer.start()
		await $Timer.timeout
	
	finished = true
	phraseNum += 1
	return
