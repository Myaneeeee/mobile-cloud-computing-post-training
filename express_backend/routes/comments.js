var express = require("express");
const db = require("../database/db");
var router = express.Router();
var auth = require("./../middleware/auth");

var getCommentsFromMotorbike = (motorbikeId) =>
  new Promise((resolve, reject) => {
    db.query(
      `SELECT c.commentText, c.commentDate, u.username
       FROM comments c
       JOIN msuser u ON c.userId = u.userId
       WHERE c.motorbikeId = ?`,
      [motorbikeId],
      (error, result) => {
        if (error) reject(error);
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
        if (error) reject(error);
        resolve(result);
      }
    );
  });

var updateComment = (commentId, commentText, commentDate) =>
  new Promise((resolve, reject) => {
    db.query(
      "UPDATE comments SET commentText = ?, commentDate = ? WHERE commentId = ?",
      [commentText, commentDate, commentId],
      (error, result) => {
        if (error) reject(error);
        resolve(result);
      }
    );
  });

var deleteComment = (commentId) =>
  new Promise((resolve, reject) => {
    db.query(
      "DELETE FROM comments WHERE commentId = ?",
      [commentId],
      (error, result) => {
        if (error) reject(error);
        resolve(result);
      }
    );
  });

// router.use(auth);

router.post("/post", function (req, res, next) {
  const body = req.body;
  const commentDate = new Date();
  postComments(
    body.motorbikeId,
    body.userId,
    body.commentText,
    commentDate
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

router.put("/edit/:id", function (req, res, next) {
  const commentId = req.params.id;
  const { commentText } = req.body;
  const commentDate = new Date();
  updateComment(commentId, commentText, commentDate).then(
    (result) => {
      res.status(200).json(result);
    },
    (error) => {
      res.status(500).send(error);
    }
  );
});

router.delete("/delete/:id", function (req, res, next) {
  const commentId = req.params.id;
  deleteComment(commentId).then(
    (result) => {
      res.status(200).json(result);
    },
    (error) => {
      res.status(500).send(error);
    }
  );
});

module.exports = router;
