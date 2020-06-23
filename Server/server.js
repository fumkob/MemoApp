const mysql = require('mysql');
const express = require('express');
const bodyParser = require('body-parser');
const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'Temp1234',
    database: 'memodb'
});
const app = express();
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

connection.connect();

//DBから取得->JSON出力
app.get('/get', function(req, res) {
    connection.query('SELECT * FROM memos ORDER BY created DESC LIMIT 100;', function(error,results,fields) {
        if (error) throw error;
        res.send(results);
    });
});

//JSON入力->DBへ投稿
app.post('/post', function(req, res) {
    const memo = req.body.memo;
    
    connection.query('INSERT INTO memos(memo) VALUES(?);',[memo], function(error, results, fields) {
        if (error) throw error;
        console.log(results);
        res.send(results);
    });
});

const port = process.removeListener.PORT || 3000;
app.listen(port);
console.log('Server is now online...');
