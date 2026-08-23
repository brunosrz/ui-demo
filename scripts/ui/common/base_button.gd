@tool
extends Button


func _ready() -> void:
	if not mouse_entered.is_connected(_on_mouse_entered):
		mouse_entered.connect(_on_mouse_entered)
	if not pressed.is_connected(_on_pressed):
		pressed.connect(_on_pressed)


func _on_mouse_entered() -> void:
	GlobalEvents.emit_signal("play_sfx_by_key_requested", "ui_hover")


func _on_pressed() -> void:
	SoundSys.play_sfx_requested.emit("ui_click", "SFX")
