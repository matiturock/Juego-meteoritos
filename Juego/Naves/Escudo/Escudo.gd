#Escudo.gd
class_name Escudo
extends Area2D

##Variables export
export var energia: float = 8.0
export var radio_desgaste:float = -1.6

##Variables
var esta_activado: bool = false setget ,get_esta_activado

## Metodos
func _ready() -> void:
	set_process(false)
	controlar_colisionador(true)

func _process(delta: float) -> void:
	energia +=radio_desgaste * delta
	if energia <= 0.0:
		desactivar()

#Metodos Customs
func controlar_colisionador(esta_desactivado: bool) -> void:
	$CollisionShape2D.set_deferred("disabled", esta_desactivado)

func activar() -> void:
	if energia <= 0.0 :
		return
	
	esta_activado = true
	controlar_colisionador(false)
	$AnimationPlayer.play("Abriendo")

func desactivar() -> void:
	set_process(false)
	esta_activado = false
	controlar_colisionador(true)
	$AnimationPlayer.play_backwards("Abriendo")

##Seters and Getters
func get_esta_activado() -> bool:
	return esta_activado

#Senales internas
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "Abriendo" and esta_activado:
		$AnimationPlayer.play("Activado")
		set_process(true)


func _on_body_entered(body: Node) -> void:
	queue_free()
