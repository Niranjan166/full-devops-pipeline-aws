const express = require("express");
const router = express.Router();

const upload = require("../middleware/upload");

const {
    getAllDocuments,
    uploadDocument,
    deleteDocument
} = require("../controllers/documentController");

router.get("/", getAllDocuments);

router.post("/", upload.single("document"), uploadDocument);

router.delete("/:id", deleteDocument);

module.exports = router;