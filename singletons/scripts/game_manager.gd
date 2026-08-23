extends Node

enum GameState { MENU, PLAYING, PAUSED, SETTINGS, QUIT_CONFIRMATION }

var current_game_state: GameState = GameState.MENU
var _previous_game_state: GameState = GameState.MENU


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	get_tree().paused = false

	GlobalEvents.request_game_state_change.connect(set_game_state)
	GlobalEvents.return_to_previous_state_requested.connect(_on_return_to_previous_state_requested)
	GlobalEvents.quit_confirmed.connect(_on_quit_confirmed)
	GlobalEvents.quit_cancelled.connect(_on_quit_cancelled)


func set_game_state(state_request_data: Dictionary) -> void:
	var new_state_key = state_request_data.get("new_state", "")
	if new_state_key.is_empty():
		printerr("GameManager: Tentativa de mudar o estado do jogo sem 'new_state' no dicionário.")
		return

	var new_state_index = GameState.keys().find(new_state_key)
	if new_state_index == -1:
		printerr("GameManager: Estado de jogo inválido solicitado: %s" % new_state_key)
		return
	var new_state = GameState.values()[new_state_index]

	if new_state == current_game_state:
		return

	var old_state = current_game_state

	if new_state == GameState.SETTINGS or new_state == GameState.QUIT_CONFIRMATION:
		_previous_game_state = old_state

	current_game_state = new_state
	print(
		(
			"GameManager: Mudando estado de %s para %s. Previous state: %s"
			% [
				GameState.keys()[old_state],
				GameState.keys()[new_state],
				GameState.keys()[_previous_game_state]
			]
		)
	)

	match current_game_state:
		GameState.MENU:
			get_tree().paused = false
			GlobalEvents.hide_quit_confirmation_requested.emit()
		GameState.PLAYING:
			get_tree().paused = false
			GlobalEvents.hide_quit_confirmation_requested.emit()
		GameState.PAUSED:
			get_tree().paused = true
			GlobalEvents.hide_quit_confirmation_requested.emit()
		GameState.SETTINGS:
			get_tree().paused = true
			GlobalEvents.hide_quit_confirmation_requested.emit()
		GameState.QUIT_CONFIRMATION:
			get_tree().paused = true
			GlobalEvents.show_quit_confirmation_requested.emit()

	GlobalEvents.game_state_updated.emit(
		{
			"new_state": GameState.keys()[new_state],
			"previous_state": GameState.keys()[old_state],
			"is_paused": get_tree().paused
		}
	)


func _on_quit_confirmed() -> void:
	get_tree().quit()


func _on_quit_cancelled() -> void:
	print(
		(
			"GameManager: Quit cancelled. Returning to previous state: %s"
			% GameState.keys()[_previous_game_state]
		)
	)

	set_game_state(
		{
			"new_state": GameState.keys()[_previous_game_state],
			"reason": "return_from_quit_confirmation"
		}
	)


func _on_return_to_previous_state_requested() -> void:
	set_game_state(
		{"new_state": GameState.keys()[_previous_game_state], "reason": "return_from_menu"}
	)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		match current_game_state:
			GameState.PLAYING:
				set_game_state(
					{"new_state": GameState.keys()[GameState.PAUSED], "reason": "user_pause"}
				)
			GameState.PAUSED:
				set_game_state(
					{"new_state": GameState.keys()[GameState.PLAYING], "reason": "user_unpause"}
				)
			GameState.SETTINGS:
				GlobalEvents.return_to_previous_state_requested.emit()
			GameState.MENU:
				GlobalEvents.show_quit_confirmation_requested.emit()
