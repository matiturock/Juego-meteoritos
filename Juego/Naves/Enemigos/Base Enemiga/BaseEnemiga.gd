#BaseEnemiga.gd
class_name BaseEnemiga
extends Node2D

##Atributos Export
export var hitpoints:float = 30.0

##Atributos Onready
onready var impacto_sfx: AudioStreamPlayer2D = $ImpactoSFX

##Atributos
var esta_destruida:bool = false

##Metodos
func _ready() -> void:
	$AnimationPlayer.play(elegir_animacion_aleatoria())

##Metodos Customs
func elegir_animacion_aleatoria() -> String:
	randomize()
	var num_anim: int = $AnimationPlayer.get_animation_list().size() -1
	var indice_anim_aleatoria:int = randi() % num_anim +1
	var lista_animacion:Array = $AnimationPlayer.get_animation_list()
	
	return lista_animacion[indice_anim_aleatoria]

func recibir_danio(danio: float) -> void:
	hitpoints -= danio
	
	if hitpoints <= 0 and not esta_destruida:
		esta_destruida = true
		destruir()
	
	impacto_sfx.play()

<<<<<<< HEAD
=======
func spawnear_orbital() -> void:
	numero_orbitales -= 1
	$RutaEnemigo.global_position = global_position
	
	var new_orbital: EnemigoOrbital = orbital.instance()
	new_orbital.crear(
		global_position + posicion_spawn,
		self,
		$RutaEnemigo
	)
	Eventos.emit_signal("spawn_orbital", new_orbital)

func deteccion_cuadrante() -> Vector2:
	var player_objetivo:Player = DatosJuego.get_player_actual()
	
	if not player_objetivo:
		return Vector2.ZERO
	
	var dir_player: Vector2 = player_objetivo.global_position - global_position
	var angulo_player: float = rad2deg(dir_player.angle())
	
	if abs(angulo_player) <= 45.0:
		#Player entra por la derecha
		$RutaEnemigo.rotation_degrees = 180.0
		return $PosicionesSpawn/Este.position
	elif abs(angulo_player) > 135.0 and abs(angulo_player) <= 180.0:
		#Player entra por la izquierda
		$RutaEnemigo.rotation_degrees = 0.0
		return $PosicionesSpawn/Oeste.position
	elif abs(angulo_player) > 45.0 and abs(angulo_player) <=135.0:
		#Player entra por arriba o por abajo
		if sign(angulo_player) > 0:
			#Player entra por abajo
			$RutaEnemigo.rotation_degrees = 270.0
			return $PosicionesSpawn/Sur.position
		else:
			#Player entra por arriba
			$RutaEnemigo.rotation_degrees = 90
			return $PosicionesSpawn/Norte.position
		
	return $PosicionesSpawn/Norte.position

>>>>>>> parent of 73f96bb (fin semana 4)
func destruir() -> void:
	var posicion_partes = [
		$Sprites/Spritebase1.global_position,
		$Sprites/Spritebase2.global_position,
		$Sprites/Spritebase3.global_position,
		$Sprites/Spritebase4.global_position,
		$Sprites/Spritebase5.global_position
	]
	
	Eventos.emit_signal("base_destruida", posicion_partes)
	queue_free()

##Senales Internas
func _on_AreaColision_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir()
