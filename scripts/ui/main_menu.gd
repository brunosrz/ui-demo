extends Panel

const CLICK_SOUND = "click1"
const HOVER_SOUND = "high_down"

@onready var new_game_button: Button = $MainButtons/NewGameButton
@onready var options_button: Button = $MainButtons/OptionsButton
@onready var exit_button: Button = $MainButtons/ExitButton


func _ready() -> void:
	new_game_button.mouse_entered.connect(_on_button_mouse_entered)
	options_button.mouse_entered.connect(_on_button_mouse_entered)
	exit_button.mouse_entered.connect(_on_button_mouse_entered)

	GlobalEvents.game_state_updated.connect(_on_game_state_updated)


func _exit_tree():
	GlobalEvents.game_state_updated.disconnect(_on_game_state_updated)


func _on_new_game_button_pressed() -> void:
	SoundSys.play_sfx_requested.emit("ui_click", "SFX")
	GlobalEvents.request_game_state_change.emit(
		{
			"new_state": GameManager.GameState.keys()[GameManager.GameState.PLAYING],
			"reason": "new_game"
		}
	)
	GlobalEvents.scene_push_requested.emit("res://scenes/world.tscn")


func _on_options_button_pressed() -> void:
	SoundSys.play_sfx_requested.emit("ui_click", "SFX")
	GlobalEvents.request_game_state_change.emit(
		{
			"new_state": GameManager.GameState.keys()[GameManager.GameState.SETTINGS],
			"reason": "open_options"
		}
	)


func _on_exit_button_pressed() -> void:
	SoundSys.play_sfx_requested.emit("ui_click", "SFX")
	GlobalEvents.request_game_state_change.emit(
		{
			"new_state": GameManager.GameState.keys()[GameManager.GameState.QUIT_CONFIRMATION],
			"reason": "exit_game"
		}
	)


func _on_button_mouse_entered():
	SoundSys.play_sfx_requested.emit("ui_rollover", "SFX")


func _on_game_state_updated(state_data: Dictionary) -> void:
	var new_state_key = state_data.get("new_state", "")
	visible = (new_state_key == GameManager.GameState.keys()[GameManager.GameState.MENU])
