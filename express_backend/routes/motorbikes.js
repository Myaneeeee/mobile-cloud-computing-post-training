var express = require("express");
var router = express.Router();
var db = require("../database/db");
var multer = require("multer");
var auth = require("./../middleware/auth");

var storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "public/images");
  },
  filename: (req, file, cb) => {
    cb(null, `${Date.now()}${file.originalname}`);
  },
});

var upload = multer({
  storage: storage,
});

var createMotorbikes = (
  motorbikeName,
  motorbikePrice,
  motorbikeDescription,
  motorbikeImage
) =>
  new Promise((resolve, reject) => {
    db.query(
      "INSERT INTO msmotorbike (motorbikeName, motorbikePrice, motorbikeDescription, motorbikeImage) value (?, ?, ?, ?)",
      [motorbikeName, motorbikePrice, motorbikeDescription, motorbikeImage],
      (error, result) => {
        if (!!error) reject(error);
        resolve(result);
      }
    );
  });

var getMotorbikes = new Promise((resolve, reject) => {
  db.query("SELECT * FROM msmotorbike", (error, result) => {
    if (!!error) reject(error);
    resolve(result);
  });
});

var getMotorbikesById = (id) =>
  new Promise((resolve, reject) => {
    db.query(
      "SELECT * FROM msmotorbike where motorbikeId = ?",
      [id],
      (error, result) => {
        if (!!error) reject(error);
        resolve(result);
      }
    );
  });

var deleteMotorbike = (id) =>
  new Promise((resolve, reject) => {
    db.query(
      "DELETE FROM msmotorbike WHERE motorbikeId = ?",
      [id],
      (error, result) => {
        if (!!error) reject(error);
        resolve(result);
      }
    );
  });

router.use(auth);

router.post("/create", upload.single("image"), function (req, res, next) {
  const body = req.body;
  createMotorbikes(
    body.motorbikeName,
    body.motorbikePrice,
    body.motorbikeDescription,
    req.file.path.replace("public\\", "")
  ).then(
    (result) => {
      res.status(200).json(result);
    },
    (error) => {
      res.status(500).send(error);
    }
  );
});

router.get("/", function (req, res, next) {
  getMotorbikes.then(
    (result) => {
      res.status(200).json(result);
    },
    (error) => {
      res.status(500).send(error);
    }
  );
});

router.get("/get/:id", function (req, res, next) {
  getMotorbikesById(req.params.id).then(
    (result) => {
      res.status(200).json(result);
    },
    (error) => {
      res.status(500).send(error);
    }
  );
});

router.delete("/delete/:id", function (req, res, next) {
  deleteMotorbike(req.params.id).then(
    (result) => {
      res
        .status(200)
        .json({ message: "Motorbike deleted successfully", result });
    },
    (error) => {
      res.status(500).send(error);
    }
  );
});

module.exports = router;
