let con;
const connection = require("../connection/connection")
	.then(res=>con=res)
const fs = require("fs")
const readline = require("readline")

function hola(req,res){
	res.send("Hola")
}
function createTemp(req,res){
	try{
		fs.readFile('./queries/createTemp.sql', function (err,data){
			if (err) throw err;
			con.execute(data.toString())
				.catch(x=>x.errorNum==955)
				.then(r=>{
					if(r==true){
						res.status(500).json({"Error":"Ya existe"})
					}else{
						res.status(200).json({"message":"Table created"})
					}
				})
			})
	}catch (err){
		console.log("aaaaaaaa",err)
		res.json({"message":"Error"})
	}
}

function loadData(req,res){
	if(!con){ return res.json({"Error":"Conectarse a la base de datos"}) }
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
		const result =  await con.executeMany(`INSERT INTO temporal (${fields}) VALUES (${binds.join(",")})`,[data[0]])
		console.log(result.rowsAffected)
		con.commit()
		res.json({"Hola":"xd"})
	})
}
async function deleteData(req,res){
	if(!con){return res.statusCode(500).json({"Error":"Conectarse a base de datos"})}
	await con.execute("DELETE temporal")
	res.status(200).json({"message":"Table 'temporal' deleted"})
}

module.exports = {hola, createTemp, loadData, deleteData}
