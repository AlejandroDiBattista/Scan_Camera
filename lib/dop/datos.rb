
module Datos

    # usuarios { dni, nombre }
    # negocios { cuit, denominacion }
    # cuentas {
    #     usuario
    #     movimientos [{ origen, destino, monto }]
    # }


  def datosDemo
    {
        usuarios: {
            u000: {
                dni: '18000001',
                nombre: 'Juan',
            } ,
            u001: {
                dni: '18000002',
                nombre: 'Maria',
            } ,
            u002: {
                dni: '18000003' ,
                nombre: 'Carlos',
            } ,
        },

        negocios: {
            n000: {
                cuit: '20200000011',
                denominacion: 'Cafe 1',
            },
            n001: {
                cuit: '20200000022',
                denominacion: 'Cafe 2',
            },
            n002: {
                cuit: '20200000033',
                denominacion: 'Cafe 3',
            }
        },

        cuentas: {
            c000: {
                usuario: 'u000',
                movimientos: [
                    { origen:  'c001', monto: 100,},
                    { origen:  'c001', monto: 200,},
                    { destino: 'c002', monto: 150,},
                ],
            }, 
            c001: { 
                usuario: 'n000',
                movimientos: [
                    { destino: 'c000', monto: 100},
                    { destino: 'c000', monto: 200},
                ],
            },
            c002: { 
                usuario: 'n001',
                movimientos: [
                    { origen: 'c000', monto: 150},
                ],
            },
            c003: {
                usuario: 'u001',
                movimientos: [ ],
            }, 
            c004: {
                usuario: 'u002',
                movimientos: [ ],
            }, 
        },
    } 
  end

end

include Datos 