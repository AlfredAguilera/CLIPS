(deftemplate enfermedad
    (slot nombre)
    (multislot signos)
    (multislot sintomas)
)

(deffacts Enfermedades
    (enfermedad (nombre "Gripe") (signos fiebre dolor-de-cabeza) (sintomas congestion-nasal dolor-de-garganta))
    (enfermedad (nombre "Resfriado") (signos congestion-nasal estornudos) (sintomas dolor-de-garganta tos))
    (enfermedad (nombre "Infección de Oído") (signos dolor-de-oido perdida-de-audicion) (sintomas fiebre dolor-de-cabeza))
    (enfermedad (nombre "Bronquitis") (signos tos dificultad-respiratoria) (sintomas fiebre cansancio))
    (enfermedad (nombre "Alergia") (signos estornudos picazon-en-los-ojos) (sintomas congestion-nasal tos))
    (enfermedad (nombre "Sinusitis") (signos dolor-de-cabeza congestion-nasal) (sintomas fiebre tos))
)



(defrule reading-input
   =>
   (printout t "Ingresa el nombre de la enfermedad a buscar: " )
   (assert (name (read)))
)

(defrule checking-input
   (name ?Name)
   (enfermedad (nombre ?Nombre) (signos $?Signos) (sintomas $?Sintomas))
   (test (member$ ?Name ?Nombre))
    =>
    (printout t "Enfermedad: " ?Nombre crlf)
    (printout t "Signos: " $?Signos crlf)
    (printout t "Síntomas: " $?Sintomas crlf)
)    

