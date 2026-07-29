const pool = require("../config/db");

// Get all documents
const getAllDocuments = async (req, res) => {
    try {
        const [rows] = await pool.query("SELECT * FROM documents");

        res.status(200).json(rows);
    } catch (error) {
        console.error(error);

        res.status(500).json({
            message: "Failed to fetch documents"
        });
    }
};

// Upload document
const uploadDocument = async (req, res) => {
    try {
        const { title, description, uploaded_by } = req.body;

        if (!req.file) {
            return res.status(400).json({
                message: "Please upload a file"
            });
        }

        const query = `
            INSERT INTO documents
            (title, description, file_name, file_path, file_type, file_size, uploaded_by)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        `;

        await pool.query(query, [
            title,
            description,
            req.file.filename,
            req.file.path,
            req.file.mimetype,
            req.file.size,
            uploaded_by || 1
        ]);

        res.status(201).json({
            success: true,
            message: "Document uploaded successfully"
        });

    } catch (error) {
        console.error(error);

        res.status(500).json({
            message: "Upload failed"
        });
    }
};

// delete document
const fs = require("fs");

const deleteDocument = async (req, res) => {
    try {
        const { id } = req.params;

        // Get file path
        const [rows] = await pool.query(
            "SELECT file_path FROM documents WHERE id = ?",
            [id]
        );

        if (rows.length === 0) {
            return res.status(404).json({
                message: "Document not found"
            });
        }

        // Delete file from uploads folder
        if (fs.existsSync(rows[0].file_path)) {
            fs.unlinkSync(rows[0].file_path);
        }

        // Delete record from database
        await pool.query(
            "DELETE FROM documents WHERE id = ?",
            [id]
        );

        res.json({
            success: true,
            message: "Document deleted successfully"
        });

    } catch (error) {
        console.error(error);

        res.status(500).json({
            message: "Delete failed"
        });
    }
};

module.exports = {
    getAllDocuments,
    uploadDocument,
    deleteDocument
};