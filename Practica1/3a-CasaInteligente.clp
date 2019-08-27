;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;                                    0. DEFINICIÓN DE HECHOS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Definicion de habitaciones

(deffacts Habitaciones
        (Habitacion Dormitorio1)
        (Habitacion Dormitorio2)
        (Habitacion Dormitorio3)
        (Habitacion Servicio)
        (Habitacion Cocina)
        (Habitacion Salon)
        (Habitacion Terraza)
        (Habitacion Pasillo)
)

; Definicion de puertas

(deffacts Puertas
        (Puerta P0)
        (Puerta P1)
        (Puerta P2)
        (Puerta P3)
        (Puerta P4)
        (Puerta P5)
)

; Definicion de pasos

(deffacts Pasos
        (Paso PS1)
        (Paso PS2)
        (Paso PS3)
)

; Definicion de ventanas

(deffacts Ventanas
        (Ventana V1)
        (Ventana V2)
        (Ventana V3)
        (Ventana V4)
        (Ventana V5)
        (Ventana V6)
)

; Definicion de Sensores de movimiento

(deffacts SensoresMovimiento
        (SenMov M1)
        (SenMov M2)
        (SenMov M3)
        (SenMov M4)
        (SenMov M5)
        (SenMov M6)
        (SenMov M7)
        (SenMov M8)
)

; Definicion de Pulsadores de luz

(deffacts PulsadoresLuz
        (Pulsador PL1)
        (Pulsador PL2)
        (Pulsador PL3)
        (Pulsador PL4)
        (Pulsador PL5)
        (Pulsador PL6)
        (Pulsador PL7)
        (Pulsador PL8)
)

; Definicion de puertas en cada habitacion

(deffacts PuertaHabitacion
        (PuertaHab Dormitorio1 P1)
        (PuertaHab Dormitorio2 P2)
        (PuertaHab Dormitorio3 P3)
        (PuertaHab Servicio P4)
        (PuertaHab Salon P0)
        (PuertaHab Salon P5)
        (PuertaHab Terraza P5)
        (PuertaHab Pasillo P1)
        (PuertaHab Pasillo P2)
        (PuertaHab Pasillo P3)
        (PuertaHab Pasillo P4)
)

; Definicion de Pasos en cada habitacion

(deffacts PasoHabitacion
        (PasoHab Cocina PS1)
        (PasoHab Cocina PS2)
        (PasoHab Salon PS1)
        (PasoHab Salon PS3)
        (PasoHab Pasillo PS2)
        (PasoHab Pasillo PS3)
)

; Definicion de ventanas en cada habitacion

(deffacts VentanaHabitacion
        (VentHab Dormitorio2 V1)
        (VentHab Dormitorio3 V2)
        (VentHab Servicio V3)
        (VentHab Cocina V4)
        (VentHab Salon V5)
        (VentHab Salon V6)
        (VentHab Terraza V6)
)

; Definicion de Sensores de movimiento en cada habitacion

(deffacts MovimientoHabitacion
        (MovHab Dormitorio1 M1)
        (MovHab Dormitorio2 M2)
        (MovHab Dormitorio3 M3)
        (MovHab Servicio M4)
        (MovHab Cocina M5)
        (MovHab Salon M6)
        (MovHab Terraza M7)
        (MovHab Pasillo M8)
)

; Definicion de Pulsadores de luz en cada habitacion

(deffacts PulsadoresHabitacion
        (PulHab Dormitorio1)
        (PulHab Dormitorio2 PL2)
        (PulHab Dormitorio3 PL3)
        (PulHab Servicio PL4)
        (PulHab Cocina PL5)
        (PulHab Salon PL6)
        (PulHab Terraza PL7)
        (PulHab Pasillo PL8)
)

; Definición de valores mínimos de luminosidad 

