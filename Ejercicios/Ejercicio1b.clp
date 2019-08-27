;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Christian Vigil Zamora
; APARTADO B)

; Para éste apartado, se considera que los hechos por defecto son de la forma "XXX".

; Regla encargada de realizar el recuento de hechos.
; Comprueba que no existe un hecho NumeroHechos ya para asegurarse de que no hay varios.
; Borra el hecho ContarHechos para que pueda ser ejecutada la regla de nuevo.
; El conteo de hechos se realiza gracias a la función find-all-facts, la cual obtiene los hechos 
; que son la de formaque se le pase como parámetro. Luego mediante la función length$ se obtiene 
; el número de hechos que satisfacen lo anterior comentado. Ésta función es la misma que la 
; implementada en el apartado anterior.

(defrule cuentaMedianteContador
        ?Borrar <- (ContarHechos ?x)
        (not (exists (NumeroHechos ?x ?f)))
        =>
        (assert (NumeroHechos ?x (length$ (find-all-facts ((?f ?x)) TRUE))))
        (retract ?Borrar)
)

; Regla encargada de borrar el hecho NumeroHechos antes de que se genere otro. Para ello, cuando
; se recibe el hecho ContarHechos, que indica que se va a generar un nuevo hecho NumeroHechos, 
; si existe uno hecho ya NumeroHechos, lo borra. Función reutilizada del apartado anterior.

(defrule borraNumeroHechos
        (ContarHechos ?x)
        ?Borrar <- (NumeroHechos ?x ?)
        =>
        (retract ?Borrar)
)

; Regla encargada de añadir que el número de hechos es 0, en caso de no haberlos.

(defrule hechoInicial
        (not (exists (XXX $?x)))
        =>
        (assert (NumeroHechos XXX 0))
)

; Regla encargada en caso de existir algún hecho, de añadir el hecho ContarHechos para que se active
; la función "cuentaMedianteContador".

(defrule gestionaHechos
        (XXX $?x)
        =>
        (assert (ContarHechos XXX))
)

; Puesto que borrar un hecho directamente desde la ventana de diálogo no satisfacía las condiciones de 
; éste apartado, se crea ésta regla para borrar hechos. Por lo tanto, cuando existe un hecho "BorrarHecho"
; se borra tanto ese hecho, como el hecho "XXX" indicado a eliminar. Seguidamente, se añade un hecho 
; "ContarHechos XXX" para que se actualice el número de hechos.
; El hecho "BorrarHecho" debe indicar el hecho tal cual se desea eliminar.
; Pe: (XXX 1 2 3) -> BorrarHecho(XXX 1 2 3)

(defrule borraHecho 
        ?Borrar <- (BorrarHecho XXX $?x)
        ?Hecho <- (XXX $?x)
        =>
        (retract ?Borrar)
        (retract ?Hecho)
        (assert (ContarHechos XXX))
)