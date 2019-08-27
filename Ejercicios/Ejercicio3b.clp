;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Christian Vigil Zamora
; APARTADO B)

; Regla encarga de abrir un fichero para su lectura. Se le da la máxima prioridad. 
; La función open abre el archivo indicado y añade un hecho para indicar que se puede
; seguir leyendo.

(defrule openfile
        (declare (salience 30))
        =>
        (open "DatosT.txt" DatosT)
        (assert (SeguirLeyendo))
)

; Regla encargada leer los valores de un fichero y añadirlos en forma de hechos.
; Comprueba que existe un hecho de SeguirLeyendo, y mediante la función readline,
; la cual se encarga de leer línea por línea un archivo, se almacena en una 
; variable la línea leida. Se borra el hecho el hecho de SeguirLeyendo y se comprueba
; que la línea que se ha leído es distinta del final del archivo. Mientras no se lea
; el final del archivo, se añaden como hechos las líneas leídas y se añade un hecho
; SeguirLeyendo para contínua leyendo el archivo. La función sym-cat es usada para 
; eliminar las comillas que se generan al leer una línea del archivo.

(defrule LeerValores
        (declare (salience 20))
        ?f <- (SeguirLeyendo)
        =>
        (bind ?Leido (readline DatosT))
        (retract ?f)
        (if (neq ?Leido EOF) 
                then
                (assert (T (sym-cat ?Leido)))
                (assert (SeguirLeyendo))
        )
)

; Regla encargada de cerrar el fichero abierto posteriormente. Se realiza mediante 
; la función close y es la regla con menos prioridad.

(defrule closeFile
        (declare (salience 10))
        =>
        (close DatosT)
)

