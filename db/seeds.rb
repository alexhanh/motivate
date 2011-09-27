# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

############
# Trackers #
############

user = User.create!(:email => "alexander.hanhikoski@gmail.com", :username => "alexhanh", :password => "salanopa", :password_confirmation => "salanopa", :gender => true, :birthday => 24.years.ago)

weight_tracker = Tracker.create!(:private => false, :name => "weight")
height_tracker = Tracker.create!(:private => false, :name => "height")
step_tracker   = Tracker.create!(:private => false, :name => "steps", :custom_unit => "askelta")
body_fat_tracker = Tracker.create!(:private => false, :name => "body_fat", :custom_unit => "%")

TrackerEntry.create!(:tracker => weight_tracker, :user => user, :logged_on => 1.week.ago, :quantity => Quantity.new(80, Units.kg))
TrackerEntry.create!(:tracker => height_tracker, :user => user, :logged_on => 2.weeks.ago, :quantity => Quantity.new(180, Units.cm))

# https://sites.google.com/site/compendiumofphysicalactivities/
Exercise.create!(:name => "running", :met => 10.0)
Exercise.create!(:name => "swimming", :met => 8.0)
Exercise.create!(:name => "bicycling", :met => 7.5)
Exercise.create!(:name => "badminton", :met => 7.0)
Exercise.create!(:name => "basketball", :met => 6.5)
Exercise.create!(:name => "football", :met => 8.0)
Exercise.create!(:name => "golf", :met => 4.8)
Exercise.create!(:name => "handball", :met => 12.0)
Exercise.create!(:name => "ice_hockey", :met => 8.0)
Exercise.create!(:name => "orienteering", :met => 9.0)
Exercise.create!(:name => "rock_climbing", :met => 7.5)
Exercise.create!(:name => "squash", :met => 7.3)
Exercise.create!(:name => "table_tennis", :met => 4.0)
Exercise.create!(:name => "tennis", :met => 7.3)
Exercise.create!(:name => "volleyball", :met => 6.0)
Exercise.create!(:name => "walking", :met => 4.3)
Exercise.create!(:name => "swimming", :met => 6.0)
Exercise.create!(:name => "water_jogging", :met => 8.0)

def create_product(name, brand=nil)
  Product.create!(:name => name, :brand => brand, :user => User.first)
end

def add_unit(p, fu = {})
  p.food_units << FoodUnit.new(fu)
  p.save!
end

def add_relation(p, unit, parent_quantity)
  p.food_units << FoodUnit.new(:value => 1, :unit => unit, :parent_quantity => parent_quantity)
  p.save!
end

# Lisäys ohjeet:
#
# Kun haluat lisätä uuden tuotteen, käytä 
# p = create_product('tuotteen_nimi', 'brändi')
#
# Huom. tuotteen_nimi ja brändi voivat sisältää välilyöntejä ja muita erikoismerkkejä.
#
# Seuraavaksi juuri luodulle tuotteelle lisätään ravintotietoa, joka tehdään seuraavasti:
# add_unit(p, :quantity => 100.g, :energy => 571, :fat => 24, :protein => 23, :carbs => 69)
#
# Parametrien määritelmät:
#
# quantity: Määrä sekä yksikkö, joille ravintotiedot on ilmoitettu.
#           Jos kyseessä on paino tai tilavuusyksikkö, niin voi käyttää esim. seuraavanlaisia lyhenteitä:
#           1.kg    (1 kilogramma)
#           23.g    (23 grammaa)
#           0.5.dl  (0.5 desilitraa)
#           4.ml    (4 millilitraa)
#           11.3.cl (11.3 senttilitraa)
#
# energy: Energian määrä kilokaloreissa (kcal, kaloria). Jos energia on ilmoitettu kilojouleissa, on se muutettava kilokaloreiksi.
# fat: Rasvojen kokonaismäärä grammoissa.
# protein: Proteiinin määrä grammoissa.
# carbs: Hiilihydraattien määrä grammoissa.
#
# Huom. Näistä pakollisia ovat energy ja carbs.
#
# Esim. On ilmoitettu että 100g tuotetta sisältää 123 kcal energiaa, 0g proteiinia ja 20g hiilihydraattia. Tällöin lisäisimme
# add_unit(p, :quantity => 100.g, :energy => 123, :protein => 0, :carbs => 20)
# (Huom. Emme asettaneet :fat => 0, koska sitä ei oltu ilmoitettu!)
#
# Järjestelmä tukee myös nk. custom yksiköitä, jotka eivät ole standardiyksiköitä (tilavuus tai paino) vaan niillä on oma nimi.
# Esim. hampurilaisesta tai pizzasta ei ole kovin hyödyllistä lisätä tietoa grammoista, koska niitä yleensä syödään suhteessa
# yhteen kappaleeseen.
#
# Custom yksikkö lisätään seuraavalla tavalla
# add_unit(p, :quantity => Quantity.new(1, 'kpl'), :energy => 837, :protein => 52.25, :carbs => 70, :fat => 37.27)
#
# Vaikka yksikön nimi voi olla mielivaltainen, niin kannattaa silti ajatella miltä syömislogi näyttää.. 
# esim. söin 22.5.2011 puolikkaan Bic Mac hampurilaisen.. tällöin järjestelmä näyttää nettisivulla
# 22.5.2011 0.5 kpl Bic Mac Hampurilainen
# (näyttää siis järkevältä)
#
# Jos olisimme nimenneet yksikön 'hampurilainen' 'kpl' sijaan, niin syömislogi näyttäisi seuraavalta
# 22.5.2011 0.5 hampurilainen Bic Mac Hampurilainen
# (ei näytä hyvältä)
#
# Järkevä nimi custom yksikölle riippuu tuotteesta. Hyviä yleisiä lyhenteitä ovat kpl (TODO: lisää!)
#
# Yksiköidä voidaan lisätä aiempien yksiköiden avulla jos niiden välinen suhde tiedetään. 
# Tätä tarkoittaa yksikön lisääminen relaation avulla. Esim. jos olisimme aikaisemmassa hampurilaisesimerkissä
# tienneet että yksi 'kpl' hampurilaista painaa 255 grammaa, niin voidaan hyödyntää tuotteelle jo määriteltyä painoyksikköä:
# add_relation(p, 'kpl', 255.g)
# 
# Järjestelmä osaa automaattisesti skaalata painoyksikön ravintotietolukemat. Jos mahdollista, niin uusien yksiköiden 
# määritteleminen olemassaolevien avulla on suositeltavaa.
#

