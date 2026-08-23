extends Node


static func play_hover_sound() -> void:
	GlobalEvents.emit_signal("play_sfx_by_key_requested", "interface_select")


static func play_click_sound() -> void:
	SoundSys.play_sfx_requested.emit("interface_confirmation", "SFX")
