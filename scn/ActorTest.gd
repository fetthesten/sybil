extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export (Texture) var HEADSHOT
export (String) var UNFAMILIAR_NAME
export (String) var FAMILIAR_NAME

var introduction = 'Why, hello, friend! Are you lost, perchance? Forsooth! Prithee, tell me thy name!!!!! lolz!!!!'
var dialogue = []

var mdl
var heh

var familiar = false

func _ready():
	mdl = $"MeshInstance"
	dialogue.append('What a splendid name!!! Indeeeeeeed!!!!! Verily!!!!!!!!!!!! My name is ' + FAMILIAR_NAME + '!!!! FORSOOOOOOOOOOOTH!!!!')
	dialogue.append('LOLZ!!!!!')
	
	heh = 0

func _process(delta):
	heh += delta
	mdl.translation.y = 2.5 + sin(heh)
	mdl.rotation.y = heh

func BodyEnter(body):
	if body.name == "Player":
		body.SetDialogueTarget(self)

func BodyExit(body):
	if body.name == "Player":
		body.SetDialogueTarget(null)

func GetHeadshot():
	return HEADSHOT

func GetDialogue(index):
	if index == -1:
		if familiar:
			return dialogue[1]
		return introduction
	if index == 1:
		familiar = true
		return dialogue[0]
	return dialogue[1]

func GetReplies(index):
	if index == -1:
		return ['Omigosh yes!!! My name is Donald Trump!!!!', 'no']
	else:
		return ['goodbyez']

func GetActorName():
	return FAMILIAR_NAME if familiar else UNFAMILIAR_NAME