extends KinematicBody

export (PackedScene) var FIREBALL
export (int) var SPEED
export (float) var GRAVITY
export (float) var LOOK_SENSITIVITY
export (float) var CAM_DIST
export (float) var CAM_OFFSET
export (bool) var INVERT_LOOK

const V3_ZERO = Vector3(0,0,0)
const V3_UP = Vector3(0,1,0)

var camera
var cameraTarget
var shotOrigin
var velocity = Vector3()
var lastMouseMove = Vector2(0,0)
var targetCamYRot
var targetCamXRot
var networkInfo

func _ready():
	camera = $"../CameraTarget/Camera"
	cameraTarget = $"../CameraTarget"
	shotOrigin = $"../CameraTarget/ShotOrigin"
	targetCamYRot = 0.0
	targetCamXRot = 0.0
	
	networkInfo = '\n[not connected]'

func _physics_process(delta):
	var move = Vector3()
	var gravity = GRAVITY
	
	if (Input.is_action_pressed('ui_page_up')):
		CAM_DIST -= 1.0 * delta
	if (Input.is_action_pressed('ui_page_down')):
		CAM_DIST += 1.0 * delta
	
	CAM_DIST = clamp(CAM_DIST, 3.0, 10.0)
	
	var mouseMove = Input.get_last_mouse_speed()
	if (mouseMove.x != lastMouseMove.x):
		lastMouseMove.x = mouseMove.x
		targetCamYRot = cameraTarget.rotation.y + (-mouseMove.x * LOOK_SENSITIVITY * delta)
	if (mouseMove.y != lastMouseMove.y):
		lastMouseMove.y = mouseMove.y
		var my = -mouseMove.y if INVERT_LOOK else mouseMove.y
		targetCamXRot = cameraTarget.rotation.x + (my * LOOK_SENSITIVITY * delta)
	cameraTarget.rotation.y = lerp(cameraTarget.rotation.y, targetCamYRot, 0.2)
	cameraTarget.rotation.x = clamp(lerp(cameraTarget.rotation.x, targetCamXRot, 0.2), -0.9, -0.15)

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
	
	if (Input.is_action_just_pressed("ui_cancel")):
		var fireball = FIREBALL.instance()
		get_parent().add_child(fireball)
		fireball.translation = cameraTarget.translation + shotOrigin.translation
		var dir = cameraTarget.rotation
		dir.x = 0
		fireball.rotation = dir
		fireball.apply_impulse(shotOrigin.translation, dir.normalized() * 10)
	
	if (Input.is_action_just_released('net_start_server')):
		NetworkStartServer()
	if (Input.is_action_just_released('net_start_client')):
		NetworkStartClient()
	
	if (is_on_floor() and Input.is_action_just_pressed("ui_accept")):
		velocity.y = 450 * delta
	
	if (velocity.y > 0):
		gravity = -20
	else:
		gravity = -30
	
	velocity.y += gravity * delta
	velocity.x = move.x
	velocity.z = move.z
	
	velocity = move_and_slide(velocity, V3_UP)
	var camOffset = translation
	camOffset.y += CAM_OFFSET
	cameraTarget.translation = camOffset
	camera.translation.z = CAM_DIST
	
	var net = get_tree().get_meta('network_peer')
	if not net:
		networkInfo = '\n[not connected]'
	else:
		networkInfo = '\n' + str(net)
		net = get_tree().is_network_server()
		networkInfo += '\n' + str(net)
	
	$"../CanvasLayer/Node2D/FpsLabel".text = 'fps: ' + str(Engine.get_frames_per_second()) + '\ncam_dist: ' + str(CAM_DIST) + networkInfo
	
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		get_tree().set_network_peer(null) # shutdown network
		get_tree().quit()

func NetworkStartServer():
	get_tree().set_network_peer(null) # shutdown network
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(1337, 8)
	get_tree().set_network_peer(peer)
	get_tree().set_meta('network_peer', peer)

func NetworkStartClient():
	get_tree().set_network_peer(null) # shutdown network
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client('127.0.0.1', 1337)
	get_tree().set_network_peer(peer)
	get_tree().set_meta('network_peer', peer)