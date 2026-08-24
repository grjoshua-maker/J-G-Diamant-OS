window.JG_BRAND_CONFIG={
  language:'de',
  brandPromise:'Diskretion. Präzision. Präsenz.',
  experience:{positioning:'Luxury Private Client Service',references:['Rolex','Bentley'],tone:['seriös','luxuriös','extravagant','einzigartig'],avoid:['Taxi-Sprache','CRM-Sprache','Personenschutz']},
  registration:{mode:'open',required:['full_name','street','postal_code','city','country','email','phone'],adminVisible:true},
  memberships:[
    {id:'diamond',name:'Diamant',rank:1},
    {id:'black',name:'Black',rank:2},
    {id:'private',name:'Private',rank:3}
  ],
  payments:{default:'invoice',newCustomer:'prepayment',methods:['invoice','twint','card','crypto']},
  mobility:{name:'Executive Fahrservice',positioning:'Persönliche Begleitung statt reine Beförderung',modes:[
    {id:'transfer',name:'Executive Transfer',billing:'distance_time'},
    {id:'hourly',name:'Chauffeur auf Zeit',billing:'hourly'},
    {id:'event',name:'Event & Evening Service',billing:'time_distance_waiting'},
    {id:'day',name:'Day & Long Distance',billing:'time_distance_waiting'},
    {id:'bespoke',name:'Bespoke Journey',billing:'manual_quote'}
  ],calculator:{inputs:['pickup','destination','distance_km','duration_min','waiting_min','vehicle','service_mode'],outputs:['estimated_time','estimated_distance','estimated_price_chf'],disclaimer:'Richtpreis – die definitive Leistung wird individuell bestätigt.'}}
};