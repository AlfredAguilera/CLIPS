(deftemplate Smartphone
  (slot nombre)
  (slot marca)
  (slot precio)
  (slot especificaciones))

(deftemplate Computador
  (slot nombre)
  (slot marca)
  (slot precio)
  (slot especificaciones))

(deftemplate Accesorio
  (slot nombre)
  (slot tipo)
  (slot precio))

(deftemplate Cliente
  (slot nombre)
  (slot edad)
  (slot genero)
  (slot ubicacion)
  (slot tipo))

(deftemplate OrdenCompra
  (slot cliente)
  (multislot productos)
  (slot total)
  (slot tipo_compra)
  (slot fecha_compra))

(deftemplate TarjetaCredito
  (slot titular)
  (slot numero)
  (slot fecha_vencimiento)
  (slot banco))

(deftemplate Vale
  (slot codigo)
  (slot valor)
  (slot fecha_emision))

(deftemplate Cupon
  (slot codigo))

(deffacts DatosIniciales
   ;; Hechos sobre Smartphones
   (Smartphone (nombre "iPhone 13") (marca "Apple") (precio 999) (especificaciones "6.1-inch Super Retina XDR display, A15 Bionic chip"))
   (Smartphone (nombre "Galaxy S21") (marca "Samsung") (precio 799) (especificaciones "6.2-inch Dynamic AMOLED 2X display, Exynos 2100 chip"))
   (Smartphone (nombre "Pixel 6") (marca "Google") (precio 599) (especificaciones "6.4-inch FHD+ OLED display, Tensor chip"))

   ;; Hechos sobre Computadores
   (Computador (nombre "MacBook Pro") (marca "Apple") (precio 1299) (especificaciones "13-inch Retina display, M1 chip"))
   (Computador (nombre "XPS 13") (marca "Dell") (precio 999) (especificaciones "13.4-inch InfinityEdge display, Intel Core i5"))
   (Computador (nombre "Surface Laptop 4") (marca "Microsoft") (precio 1299) (especificaciones "13.5-inch PixelSense display, AMD Ryzen 5"))

   ;; Hechos sobre Accesorios
   (Accesorio (nombre "AirPods Pro") (tipo "Auriculares inalámbricos") (precio 249))
   (Accesorio (nombre "Logitech MX Master 3") (tipo "Ratón") (precio 99))
   (Accesorio (nombre "Samsung EVO 970 SSD") (tipo "Almacenamiento externo") (precio 149))

   ;; Hechos sobre Clientes
   (Cliente (nombre "Juan Pérez") (edad 30) (genero "Masculino") (ubicacion "Ciudad de México") (tipo "cliente-recurrente"))
   (Cliente (nombre "María García") (edad 25) (genero "Femenino") (ubicacion "Buenos Aires") (tipo "estudiante universitario"))
   (Cliente (nombre "Carlos López") (edad 35) (genero "Masculino") (ubicacion "Madrid") (tipo "cliente-nuevo"))

   ;; Hechos sobre Ordenes de Compra
   (OrdenCompra (cliente "Juan Pérez") (productos "iPhone 13" "AirPods Pro") (total 1248) (tipo_compra "en línea") (fecha_compra "2024-05-20"))
   (OrdenCompra (cliente "María García") (productos "Pixel 6" "Logitech MX Master 3") (total 698) (tipo_compra "en tienda física") (fecha_compra "2024-05-18"))
   (OrdenCompra (cliente "Carlos López") (productos "Galaxy S21" "Samsung EVO 970 SSD") (total 948) (tipo_compra "en línea") (fecha_compra "2024-05-15"))

   ;; Hechos sobre Tarjetas de Crédito
   (TarjetaCredito (titular "Juan Pérez") (numero "1234 5678 9012 3456") (fecha_vencimiento "04/26") (banco "Banamex"))
   (TarjetaCredito (titular "María García") (numero "9876 5432 1098 7654") (fecha_vencimiento "09/25") (banco "Liverpool"))
   (TarjetaCredito (titular "Carlos López") (numero "5678 9012 3456 7890") (fecha_vencimiento "12/27") (banco "BBVA"))

   ;; Hechos sobre Vales
   (Vale (codigo "ABC123") (valor 50) (fecha_emision "2024-05-20"))
   (Vale (codigo "XYZ789") (valor 20) (fecha_emision "2024-05-18"))
   (Vale (codigo "DEF456") (valor 30) (fecha_emision "2024-05-15"))

   ;; Hechos sobre Cupones
   (Cupon (codigo "50pesos"))
)

