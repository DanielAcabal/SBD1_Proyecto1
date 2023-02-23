const oracle = require("oracledb");
oracle.outFormat = oracle.OUT_FORMAT_OBJECT;

async function getConnection(){
	try{
		const connection =  await oracle.getConnection({
			user: process.env.DB_USER,
			password: process.env.DB_PASSWORD,
			connectString: process.env.URL
		});
		return connection
	} catch (err){
		console.log(err)
	}
	return null
}
module.exports = getConnection() 
