# require './dop.rb'
# require './datos.rb' 
require './sistema.rb' 

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

def probar_traer_cuenta
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
end 

def probar_diferencia
    a = {a: 10, b: 20,      d:[{m: 1}, {m: 2, n: 3}],         e: {x: 10, y: {v: 10, w: 20}}}
    b = {a: 10, b: 22, c:5, d:[{m: 1}, {m: 2, n: 4}, {o: 3}], e: {x: 10, y: {v: 12, z: 30}}}
    puts 'Diferencia >> '
    pp d = diff(a, b)
    # --
    # pp [:b, :d, [[:e, :y, :v],[:e, :y, :z]], :c]
    # --

    puts "--------"
    puts " > A "
    pp a 
    puts " > B "
    pp b 
    puts " A <=> B"
    pp d 
    puts "--"
    pp path(d)

    puts "Merge"

    pp merge(a,d)
end



a = [1, 2, 3]
b = {c1: 10, c2: 20}
p a[10]
a[10]= 100
p a 
p a.keys
p a.size
p b.next_key

probar_diferencia
