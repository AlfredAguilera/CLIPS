(deftemplate position
   (slot entity)
   (slot location))

(deftemplate status
   (slot entity)
   (slot state))

(deffacts initial-state
   (position (entity mono) (location puerta))
   (position (entity silla) (location esquina))
   (position (entity banana) (location techo))
   (status (entity mono) (state en-piso))
   (status (entity banana) (state colgando)))

;; Regla 1: El mono se mueve a la silla
(defrule mover-mono-a-silla
   ?mono-pos <- (position (entity mono) (location ?loc))
   (position (entity silla) (location esquina))
   (not (position (entity mono) (location esquina)))
   =>
   (retract ?mono-pos)
   (assert (position (entity mono) (location esquina)))
   (printout t "El mono se mueve de " ?loc " a la esquina." crlf))

;; Regla 2: El mono mueve la silla debajo de la banana
(defrule mover-silla
   (position (entity mono) (location esquina))
   ?silla-pos <- (position (entity silla) (location esquina))
   (not (position (entity silla) (location debajo-de-la-banana)))
   =>
   (retract ?silla-pos)
   (assert (position (entity silla) (location debajo-de-la-banana)))
   (printout t "El mono mueve la silla de la esquina a debajo de la banana." crlf))

;; Regla 3: El mono se mueve debajo de la banana
(defrule mover-mono-debajo-banana
   ?mono-pos <- (position (entity mono) (location esquina))
   (position (entity silla) (location debajo-de-la-banana))
   (not (position (entity mono) (location debajo-de-la-banana)))
   =>
   (retract ?mono-pos)
   (assert (position (entity mono) (location debajo-de-la-banana)))
   (printout t "El mono se mueve de la esquina a debajo de la banana." crlf))

;; Regla 4: El mono se sube a la silla
(defrule subir-silla
   (position (entity mono) (location debajo-de-la-banana))
   (position (entity silla) (location debajo-de-la-banana))
   ?mono-status <- (status (entity mono) (state en-piso))
   =>
   (retract ?mono-status)
   (assert (status (entity mono) (state en-silla)))
   (printout t "El mono se sube a la silla." crlf))

;; Regla 5: El mono agarra la banana
(defrule alcanzar-banana
   (status (entity mono) (state en-silla))
   ?banana-status <- (status (entity banana) (state colgando))
   =>
   (retract ?banana-status)
   (assert (status (entity banana) (state agarrada)))
   (printout t "El mono agarra la banana." crlf))

;; Regla 6: El mono baja de la silla al piso (solo si ha agarrado la banana)
(defrule bajar-de-la-silla
   ?mono-status <- (status (entity mono) (state en-silla))
   (status (entity banana) (state agarrada))
   =>
   (retract ?mono-status)
   (assert (status (entity mono) (state en-piso-con-banana))) ; Estado especial
   (printout t "El mono baja de la silla al piso con la banana." crlf))

;; Regla 7: El mono se mueve de debajo de la banana a la puerta (solo si tiene la banana)
(defrule mover-mono-a-puerta
   ?mono-pos <- (position (entity mono) (location debajo-de-la-banana))
   (status (entity mono) (state en-piso-con-banana))
   =>
   (retract ?mono-pos)
   (assert (position (entity mono) (location puerta)))
   (printout t "El mono se mueve de debajo de la banana a la puerta con la banana." crlf))

;; Regla 8: El mono se mueve de la esquina con la banana a la esquina
(defrule mover-mono-a-esquina-con-banana
   ?mono-pos <- (position (entity mono) (location puerta))
   (status (entity mono) (state en-piso-con-banana))
   (not (position (entity mono) (location esquina-con-banana))) ; Añadido
   =>
   (retract ?mono-pos)
   (assert (position (entity mono) (location esquina-con-banana)))
   (printout t "El mono se mueve de la puerta a la esquina con la banana." crlf))

;; Regla 9: El mono está feliz
(defrule mono-feliz
   (position (entity mono) (location esquina-con-banana))
   (status (entity mono) (state en-piso-con-banana))
   =>
   (assert (status (entity mono) (state feliz)))
   (assert (status (entity banana) (state agarrada)))
   (printout t "El mono está feliz." crlf))

;; Regla 10: El mono come la banana
(defrule mono-come-banana
   (status (entity mono) (state feliz))
   ?banana-state <- (status (entity banana) (state agarrada))
   =>
   (retract ?banana-state)
   (printout t "El mono come la banana." crlf))

