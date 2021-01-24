extends Node

var followingScene = ""
var currentScene = ""

onready var player = $"/root/global/AnimationPlayer"

func _ready():
	var root = get_tree().get_root()
	currentScene = root.get_child(root.get_child_count() - 1)
	player.play("a1")


func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		quitGame()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		quitGame()

func quitGame():
	# saveGame()
	get_tree().quit()

func goto_scene(path):
	global.followingScene = path
	player.playback_speed = 2
	player.play_backwards()

func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	currentScene.free()

	# Load the new scene.
	print(path)
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	currentScene = s.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(currentScene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(currentScene)
	
	player.play()


func _on_AnimationPlayer_animation_finished(anim_name):
	if global.followingScene != "":
		call_deferred("_deferred_goto_scene", global.followingScene)
	global.followingScene = ""
