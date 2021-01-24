extends Node


var followingScene = ""
var current_scene = null


onready var player = $"/root/global/AnimationPlayer"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



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
	# call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	print(path)
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
	
	player.play()


func _on_AnimationPlayer_animation_finished(anim_name):
	print("111"+global.followingScene)
	if global.followingScene != "":
		call_deferred("_deferred_goto_scene", global.followingScene)
	global.followingScene = ""
