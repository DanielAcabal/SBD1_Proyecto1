const router = require("express").Router();
const controller = require("../controller/controller")

function routes(app){
	router.get("/hola",controller.hola)
	router.get("/createTemp",controller.createTemp)
	router.get("/eliminarTemporal",controller.deleteData)
	router.get("/cargarTemporal",controller.loadData)
	router.get("/cargarModelo",controller.createModel)
	router.get("/eliminarModelo",controller.deleteModel)
	app.use(router)
}
module.exports = routes 
