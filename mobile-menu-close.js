(()=>{
function close(){document.querySelector('#side')?.classList.remove('open')}
document.addEventListener('click',e=>{const side=document.querySelector('#side'),menu=document.querySelector('#mobileMenu');if(!side?.classList.contains('open'))return;if(side.contains(e.target)||menu?.contains(e.target))return;close()},true);
document.addEventListener('keydown',e=>{if(e.key==='Escape')close()});
const s=document.createElement('script');s.src='project-offer-workflow.js?v=20260904-1538';s.async=false;s.dataset.jgosProjectOfferWorkflow='1';document.head.appendChild(s);
const p=document.createElement('script');p.src='service-project-sync.js?v=20260904-1538';p.async=false;p.dataset.jgosServiceProjectSync='1';document.head.appendChild(p);
const w=document.createElement('script');w.src='service-workfile.js?v=20260904-1545';w.async=false;w.dataset.jgosServiceWorkfile='1';document.head.appendChild(w);
})();