(()=>{
function close(){document.querySelector('#side')?.classList.remove('open')}
document.addEventListener('click',e=>{const side=document.querySelector('#side'),menu=document.querySelector('#mobileMenu');if(!side?.classList.contains('open'))return;if(side.contains(e.target)||menu?.contains(e.target))return;close()},true);
document.addEventListener('keydown',e=>{if(e.key==='Escape')close()});
})();