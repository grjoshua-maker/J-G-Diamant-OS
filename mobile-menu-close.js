(()=>{
function close(){document.querySelector('#side')?.classList.remove('open')}
document.addEventListener('click',e=>{const side=document.querySelector('#side'),menu=document.querySelector('#mobileMenu');if(!side?.classList.contains('open'))return;if(side.contains(e.target)||menu?.contains(e.target))return;close()},true);
document.addEventListener('keydown',e=>{if(e.key==='Escape')close()});
const s=document.createElement('script');s.src='project-offer-workflow.js?v=20260825-2322';s.async=false;s.dataset.jgosProjectOfferWorkflow='1';document.head.appendChild(s);
})();