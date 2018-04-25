extends KinematicBody

export (PackedScene) var FIREBALL
export (int) var SPEED

const V2_ZERO = Vector2(0,0)
const V3_ZERO = Vector3(0,0,0)
const V3_UP = Vector3(0,1,0)
const V3_FORWARD = Vector3(0,0,1)
const V3_LEFT = Vector3(1,0,0)

var camera
var cameraTarget
var cameraOffset
var shotOrigin
var anchor
var velocity = Vector3()
var lastMousePos = Vector2(0,0)
var mouseWorldPos = Vector3(0,0,0)
var mouseMove = Vector2(0,0)
var mouseScrollUp = false
var mouseScrollDown = false

func _ready():
	camera = $"Camera"
	cameraTarget = $"CameraTarget"
	cameraOffset = Vector3(0,12,5)
	camera.rotate_x(-45)
	
	shotOrigin = $"Anchor/ShotOrigin"
	anchor = $"Anchor"

func _physics_process(delta):
	var move = Vector3()

	var cam_transform = camera.get_global_transform()
	if (Input.is_action_pressed("ui_up")):
		move += -cam_transform.basis[2]
	if (Input.is_action_pressed("ui_down")):
		move += cam_transform.basis[2]
	if (Input.is_action_pressed("ui_left")):
		move += -cam_transform.basis[0]
	if (Input.is_action_pressed("ui_right")):
		move += cam_transform.basis[0]
	move = move.normalized()
	move = move * SPEED * delta
	
#	if (Input.is_action_just_pressed('player_attack')):
#		var fireball = FIREBALL.instance()
#		get_parent().add_child(fireball)
#		fireball.set_transform(shotOrigin.get_global_transform().orthonormalized())
#		fireball.set_linear_velocity(shotOrigin.get_global_transform().basis[2].normalized()*20)
#		fireball.add_collision_exception_with(self)
	
	velocity.x = move.x
	velocity.z = move.z
	
	velocity = move_and_slide(velocity, V3_UP)
	camera.translation = cameraOffset
	
	# test move sight
	#print(lastMousePos)
	var anchorPos = mouseWorldPos
	anchorPos.y = 0.1
	anchor.look_at(anchorPos, V3_UP)
	#$"../CanvasLayer/Node2D/FpsLabel".text = 'fps: ' + str(Engine.get_frames_per_second()) + '\ncam_dist: ' + str(CAM_DIST)
	
	# clear input stuffs
	mouseMove = Vector2(0,0)
	mouseScrollUp = false
	mouseScrollDown = false

func _input(event):
	if event is InputEventMouse:
		mouseMove = event.position - lastMousePos
		lastMousePos = event.position
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			mouseScrollUp = true
		if event.button_index == BUTTON_WHEEL_DOWN:
			mouseScrollDown = true

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		get_tree().quit()

func _on_mouseAimGround(camera, event, click_position, click_normal, shape_idx):
	mouseWorldPos = click_position
