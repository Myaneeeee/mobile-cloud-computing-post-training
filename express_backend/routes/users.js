const express = require("express");
const router = express.Router();
const db = require("../database/db");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

// Register Route
router.post("/register", async (req, res) => {
  const { username, email, password } = req.body;

  try {
    // Check if the email or username already exists
    const checkQuery = "SELECT * FROM msuser WHERE email = ? OR username = ?";
    const checkResult = await new Promise((resolve, reject) => {
      db.query(checkQuery, [email, username], (error, results) => {
        if (error) return reject(error);
        resolve(results);
      });
    });

    if (checkResult.length > 0) {
      return res
        .status(400)
        .json({ error: "Email or username already exists" });
    }

    // Proceed with registration
    const hashedPassword = await bcrypt.hash(password, 10);
    await new Promise((resolve, reject) => {
      db.query(
        "INSERT INTO msuser (username, email, password) VALUES (?, ?, ?)",
        [username, email, hashedPassword],
        (error, result) => {
          if (error) return reject(error);
          resolve(result);
        }
      );
    });
    res.status(201).json({ message: "Registration successful" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Login Route
router.post("/login", async (req, res) => {
  const { email, password } = req.body;

  try {
    const result = await new Promise((resolve, reject) => {
      db.query(
        "SELECT id, username, password FROM msuser WHERE email = ?",
        [email],
        (error, results) => {
          if (error) return reject(error);
          if (results.length === 0) return reject(new Error("User not found"));
          resolve(results);
        }
      );
    });

    const user = result[0];
    const isMatch = await bcrypt.compare(password, user.password);

    if (isMatch) {
      const token = jwt.sign(
        { username: user.username },
        process.env.API_SECRET,
        { expiresIn: "1d" }
      );
      res.status(200).json({ id: user.id, username: user.username, token });
    } else {
      res.status(400).json({ error: "Invalid credentials" });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.post("/logout", (req, res) => {
  res.status(200).json({ message: "Logged out successfully" });
});

module.exports = router;
