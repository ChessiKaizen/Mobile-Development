const express = require("express");
const jwt = require("jsonwebtoken");
const cors = require("cors");

const app = express();

app.use(express.json());
app.use(cors());

const SECRET = "my-secret-key";


// -------------------- DATA --------------------

const users = [
    {
        id: 1,
        name: "john",
        password: "1234",
        role: "student"
    },
    {
        id: 2,
        name: "alice",
        password: "abcd",
        role: "student"
    },
    {
        id: 3,
        name: "teacher",
        password: "admin",
        role: "teacher"
    }
];


const scores = [
    {
        id: 1,
        userId: 1,
        title: "Flutter Quiz",
        score: 85
    },
    {
        id: 2,
        userId: 1,
        title: "Dart Exercise",
        score: 90
    },
    {
        id: 3,
        userId: 2,
        title: "Flutter Quiz",
        score: 75
    },
    {
        id: 4,
        userId: 3,
        title: "Teacher Evaluation",
        score: 100
    }
];


// -------------------- LOGIN --------------------

app.post("/login", (req, res) => {

    const { name, password } = req.body;

    console.log("POST /login", name);


    const user = users.find(
        u => u.name === name && u.password === password
    );


    if (!user) {

        console.log(" -> Invalid credentials");

        return res
            .status(401)
            .json({ error: "Invalid credentials" });
    }


    const token = jwt.sign(
        {
            userId: user.id,
            name: user.name,
            role: user.role
        },
        SECRET,
        {
            expiresIn: "1h"
        }
    );


    console.log(" -> JWT created for", user.name);


    res.json({
        token: token,
        user: {
            id: user.id,
            name: user.name,
            role: user.role
        }
    });

});


// -------------------- AUTH MIDDLEWARE --------------------

function authenticateToken(req, res, next) {

    const authHeader = req.headers.authorization;


    if (!authHeader) {
        return res.status(401).json({
            error: "No token"
        });
    }


    const token = authHeader.split(" ")[1];


    try {

        const user = jwt.verify(token, SECRET);

        req.user = user;

        next();

    } catch(error) {

        return res.status(401).json({
            error: "Invalid token"
        });
    }

}



// -------------------- GET ALL SCORES --------------------

app.get("/scores", (req, res) => {

    console.log("GET /scores");

    res.json(scores);

});



// -------------------- GET USER SCORES --------------------

app.get("/scores/user/:userId", authenticateToken, (req, res) => {


    const userId = Number(req.params.userId);


    console.log(
        "GET /scores/user/",
        userId
    );


    const userScores = scores.filter(
        s => s.userId === userId
    );


    res.json(userScores);

});



// -------------------- START SERVER --------------------

app.listen(3000, () =>
    console.log(
        "Server running on http://localhost:3000"
    )
);