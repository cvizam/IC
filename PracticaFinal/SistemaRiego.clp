;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; HECHOS INICIALES

; Definición de los tiestos
(deffacts Tiestos 
        (Tiesto T1) 
        (Tiesto T2) 
        (Tiesto T3) 
)

; Definición rango humedad ideal
(deffacts RangoHumedad
        (Rango T1 600 800)
        (Rango T2 500 700)
        (Rango T3 200 400)
)

; Definición de momentos del dia
(deffacts MomentoDia
        (Momento Maniana 21600 46800)
        (Momento Tarde 46801 75600)
        (Momento Noche 75601 21599)
)

; Definición de temperatura máxima
(deffacts MaximaTemperatura
        (Temperatura T1 34)
        (Temperatura T2 32)
        (Temperatura T3 28)
)

; Definición de luminosidad máxima
(deffacts MaximaLuminosidad
        (Luminosidad T1 500)
        (Luminosidad T2 400)
        (Luminosidad T3 250)
)

; Definición de rango intensidad lluvia
(deffacts IntensidadLluvia
        (Intensidad Ligera 0 6.5)
        (Intensidad Moderada 6.5 15)
        (Intensidad Fuerte 15 10000)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; REGLAS ASOCIDADAS AL TRATAMIENTO DE VALORES DE SENSORES

; Regla encargada de transformar los valores que recibe de los sensores en valores registrados. 
; También borra los valores de los sensores.

(defrule RegistrarValor
        (valor ?tipo ?tiesto ?h)
        ?Borrar <- (valor ?tipo ?tiesto ?h)
        (HoraActualizada ?actual)
        =>
        (assert (valor_registrado ?actual ?tipo ?tiesto ?h))
        (retract ?Borrar)
)

; Regla que almacena el último registro de un sensor. En la regla posterior, se garantiza que sea 
; el último el que se almacena.

(defrule UltimoRegistro
        (valor_registrado ?t ?tipo ?tiesto ?h)
        =>
        (assert (ultimo_registro ?tipo ?tiesto ?t))
)

; En ésta regla, si existen 2 últimos registros del mismo tipo y sobre el mismo tiesto, se comparan
; sus tiempos registrados, y se almacena como último registro el que tenga el tiempo mayor, o sea el 
; más reciente. El otro se borra.

(defrule BorraUltimo
        (ultimo_registro ?tipo ?tiesto ?h)
        (ultimo_registro ?tipo ?tiesto ?h2)
        (test (> ?h2 ?h))
        ?Borrar <- (ultimo_registro ?tipo ?tiesto ?h)
        =>
        (retract ?Borrar)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MÓDULO ACTIVAR-RIEGO

; Regla para borrar las acciones de apagar riego y permitir que se puedan incluir de nuevo

(defrule borraApagar
        ?Borrar <- (accion riego ?tiesto apagar)
        =>
        (retract ?Borrar)
)

; Regla encargada de activar el riego de un tiesto por la mañana

(defrule ActivaRiegoManiana
        (and (ultimo_registro temperatura ?tiesto ?t)(valor_registrado ?t temperatura ?tiesto ?temp))
        (and (ultimo_registro luminosidad ?tiesto ?t2)(valor_registrado ?t2 luminosidad ?tiesto ?l))
        (and (ultimo_registro humedad ?tiesto ?t3)(valor_registrado ?t3 humedad ?tiesto ?h))
        (and (ultimo_registro estadoriego ?tiesto ?t4)(valor_registrado ?t4 estadoriego ?tiesto off))
        (and (ultimo_registro lluvia ?tiesto ?t5)(valor_registrado ?t5 lluvia ?tiesto ?ll))
        (and (Intensidad ?nombre ?i1 ?i2)(and (test (>= ?ll ?i1))(test (< ?ll ?i2))))
        (Temperatura ?tiesto ?tem)
        (Luminosidad ?tiesto ?lux)
        (Rango ?tiesto ?r1 ?r2)
        (or (and (and (test (< ?temp ?tem))(test (< ?l ?lux)))(test (>= ?h ?r2)))(test (>= ?h (+ ?r2 150)))(and (test (neq ?nombre Fuerte))(test (>= ?h ?r2))))
        (HoraActualizada ?actual)
        (Momento Maniana ?m1 ?m2)
        (and (test (>= ?actual ?m1))(test (<= ?actual ?m2)))
        =>
        (if (eq ?nombre Ligera)
                then
                (assert (momento_riego maniana))
        )
        (if (eq ?nombre Moderada)
                then
                (assert (momento_riego noche))
        )
        (if (and (eq ?nombre Fuerte)(>= ?h (+ ?r2 150)))
                then
                (assert (momento_riego tarde))
        )
        (assert (accion riego ?tiesto encender))
)

; Regla encargada de activar el riego de un tiesto por la tarde

(defrule ActivaRiegoTarde
        (and (ultimo_registro temperatura ?tiesto ?t)(valor_registrado ?t temperatura ?tiesto ?temp))
        (and (ultimo_registro luminosidad ?tiesto ?t2)(valor_registrado ?t2 luminosidad ?tiesto ?l))
        (and (ultimo_registro humedad ?tiesto ?t3)(valor_registrado ?t3 humedad ?tiesto ?h))
        (and (ultimo_registro estadoriego ?tiesto ?t4)(valor_registrado ?t4 estadoriego ?tiesto off))
        (and (ultimo_registro lluvia ?tiesto ?t5)(valor_registrado ?t5 lluvia ?tiesto ?ll))
        (and (Intensidad ?nombre ?i1 ?i2)(and (test (>= ?ll ?i1))(test (< ?ll ?i2))))
        (Temperatura ?tiesto ?tem)
        (Luminosidad ?tiesto ?lux)
        (Rango ?tiesto ?r1 ?r2)
        (or (and (and (test (< ?temp ?tem))(test (< ?l ?lux)))(test (>= ?h ?r2)))(test (>= ?h (+ ?r2 150)))(and (test (neq ?nombre Fuerte))(test (>= ?h ?r2))))
        (HoraActualizada ?actual)
        (Momento Tarde ?m1 ?m2)
        (and (test (>= ?actual ?m1))(test (<= ?actual ?m2)))
        =>
        (if (eq ?nombre Ligera)
                then
                (assert (momento_riego maniana))
        )
        (if (eq ?nombre Moderada)
                then
                (assert (momento_riego noche))
        )
        (if (and (eq ?nombre Fuerte)(>= ?h (+ ?r2 150)))
                then
                (assert (momento_riego tarde))
        )
        (assert (accion riego ?tiesto encender))
)

; Regla encargada de activar el riego de un tiesto por la noche

(defrule ActivaRiegoNoche
        (and (ultimo_registro temperatura ?tiesto ?t)(valor_registrado ?t temperatura ?tiesto ?temp))
        (and (ultimo_registro luminosidad ?tiesto ?t2)(valor_registrado ?t2 luminosidad ?tiesto ?l))
        (and (ultimo_registro humedad ?tiesto ?t3)(valor_registrado ?t3 humedad ?tiesto ?h))
        (and (ultimo_registro estadoriego ?tiesto ?t4)(valor_registrado ?t4 estadoriego ?tiesto off))
        (and (ultimo_registro lluvia ?tiesto ?t5)(valor_registrado ?t5 lluvia ?tiesto ?ll))
        (and (Intensidad ?nombre ?i1 ?i2)(and (test (>= ?ll ?i1))(test (< ?ll ?i2))))
        (Temperatura ?tiesto ?tem)
        (Luminosidad ?tiesto ?lux)
        (Rango ?tiesto ?r1 ?r2)
        (or (and (and (test (< ?temp ?tem))(test (< ?l ?lux)))(test (>= ?h ?r2)))(test (>= ?h (+ ?r2 150)))(and (test (neq ?nombre Fuerte))(test (>= ?h ?r2))))
        (HoraActualizada ?actual)
        (Momento Noche ?m1 ?m2)
        (and (test (>= ?actual ?m1))(test (<= ?actual ?m2)))
        =>
        (if (eq ?nombre Ligera)
                then
                (assert (momento_riego maniana))
        )
        (if (eq ?nombre Moderada)
                then
                (assert (momento_riego noche))
        )
        (if (and (eq ?nombre Fuerte)(>= ?h (+ ?r2 150)))
                then
                (assert (momento_riego tarde))
        )
        (assert (accion riego ?tiesto encender))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MÓDULO DESACTIVAR RIEGO

; Regla para insertar el hecho que activa éste módulo

(defrule moduloDesactivar
        (momento_riego ?x)
        =>
        (assert (modulo desactivar-riego))
)

; Regla para borrar las acciones de encender riego y permitir que se puedan incluir de nuevo

(defrule borraEncender
        ?Borrar <- (accion riego ?tiesto encender)
        =>
        (retract ?Borrar)
)

; Regla encargada de desactivar el riego por la mañana. En ella se verifica la intensidad del riego.

(defrule DesactivaRiegoManiana
        ?f <- (modulo desactivar-riego)
        ?Borrar <- (momento_riego maniana)
        (and (ultimo_registro humedad ?tiesto ?t)(valor_registrado ?t humedad ?tiesto ?h))
        (and (ultimo_registro estadoriego ?tiesto ?t2)(valor_registrado ?t2 estadoriego ?tiesto on))
        (Rango ?tiesto ?r1 ?r2)
        (and (test (>= ?h ?r1))(test (<= ?h (+ ?r1 50))))
        =>
        (assert (accion riego ?tiesto apagar))
        (retract ?f ?Borrar)
)

; Regla encargada de desactivar el riego por la tarde. En ella se verifica la intensidad del riego.

(defrule DesactivaRiegoTarde
        ?f <- (modulo desactivar-riego)
        ?Borrar <- (momento_riego tarde)
        (and (ultimo_registro humedad ?tiesto ?t)(valor_registrado ?t humedad ?tiesto ?h))
        (and (ultimo_registro estadoriego ?tiesto ?t2)(valor_registrado ?t2 estadoriego ?tiesto on))
        (Rango ?tiesto ?r1 ?r2)
        (and (test (<= ?h ?r2))(test (>= ?h (- ?r2 50))))
        =>
        (assert (accion riego ?tiesto apagar))
        (retract ?f ?Borrar)
)

; Regla encargada de desactivar el riego por la noche. En ella se verifica la intensidad del riego.

(defrule DesactivaRiegoNoche
        ?f <- (modulo desactivar-riego)
        ?Borrar <- (momento_riego noche)
        (and (ultimo_registro humedad ?tiesto ?t)(valor_registrado ?t humedad ?tiesto ?h))
        (and (ultimo_registro estadoriego ?tiesto ?t2)(valor_registrado ?t2 estadoriego ?tiesto on))
        (Rango ?tiesto ?r1 ?r2)
        (and (test (<= ?h ?r2))(test (>= ?h (- ?r2 100))))
        =>
        (assert (accion riego ?tiesto apagar))
        (retract ?f ?Borrar)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MÓDULO ACTIVAR/DESACTIVAR VAPORIZADORES

; Regla para insertar el hecho que activa éste módulo

(defrule moduloVaporizadores
        (and (ultimo_registro temperatura ?tiesto ?t)(valor_registrado ?t temperatura ?tiesto ?temp))
        (Temperatura ?tiesto ?tem)
        (and (test (>= ?temp ?tem))(test (< ?temp (+ ?tem 12))))
        =>
        (assert (modulo vaporizador))
)
; Regla encargada de activar los vaporizadores en caso de temperatura alta

(defrule ActivaVaporizadores
        (modulo vaporizador)
        (and (ultimo_registro temperatura ?tiesto ?t)(valor_registrado ?t temperatura ?tiesto ?temp))
        (Temperatura ?tiesto ?tem)
        (test (>= ?temp ?tem))
        =>
        (assert (accion vaporizar ?tiesto encender))
)

; Regla encargada de desactivar los vaporizadores 

(defrule DesactivaVaporizadores
        ?Borrar <- (modulo vaporizador)
        (and (ultimo_registro estadovaporizador ?tiesto ?t)(valor_registrado ?t estadovaporizador ?tiesto on))
        (and (ultimo_registro temperatura ?tiesto ?t2)(valor_registrado ?t2 temperatura ?tiesto ?temp))
        (Temperatura ?tiesto ?tem)
        (test (< ?temp ?tem))
        =>
        (assert (accion vaporizar ?tiesto apagar))
        (retract ?Borrar)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MÓDULO ACTIVAR/DESACTIVAR CASO ESTRICTO

; Regla para insertar el hecho que activa éste módulo

(defrule moduloCasoEstricto
        (and (ultimo_registro temperatura ?tiesto ?t)(valor_registrado ?t temperatura ?tiesto ?temp))
        (Temperatura ?tiesto ?tem)
        (test (>= ?temp (+ ?tem 12)))
        =>
        (assert (modulo caso-estricto))
)

; Regla para activar tanto vaporizadores como riego, en caso necesidad estricto

(defrule ActivaCasoEstricto
        (modulo caso-estricto)
        (and (ultimo_registro temperatura ?tiesto ?t)(valor_registrado ?t temperatura ?tiesto ?temp))
        (Temperatura ?tiesto ?tem)
        (test (>= ?temp (+ ?tem 12)))
        =>
        (assert (accion vaporizar ?tiesto encender))
        (assert (accion riego ?tiesto encender))
)

; Regla para desactivar tanto vaporizadores como riego, en caso estricto

(defrule DesactivaCasoEstricto
        ?Borrar <- (modulo caso-estricto)
        (and (ultimo_registro estadovaporizador ?tiesto ?t)(valor_registrado ?t estadovaporizador ?tiesto on))
        (and (ultimo_registro estadoriego ?tiesto ?t2)(valor_registrado ?t2 estadoriego ?tiesto on))
        (and (ultimo_registro temperatura ?tiesto ?t3)(valor_registrado ?t3 temperatura ?tiesto ?temp))
        (and (ultimo_registro humedad ?tiesto ?t4)(valor_registrado ?t4 humedad ?tiesto ?h))
        (Temperatura ?tiesto ?tem)
        (Rango ?tiesto ?r1 ?r2)
        (and (test (< ?temp ?tem))(test (< ?h ?r2)))
        =>
        (assert (accion vaporizar ?tiesto apagar))
        (assert (accion riego ?tiesto apagar))
        (retract ?Borrar)
)