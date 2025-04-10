extends Node

@export var mob_scene: PackedScene
var score

func _ready():
	new_game()

# Inicia una nueva partida
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	$Music.play() # <<<<<< música

# Se ejecuta cuando el jugador pierde
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()        # <<<<<< detener música
	$DeathSound.play()   # <<<<<< sonido de muerte

# Aumenta el puntaje cada segundo
func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score) # Esto faltaba para mostrar el puntaje en pantalla

# Inicia los temporizadores de enemigos y puntaje
func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

# Crea e instancia un nuevo enemigo (mob)
func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	mob.position = mob_spawn_location.position

	var direction = mob_spawn_location.rotation + PI / 2
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	add_child(mob)
