
def get(data, camino)
end

def set(data, camino, valor)
end

# Clases

#   Usuario
#   - usuario_id
#   - dni
#   - nombre

#   Negocio
#   - negocio_id
#   - cuit
#   - denominacion

#   Cuenta
#   - cuenta_id
#   - usuario
#   - creacion
   
#   Movimiento
#   - movimiento_id
#   - origen
#   - destino
#   - fecha
#   - monto 


# crearUsuario(datos, dni, nombre)
# acreditar(datos, origen, destino, monto)
# debitar(datos, origen, destino, monto)
# saldo(datos, cuenta)
# historia(datos, usuario)

datos = {
    usuarios_por_dni: {
        '18000001': {
            dni: '18000001',
            nombre: 'Juan',
        } ,
        '18000002': {
            dni: '18000002',
            nombre: 'Maria',
        } ,
        '18000001': {
            dni: '18000003' ,
            nombre: 'Carlos',
        } ,
    }

    negocios_por_cuit: {
        '20200000011': {
            cuit:  '20200000011',
            denominacion: 'Cafe 1',
        }
        '20200000022': {
            cuit:  '20200000022',
            denominacion: 'Cafe 2',
        }
        '20200000013': {
            cuit:  '20200000033',
            denominacion: 'Cafe 3',
        }
    }
    cuentas_por_id: {
        "1": {
            usuario: '18000001'
            movimientos: {
                1: {

                }
            }
    }
}