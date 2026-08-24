import { chromium } from 'playwright';

const base='http://127.0.0.1:4173/os.html';
const viewports=[['desktop',{width:1440,height:1000}],['mobile',{width:390,height:844}]];
let failed=false;
for(const [name,viewport] of viewports){
  const browser=await chromium.launch({headless:true});
  const page=await browser.newPage({viewportSize:viewport});
  const pageErrors=[]; const badResponses=[];
  page.on('pageerror',e=>pageErrors.push(e.message));
  page.on('response',r=>{if(r.status()>=400 && new URL(r.url()).origin==='http://127.0.0.1:4173')badResponses.push(`${r.status()} ${r.url()}`)});
  await page.goto(base,{waitUntil:'networkidle'});
  const frame=page.frameLocator('#os');
  await frame.locator('#auth').waitFor({state:'visible',timeout:10000});
  await frame.locator('#loginBtn').waitFor({state:'visible'});
  await frame.locator('#showRegister').waitFor({state:'visible'});
  const diamond=await frame.locator('.loginDiamond').count();
  if(!diamond) pageErrors.push('Login-Diamant fehlt');
  if(pageErrors.length||badResponses.length){
    failed=true;
    console.error(`[${name}] Fehler`,{pageErrors,badResponses});
  } else console.log(`[${name}] Browser smoke OK`);
  await browser.close();
}
if(failed)process.exit(1);