(deffacts valoresMinimos
        (valorMin Salon 350)
        (valorMin Dormitorio1 400)
        (valorMin Dormitorio2 400)
        (valorMin Dormitorio3 400)
        (valorMin Cocina 300)
        (valorMin Servicio 125)
        (valorMin Pasillo 100)
        (valorMin Terraza 100)
)

; Definición de valores máximos de luminosidad

(deffacts valoresMaximos
        (valorMax Salon 450)
        (valorMax Dormitorio1 500)
        (valorMax Dormitorio2 500)
        (valorMax Dormitorio3 500)
        (valorMax Cocina 400)
        (valorMax Servicio 250)
        (valorMax Pasillo 300)
        (valorMax Terraza 300)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;                                    1. REPRESENTACIÓN DE LA CASA

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Regla encargada de deducir de que habitaciones es posible pasar a otras. 
; Para ello, comprueba que 2 habitaciones compartan puerta o paso.

(defrule PosiblePasar
        (Habitacion ?Nombre)
        (Habitacion ?Nombre2)
        (test (neq ?Nombre ?Nombre2))
        (or (PuertaHab ?Nombre ?P)(PasoHab ?Nombre ?P))
        (or (PuertaHab ?Nombre2 ?P)(PasoHab ?Nombre2 ?P))
        =>
        (assert (posible_pasar ?Nombre ?Nombre2))
)

; Regla encargada de deducir a través de que habitaciones es necesario pasar
; para ir a otras. Para ello, se comprueba que 2 habitaciones compartan puerta o piso
; y que una de ellas no tenga más puertas, osea que la puerta que tiene sea su única 
; forma de acceso. 

(defrule NecesarioPasar
        (Habitacion ?Nombre)
        (Habitacion ?Nombre2)
        (test (neq ?Nombre ?Nombre2))
        (or (PuertaHab ?Nombre ?P)(PasoHab ?Nombre ?P))
        (or (PuertaHab ?Nombre2 ?P)(PasoHab ?Nombre2 ?P))
        (or (not (exists (PuertaHab ?Nombre ~?P))))(not (exists (PasoHab ?Nombre ~?P)))
        =>
        (assert (necesario_pasar ?Nombre2 ?Nombre))
)

; Regla encargada de deducir que habitaciones son interiores, es decir, no tienen
; ventana. Para ello, se comprueba si existe alguna habitación la cual no tenga
; una ventana definida.

(defrule HabitacionInterior
        (Habitacion ?Nombre)
        (not (exists (VentHab ?Nombre ?)))
        =>
        (assert (habitacion_interior ?Nombre))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;                                    2. REGISTRO DE LOS DATOS DE LOS SENSORES

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Regla encargada de transformar los valores que recibe de los sensores en valores registrados. 
; También borra los valores de los sensores.

(defrule RegistrarValor
        (valor ?tipo ?habitacion ?v)
        ?Borrar <- (valor ?tipo ?habitacion ?v)
        (HoraActualizada ?actual)
        =>
        (assert (valor_registrado ?actual ?tipo ?habitacion ?v))
        (retract ?Borrar)
)

; Regla que almacena el último registro de un sensor. En la regla posterior, se garantiza que sea 
; el último el que se almacena.

(defrule UltimoRegistro
        (valor_registrado ?t ?tipo ?habitacion ?v)
        =>
        (assert (ultimo_registro ?tipo ?habitacion ?t))
)

; En ésta regla, si existen 2 últimos registros del mismo tipo y en la misma habitación, se comparan
; sus tiempos registrados, y se almacena como último registro el que tenga el tiempo mayor, o sea el 
; más reciente. El otro se borra.

(defrule BorraUltimo
        (ultimo_registro ?tipo ?habitacion ?t)
        (ultimo_registro ?tipo ?habitacion ?t2)
        (test (> ?t2 ?t))
        ?Borrar <- (ultimo_registro ?tipo ?habitacion ?t)
        =>
        (retract ?Borrar)
)

; Regla la cuál almacena la última activación del sensor de movimiento en una habitación.
; Comprueba que haya existido previamente en la misma habitación un valor registrado de movimiento OFF,
; y que el último registro de movimiento en esa habitación haya sido ON.

(defrule UltimaActivacion
        (ultimo_registro movimiento ?habitacion ?t)
        (valor_registrado ?t movimiento ?habitacion on)
        (valor_registrado ?t2 movimiento ?habitacion off)
        =>
        (assert (ultima_activacion movimiento ?habitacion ?t))
)

; En ésta regla, si existen 2 últimas activaciones en la misma habitación, se comparan
; sus tiempos registrados, y se almacena como última activación la que tenga el tiempo mayor, o sea el 
; más reciente. La otra se borra.

(defrule BorraUltimaActivacion
        (ultima_activacion movimiento ?habitacion ?t)
        (ultimo_activacion movimiento ?habitacion ?t2)
        (test (> ?t2 ?t))
        ?Borrar <- (ultimo_activacion movimiento ?habitacion ?t)
        =>
        (retract ?Borrar)
)

; Regla la cuál almacena la última desactivación del sensor de movimiento en una habitación.
; Comprueba que haya existido previamente en la misma habitación un valor registrado de movimiento ON,
; y que el último registro de movimiento en esa habitación haya sido OFF.

(defrule UltimaDesactivacion
        (ultimo_registro movimiento ?habitacion ?t)
        (valor_registrado ?t movimiento ?habitacion off)
        (valor_registrado ?t2 movimiento ?habitacion on)
        =>
        (assert (ultima_desactivacion movimiento ?habitacion ?t))
)

; En ésta regla, si existen 2 últimas desactivaciones en la misma habitación, se comparan
; sus tiempos registrados, y se almacena como última desactivación la que tenga el tiempo mayor, o sea el 
; más reciente. La otra se borra.

(defrule BorraUltimaDesactivacion
        (ultima_desactivacion movimiento ?habitacion ?t)
        (ultimo_desactivacion movimiento ?habitacion ?t2)
        (test (> ?t2 ?t))
        ?Borrar <- (ultimo_desactivacion movimiento ?habitacion ?t)
        =>
        (retract ?Borrar)
)

; Regla en la cúal se generan unos hechos auxiliares, que son los valores registrados en una habitación
; que van a ser impresos por pantalla. Para ello se van generando tantos hechos como valores registrados
; haya en la habitación del informe siempre y cuando no hayan sido añadidos ya.

(defrule ValoresInforme
        (informe ?h)
        (valor_registrado ?t ?tipo ?h ?v)
        (not (max_informe ?t ?tipo ?h ?v))
        =>
        (assert (max_informe ?t ?tipo ?h ?v))
)

; Ésta regla se encarga de comprobar cuando se dejan de añadir hechos de valores registrados.
; Por ello, en el momento en el que no exista un sólo valor registrado en la habitación del informe
; que no haya sido añadido como hecho auxiliar aún, es decir que ya se hayan añadido todos los hechos
; necesarios, se borra el hecho de informe, para que pueda ser referenciado en un futuro de nuevo.

(defrule BorraHechoInforme
        ?Borrar <- (informe ?h)
        (not (and (valor_registrado ?t ?tipo ?h ?v)(not (max_informe ?t ?tipo ?h ?v))))
        =>
        (retract ?Borrar)
)

; Una vez que tenemos todos los hechos auxiliares que van a ser impresos por pantalla, se selecciona
; el máximo de ellos en cada iteración, se imprime y se borra. El máximo de ellos se obtiene comprobando
; que no existe otro hecho con un tiempo registrado mayor que el considerado.

(defrule PresentaInforme
    (not (informe ?h))
    ?Borrar <- (max_informe ?t ?tipo ?h ?v)
    (not (and (max_informe ?t2 ?tipo2 ?h2 ?v2)(test (> ?t2 ?t))))
    => 
    (retract ?Borrar)
    (printout t "- Instante: " ?t " - Tipo: " ?tipo " - Habitacion: " ?h " - Valor: " ?v crlf)

)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;                                    3. MANEJO INTELIGENTE DE LUCES

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Puesto que las habitaciones que son consideradas interiores no tienen ventana, considero que la luminosidad
; de dichas habitaciones siempre va a ser muy baja, por lo tanto, siempre que se detecte movimiento ON en una
; habitación interior y la luz esté apagada, se enciende. Para ello, se comprueba que el último registro de 
; movimiento de esa habitación haya sido ON y que la luz esté apagada. Si se dan ambos requisitos, se enciende
; la luz de la habitación.

(defrule EnciendeHabitacionInterior
        (Manejo_inteligente_luces ?h)
        (habitación_interior ?int)
        (test (eq ?h ?int))
        (ultimo_registro movimiento ?h ?t)
        (valor_registrado ?t movimiento ?h on)
        (ultimo_registro estadoluz ?h ?t2)
        (valor_registrado ?t2 estadoluz ?h off)
        =>
        (assert (accion pulsador_luz ?h encender))
)

; Con ésta regla se pretende encender una habitación cuando la luminosidad de ella sea inferior a un mínimo.
; Para ello, se comprueba que el último registro de movimiento de esa habitación haya sido ON y que la luz
; esté apagada. Por último, se obtiene la luminosidad de la habitación, y se comprueba: si la luminosidad
; es menor o igual que un mínimo establecido, se enciende la luz, sino, se deja apagada, lo que significa que con 
; la luminosidad actual de la habitación es suficiente.

(defrule EnciendeHabitacion
        (Manejo_inteligente_luces ?h)
        (valorMin ?h ?min)
        (habitación_interior ?int)
        (test (neq ?h ?int))
        (ultimo_registro movimiento ?h ?t)
        (valor_registrado ?t movimiento ?h on)
        (ultimo_registro luminosidad ?h ?t2)
        (valor_registrado ?t2 luminosidad ?h ?lux)
        (ultimo_registro estadoluz ?h ?t3)
        (valor_registrado ?t3 estadoluz ?h off)
        (test (<= ?lux ?min))
        =>
        (assert (accion pulsador_luz ?h encender))
)

; Ésta regla también se encarga de gestionar el encendido de luces de las habitaciones. En éste caso, el factor
; a tener en cuenta es el momento del día en el que nos encontremos. Considero que a partir de las 20:30, sea la época
; del año que sea, es necesario encender la luz de una habitación, pues empieza a anochecer. En el caso de que sea
; Invierno, época en la que anoche antes de esa hora, se activaría la regla anterior definida, por valor bajo de 
; luminosidad. Aquí, se comprueba que en la habitación haya movimiento y que la luz esté apagada. Si se cumplen
; esas condiciones, se comprueba la hora actual; si es mayor o igual a las 20:30:00, se enciende la luz de la habitación,
; sino, no.

(defrule EnciendeHabitacionSegunMomento
        (Manejo_inteligente_luces ?h)
        (HoraActualizada ?actual)
        (ultimo_registro movimiento ?h ?t)
        (valor_registrado ?t movimiento ?h on)
        (ultimo_registro estadoluz ?h ?t3)
        (valor_registrado ?t3 estadoluz ?h off)
        =>
        (bind ?tiem (totalsegundos 20 30 0))
        (if(>= ?actual ?tiem)
                then
                (assert (accion pulsador_luz ?h encender))
        )
)

; En ésta regla, se gestiona el apagado de luces de las habitaciones. Si una habitación la cuál tiene la luz encendida y 
; había movimiento, registra movimiento OFF, se esperan 15 segundos antes de apagar la luz o no. He considerado 15 segundos
; pues muchas veces necesitamos salir de una habitación a otra para coger un objeto, o algo por el estilo, por lo tanto
; si salimos de una habitación y en menos de 15 segundos volvemos a ella, no se apaga la luz. Se comprueba que se haya 
; recibido un registro de movimiento OFF y que la luz esté encendida en esa habitación. Tras ésto, se esperan 15 segundos
; y se evalúa si entre el instante en el que se recibió el OFF y los 15 segundos de espera se ha recibido un último
; registro de movimiento ON en esa habitación. Si se ha recibido, se deja la luz encendida, sino se apaga. En ésta regla se 
; excluye el Servicio que tiene una regla específica, explicada posteriormente.

(defrule ApagaInactiva
        (Manejo_inteligente_luces ?h)
        (test (neq ?h Servicio))
        (HoraActualizada ?actual)
        (ultimo_registro movimiento ?h ?t)
        (valor_registrado ?t movimiento ?h off)
        (ultimo_registro estadoluz ?h ?t2)
        (valor_registrado ?t2 estadoluz ?h on)
        (test (eq ?actual (+ ?t 15)))
        (not (and(ultimo_registro movimiento ?h ?t3)(valor_registrado ?t3 movimiento ?h on)(test (> ?t3 ?t))(test(<= ?t3 (+ ?t 15)))))
        =>
        (assert (accion pulsador_luz ?h apagar))
)

; Ésta regla se encarga de apagar la luz de una habitación en caso de que la luminosidad sea superior a un límite.
; En éste caso, el límite es el doble del valor mínimo establecido para encender la luz. De nuevo, se comprueba
; que la luz en la habitación esté encendida y se obtiene el valor de luminosidad. Posteriormente, se evalúa el
; valor de luminosidad. Si es mayor o igual que el límite establecido, se apaga la luz, sino se deja encendida.

(defrule ApagaMaximaLuminosidad
        (Manejo_inteligente_luces ?h)
        (valorMax ?h ?max)
        (ultimo_registro estadoluz ?h ?t)
        (valor_registrado ?t estadoluz ?h on)
        (ultimo_registro luminosidad ?h ?t2)
        (valor_registrado ?t2 luminosidad ?h ?lux)
        (test (>= ?lux ?max))
        =>
        (assert (accion pulsador_luz ?h apagar))
)

; Ésta regla es exclusiva para el Servicio. Cuando una persona está en el Servicio, es posible que se detecte movimiento OFF
; aún siguiendo la persona dentro. Para evitar problemas relacionados con eso, ésta regla una vez que recibe un registro de 
; movimiento OFF en el Servicio, espera 1 minuto, en el que comprueba si sigue habiendo una persona ahí o de verdad ha salido.
; De ésta forma conseguimos que la luz no se apague estando la persona dentro al instante de recibir un registro de movimiento
; OFF, puesto que considero que 1 minuto es más que suficiente tiempo para comprobar si sigue la persona ahí o no. Las condiciones
; para ésta regla serían que se haya registrado un movimiento OFF en el Servicio y que la luz estuviera encendida. Tras eso, se espera
; 1 minuto y si durante el transcurso de ese minuto se ha vuelto a recibir un último registro de movimiento ON, se deja la luz encendida,
; sino, se da por hecho que la persona ha salido del Servicio, y se apaga.

(defrule MantieneServicio
        (Manejo_inteligente_luces Servicio)
        (HoraActualizada ?actual)
        (ultimo_registro movimiento Servicio ?t)
        (valor_registrado ?t movimiento Servicio off)
        (ultimo_registro estadoluz Servicio ?t2)
        (valor_registrado ?t2 estadoluz Servicio on)
        (test (eq ?actual (+ ?t 60)))
        (not (and(ultimo_registro movimiento Servicio ?t3)(valor_registrado ?t3 movimiento Servicio on)(test (> ?t3 ?t))(test(<= ?t3 (+ ?t 60)))))
        =>
        (assert (accion pulsador_luz Servicio apagar))
)

; Regla encargada de gestionar las acciones de los pulsadores de luz. Tras ser usadas, las borra del sistema para poder ser usadas de nuevo.

(defrule GestionaPulsadores
        ?Pulsador <- (accion pulsador_luz ?h ?state)
        =>
        (retract ?Pulsador)
)
