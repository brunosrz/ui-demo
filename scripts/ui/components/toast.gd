extends PanelContainer

@onready var label: Label = $Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func show_toast(message: String, type: String = "info") -> void:
	label.text = message

	match type:
		"info":
			add_theme_color_override("panel_color", Color("007bff"))
		"success":
			add_theme_color_override("panel_color", Color("28a745"))
		"error":
			add_theme_color_override("panel_color", Color("dc3545"))
		_:
			add_theme_color_override("panel_color", Color("6c757d"))

	visible = true
	animation_player.play("fade_in_out")


func _on_animation_player_animation_finished(anim_name: String) -> void:
	if anim_name == "fade_in_out":
		visible = false
		queue_free()
