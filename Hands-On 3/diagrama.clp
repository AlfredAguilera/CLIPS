(deftemplate Sintoma
    (slot nombre)
)

(defrule identificar-diabetes-tipo-2
    (Sintoma (nombre sed))
    (Sintoma (nombre hambre))
    (Sintoma (nombre vision_borrosa))
    (Sintoma (nombre fatiga))
    =>
    (printout t "La enfermedad es Diabetes Tipo 2." crlf)
    (assert (diabetes_tipo_2))
)

(defrule identificar-hipertension-arterial
    (Sintoma (nombre mareos))
    (Sintoma (nombre dificultad_respirar))
    (Sintoma (nombre vision_borrosa))
    (Sintoma (nombre fatiga))
    =>
    (printout t "La enfermedad es Hipertensión Arterial." crlf)
    (assert (hipertension_arterial))
)

(defrule identificar-asma
    (Sintoma (nombre sibilancias))
    (Sintoma (nombre respiracion_debil))
    (Sintoma (nombre tos))
    (Sintoma (nombre dolor_pecho))
    =>
    (printout t "La enfermedad es Asma." crlf)
    (assert (asma))
)

(defrule identificar-artritis
    (Sintoma (nombre rigidez_muscular))
    (Sintoma (nombre debilidad_muscular))
    (Sintoma (nombre articulaciones_hinchadas))
    (Sintoma (nombre dolor_articular))
    =>
    (printout t "La enfermedad es Artritis." crlf)
    (assert (artritis))
)

(defrule identificar-depresion
    (Sintoma (nombre cambio_apetito))
    (Sintoma (nombre falta_energia))
    (Sintoma (nombre trastornos_dormir))
    (Sintoma (nombre tristeza))
    =>
    (printout t "La enfermedad es Depresión." crlf)
    (assert (depresion))
)

(defrule identificar-alzheimer
    (Sintoma (nombre dificultad_lenguaje))
    (Sintoma (nombre cambio_personalidad))
    (Sintoma (nombre perdida_memoria))
    (Sintoma (nombre desorientacion))
    =>
    (printout t "La enfermedad es Alzheimer." crlf)
    (assert (alzheimer))
)


