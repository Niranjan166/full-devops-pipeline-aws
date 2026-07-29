const app = require("./app");
const PORT = process.env.PORT || 3000;
const pool = require("./config/db");

async function testDatabaseConnection() {
    try {
        const connection = await pool.getConnection();
        console.log("✅ Connected to MySQL Database");
        connection.release();
    } catch (error) {
        console.error("❌ Database Connection Failed");
        console.error(error.message);
        process.exit(1);
    }
}

testDatabaseConnection();

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});