class Object
	def object?
		is_a?(Hash)
	end

	def array?
		is_a?(Array)
	end
end

class Array

	def get(index)
		return nil if index >= self.size 
		self[index]
	end

	def set(index, value)
		push(nil) while index > size 

		return push(value) if index == size 
		self[index] = value
	end

	def keys 
		(0...size).map{|i|i}
	end

	def next_key 
		self.size
	end  

end

class Hash
	def get(key)
	  self[key.to_sym]  
	end 

	def set(key, value)
	  self[key.to_sym] = value   
	end

	def next_key 
		keys.sort.last.to_s.succ.to_sym
	end  
end

module DOP 
	
	def claves(*camino)
		camino.flatten.map{|k| String === k ? k.to_sym : k }
	end

	def next_key(datos)
		datos.keys.sort.last.to_s.succ     
	end

	def get(data, *camino)
		claves(camino).reduce(data){|d, k| d.get(k) }
	end

	def set(datos, *camino, valor)
		return datos if valor.nil?
		return datos if get(datos, camino) == valor

		clave, *resto = claves(camino)
		 
		datos.clone.tap{|nuevo| nuevo.set(clave, resto.empty? ? valor : set(nuevo.get(clave), resto, valor)) }
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
		return diff_o(a, b) if a.object? && b.object?  
		return diff_a(a, b) if a.array?  && b.array?
		return b if a != b
		return nil 
	end

	def diff_a(a, b)
		n = [a.length, b.length].max
		(0...n).map{|i| a[i] == b[i] ? nil : diff(a[i], b[i])}
	end

	def diff_o(a, b)
		e = a.array? ? [] : {}
		return e if a == b 

		keys = (a.keys + b.keys).uniq
		keys.inject(e) do |acc, k|
			d = diff( get(a, k), get(b, k) )
			if d.object? && d.empty? || d.nil?
				acc
			else
				set(acc, [k], d)
			end
		end
	end
	
	def path(datos, salida=[])
	  datos.inject([]) do |acc, (k,v)|
		acc + if v.object? 
			path(v, salida + [k])
		elsif v.array?
			v.map.with_index{|a, i| a && salida + path(a, [k ,i]) }.compact.map(&:first)
		else
			[salida + [k]]
		end
	  end  
	end

	def merge_o(a, b)
		b.keys.inject(a){|d,k| set(d, k, merge(a.get(k), b.get(k)))}
	end
	
	def merge_a(a, b)
		b.keys.inject(a){|d,k| set(d, k, merge(a.get(k), b.get(k)))}
	end

	def merge(a, b)
		return a if a == b 
		if a.object? && b.object? || a.array?  && b.array?
			b.keys.inject(a){|d, k| set(d, k, merge(a.get(k), b.get(k)))}	
		else 
			b
		end 
	end

	def igual(a, b)
		if a == b
			true
		elsif a.object? && b.object? || a.array? && b.array?
			a.keys.all? {|k| igual(a.get(k), b.get(k)) }
		end
	end

end



# -----------------------
include DOP 


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

# {:b=>22, :d=>[nil, {:n=>4}, {:o=>3}], :e=>{:y=>{:v=>12, :z=>30}}, :c=>5}
# [[:b], [:d], [:e, :y, :v], [:e, :y, :z], [:c]]
# 
# [[:b], {:n=>4}, {:o=>3}, [:e, :y, :v], [:e, :y, :z], [:c]]
# [[:b], [[:d, 1, :n]], [[:d, 2, :o]], [:e, :y, :v], [:e, :y, :z], [:c]]

# [[:b], [:d, 1, :n], [:d, 2, :o], [:e, :y, :v], [:e, :y, :z], [:c]]
# 
#
#
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

	pp merge(a, d)
end


probar_diferencia