;; Regla 1: Oferta para iPhone 15 con tarjetas Banamex
(defrule oferta-iphone15-banamex
  (OrdenCompra (cliente ?cliente) (productos $?productos&:(member$ "iPhone 15" ?productos)))
  (TarjetaCredito (titular ?cliente) (numero ?numero) (banco "Banamex"))
  =>
  (printout t "Oferta: 24 meses sin intereses para el iPhone 15 con tarjetas Banamex" crlf))

;; Regla 2: Oferta para Samsung Note 12 con tarjeta de Liverpool VISA
(defrule oferta-samsung-note12-liverpool
  (OrdenCompra (cliente ?cliente) (productos $?productos&:(member$ "Samsung Note 12" ?productos)))
  (TarjetaCredito (titular ?cliente) (numero ?numero) (banco "Liverpool"))
  =>
  (printout t "Oferta: 12 meses sin intereses para el Samsung Note 12 con tarjeta de Liverpool VISA" crlf))

;; Regla 3: Oferta de vales por compras al contado de MacBook Air e iPhone 15
(defrule oferta-macbook-iphone15-al-contado
  (OrdenCompra (cliente ?cliente) (productos $?productos&:(and (member$ "iPhone 15" ?productos) (member$ "MacBook Air" ?productos))) (tipo_compra "al contado") (total ?total&:(>= ?total 2000)))
  =>
  (bind ?vales (* (/ ?total 1000) 100))
  (printout t "Oferta: $" ?vales " en vales por cada $1000 de compra al contado de una MacBook Air y un iPhone 15" crlf))

;; Regla 4: Oferta de descuento en funda y mica para clientes que compren un smartphone
(defrule oferta-funda-mica
  (OrdenCompra (productos $?productos&:(member$ "Smartphone" ?productos)))
  =>
  (printout t "Oferta: 15% de descuento en funda y mica para clientes que compren un smartphone" crlf))

;; Regla 5: Oferta para compras superiores a $1000 con tarjeta de crédito Banorte
(defrule oferta-compras-banorte
  (OrdenCompra (cliente ?cliente) (total ?total&:(>= ?total 1000)))
  (TarjetaCredito (titular ?cliente) (banco "Banorte"))
  =>
  (printout t "Oferta: 6 meses sin intereses para compras superiores a $1000 con tarjeta de crédito Banorte" crlf))

;; Regla 6: Oferta para MacBook Pro con tarjeta de crédito BBVA
(defrule oferta-macbookpro-bbva
  (OrdenCompra (cliente ?cliente) (productos $?productos&:(member$ "MacBook Pro" ?productos)))
  (TarjetaCredito (titular ?cliente) (banco "BBVA"))
  =>
  (printout t "Oferta: 12 meses sin intereses para MacBook Pro con tarjeta de crédito BBVA" crlf))

;; Regla 7: Descuento del 10% en accesorios para compras de estudiantes universitarios
(defrule descuento-estudiantes-universitarios
  (OrdenCompra (cliente ?cliente) (productos $?productos))
  (Cliente (nombre ?cliente) (tipo "estudiante universitario"))
  =>
  (printout t "Descuento del 10% en accesorios para compras de estudiantes universitarios" crlf))

;; Regla 8: Oferta de envío gratuito para clientes recurrentes
(defrule envio-gratuito-clientes-recurrentes
  (OrdenCompra (cliente ?cliente) (productos $?productos))
  (Cliente (nombre ?cliente) (tipo "cliente-recurrente"))
  =>
  (printout t "Oferta: Envío gratuito para clientes recurrentes" crlf))

;; Regla 9: Oferta de regalo en compras de más de $1500
(defrule regalo-compras-mayores-1500
  (OrdenCompra (total ?total&:(>= ?total 1500)))
  =>
  (printout t "Oferta: Regalo en compras de más de $1500" crlf))

