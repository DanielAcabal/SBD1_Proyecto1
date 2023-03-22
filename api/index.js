const express = require("express");
const dotenv = require("dotenv");
dotenv.config();
const routes = require("./routes/routes");

const app = express();
const port = process.env.PORT ;
app.use(express.json())

routes(app)

app.listen(port,()=>{
	console.log(`Server listening on port ${port}`);
});
