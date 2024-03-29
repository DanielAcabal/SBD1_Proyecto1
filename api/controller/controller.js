const connection = require("../connection/connection")
const fs = require("fs")
const readline = require("readline")
let reports = []
fs.readFile(('./queries/reports.sql'), (err,data)=>{
	if (err) return
	reports = data.toString().split(";")
})

async function hola(req,res){
	res.send("Hola")
	console.log(await connection())
	console.log("[*] Hola",new Date())
}
function createTemp(req,res){
	try{
		fs.readFile('./queries/createTemp.sql', async function (err,data){
			if (err) throw err;
			const con = await connection()
			con.execute(data.toString())
				.catch(x=>x.errorNum==955)
				.then(r=>{
					if(r==true){
						res.status(500).json({"Error":"Ya existe"})
					}else{
						res.status(200).json({"message":"Table created"})
					}
				})
			con.close()
			})
	}catch (err){
		console.log("aaaaaaaa",err)
		res.json({"message":"Error"})
	}
	console.log("[*] Crear temporal",new Date())
}

function loadData(req,res){
	const file = readline.createInterface(fs.createReadStream("DB_Excel.csv"))
	const data = []
	let binds = [] 
	file.on("line",async line =>{
		data.push(line.split(";"))
	})
	file.on("close",async ()=>{
		data.shift()
		for (let i=1;i<24;i++){
			if (i==6||i==4||i==5||i==10||i==12||i==13||i==17||i==18||i==21||i==22){
				binds.push(`TO_DATE(:${i},'MM/DD/YYYY HH24:MI')`)
			}else{
				binds.push(":"+i)
			}
		}
		const fields =	"nombre_victima,apellido_victima,direccion_victima,primera_sospecha,fecha_confirmacion,fecha_muerte,"+
										"estado_victima,nombre_asociado ,apellido_asociado ,fecha_conocio ,contacto_fisico ,inicio_contacto ,"+
										"fin_contacto ,nombre_hospital ,direccion_hospital ,ubicacion_victima  ,fecha_llegada ,fecha_retiro ,"+
										"tratamiento ,efectividad,inicio_tratamiento ,fin_tratamiento ,efectividad_victima"
		const con = await connection();
		const result =  await con.executeMany(`INSERT INTO temporal (${fields}) VALUES (${binds.join(",")})`,data)
		console.log(result.rowsAffected)
		con.commit()
		res.json({"message":"Data uploaded successfully"})
		con.close()
	})
	console.log("[*] Crear temporal",new Date())
}
async function deleteData(req,res){
	const con = await connection()
	const r = await con.execute("DELETE FROM temporal")
	res.status(200).json({"message":"Table 'temporal' deleted"})
	console.log("[*] Temporal eliminado",new Date())
	console.log(r.rowsAffected)
	con.close()
}

function createModel(req,res){
	try{
		fs.readFile('./queries/createModel.sql', async function (err,data){
			if (err) throw err;
			const q = data.toString().split("$")
			const tables = q[0].split(";").map((val)=>`execute immediate '${val}'`)
			//console.log(queries.join("; \n"))
			const con = await connection();
			con.execute(`begin\n${tables.join(";\n")};\nend;`)
				.catch(x=>{console.log("xd:",x);return true;})
				.then(r=>{
					if(r==true){
						res.status(500).json({"Error":"Ya existe"})
					}else{
						res.status(200).json({"message":"Model created"})
					}
				})
			con.commit()
			const r = await con.execute("begin\n"+q[1]+"\n end;")
			con.commit()
			console.log("Filas: ",r)
			con.close()
			console.log("[*] Modelo creado",new Date())
			})
	}catch (err){
		console.log("aaaaaaaa",err)
		res.json({"message":"Error"})
	}
}

function deleteModel(req,res){
	try{
		fs.readFile('./queries/deletemodel.sql', async function (err,data){
			if (err) throw err;
			const queries = data.toString().split(";").map((val)=>`execute immediate '${val}'`)
			const con = await connection()
			con.execute(
			`begin
				${queries.join(";\n")};
			 end;
			`)
				.catch(x=>{console.log("xd:",x);return true;})
				.then(r=>{
					if(r==true){
						res.status(500).json({"Error":"Error al eliminar modelo"})
					}else{
						res.status(200).json({"message":"Model deleted"})
					}
				})
			con.close()
			console.log("[*] Modelo eliminado",new Date())
			})
	}catch (err){
		console.log("aaaaaaaa",err)
		res.status(500).json({"message":"Error"})
	}
}
async function query(req,res,index){
	try{
		console.log(`[*] Consulta ${index+1}`,new Date())
		const con = await connection()
		if (con==null){ throw Error("Conectarse a la base") }
		const result = await con.execute(reports[index],[])
		res.status(200).json(result.rows)
		con.close()
	}catch (err){
		console.log(err)
		res.status(500).json({"message":"Error"})
	}
}
async function query1(req,res){
	query(req,res,0)
}
async function query2(req,res){
	query(req,res,1)
}
async function query3(req,res){
	query(req,res,2)
}
async function query4(req,res){
	query(req,res,3)
}
async function query5(req,res){
	query(req,res,4)
}
async function query6(req,res){
	query(req,res,5)
}
async function query7(req,res){
	query(req,res,6)
}
async function query8(req,res){
	query(req,res,7)
}
async function query9(req,res){
	query(req,res,8)
}
async function query10(req,res){
	query(req,res,9)
}
module.exports = {hola, createTemp, loadData, deleteData,createModel, deleteModel
	,query1,query2,query3,query4,query5,query6,query7,query8,query9,query10}
