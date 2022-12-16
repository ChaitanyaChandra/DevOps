const express = require('express');
const bodyParser = require('body-parser');
var child_process = require("child_process");


let user = "chaitu"
let password = "@123Chaitu"


const app = express()
const port = 8080

app.use(express.static('public'))
app.use(express.static('views/public'))

app.set('view engine', 'pug')
app.use(bodyParser.urlencoded({
    extended: false
}))

app.get('/health', (req, res) => {
    var stat = {
        app: 'OK'
    };
    res.json(stat);
});

app.get('/', function(req, res) {
    res.sendFile('public/index.html', {
        root: __dirname
    })
})

app.post('/', function(req, res) {
    if ((user == req.body.username) && (password == req.body.password)) {
        const command_data = {};
        command_data.items = [];
        let cmd_hostname = child_process.execSync("hostname");
        command_data.items[0] = {hostname : (cmd_hostname.toString())}
        let cmd_uptime = child_process.execSync("uptime");
        command_data.items[1] = {uptime : (cmd_uptime.toString())}
        let cmd_lscpu = child_process.execSync("cat /proc/cpuinfo");
        command_data.items[2] = {lscpu : cmd_lscpu.toString()}
        let cmd_memoryInfo = child_process.execSync("cat /proc/meminfo");
        command_data.items[3] = {meminfo : cmd_memoryInfo.toString()}
        // .replace(/\n?\r\n/g, '<br />' )
        console.log(command_data)
        res.render('spec', {
            hostname: command_data.items[0].hostname,
            uptime: command_data.items[1].uptime,
            lscpu: command_data.items[2].lscpu,
            meminfo: command_data.items[3].meminfo,
            dev: "chaitanya chandra (chay@outlook.in)"
        })        
        
    } else {
        res.sendFile('public/index.html', {
            root: __dirname
        })
    }
})

app.use((error, req, res, next) => {
    res.status(error.status || 500).send({
        error: {
            status: error.status || 500,
            message: error.message || 'Internal Server Error',
        },
    });
    res.sendFile('public/error.html', {
        root: __dirname
    })
});

app.use(function(req, res, next){
    res.status(404);
    res.sendFile('public/error.html', {
        root: __dirname
    })
})

app.listen(process.env.PORT || port, () => {
    console.log(`leads app listening at http://localhost:${port}`)
})
