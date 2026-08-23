class_name SceneManager
extends Control

var _scene_stack: Array[Node] = []

@onready var menu_control: Control = $MenuViewportContainer/GameViewport/Control
@onready var main_menu: Panel = menu_control.get_node("MainMenu")
@onready var pause_menu: Panel = menu_control.get_node("PauseMenu")
@onready var options_menu: Panel = menu_control.get_node("OptionsMenu")
@onready
var quit_confirmation_dialog: PanelContainer = menu_control.get_node("QuitConfirmationDialog")

@onready var game_viewport: SubViewport = $GameViewportContainer/GameViewport


func _ready():
	GlobalEvents.scene_push_requested.connect(_on_scene_push_requested)
	GlobalEvents.scene_pop_requested.connect(_on_scene_pop_requested)
	GlobalEvents.game_state_updated.connect(_on_game_state_updated)
	SoundSys.emit_signal("request_audio_start")


func _on_scene_push_requested(path: String):
	"\n\tCarrega uma cena e a adiciona à pilha, ou a traz para frente se já carregada.\n\t"

	if path.is_empty():
		printerr("SceneManager: Recebido pedido para carregar cena com caminho vazio.")
		return

	for i in range(_scene_stack.size()):
		var existing_scene = _scene_stack[i]
		if existing_scene.scene_file_path == path:
			print("SceneManager: Cena '%s' já está na pilha. Trazendo para frente." % path)

			if not _scene_stack.is_empty():
				_scene_stack.back().hide()

			_scene_stack.remove_at(i)
			_scene_stack.push_back(existing_scene)

			existing_scene.show()
			existing_scene.process_mode = Node.PROCESS_MODE_INHERIT
			GlobalEvents.scene_updated.emit({"path": path, "type": "game_world"})
			return

	if not ResourceLoader.exists(path):
		printerr("SceneManager: Caminho da cena inválido ou não encontrado: ", path)
		return

	if not _scene_stack.is_empty():
		_scene_stack.back().hide()

	var new_scene = load(path).instantiate()

	game_viewport.add_child(new_scene)
	_scene_stack.append(new_scene)

	GlobalEvents.scene_updated.emit({"path": path, "type": "game_world"})


func _on_game_state_updated(state_data: Dictionary) -> void:
	var new_state = state_data.get("new_state", "")
	var is_paused = state_data.get("is_paused", false)

	main_menu.visible = false
	pause_menu.visible = false
	options_menu.visible = false
	quit_confirmation_dialog.visible = false

	match new_state:
		"MENU":
			main_menu.visible = true
		"PLAYING":
			pass
		"PAUSED":
			pause_menu.visible = true
		"SETTINGS":
			options_menu.visible = true
		"QUIT_CONFIRMATION":
			quit_confirmation_dialog.visible = true

	for scene in _scene_stack:
		if scene != null and is_instance_valid(scene):
			scene.process_mode = (
				Node.PROCESS_MODE_INHERIT if not is_paused else Node.PROCESS_MODE_DISABLED
			)


func _on_scene_pop_requested():
	"\n\tRemove a cena atual da pilha e retorna à cena anterior.\n\t"

	if _scene_stack.size() <= 1:
		printerr("SceneManager: Não há cenas para remover da pilha.")

		get_tree().quit()
		return

	var current_scene = _scene_stack.pop_back()
	current_scene.queue_free()

	if not _scene_stack.is_empty():
		var previous_scene = _scene_stack.back()
		previous_scene.show()
		previous_scene.process_mode = Node.PROCESS_MODE_INHERIT
		GlobalEvents.scene_updated.emit(
			{"path": previous_scene.scene_file_path, "type": "game_world"}
		)
