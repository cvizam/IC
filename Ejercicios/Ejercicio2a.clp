;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Christian Vigil Zamora
; APARTADO A)

; Definición del template T con un multislot S de tipo númerico.
(deftemplate T
        (multislot S 
          (type NUMBER))
)

; Ejemplo de prueba

(deffacts Hechos
        (T (S 1 0 7 9))
        (T (S 3 4 5 1 8))
)

; Regla encargada de calcular el mínimo valor de S en una instancia T.
; Primeramente comprueba que existe una instancia T. 
; Almacena como valor mínimo temporal el primer valor de S gracias a la 
; función nth$, la cuál devuelve el elemento de una lista situado en la posición
; que se le indique.
; Calcula el número de elementos que tiene S.
; Realiza un bucle for desde 1 hasta el número de elementos que tiene S, y
; gracias a la función nth$ va obteniendo el valor de la posicion "i" y lo compara
; con el mínimo almacenado, sí es mejor, reemplaza el mínimo. Por último, muestra
; por pantalla el resultado. 

(defrule minSdeT
        (T (S $?v))
        =>
        (bind ?min (nth$ 1 ?v))
        (bind ?len (length$ ?v))
        (loop-for-count (?i 1 ?len) do
                (if (< (nth$ ?i ?v) ?min)
                        then
                        (bind ?min (nth$ ?i ?v))
                )
        )
        (printout t "Valor minimo S de la instancia (T "?v": " ?min crlf)
)


