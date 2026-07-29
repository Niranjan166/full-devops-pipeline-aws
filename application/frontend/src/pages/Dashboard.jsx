import { useEffect, useState } from "react";
import api from "../services/api";

function Dashboard() {
    const [title, setTitle] = useState("");
    const [description, setDescription] = useState("");
    const [file, setFile] = useState(null);
    const [documents, setDocuments] = useState([]);

    const fetchDocuments = async () => {
        try {
            const res = await api.get("/documents");
            setDocuments(res.data);
        } catch (err) {
            console.error(err);
        }
    };

    useEffect(() => {
        fetchDocuments();
    }, []);

    const handleUpload = async () => {
        if (!file) {
            alert("Please select a file");
            return;
        }

        const formData = new FormData();

        formData.append("title", title);
        formData.append("description", description);

        // IMPORTANT: This must match upload.single("document")
        formData.append("document", file);

        formData.append("uploaded_by", 1);

        try {
            await api.post("/documents", formData);

            alert("Document uploaded successfully");

            setTitle("");
            setDescription("");
            setFile(null);

            fetchDocuments();

        } catch (err) {
            console.error(err);
            alert("Upload failed");
        }
    };

    return (
        <div className="container">

            <h1>Document Management System</h1>

            <h2>Upload Document</h2>

            <input
                type="text"
                placeholder="Title"
                value={title}
                onChange={(e) => setTitle(e.target.value)}
            />

            <input
                type="text"
                placeholder="Description"
                value={description}
                onChange={(e) => setDescription(e.target.value)}
            />

            <input
                type="file"
                onChange={(e) => setFile(e.target.files[0])}
            />

            <button onClick={handleUpload}>
                Upload
            </button>

            <button
                onClick={() => {
                    localStorage.removeItem("token");
                     window.location.reload();
             }}
>
    Logout
</button>

            <hr />

            <h2>Uploaded Documents</h2>

            {documents.map((doc) => (
    <div
        key={doc.id}
        style={{
            display: "flex",
            justifyContent: "space-between",
            alignItems: "center",
            marginBottom: "10px",
            borderBottom: "1px solid #ddd",
            paddingBottom: "8px"
        }}
    >
        <div>
            <strong>{doc.title}</strong>
            <br />
            <small>{doc.description}</small>
        </div>

        <button
            onClick={async () => {
                try {
                    await api.delete(`/documents/${doc.id}`);

                    alert("Document deleted");

                    fetchDocuments();

                } catch (err) {
                    console.error(err);
                    alert("Delete failed");
                }
            }}
        >
            Delete
        </button>
    </div>
))}

        </div>
    );
}

export default Dashboard;