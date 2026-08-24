import fs from 'node:fs';
import path from 'node:path';
import {execFileSync} from 'node:child_process';

const root=process.cwd();
const osPath=path.join(root,'os.html');
if(!fs.existsSync(osPath)) throw new Error('os.html fehlt');
const os=fs.readFileSync(osPath,'utf8');
const refs=[...os.matchAll(/(?:src|href)=['\"]([^'\"]+\.(?:js|css))(?:\?[^'\"]*)?['\"]/g)].map(m=>m[1]);
const missing=refs.filter(r=>!fs.existsSync(path.join(root,r)));
if(missing.length){console.error('Fehlende Preview-Dateien:',missing);process.exit(1)}

const jsFiles=fs.readdirSync(root).filter(f=>f.endsWith('.js'));
for(const f of jsFiles){
  try{execFileSync(process.execPath,['--check',path.join(root,f)],{stdio:'pipe'})}
  catch(e){console.error('JavaScript Syntaxfehler in',f);console.error(e.stderr?.toString()||e.message);process.exit(1)}
}

const activeFiles=[...new Set(refs.filter(r=>r.endsWith('.js')))];
const forbidden=[/\bPersonenschutz\b/i,/\bGold\b/i,/\bPlatin\b/i,/Commercial Documents/i,/KI-Endpunkt/i];
const hits=[];
for(const f of activeFiles){
  const txt=fs.readFileSync(path.join(root,f),'utf8');
  for(const rx of forbidden) if(rx.test(txt)) hits.push(`${f}: ${rx}`);
}
if(hits.length){console.error('Veraltete Kundensprache in aktiven Runtime-Dateien:',hits);process.exit(1)}

console.log(`Release smoke OK · ${refs.length} Preview-Referenzen vorhanden · ${jsFiles.length} JS-Dateien syntaktisch geprüft · keine verbotenen Altbegriffe in aktiven Runtimes.`);
