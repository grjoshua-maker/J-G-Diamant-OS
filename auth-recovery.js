(()=>{
const U='https://qgrsbqzhbifbyyfbslyh.supabase.co';
const K='sb_publishable_DKxNrYb1zbLkKyQQ_LAh2w_B0NRK72k';
function install(){
  const btn=document.querySelector('#loginBtn');
  if(!btn||document.querySelector('#forgotPasswordBtn'))return;
  const forgot=document.createElement('button');
  forgot.type='button';
  forgot.id='forgotPasswordBtn';
  forgot.textContent='Passwort vergessen?';
  forgot.style.cssText='display:block;width:100%;margin:10px 0 0;padding:8px;border:0;background:transparent;color:#d9bc6a;font:inherit;text-decoration:underline;cursor:pointer';
  btn.insertAdjacentElement('afterend',forgot);

  const box=document.createElement('div');
  box.id='passwordRecoveryBox';
  box.hidden=true;
  box.style.cssText='margin-top:12px;padding-top:12px;border-top:1px solid rgba(217,188,106,.25)';
  box.innerHTML='<input id="recoveryEmail" type="email" placeholder="E-Mail" style="box-sizing:border-box;width:100%;margin:6px 0"><button type="button" class="btn" id="sendRecoveryBtn" style="width:100%;margin-top:8px">RESET-LINK SENDEN</button><div class="msg" id="recoveryMsg" style="margin-top:10px"></div>';
  forgot.insertAdjacentElement('afterend',box);
  forgot.onclick=()=>{box.hidden=!box.hidden};
  box.querySelector('#sendRecoveryBtn').onclick=async()=>{
    const email=box.querySelector('#recoveryEmail').value.trim();
    const msg=box.querySelector('#recoveryMsg');
    if(!email){msg.textContent='Bitte E-Mail-Adresse eingeben.';return}
    msg.textContent='Reset-Link wird gesendet …';
    try{
      const redirect=location.origin+location.pathname;
      const r=await fetch(U+'/auth/v1/recover?redirect_to='+encodeURIComponent(redirect),{method:'POST',headers:{apikey:K,'Content-Type':'application/json'},body:JSON.stringify({email}),cache:'no-store'});
      if(!r.ok)throw new Error('Reset konnte nicht gesendet werden.');
      msg.textContent='E-Mail versendet. Bitte den Link in der E-Mail öffnen.';
    }catch(e){msg.textContent=e.message||'Reset konnte nicht gesendet werden.'}
  };

  const h=new URLSearchParams(location.hash.replace(/^#/,''));
  const q=new URLSearchParams(location.search);
  const type=h.get('type')||q.get('type');
  const token=h.get('access_token')||q.get('access_token');
  if(type==='recovery'&&token){
    document.querySelector('#auth')?.classList.remove('hidden');
    document.querySelector('#auth .form')?.setAttribute('style','display:none');
    btn.style.display='none';
    document.querySelector('#showRegister')?.setAttribute('style','display:none');
    forgot.style.display='none';
    box.hidden=false;
    box.innerHTML='<input id="newPassword" type="password" placeholder="Neues Passwort (mind. 10 Zeichen)" style="box-sizing:border-box;width:100%;margin:6px 0"><input id="newPassword2" type="password" placeholder="Passwort wiederholen" style="box-sizing:border-box;width:100%;margin:6px 0"><button type="button" class="btn" id="saveNewPassword" style="width:100%;margin-top:8px">NEUES PASSWORT SPEICHERN</button><div class="msg" id="recoveryMsg" style="margin-top:10px"></div>';
    box.querySelector('#saveNewPassword').onclick=async()=>{
      const p=box.querySelector('#newPassword').value;
      const p2=box.querySelector('#newPassword2').value;
      const msg=box.querySelector('#recoveryMsg');
      if(p.length<10){msg.textContent='Das Passwort muss mindestens 10 Zeichen haben.';return}
      if(p!==p2){msg.textContent='Die Passwörter stimmen nicht überein.';return}
      msg.textContent='Passwort wird gespeichert …';
      try{
        const r=await fetch(U+'/auth/v1/user',{method:'PUT',headers:{apikey:K,Authorization:'Bearer '+token,'Content-Type':'application/json'},body:JSON.stringify({password:p}),cache:'no-store'});
        if(!r.ok)throw new Error('Passwort konnte nicht gespeichert werden.');
        localStorage.removeItem('jgos:session');
        history.replaceState(null,'',location.pathname);
        msg.textContent='Passwort geändert. Sie können sich jetzt anmelden.';
        setTimeout(()=>location.reload(),900);
      }catch(e){msg.textContent=e.message||'Passwort konnte nicht gespeichert werden.'}
    };
  }
}
if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',install);else install();
setTimeout(install,300);
})();
