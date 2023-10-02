require 'httparty'
require 'nokogiri'

# Define la URL del QR
qr_url = 'https://serviciosweb.afip.gob.ar/clavefiscal/qr/response.aspx?qr=7gbG0UVlv3codO6nHiw1iA,,'

# Hace una solicitud HTTP a la URL del QR y obtiene el código HTML de la página web
response = HTTParty.get(qr_url)
html = response.body

# Crea un objeto Nokogiri para analizar el código HTML
doc = Nokogiri::HTML(html)

# Busca el elemento que contiene el CUIT del emisor
cuit_element = doc.at_css('#tbCUIT')

# Extrae el texto del elemento y lo guarda en una variable
cuit = cuit_element['value']

# Busca el elemento que contiene la denominación del emisor
denominacion_element = doc.at_css('#taDenominacion')

# Extrae el texto del elemento y lo guarda en otra variable
denominacion = denominacion_element.text

# Imprime los datos extraídos
puts "CUIT: #{cuit}"
puts "Denominación: #{denominacion}"
