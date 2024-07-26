var express = require("express");
var router = express.Router();
var session = require("express-session");

var passport = require("passport");
var GoogleStrategy = require("passport-google-oauth20").Strategy;
var db = require("../database/db");
var jwt = require("jsonwebtoken");

router.use(
  session({
    secret: process.env.API_SECRET,
    resave: false,
    saveUninitialized: false,
  })
);

passport.use(
  new GoogleStrategy(
    {
      clientID: process.env.GOOGLE_CLIENT_ID,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET,
      callbackURL: "http://localhost:3000/google/auth/google/callback",
    },
    function (accessToken, refreshToken, profile, cb) {
      // console.log(profile.id);
      db.query(
        "select username from msuser where oauth_id = ?",
        [profile.id],
        (error, result) => {
          if (!!error) cb();

          if (result.length === 0) {
            db.query(
              "insert into users (username, oauth_id) value (?, ?)",
              [profile.displayName, profile.id],
              (error, result) => {
                if (!!error) cb(error);
                const token = jwt.sign(
                  {
                    username: profile.displayName,
                  },
                  process.env.API_SECRET,
                  { expiresIn: "1h" }
                );

                cb(null, {
                  username: profile.displayName,
                  token: token,
                });
              }
            );
          } else {
            const token = jwt.sign(
              {
                username: profile.displayName,
              },
              process.env.API_SECRET,
              { expiresIn: "1h" }
            );

            cb(null, {
              username: profile.displayName,
              token: token,
            });
          }
        }
      );
    }
  )
);

passport.serializeUser(function (user, cb) {
  process.nextTick(function () {
    cb(null, { id: user.id, username: user.username, name: user.name });
  });
});

passport.deserializeUser(function (user, cb) {
  process.nextTick(function () {
    return cb(null, user);
  });
});

router.get(
  "/auth/google",
  passport.authenticate("google", { scope: ["profile"] })
);

router.get(
  "/auth/google/callback",
  passport.authenticate("google", { failureRedirect: "/login" }),
  function (req, res) {
    // Successful authentication, redirect home.
    // res.redirect("/");
    // Edited to return user json instead
    res.status(200).json(req.user);
  }
);

module.exports = router;
