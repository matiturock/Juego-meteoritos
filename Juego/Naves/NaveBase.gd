#NaveBase.gd 
class_name NaveBase
extends RigidBody2D

#Enums
enum ESTADO {SPAWN,VIVO, INVENCIBLE, MUERTO}

## Atributos Export
export var hitpoints: float = 15.0
export var cantidad_explosiones: int = 1

## Atributos

var estado_actual:int = ESTADO.SPAWN

## Atributos onready
onready var canion:Canion = $Canion
onready var colisionador:CollisionShape2D = $CollisionShape2D
onready var impactosfx : AudioStreamPlayer = $ImpactoSFX


## Metodos
func _ready() -> void:
	controlador_estados(estado_actual)

## Metodos Customs 
func controlador_estados(nuevo_estado: int) -> void:
	match nuevo_estado:
		ESTADO.SPAWN:
			colisionador.set_deferred("disabled", true)
			canion.set_puede_disparar(false)
		ESTADO.VIVO:
			colisionador.set_deferred("disabled", false)
			canion.set_puede_disparar(true)
		ESTADO.INVENCIBLE:
			colisionador.set_deferred("disable", true)
		ESTADO.MUERTO:
			colisionador.set_deferred("disable", true)
			canion.set_puede_disparar(false)
			Eventos.emit_signal("nave_destruida",self ,global_position, cantidad_explosiones)
			queue_free()
		_:
			printerr("Error de estado")
	estado_actual = nuevo_estado

func destruir() -> void:
	controlador_estados(ESTADO.MUERTO)

func recibir_danio(danio: float) -> void:
	hitpoints -= danio
	if hitpoints <= 0.0:
		destruir()
	impactosfx.play()	

##Senales Internas
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "Spawn":
		controlador_estados(ESTADO.VIVO)

func _on_body_entered(body: Node) -> void:
	if body is Meteorito:
		body.destruir()
		destruir()



