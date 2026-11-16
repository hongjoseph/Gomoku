import fs from 'node:fs';
const assets={};for(const f of ['index.html','style.css','game.js','club.js','club.css'])assets['/'+(f==='index.html'?'':f)]={body:fs.readFileSync('web/'+f,'utf8'),type:f.endsWith('.css')?'text/css':f.endsWith('.js')?'application/javascript':'text/html'};
fs.rmSync('dist',{recursive:true,force:true});fs.mkdirSync('dist/server',{recursive:true});fs.writeFileSync('dist/server/index.js','const ASSETS='+JSON.stringify(assets)+';\n'+['auth.js','training.js','npcs.js','index.js'].map(f=>fs.readFileSync('worker/'+f,'utf8')).join('\n'));

console.log('Built Worker and embedded web assets.');
