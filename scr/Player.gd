extends KinematicBody

export (PackedScene) var FIREBALL
export (int) var SPEED
export (float) var GRAVITY
export (float) var LOOK_SENSITIVITY
export (float) var CAM_DIST
export (float) var CAM_OFFSET
export (bool) var INVERT_LOOK
export (Texture) var GUI_TALK_PROMPT

const V2_ZERO = Vector2(0,0)
const V3_ZERO = Vector3(0,0,0)
const V3_UP = Vector3(0,1,0)

var camera
var cameraTarget
var shotOrigin
var velocity = Vector3()
var lastMousePos = Vector2(0,0)
var mouseMove = Vector2(0,0)
var mouseScrollUp = false
var mouseScrollDown = false
var targetCamYRot
var targetCamXRot
var networkInfo

func _ready():	
	# set up camera and offsets
	camera = $"../CameraTarget/Camera"
	cameraTarget = $"../CameraTarget"
	shotOrigin = $"../CameraTarget/ShotOrigin"
	targetCamYRot = 0.0
	targetCamXRot = 0.0
	
	networkInfo = '\n[not connected]'
	get_tree().set_meta('network_peer', false)

func _physics_process(delta):
	var move = Vector3()
	var gravity = GRAVITY
	
	if mouseScrollUp:
		CAM_DIST -= 20.0 * delta
	if mouseScrollDown:
		CAM_DIST += 20.0 * delta
	
	CAM_DIST = clamp(CAM_DIST, 3.0, 10.0)
	
	# camera stuffs, stick overrides mouse
	if mouseMove != V2_ZERO:
		targetCamYRot = cameraTarget.rotation.y + (-mouseMove.x * LOOK_SENSITIVITY * delta)
		var my = mouseMove.y if INVERT_LOOK else -mouseMove.y
		targetCamXRot = cameraTarget.rotation.x + (my * LOOK_SENSITIVITY * delta)
	
	#stick follows
	if (Input.is_action_pressed('cam_right')):
		targetCamYRot = cameraTarget.rotation.y - (LOOK_SENSITIVITY * delta)
	if (Input.is_action_pressed('cam_left')):
		targetCamYRot = cameraTarget.rotation.y + (LOOK_SENSITIVITY * delta)
	var camStickAdjust = -(LOOK_SENSITIVITY * delta) if INVERT_LOOK else LOOK_SENSITIVITY * delta
	if (Input.is_action_pressed('cam_up')):
		targetCamXRot = cameraTarget.rotation.x + camStickAdjust
	if (Input.is_action_pressed('cam_down')):
		targetCamXRot = cameraTarget.rotation.x - camStickAdjust
	
	#cameraTarget.rotation.y = lerp(cameraTarget.rotation.y, targetCamYRot, 1.0 * delta)
	#cameraTarget.rotation.x = clamp(lerp(cameraTarget.rotation.x, targetCamXRot, 1.0 * delta), -1.0, 0.1)
	cameraTarget.rotation.y = targetCamYRot
	cameraTarget.rotation.x = clamp(targetCamXRot, -1.0, 0.1)

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
	
	if (Input.is_action_just_pressed('player_attack')):
		var fireball = FIREBALL.instance()
		get_parent().add_child(fireball)
		fireball.set_transform(shotOrigin.get_global_transform().orthonormalized())
		fireball.set_linear_velocity(shotOrigin.get_global_transform().basis[2].normalized()*100)
		fireball.add_collision_exception_with(self)
	
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
	
	GUI.set_debug_info('fps: ' + str(Engine.get_frames_per_second()) + '\ncam_dist: ' + str(CAM_DIST) + networkInfo)
	
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


