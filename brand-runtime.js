(()=>{
function apply(){
 const q=s=>document.querySelector(s),qa=s=>[...document.querySelectorAll(s)];
 const membership=q('#view-memberships');
 if(membership){
  const sub=membership.querySelector('.sub'); if(sub)sub.textContent='Diamant, Black und Private – drei diskrete Zugangsstufen mit wachsender Priorität und persönlicher Betreuung.';
  const grid=membership.querySelector('.vehicleGrid'); if(grid)grid.innerHTML=`
   <div class="vehicle"><h3>Diamant</h3><p>Bevorzugter Zugang, priorisierte Termine und persönlicher J&G Service.</p><button class="btn ghost membership" data-tier="diamond">Zugang anfragen</button></div>
   <div class="vehicle"><h3>Black</h3><p>Erweiterte Priorität, persönliche Koordination und bevorzugter Concierge-Zugang.</p><button class="btn ghost membership" data-tier="black">Zugang anfragen</button></div>
   <div class="vehicle"><h3>Private</h3><p>Höchste Betreuungsstufe für individuelle Arrangements, diskrete Koordination und maximale Verfügbarkeit.</p><button class="btn membership" data-tier="private">Private anfragen</button></div>`;
 }
 const tier=q('#ceTier'); if(tier)tier.innerHTML='<option value="none">Keine Mitgliedschaft</option><option value="diamond">Diamant</option><option value="black">Black</option><option value="private">Private</option>';
 const mob=q('#view-mobility'); if(mob){const eye=mob.querySelector('.eyebrow'),title=mob.querySelector('.title'),sub=mob.querySelector('.sub');if(eye)eye.textContent='J&G EXECUTIVE';if(title)title.textContent='Executive Fahrservice';if(sub)sub.textContent='Persönliche Begleitung auf höchstem Niveau – vom diskreten Transfer bis zur individuellen Tages-, Event- oder Langstreckenbegleitung.';const form=mob.querySelector('.form.one');if(form&&!q('#mobServiceMode')){const s=document.createElement('select');s.id='mobServiceMode';s.innerHTML='<option value="transfer">Executive Transfer · A nach B</option><option value="hourly">Chauffeur auf Zeit</option><option value="event">Event & Evening Service</option><option value="day">Day & Long Distance</option><option value="bespoke">Bespoke Journey · individuelle Anfrage</option>';form.insertBefore(s,form.firstChild)}}
 qa('[data-view="mobility"]').forEach(b=>{const text=[...b.childNodes].find(n=>n.nodeType===3);if(text)text.textContent='Executive Fahrservice'});
 qa('.membership').forEach(b=>b.addEventListener('click',()=>{const t=b.dataset.tier;if(window.J?.membership)window.J.membership(t)}));
 const emergency=q('.emergency');if(emergency)emergency.innerHTML='<b>PRIVATE CLIENT CONTACT</b>Persönliche Betreuung';
}
document.readyState==='loading'?document.addEventListener('DOMContentLoaded',()=>setTimeout(apply,50)):setTimeout(apply,50);
})();