const express = require("express");
const cors = require("cors");
const documentRoutes = require("./routes/documentRoutes");
const path = require("path");

const app = express();
const authRoutes = require("./routes/authRoutes");

//middleware
app.use(express.json());
app.use(cors());
app.use("/uploads", express.static(path.join(__dirname, "uploads")));

//default route
app.get("/", (req, res) => {
    res.send("Welcome to the Document Management System API");
});

app.use("/documents", documentRoutes);
app.use("/auth", authRoutes);

module.exports = app;