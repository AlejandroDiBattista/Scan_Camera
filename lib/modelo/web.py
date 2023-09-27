# Importa las librerías necesarias
import requests
from bs4 import BeautifulSoup

# Define la URL del QR
qr_url = 'https://serviciosweb.afip.gob.ar/clavefiscal/qr/response.aspx?qr=7gbG0UVlv3codO6nHiw1iA,,'

# Hace una solicitud HTTP a la URL del QR y obtiene el código HTML de la página web
response = requests.get(qr_url)
html = response.text

# Crea un objeto BeautifulSoup para analizar el código HTML
soup = BeautifulSoup(html, 'html.parser')

# Busca el elemento que contiene el CUIT del emisor
cuit_element = soup.find('input', id='tbCUIT')

# Extrae el texto del elemento y lo guarda en una variable
print(cuit_element)
cuit = cuit_element["value"]

# Busca el elemento que contiene la denominación del emisor
denominacion_element = soup.find('textarea', id='taDenominacion')
print(denominacion_element)

# Extrae el texto del elemento y lo guarda en otra variable
denominacion = denominacion_element.text

# Imprime los datos extraídos
print(f'CUIT: {cuit}')
print(f'Denominación: {denominacion}')
