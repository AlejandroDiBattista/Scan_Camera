module DOP 
    def claves(*camino)
        camino.flatten.map{|k| String === k ? k.to_sym : k }
    end

    def next_key(datos)
        datos.keys.sort.last.to_s.succ     
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

    def diff(a, b)
        return diff_o(a, b) if a.is_a?(Hash)  && b.is_a?(Hash)  
        return diff_a(a, b) if a.is_a?(Array) && b.is_a?(Array)
        return b if a != b
        return nil 
    end

    def diff_a(a, b)
        n = [a.length, b.length].max
        s = b.clone
        (0...n).each{|i| s[i] = a[i] == b[i] ? nil : b[i]}
        s
    end

    def path(datos, salida=[])
      datos.inject([]) do |acc, (k,v)|
        acc.clone + if(v.is_a?(Hash))
            path(v, salida.clone << k)
        else
            salida.clone << k   
        end
      end  
    end

    def diff_o(a, b)
        e = a.is_a?(Array) ? [] : {}
        return e if a == b 

        keys = (a.keys + b.keys).uniq
        keys.inject(e) do |acc, k|
            d = diff( get(a, k), get(b, k) )
            if d.is_a?(Hash) && d.empty? || d.nil?
                acc
            else
                set(acc, [k], d)
            end
        end
    end
end
# -----------------------
include DOP 

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

