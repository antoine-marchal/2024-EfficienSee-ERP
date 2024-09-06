const express = require("express");
const cors = require("cors");
const mongoose = require("mongoose");
require("dotenv").config();

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Connect to MongoDB
mongoose
  .connect(process.env.MONGODB_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("Connected to MongoDB"))
  .catch((err) => console.error("Could not connect to MongoDB", err));

// Routes
app.get("/", (req, res) => {
  res.send("Welcome to EfficienSee ERP API");
});

// Start server
const PORT = process.env.PORT || 5173;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
