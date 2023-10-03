
datos = {
    usuarios: {
        u0: {
            dni: '18000001',
            nombre: 'Juan',
        } ,
        u1: {
            dni: '18000002',
            nombre: 'Maria',
        } ,
        u2: {
            dni: '18000003' ,
            nombre: 'Carlos',
        } ,
    },

    negocios: {
        n0: {
            cuit: '20200000011',
            denominacion: 'Cafe 1',
        },
        n1: {
            cuit: '20200000022',
            denominacion: 'Cafe 2',
        },
        n2: {
            cuit: '20200000033',
            denominacion: 'Cafe 3',
        }
    },

    cuentas: {
        c0: {
            usuario: 'u0',
            movimientos: [
                { origen: 'c1', monto: 100,},
                { origen: 'c1', monto: 200,},
                { destino: 'c2', monto: 150,},
            ],
        }, 
        c1: { 
            usuario: 'n0',
            movimientos: [
                { destino: 'c0', monto: 100},
                { destino: 'c0', monto: 200},
            ],
        },
        c2: { 
            usuario: 'n1',
            movimientos: [
                { origen: 'c0', monto: 150},
            ],
        },
        c3: {
            usuario: 'u1',
            movimientos: [ ],
        }, 
        c4: {
            usuario: 'u2',
            movimientos: [ ],
        }, 
    },
}

def claves(*camino)
    camino.flatten.map{|k| String === k ? k.to_sym : k }
end

def get(data, *camino)
    claves(camino).reduce(data){|d, k| d[k] }
end

def set(datos, *camino, valor)
    return datos if get(datos, camino) == valor 

    clave, *resto = claves(camino)
    datos.clone.tap{|nuevo| nuevo[clave] = resto.empty? ? valor : set(datos[clave], resto, valor) }
end

def has(datos, *camino)
    !get(datos, camino).nil?
end 

def add(datos, *camino, valor)
    aux = get(datos, camino)
    aux.push(valor)
    set(datos, camino, aux)
end

# -----------------------

def traerCuenta(datos, usuario)
    for k, valor in get(datos, :cuentas)
        return k if get(valor, :usuario) == usuario 
    end
    {}
end

def acreditar(datos, negocio, usuario, monto )
    n = traerCuenta(datos, negocio)
    u = traerCuenta(datos, usuario)
    aux = add(datos, [:cuentas, n, :movimientos], {origen:  negocio, monto: monto})
    aux = add(aux,   [:cuentas, u, :movimientos], {destino: usuario, monto: monto})
end

def saldo(datos, usuario)
    n = traerCuenta(datos, usuario)
    m = get(datos, :cuentas, n, :movimientos)
    total = 0
    for e in m 
        monto = get(e, :monto)
        total += has(e, :origen) ? monto : -monto
    end 
    total 
end

# puts "TraerCuenta: "
# puts traerCuenta(datos, "u0")
puts saldo(datos, "u0")
pp(datos= acreditar(datos, "n1", "u0", 123))
puts "--------"
c = traerCuenta(datos, "u0")
pp (get(datos, :cuentas, c, :movimientos))
puts saldo(datos, "u0")

def probar_get_set(datos)
    puts 'test_get_set'

    puts '- get -'
    puts anterior = get(datos, [:usuarios, :u0, :dni])

    puts '- set = -'
    aux1 = set(datos, :usuarios, :u0, :dni, anterior)
    puts get(aux1, [:usuarios, :u0, :dni])
    puts datos == aux1
    puts '- set != -'

    aux2 = set(datos, :usuarios, :u0, :dni, '1800000x')
    puts get(aux2, [:usuarios, :u0, :dni])
    puts datos == aux2
end 

# probar_get_set(datos)
# Clases

#   Usuario
#   - id
#   - dni
#   - nombre

#   Negocio
#   - id
#   - cuit
#   - denominacion

#   Cuenta
#   - id
#   - usuario
#   - creacion
   
#   Movimiento
#   - origen
#   - destino
#   - monto 

# crearUsuario(datos, dni, nombre)
# acreditar(datos, origen, destino, monto)
# debitar(datos, origen, destino, monto)
# saldo(datos, cuenta)
# historia(datos, usuario)
