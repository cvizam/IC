;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Christian Vigil Zamora
; APARTADO A)

; Ejemplo de prueba

(deffacts Hechos
        (XXX 1 3 4)
        (XXX 3 2)
        (EEE 1 1)
)

; Regla encargada de realizar el recuento de hechos.
; Comprueba que no existe un hecho NumeroHechos ya, para asegurarse de que no hay varios.
; Borra el hecho ContarHechos para que pueda ser ejecutada la regla de nuevo.
; El conteo de hechos se realiza gracias a la función find-all-facts, la cual obtiene los hechos 
; que son de la forma que se le pase como parámetro. Luego mediante la función length$ se obtiene 
; el número de hechos que satisfacen lo anterior comentado.

(defrule cuentaBajoDemanda
        ?Borrar <- (ContarHechos ?x)
        (not (exists (NumeroHechos ?x ?f)))
        =>
        (assert (NumeroHechos ?x (length$ (find-all-facts ((?f ?x)) TRUE))))
        (retract ?Borrar)
)

; Regla encargada de borrar el hecho NumeroHechos antes de que se genere otro. Para ello, cuando
; se recibe el hecho ContarHechos, que indica que se va a generar un nuevo hecho NumeroHechos, 
; si existe uno hecho ya NumeroHechos, lo borra.

(defrule borraNumeroHechos
        (ContarHechos ?x)
        ?Borrar <- (NumeroHechos ?x ?)
        =>
        (retract ?Borrar)
)
