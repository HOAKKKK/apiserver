<?php
// DEFACE - JLG NETWORK
// OWNER : @johenlastgen
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>JOHENLASTGEN</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Fira+Code:wght@400;600&display=swap');

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background: #0a0a0a;
            font-family: 'Fira Code', monospace;
            height: 100vh;
            overflow: hidden;
            position: relative;
            color: #ff2a2a;
        }

        #rainCanvas {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 1;
            pointer-events: none;
            opacity: 0.3;
        }

        .container {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 92%;
            max-width: 1000px;
            z-index: 2;
            text-align: center;
            background: rgba(0, 0, 0, 0.7);
            padding: 30px 20px;
            border: 2px solid #ff2a2a;
            box-shadow: 0 0 30px #ff0000;
            border-radius: 12px;
            backdrop-filter: blur(2px);
        }

        h1 {
            font-size: 42px;
            letter-spacing: 5px;
            text-shadow: 0 0 15px #ff0000, 0 0 30px #ff4444;
            animation: flicker 1.5s infinite;
            color: #ff3a3a;
            margin-bottom: 10px;
            word-break: break-word;
        }

        .label {
            font-size: 22px;
            color: #ff8888;
            margin-bottom: 20px;
            text-transform: uppercase;
            border-bottom: 1px dashed #ff2a2a;
            padding-bottom: 8px;
            display: inline-block;
        }

        .quote {
            font-size: 20px;
            color: #ff6b6b;
            margin: 25px 0;
            padding: 20px;
            border-left: 4px solid #ff2a2a;
            border-right: 4px solid #ff2a2a;
            font-style: italic;
            line-height: 1.6;
            text-shadow: 0 0 8px #ff0000;
            background: rgba(255, 0, 0, 0.05);
            animation: glowPulse 3s infinite;
        }

        .terminal {
            text-align: left;
            background: #110000;
            border: 2px solid #ff2a2a;
            padding: 25px;
            margin: 25px 0;
            border-radius: 8px;
            box-shadow: inset 0 0 20px #330000, 0 0 20px #ff0000;
        }

        .terminal pre {
            color: #ff5a5a;
            font-size: 16px;
            line-height: 1.8;
            white-space: pre-wrap;
            word-wrap: break-word;
            text-shadow: 0 0 5px #ff0000;
            font-family: 'Fira Code', monospace;
        }

        .glitch {
            font-size: 20px;
            font-weight: bold;
            color: #ff2a2a;
            margin: 15px 0;
            animation: glitch 2s infinite;
        }

        .owner {
            font-size: 18px;
            margin-top: 15px;
            color: #ff8888;
        }

        .owner a {
            color: #ff2a2a;
            text-decoration: none;
            border-bottom: 1px dotted #ff2a2a;
        }

        .owner a:hover {
            text-shadow: 0 0 10px red;
        }

        .contact {
            margin-top: 10px;
            font-size: 16px;
        }

        .contact a {
            color: #ff4d4d;
            text-decoration: none;
        }

        audio {
            margin-top: 20px;
            filter: drop-shadow(0 0 8px #ff0000);
            width: 80%;
            max-width: 400px;
        }

        @keyframes flicker {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.6; text-shadow: 0 0 25px #ff3333; }
        }

        @keyframes glitch {
            0% { transform: translate(0); }
            20% { transform: translate(-3px, 2px); }
            40% { transform: translate(3px, -2px); }
            60% { transform: translate(-2px, 1px); }
            80% { transform: translate(2px, -1px); }
            100% { transform: translate(0); }
        }

        @keyframes glowPulse {
            0%, 100% { text-shadow: 0 0 8px #ff0000; }
            50% { text-shadow: 0 0 20px #ff4444, 0 0 30px #ff0000; }
        }

        .cursor {
            display: inline-block;
            width: 12px;
            height: 22px;
            background: #ff2a2a;
            vertical-align: middle;
            margin-left: 5px;
            animation: blink 1s infinite;
        }

        @keyframes blink {
            0%, 100% { opacity: 1; }
            50% { opacity: 0; }
        }
    </style>
</head>
<body>

    <canvas id="rainCanvas"></canvas>

    <div class="container">
        <h1>./johenlastgen</h1>
        <div class="label">JLG NETWORK</div>

        <!-- Quote pertama -->
        <div class="quote">
            "Sometimes kita harus ninggalin orang yang kita sayang banget,<br>
             untuk nemuin orang yang sayang banget ke kita."
        </div>

        <div class="terminal">
            <pre>
[ JLG NETWORK ACCESS ]

> System : JLG TERMINAL 
> Target : ./johenlastgen
> Status : 🔴 HACKED

"“Nyatanya, manusia hanya perlu terbiasa. Seperti terbiasa bertemu, terbiasa berbicara, 
  terbiasa tertawa bareng. Termasuk juga, terbiasa lupa, terbiasa tidak dengannya.”"

Kami bukan perusak, kami pengingat.
Your security is a joke.
We are JLG NETWORK.

~ ./johenlastgen
            </pre>
        </div>

        <div class="glitch">
            ⚡ ACCESS GRANTED ⚡
        </div>

        <div class="owner">
            Owner : <a href="https://t.me/johenlastgen" target="_blank">@johenlastgen</a>
            <span class="cursor"></span>
        </div>

        <div class="contact">
            Channel : <a href="https://t.me/JLGNETWORKREDIRECT" target="_blank">t.me/JLGNETWORKREDIRECT</a>
        </div>

        <!-- Audio: -->
        <audio controls autoplay loop>
            <source src="https://raw.githubusercontent.com/HOAKKKK/apiserver/refs/heads/main/ssstik.io_1771241509910.mp3" type="audio/mpeg">
            Browser tidak mendukung audio.
        </audio>
        <div style="color:#ff8888; font-size:12px; margin-top:5px;">♫ Dengar Laraku</div>
    </div>

    <script>
        const canvas = document.getElementById('rainCanvas');
        const ctx = canvas.getContext('2d');

        let w = canvas.width = window.innerWidth;
        let h = canvas.height = window.innerHeight;

        const fontSize = 24;
        const columns = Math.floor(w / fontSize);
        const drops = [];
        for (let i = 0; i < columns; i++) {
            drops[i] = Math.floor(Math.random() * -100);
        }

        const chars = "01アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲンABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()_+[]{};:.<>?";

        function drawRain() {
            ctx.fillStyle = 'rgba(10, 0, 0, 0.05)';
            ctx.fillRect(0, 0, w, h);

            ctx.fillStyle = '#ff2a2a';
            ctx.font = fontSize + 'px "Fira Code", monospace';
            ctx.shadowColor = '#ff0000';
            ctx.shadowBlur = 10;

            for (let i = 0; i < drops.length; i++) {
                const text = chars[Math.floor(Math.random() * chars.length)];
                const x = i * fontSize;
                const y = drops[i] * fontSize;

                ctx.fillText(text, x, y);

                if (y > h && Math.random() > 0.975) {
                    drops[i] = 0;
                }
                drops[i]++;
            }
            requestAnimationFrame(drawRain);
        }

        drawRain();

        window.addEventListener('resize', () => {
            w = canvas.width = window.innerWidth;
            h = canvas.height = window.innerHeight;
            const newColumns = Math.floor(w / fontSize);
            if (newColumns > drops.length) {
                for (let i = drops.length; i < newColumns; i++) {
                    drops[i] = Math.floor(Math.random() * -50);
                }
            } else {
                drops.length = newColumns;
            }
        });
    </script>
</body>
</html>
