var express = require("express");
const db = require("../database/db");
var router = express.Router();

var getCommentsFromMotorbike = (motorbikeId) =>
  new Promise((resolve, reject) => {
    db.query(
      "SELECT * FROM comments WHERE motorbikeId = ?",
      [motorbikeId],
      (error, result) => {
        if (!!error) reject(error);
        resolve(result);
      }
    );
  });

var postComments = (motorbikeId, userId, commentText, commentDate) =>
  new Promise((resolve, reject) => {
    db.query(
      "INSERT INTO comments (motorbikeId, userId, commentText, commentDate) VALUES (?, ?, ?, ?)",
      [motorbikeId, userId, commentText, commentDate],
      (error, result) => {
        if (!!error) reject(error);
        resolve(result);
      }
    );
  });

router.post("/post", function (req, res, next) {
  const body = req.body;
  postComments(
    body.motorbikeId,
    body.userId,
    body.commentText,
    body.commentDate
  ).then(
    (result) => {
      res.status(200).json(result);
    },
    (error) => {
      res.status(500).send(error);
    }
  );
});

router.get("/get/:id", function (req, res, next) {
  getCommentsFromMotorbike(req.params.id).then(
    (result) => {
      res.status(200).json(result);
    },
    (error) => {
      res.status(500).send(error);
    }
  );
});

module.exports = router;
