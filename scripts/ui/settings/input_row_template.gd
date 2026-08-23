extends HBoxContainer

signal remap_requested(action: String, input_type: String)

var action_name: String

@onready var action_label: Label = $ActionLabel
@onready var key_button: Button = $KeyButton
@onready var controller_button: Button = $ControllerButton
@onready var mouse_button: Button = $MouseButton


func _ready() -> void:
	pass


func set_action_name(name: String) -> void:
	action_name = name
	action_label.text = tr("input_action." + name)


func update_bindings(bindings: Array) -> void:
	var keyboard_binding = ""
	var controller_binding = ""
	var mouse_binding = ""

	for event_data in bindings:
		var event_type = event_data.get("type", "")
		match event_type:
			"InputEventKey":
				keyboard_binding = OS.get_keycode_string(event_data.get("keycode", 0))
			"InputEventJoypadButton":
				controller_binding = "J" + str(event_data.get("button_index", 0))
			"InputEventMouseButton":
				mouse_binding = "M" + str(event_data.get("button_index", 0))

	key_button.text = keyboard_binding if not keyboard_binding.is_empty() else tr("UI_NONE")
	controller_button.text = (
		controller_binding if not controller_binding.is_empty() else tr("UI_NONE")
	)
	mouse_button.text = mouse_binding if not mouse_binding.is_empty() else tr("UI_NONE")


func _on_key_button_pressed() -> void:
	remap_requested.emit(action_name, "keyboard")


func _on_controller_button_pressed() -> void:
	remap_requested.emit(action_name, "controller")


func _on_mouse_button_pressed() -> void:
	remap_requested.emit(action_name, "mouse")