###################
# Picnic          #
###################

# http://www.picnic.fi/pdf/ravinto.php
p = create_product('Paahtopaistipatonki', 'Picnic')
add_unit(p, :quantity => 255.g, :energy => 571, :fat => 24, :protein => 23, :carbs => 69)
add_relation(p, 'kpl', 255.g)

p = create_product('Kanapatonki', 'Picnic')
add_unit(p, :quantity => 255.g, :energy => 437, :fat => 12, :protein => 24, :carbs => 69)
add_relation(p, 'kpl', 255.g)

p = create_product('Juustosämpylä', 'Picnic')
add_unit(p, :quantity => 280.g, :energy => 670, :fat => 35, :protein => 24, :carbs => 70)
add_relation(p, 'kpl', 280.g)

p = create_product('Kinkku-parilapatonki', 'Picnic')
add_unit(p, :quantity => 240.g, :energy => 531, :fat => 17, :protein => 24, :carbs => 54)
add_relation(p, 'kpl', 240.g)

p = create_product('Oriental kanasalaatti', 'Picnic')
add_unit(p, :quantity => 300.g, :energy => 382, :fat => 24, :protein => 38, :carbs => 20)
add_relation(p, 'kpl', 300.g)

p = create_product('Seesami- soijavinegretti', 'Picnic')
add_unit(p, :quantity => 30.g, :energy => 150, :fat => 15, :protein => 0, :carbs => 3)
add_relation(p, 'kpl', 30.g)

###################
# Kotipizza       #
###################

# http://www.kotipizza.fi/Suomeksi/Ravintotietoa/

# Ohjeistus:
# - Ei tarvitse lisätä kevennettyjä pizzoja
# - Ei tarvitse lisätä ravintotietoja painoyksiköille (grammoille).. "kpl" riittää

# En oikein tiedä mikä seuraavista nimeämiskäytännöistä olisi paras:

# Pizza Alla Pollo (Normaali, Runsaskuituinen)
# Alla Pollo Pizza (Normaali, Runsaskuituinen)
# Alla Pollo (Pizza, Normaali, Runsaskuituinen)
# Alla Pollo Pizza - Normaali, Runsaskuituinen
# Alla Pollo pizza - normaali, runsaskuituinen
# 
# Alla Pollo pizza - Perhe
# Alla Pollo pizza (Perhe)

create_product('Pizza Alla Pollo (Normaali, Runsaskuituinen)')
create_product('Alla Pollo Pizza (Normaali, Runsaskuituinen)')
create_product('Alla Pollo (Pizza, Normaali, Runsaskuituinen)')
create_product('Alla Pollo Pizza - Normaali, Runsaskuituinen')
create_product('Alla Pollo pizza - normaali, runsaskuituinen')

p = create_product('Alla Pollo, Normaali', 'Kotipizza')
add_unit(p, :quantity => Quantity.new(1, 'kpl'), :energy => 837, :protein => 52.25, :carbs => 70, :fat => 37.27)

p = create_product('Alla Pollo, Runsaskuituinen', 'Kotipizza')
add_unit(p, :quantity => Quantity.new(1, 'kpl'), :energy => 837, :protein => 53.65, :carbs => 69.5, :fat => 37.37)

###################
# Subway          #
###################

# http://www.subway.com/applications/NutritionInfo/Files/NutritionValues.pdf

p = create_product('Italian B.M.T', 'Subway')
add_unit(p, :quantity => 237.g, :energy => 453, :fat => 20.8, :carbs => 46.2, :protein => 25)
add_relation(p, 'puolikas', 237.g)
add_relation(p, 'kokonainen', 2*237.g)

###################
# McDonald's      #
###################

# http://www.mcdonaldsmenu.info/nutrition/