import { chromium } from 'playwright';

const base=process.env.JG_SMOKE_URL||'http://127.0.0.1:4173/os.html';
const profiles=[
  ['desktop',{viewport:{width:1440,height:1000},isMobile:false,hasTouch:false}],
  ['iphone',{viewport:{width:390,height:844},isMobile:true,hasTouch:true}],
];
let failed=false;
for(const [name,ctx] of profiles){
  const browser=await chromium.launch({headless:true});
  const context=await browser.newContext(ctx);
  const page=await context.newPage();
  const pageErrors=[]; const badResponses=[];
  page.on('pageerror',e=>pageErrors.push(e.message));
  page.on('response',r=>{try{const u=new URL(r.url());const b=new URL(base);if(r.status()>=400&&u.origin===b.origin)badResponses.push(`${r.status()} ${r.url()}`)}catch{}});
  await page.goto(base,{waitUntil:'networkidle',timeout:30000});
  const frame=page.frameLocator('#os');
  await frame.locator('#auth').waitFor({state:'visible',timeout:10000});
  for(const sel of ['#loginBtn','#showRegister']) await frame.locator(sel).waitFor({state:'visible'});
  if(!(await frame.locator('.loginDiamond').count()))pageErrors.push('Login-Diamant fehlt');

  // Registration must be reachable and usable without horizontal clipping.
  await frame.locator('#showRegister').click();
  const register=frame.locator('#registerForm');
  if(await register.count())await register.waitFor({state:'visible',timeout:5000});
  const metrics=await frame.locator('body').evaluate(el=>({scrollWidth:el.scrollWidth,clientWidth:el.clientWidth}));
  if(metrics.scrollWidth>metrics.clientWidth+4)pageErrors.push(`Horizontales Overflow: ${metrics.scrollWidth}px > ${metrics.clientWidth}px`);

  // Back to login; controls must remain tappable after the view switch.
  const back=frame.locator('#showLogin');
  if(await back.count()){await back.click();await frame.locator('#loginBtn').waitFor({state:'visible'});}

  if(pageErrors.length||badResponses.length){failed=true;console.error(`[${name}] Fehler`,{pageErrors,badResponses});}
  else console.log(`[${name}] Responsive browser smoke OK`);
  await browser.close();
}
if(failed)process.exit(1);