;; Regla 10: Oferta de 20% de descuento en próxima compra para clientes nuevos
(defrule descuento-proxima-compra-clientes-nuevos
  (OrdenCompra (cliente ?cliente) (productos $?productos))
  (Cliente (nombre ?cliente) (tipo "cliente-nuevo"))
  =>
  (printout t "Oferta: 20% de descuento en la próxima compra para clientes nuevos" crlf))


;; Regla 11: Oferta para compras de accesorios Logitech con tarjeta Visa
(defrule oferta-logitech-visa
  (OrdenCompra (cliente ?cliente) (productos $?productos&:(member$ "Logitech MX Master 3" ?productos)))
  (TarjetaCredito (titular ?cliente) (numero ?numero))
  (test (neq (str-index ?numero "Visa") -1))
  =>
  (printout t "Oferta: 10% de descuento en accesorios Logitech con tarjeta Visa" crlf))

;; Regla 12: Descuento en computadoras Dell para compras en línea
(defrule descuento-dell-online
  (OrdenCompra (productos $?productos&:(member$ "XPS 13" ?productos)) (tipo_compra "en línea"))
  =>
  (printout t "Descuento del 15% en computadoras Dell para compras en línea" crlf))

;; Regla 13: Oferta para Surface Laptop 4 con tarjeta MasterCard
(defrule oferta-surface-laptop-mastercard
  (OrdenCompra (cliente ?cliente) (productos $?productos&:(member$ "Surface Laptop 4" ?productos)))
  (TarjetaCredito (titular ?cliente) (numero ?numero))
  (test (neq (str-index ?numero "MasterCard") -1))
  =>
  (printout t "Oferta: 18 meses sin intereses para Surface Laptop 4 con tarjeta MasterCard" crlf))


;; Regla 14: Descuento en almacenamiento externo Samsung para compras mayores a $500
(defrule descuento-samsung-almacenamiento
  (OrdenCompra (productos $?productos&:(member$ "Samsung EVO 970 SSD" ?productos)) (total ?total&:(>= ?total 500)))
  =>
  (printout t "Descuento del 10% en almacenamiento externo Samsung para compras mayores a $500" crlf))

;; Regla 15: Oferta de 5% de descuento en compras superiores a $1000 para clientes de Buenos Aires
(defrule descuento-clientes-buenos-aires
  (OrdenCompra (cliente ?cliente) (total ?total&:(>= ?total 1000)))
  (Cliente (nombre ?cliente) (ubicacion "Buenos Aires"))
  =>
  (printout t "Oferta: 5% de descuento en compras superiores a $1000 para clientes de Buenos Aires" crlf))

;; Regla 16: Oferta de descuento en accesorios para compras realizadas en línea
(defrule oferta-descuento-online
  (OrdenCompra (cliente ?cliente) (tipo_compra "en línea"))
  =>
  (printout t "Oferta: 10% de descuento en accesorios para compras realizadas en línea" crlf))

;; Regla 17: Oferta de descuento en auriculares inalámbricos para compras en tienda física
(defrule oferta-descuento-auriculares-tienda-fisica
  (OrdenCompra (cliente ?cliente) (tipo_compra "en tienda física"))
  =>
  (printout t "Oferta: Descuento del 15% en auriculares inalámbricos para compras en tienda física" crlf))

;; Regla 18: Oferta de devolución del 10% en efectivo para compras con tarjeta de crédito del banco XYZ
(defrule oferta-devolucion-efectivo-xyz
  (OrdenCompra (cliente ?cliente))
  (TarjetaCredito (titular ?cliente) (banco "XYZ"))
  =>
  (printout t "Oferta: Devolución del 10% en efectivo para compras con tarjeta de crédito del banco XYZ" crlf))

;; Regla 19: Oferta de crédito adicional para clientes que compren un computador de más de $1500
(defrule oferta-credito-adicional-computador
  (OrdenCompra (cliente ?cliente) (productos $?productos&:(member$ "Computador" ?productos)) (total ?total&:(>= ?total 1500)))
  =>
  (printout t "Oferta: Crédito adicional para clientes que compren un computador de más de $1500" crlf))

;; Regla 20: Oferta de regalo sorpresa
(defrule oferta-regalo-sorpresa
  (OrdenCompra (cliente ?cliente))
  =>
  (printout t "Oferta: ¡Regalo sorpresa para el cliente " ?cliente "!" crlf))


