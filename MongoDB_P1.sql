C:\Program Files\MongoDB\Server\8.0\bin>mongosh

test> show dbs
admin    40.00 KiB
config  108.00 KiB
local    72.00 KiB

test> use db200
==========================================
--CREAR UNA NUEVA COLECCION:
db200> db.createCollection("productos")

--VERIFICAR COLECCION CREADA:
db200> show collections // db.getCollectionNames()
productos

--RENOMBRAR COLECCION:
db200> db.Productos.renameCollection("mercaderia")

--ELIMINAR COLECCION:
db200> db.mercaderia.drop()

--VER EL CONTENIDO DE UNA COLECCION SIN PARAMETRO = (SELECT * FROM TABLE):
db200> db.productos.find()

	--ES LO MISMO AL (db.productos.find()) SOLO QUE PUEDES APLICAR FILTROS
	db.productos.find( {} )
	db.productos.find( {filtros}, {campos a visualizar} )
	
	--INDICO EN EL SEGUNDO {} LOSCAMPOS QUE QUIERO QUE SE VISUALICEN
	db.productos.find( { marca : "Marca A"} , {_id:0, nombre:1, marca:1} )
	
	--SOLO MUESTRA EL PRIMER RESULTADO
	db.productos.findOne()
	db.productos.findOne( {filtros}, {campos a visualizar} )

--INSERTONE [1 DOCUMENTO]
db.productos.insertOne( {"_id": 800, "nombre" : "producto 8"} )

--INSERTMANY [1--M DOCUMENTOS]
db.productos.insertMany( 
 [
  {"_id": 900, "nombre" : "producto 9"}, 
  {"_id": 1000, "nombre" : "producto 10"}, 
  {"_id": 1100, "nombre" : "producto 11"}, 
  {"_id": 1200, "nombre" : "producto 12"} 
 ]
)
=============================================================================================================

--OPERADORES BUSQUEDA
$eq	--> IGUALDAD
$ne --> DESIGUALDAD
$gt --> MAYOR QUE
$lt --> MENOR QUE
$gte --> MAYOR IGUAL QUE
$lte --> MENOR IGUAL QUE
$in --> LISTA VALORES // MUESTRA UN LISTADO DE VALORES EXISTENTES
$nin --> NO LISTA VALORES // MUESTRA UN LISTADO SIN LOS VALORES INDICADOS

db.productos.find( { marca : {$eq: "Marca B"}  } , {_id:0} )
db.productos.find( { marca : {$ne: "Marca B"}  } , {_id:0} )
db.productos.find( { precio : {$gt: 55}  } , {_id:0} )
db.productos.find( { precio : {$lt: 15}  } , {_id:0} )
db.productos.find( { precio : {$gte: 55}  } , {_id:0} )
db.productos.find( { precio : {$lte: 15}  } , {_id:0} )
db.productos.find( { marca : {$in: ["Marca X","Marca D","Marca E"] }  } , {_id:0} )
db.productos.find( { marca : {$nin: ["Marca A","Marca B"] }  } , {_id:0} )

--CONSULTA COMBINADA
db.productos.find( { precio : {$gt: 15, $lt: 60}  } , {_id:0} )

--OPERADORES LOGICOS

-- AND	<-- COMBINAR FILTROS, RESULTADOS CUMPLIR TODOS LOS FILTROS
	--IMPLICITO
	db.productos.find( { marca : "Marca A", precio:87} , {_id:0} )
	
	--EXPLICITO 
	db.productos.find( 
	  { $and: [ {marca : "Marca A"}, {precio:87}] },
	  {_id:0} 
	)
	
-- OR	<-- COLOCAR FILTROS, NO NECESARIAMENTE SE DEBEN CUMPLIR TODOS
db.productos.find( 
  { $or: [ {marca : "Marca A"}, {precio:87}] },
  {_id:0} 
)
===========================================================================
--CONSULTA PARA SABER LA CANTIDAD DE DOC EN UNA COLECCION(depreciado )
db.productos.count()

--CONTAR CANTIDAD POR CONDICION DE BUSQUEDA(depreciado )
db.productos.find({marca:"Marca A"}).count()

--CONTAR LA CANTIDAD POR CONDICION DE BUSQUEDA
db.productos.countDocuments({marca:"Marca A"})

--PARA VER LOS DISTINTOS VALORES POR COLUMNA
db.productos.distinct("marca")

--ORDENAMIENTO ASCENDENTE
db.productos.find( {}, {_id:0}).sort({precio:1})

--ORDENAMIENTO DECENDENTE
db.productos.find( {}, {_id:0}).sort({precio:-1})

--PARA VER X NUMERO DE DOCUMENTOS
db.productos.find( {}, {_id:0}).limit(3)

--PARA VER X NUMERO DE DOCUMENTOS ASCENDENTE
db.productos.find( {marca:"Marca B"}, {_id:0}).sort({precio:1}).limit(5)

