# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
countries = {
  "United States" => ["Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Puerto Rico","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","Washington D.C.","West Virginia","Wisconsin","Wyoming"],
  "Australia" => ["Australian Capital Territory","New South Wales","Northern Territory","Queensland","South Australia","Tasmania","Victoria","Western Australia"],
  "Canada" => ["Alberta","British Columbia","Manitoba","New Brunswick","Newfoundland","Northwest Territories","Nova Scotia","Nunavut","Ontario","Prince Edward Island","Quebec","Saskatchewan","Yukon"],
  "France" => ["Alsace","Aquitaine","Auvergne","Bourgogne","Bretagne","Centre","Champagne-Ardenne","Corse","Franche-Comte","Ile-de-France","Languedoc-Roussillon","Limousin","Lorraine","Midi-Pyrenees","Nord-Pas-de-Calais","Basse-Normandie","Haute-Normandie","Pays de la Loire","Picardie","Poitou-Charentes","Provence-Alpes-Cote d'Azur","Rhone-Alpes"],
  "Germany" => ["Baden-Wurttemberg","Bayern","Berlin","Brandenburg","Bremen","Hamburg","Hessen","Mecklenburg- Vorpommern","Niedersachsen","Nordrhein-Westfalen","Rhineland- Pflaz","Saarland","Sachsen","Sachsen-Anhalt","Schleswig- Holstein","Thuringen"],
  "India" => ["Andhra Pradesh","Arunachal Pradesh","Assam","Bihar","Chhattisgarh","New Delhi","Goa","Gujarat","Haryana","Himachal Pradesh","Jammu and Kashmir","Jharkhand","Karnataka","Kerala","Madhya Pradesh","Maharashtra","Manipur","Meghalaya","Mizoram","Nagaland","Orissa""Punjab","Rajasthan","Sikkim","Tamil Nadu","Tripura","Uttaranchal","Uttar Pradesh","West Bengal"],
  "Ireland" => ["Dublin","Midlands","Northern Ireland","Outer Dublin","Southeast Ireland","Southwest Ireland","West Ireland"],
  "Scotland" => ["Aberdeen City","Aberdeenshire","Angus","Argyll & Bute","Clackmannanshire","Dumfries & Galloway","Dundee City","East Ayrshire","East Dunbartonshire","East Lothian","East Renfrewshire","Edinburgh","Falkirk","Fife","Glasgow","Highland","Inverclyde","Midlothian","Moray","North Ayrshire","North Lanarkshire","Orkney","Perth & Kinross","Renfrewshire","Scottish Borders","Shetland","South Ayrshire","South Lanarkshire","Stirling","West Dunbartonshire","West Lothian","Western Isles"],
  "Spain" => ["Alava","Albacete","Alicante","Almeria","Asturias","Avila","Badajoz","Barcelona","Burgos","Caceres","Cadiz","Cantrabria","Castellon","Ceuta","Ciudad Real","Cordoba","Cuenca","Girona","Granada","Guadalajara","Guipuzcoa","Huelva","Huesca","Islas Baleares","Jaen","La Coruna","Leon","Lleida","Lugo","Madrid","Malaga","Melilla","Murcia","Navarra","Ourense","Palencia","Palmas, Las","Pontevedra","Rioja, La","Salamanda","Santa Cruz de Tenerife","Segovia","Sevila","Soria","Tarragona","Teruel","Toledo","Valencia","Valladolid","Vizcaya","Zamora","Zaragoza"],
  "Uganda" => ["Abim","Adjumani","Amolatar","Amuria","Apac","Arua","Budaka","Bugiri","Bukwa","Bulisa","Bundibugyo","Bushenyi","Busia","Busiki","Butaleja","Dokolo","Gulu","Hoima","Ibanda","Iganga","Jinja","Kaabong","Kabale","Kabarole","Kaberamaido","Kabingo","Kalangala","Kaliro","Kampala","Kamuli","Kamwenge","Kanungu","Kapchorwa","Kasese","Katakwi","Kayunga","Kibale","Kiboga","Kilak","Kiruhura","Kisoro","Kitgum","Koboko","Kotido","Kumi","Kyenjojo","Lira","Luwero","Manafwa","Maracha","Masaka","Masindi","Mayuge","Mbale","Mbarara","Mityana","Moroto","Moyo","Mpigi","Mubende","Mukono","Nakapiripirit","Nakaseke","Nakasongola","Nebbi","Ntungamo","Oyam","Pader","Pallisa","Rakai","Rukungiri","Sembabule","Sironko","Soroti","Tororo","Wakiso","Yumbe"],
  "United Kingdom" => ["Avon","Bedfordshire","Berkshire","Buckinghamshire","Cambridgeshire","Cheshire","Cleveland","Cornwall","Cumbria","Derbyshire","Devon","Dorset","Durham","Essex","Gloucestershire","Hampshire","Hereford & Worcester","Hertfordshire","Humberside","Kent","Lancashire","Leicestershire","Lincolnshire","London","Manchester","Merseyside","Norfolk","Northamptonshire","Northumberland","Nottinghamshire","Oxfordshire","Shropshire","Somerset","Staffordshire","Suffolk","Surrey","Sussex","Tyne & Wear","Warwickshire","West Midlands","Wiltshire","Yorkshire"],
  "Wales" => ["Aberystwyth","Builth Wells","Brecon Beacons","Cardiff","Caernarfon","Fishguard","Holyhead","Llangollen","Pembrokshire","Snowdonia","Swansea"],
  "Other" => ["(Unlisted)"]
}

countries.each_pair do |k, states|
  country = Country.create(:name => k)
  states.each { |state| country.states.create(:name => state) }
end


