;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Christian Vigil Zamora
; APARTADO A)

; Ejemplo de prueba

(deffacts Hechos
        (T 1 2 3 4 5)
        (T 1 2 3)
)

; Regla encarga de abrir un fichero para su escritura. Se le da la máxima prioridad. 
; La función open abre el archivo indicado, o lo crea si no existe. El hecho de 
; añadir "w" es para que el archivo tenga permisos de escritura.

(defrule openFile
        (declare (salience 30))
        =>
        (open "DatosT.txt" DatosT "w")
)

; Regla encargada de escribir los datos en el fichero. Una vez abierto. Comprueba
; que existe al menos un hecho de tipo (T ?X1 ...). Seguidamente, con la función 
; progn$, la cual sirve para iterar sobre los valores de una lista ordenadamente, 
; recorremos los elementos del hecho en orden y los copiamos en el fichero, guardando
; un espacio entre los elementos.

(defrule writeData
        (declare (salience 20))
        (T $?n)
        =>
        (progn$ (?var (create$ $?n))
        (printout DatosT ?var " "))
        (printout DatosT crlf)
)

; Regla encargada de cerrar el fichero abierto posteriormente. Se realiza mediante 
; la función close y es la regla con menos prioridad.

(defrule closefile
        (declare (salience 10))
        =>
        (close DatosT)
)