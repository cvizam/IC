;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Christian Vigil Zamora
; APARTADO B)

; Ejemplo de prueba

(deffacts Hechos
        (T 2 1 4 6 1)
        (T 3 2 0)
)

; Regla encargada de calcular el mínimo valor en un vector ordenado.
; Comprueba que existe un dato con estructura de vector ordenado T.
; Almacena como valor mínimo temporal el primer elemento de T, gracias a la función 
; nth$, ya comentada anteriormente. Calcula el número de elementos que tiene T. 
; Realiza un bucle for desde 1 hasta el número de elementos que tiene T, y
; gracias a la función nth$ va obteniendo el valor de la posicion "i" y lo compara
; con el mínimo almacenado, sí es mejor, reemplaza el mínimo. Por último, muestra
; por pantalla el resultado.

(defrule minXiT
        (T $?v)
        =>
        (bind ?min (nth$ 1 ?v))
        (bind ?len (length$ ?v))
        (loop-for-count (?i 1 ?len) do
                (if(< (nth$ ?i ?v) ?min)
                        then
                        (bind ?min (nth$ ?i ?v)))
        )
        (printout t "Valor minimo de Xi en (T "?v"): " ?min crlf)
)