--PARA VER X NUMERO DE DOCUMENTOS DECENDENTE
db.productos.find( {marca:"Marca A"}, {_id:0}).sort({precio:-1}).limit(3)

--PERMITE SALTAR X CANTIDAD DE DOCUMENTOS ANTES DE MOSTRAR LA INFORMACION
db.productos.find({},{nombre:1}).skip(3)

db.productos.find( {marca:"Marca A"}, {_id:0}).sort({precio:-1}).skip(2).limit(1)

--DOCUMENTO JSON
{
  campo1: 100,
  campo2: "valor2",
  campo3: "fecha3",
  campo4: ["elem1","elem2","elem3"]
}

--SUBDOCUMENTO
{
  campo1: 100,
  campo2: "valor2",
  campo3: "fecha3",
  campo4: ["elem1","elem2","elem3"],
  campo5: {sd1: "valor", sd2: "valor", sd3: "valor"}
}
===============================================EJEMPLO==============================================

		{"nombre":"Estudiante 10","aula":"seccion A","notas":{mat:12,ing:18,cie:11,art:16} },
		{"nombre":"Estudiante 11","aula":"seccion A","notas":{mat:15,ing:13,cie:17,art:14} },
		{"nombre":"Estudiante 12","aula":"seccion A","notas":{mat:14,ing:16,cie:14,art:14} },
		{"nombre":"Estudiante 13","aula":"seccion B","notas":{mat:18,ing:18,cie:17,art:17} },
		{"nombre":"Estudiante 14","aula":"seccion C","notas":{mat:11,ing:10,cie:18,art:18} },
		{"nombre":"Estudiante 15","aula":"seccion D","notas":{mat:19,ing:12,cie:17,art:18} }

--FILTRAR EN UN CAMPO DENTRO DE UN SUBDOCUMENTO
db.estudiantes.find({"notas.mat":18} , {_id:0})

--FILTRAR EN UN CAMPO DENTRO DE UN SUBDOCUMENTO CON OPERADORES DE BUSQUEDA
db.estudiantes.find({aula:"seccion A","notas.mat": {$gte:13 , $lte:16}}, {_id:0})

--LA ESTRUCTURA TAMBIEN PUEDE SER:
db.estudiantes.find(
{ aula:"seccion A", "notas.mat": {$gte:13 , $lte:16} }, 
{_id:0}
)

db.estudiantes.find(
	{aula:"seccion A",
	"notas.mat": {$gte:13 , $lte:16}}, 
	{_id:0, nombre:1, "notas.mat":1}
).sort( {"notas.mat":-1})


--CAMPO DE TIPO FECHA (ACTUAL)
db.productos.insertOne( {"_id": 1500, "nombre" : "producto 15", "fecha_compra": ISODate() })

--CAMPO DE TIPO FECHA (MODIFICADA)
db.productos.insertOne( {"_id": 1600, "nombre" : "producto 16", "fecha_compra": ISODate("2025-02-19") })

db.alumnos.insertOne( {_id:1, nombre_completo: "Francisco Perez", fecha_admision:"15-05-1980" } ) ====> --SE INSERTA COMO STRING
db.alumnos.insertOne( {_id:2, nombre_completo: "Paula Mendoza", fecha_admision: ISODate("1980-05-15") } ) ====> --SE INSERTA COMO DATE
db.alumnos.insertOne( {_id:3, nombre_completo: "Li Yong", fecha_admision: ISODate("1980-05-15T19:00:00") } ) ====> --SE INSERTA COMO DATE Y HORA
db.alumnos.insertOne( {_id:5, nombre_completo: "Tom Lee", fecha_admision: new ISODate("1980-05-15T19:00:00.000Z") } ) 

===============================================EJEMPLO==============================================
db.alumnos.insertOne( {_id:1, nombre: "Francisco Perez", fecha_admision:ISODate("2022-05-15") } )
db.alumnos.insertOne( {_id:2, nombre: "Paula Mendoza", fecha_admision: ISODate("2019-12-19") } )
db.alumnos.insertOne( {_id:3, nombre: "Li Yong", fecha_admision: ISODate("2023-01-01") } )
db.alumnos.insertOne( {_id:4, nombre: "Who Yong", fecha_admision: ISODate("2024-05-14") } )
db.alumnos.insertOne( {_id:5, nombre: "Tom Lee", fecha_admision: ISODate("2021-08-19") } )
db.alumnos.insertOne( {_id:6, nombre: "Lisa Lee", fecha_admision: ISODate("2021-10-15") } )

db.alumnos.find(
 {fecha_admision: {$gte: ISODate("2022-01-01") } }
)

db.alumnos.find(
 {fecha_admision: {$eq: ISODate("2021-10-15") } }
)
==========================================================================================================================================================

