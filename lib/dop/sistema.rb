require './dop.rb' 
require './datos.rb' 

datos = datosDemo() 

# crearUsuario(datos, dni, nombre)
# crearNegocio(datos, cuit, denominacion)
# crearCuenta(datos, usuario)
# 
# acreditar(datos, origen, destino, monto)
# debitar(datos, origen, destino, monto)
# saldo(datos, cuenta)
# 
#historia(datos, usuario)

def traerCuenta(datos, usuario)
    for k, valor in get(datos, :cuentas)
        return k if get(valor, :usuario) == usuario 
    end
    nil
end

def crearUsuario(datos, dni, nombre)
    u = next_key(datos, :usuarios)
    aux = datos 
    aux = set(aux, [:usuarios, u], { dni: dni, nombre: nombre }) 
    aux = crearCuenta(aux, u) 
    aux 
end

def crearNegocio(datos, cuit, denominacion)
    n = next_key(datos, :negocios)
    aux = datos 
    aux = set(aux, [:negocios, n], { cuit: cuit, denominacion: denominacion })
    aux = crearCuenta(aux, n) 
    aux 
end

def crearCuenta(datos, usuario)
    c = next_key(datos, :cuentas)
    set(datos, [:cuentas, c], { usuario: usuario, movimientos: [] }) 
end

def acreditar(datos, negocio, usuario, monto )
    n = traerCuenta(datos, negocio)
    u = traerCuenta(datos, usuario)
    aux = datos
    if !n.nil? && !u.nil?
        aux = add(aux, [:cuentas, n, :movimientos], { destino: negocio, monto: monto })
        aux = add(aux, [:cuentas, u, :movimientos], { origen:  usuario, monto: monto })
    end
    aux 
end

def debitar(datos, negocio, usuario, monto )
    n = traerCuenta(datos, negocio)
    u = traerCuenta(datos, usuario)
    aux = datos
    if saldo(aux, usuario) >= monto 
        aux = add(aux, [:cuentas, n, :movimientos], { origen:  negocio, monto: monto })
        aux = add(aux, [:cuentas, u, :movimientos], { destino: usuario, monto: monto })
    end
    aux 
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
puts '--------'
puts saldo(datos, 'u000')

puts '--------'
pp(datos = acreditar(datos, 'n001', 'u000', 123))
puts saldo(datos, 'u000')

puts '--------'
pp(datos = debitar(datos, 'n001', 'u000', 1000))
puts saldo(datos, 'u000')

puts next_key(get(datos, :cuentas ))
puts next_key(get(datos, :usuarios))
puts next_key(get(datos, :negocios))

proximo = acreditar(datos, 'n001', 'u001', 999)
pp proximo

pp traerCuenta(datos, 'n001')
pp traerCuenta(datos, 'n002')

pp d= diff( {a: 10, b: 20, d:[1, 2], e: {x: 10, y: 20}}, {a: 10, b: 22, c:5, d:[2, 2, 3], e: {x: 10, y: 22}})
pp path(d)