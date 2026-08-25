(()=>{
const U='https://qgrsbqzhbifbyyfbslyh.supabase.co',K='sb_publishable_DKxNrYb1zbLkKyQQ_LAh2w_B0NRK72k',SK='jgos:session';
function s(){try{return JSON.parse(localStorage.getItem(SK)||'null')}catch{return null}}
async function apply(){const ss=s();if(!ss?.access_token||!ss?.user?.id)return;try{const r=await fetch(U+'/rest/v1/profiles?id=eq.'+encodeURIComponent(ss.user.id)+'&select=display_role',{headers:{apikey:K,Authorization:'Bearer '+ss.access_token},cache:'no-store'});if(!r.ok)return;const p=(await r.json())?.[0];const role=(p?.display_role||'').trim();if(!role)return;const e=document.querySelector('#userRole');if(e)e.textContent=role;const h=document.querySelector('#hello');if(h){const badge=h.querySelector('.adminbadge');if(badge)badge.textContent=role}}
catch{}}
new MutationObserver(apply).observe(document.documentElement,{childList:true,subtree:true});setInterval(apply,700);apply();
})();