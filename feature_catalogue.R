FCLASS_initialise_catalogue <- function()
{
  ##  based on the documentation provided here: http://download.geofabrik.de/technical.html
  ##  NO_TARGET:      feature unlikely to be target of car ride or duration of stay/use doesn't facilitate a charging event
  ##  NO_IMPLICATION: feature doesn't provide any useful information on the location (e.g. demographic, economics, etc.)
  ##  NO_ACCESS:      feature generally not accessible to the public or does not provide (public) parking
  ##  TEMPORARY:      feature is likely to be only temporary.
  
  feature_catalogue <- data.frame(rbind(
    c("places","city","Often over 100,000 people",0),
    c("places","town","Generally smaller than a city, between 10,000 and 100,000 people",0),
    c("places","village","Generally smaller than a town, below 10,000 people",0),
    c("places","hamlet","Generally smaller than a village, just a few houses",0),
    c("places","national_capital","A national capital",0),
    c("places","suburb","Named area of town or city",0),
    c("places","island","Identifies an island",NA), ## NO_IMPLICATION
    c("places","farm","Named farm",1),
    c("places","dwelling","Isolated dwelling (1 or 2 houses, smaller than hamlet)",0),
    c("places","region","A region label (used in some areas only)",NA), ## NO_IMPLICATION
    c("places","county","A county label (used in some areas only)",NA), ## NO_IMPLICATION
    c("places","locality","Other kind of named place",NA), ## NO_IMPLICATION
    c("public","police","A police post or station",2),
    c("public","fire_station","A fire station",2),
    c("public","post_box","A post box (for letters)",NA), ## NO_TARGET
    c("public","post_office","A post office",0),
    c("public","telephone","A public telephone booth",0), ## NO_TARGET
    c("public","library","A library",0),
    c("public","town_hall","A town hall",0),
    c("public","courthouse","A court house",0),
    c("public","prison","A prison",0),
    c("public","embassy","An embassy",0),
    c("public","community_centre","A public facility which is mostly used by local associations for events and festivities",0),
    c("public","nursing_home","A home for disabled or elderly persons who need permanent care",0),
    c("public","arts_centre","A venue at which a variety of arts are performed or conducted, and may well be involved with the creation of those works, and run occasional courses",0),
    c("public","graveyard","A graveyard",20),
    c("public","market_place","A place where markets are held",0),
    c("public","recycling","A place (usually a container) where you can drop waste for recycling",NA), ## NO_TARGET
    c("public","recycling_glass","A place for recycling glass",NA), ## NO_TARGET
    c("public","recycling_paper","A place for recycling paper",NA), ## NO_TARGET
    c("public","recycling_clothes","A place for recycling clothes",NA), ## NO_TARGET
    c("public","recycling_metal","A place for recycling metal",NA), ## NO_TARGET
    c("public","university","A university",3),
    c("public","school","A school",16),
    c("public","kindergarten","A kindergarten (nursery)",4),
    c("public","college","A college",3),
    c("public","public_building","An unspecified public building",5),
    c("health","pharmacy","A pharmacy",0),
    c("health","hospital","A hospital",6),
    c("health","doctors","A medical practice",0),
    c("health","dentist","A dentist's practice",0),
    c("health","veterinary","A veterinary (animal doctor)",0),
    c("leisure","theatre","A theatre",0),
    c("leisure","nightclub","A nightclub, or disco",0),
    c("leisure","cinema","A cinema",0),
    c("leisure","park","A park",21),
    c("leisure","playground","A playground for children",0),
    c("leisure","dog_park","An area where dogs are allowed torun free without a leash",0),
    c("leisure","sports_centre","A facility where a range of sports activities can be pursued",0),
    c("leisure","pitch","An area set aside for a specific sport",0),
    c("leisure","swimming_pool","A swimming pool or water park",0),
    c("leisure","tennis_court","A tennis court",0),
    c("leisure","golf_course","A golf course",0),
    c("leisure","stadium","A stadium. The area of the stadium may contain one or several pitches",7),
    c("leisure","ice_rink","An ice rink",0),
    c("catering","restaurant","A normal restaurant",0),
    c("catering","fast_food","A fast-food restaurant",0),
    c("catering","cafe","A cafe",0),
    c("catering","pub","A pub",0),
    c("catering","bar","A bar. The difference between a pub and a bar is not clear but pubstend to offer food while bars do not",0),
    c("catering","food_court","A common seating area with various fast-food vendors",0),
    c("catering","biergarten","An open-air area where food and drinks are served",0),
    c("accommodation","hotel","A hotel",8),
    c("accommodation","motel","A motel",0),
    c("accommodation","bed_and_breakfast","A facility offering bed and breakfast",0),
    c("accommodation","guesthouse","A guesthouse. The difference between hotel, bed and breakfast, and guest houses is not a strict one and OSM tends to use whatever the facility calls itself",0),
    c("accommodation","hostel","A hostel (offering cheap accomodation, often bunk beds in dormitories)",0),
    c("accommodation","chalet","A detached cottage, usually self-catering",0),
    c("accommodation","shelter","All sorts of small shelters to protect against bad weather conditions",NA),  ## NO_IMPLICATION
    c("accommodation","camp_site","A camp site or camping ground",0),
    c("accommodation","alpine_hut","An alpine hut is a building typically situated in mountains providing shelter and often food and beverages to visitors",0),
    c("accommodation","caravan_site","A place where people with caravans or motorhomes can stay overnight or longer",0),
    c("shopping","supermarket","A supermarket",9),
    c("shopping","bakery","A bakery",0),
    c("shopping","kiosk","A very small shop usually selling cigarettes, newspapers, sweets, snacks and beverages",10),
    c("shopping","mall","A shopping mall",0),
    c("shopping","department_store","A department store",0),
    c("shopping","convenience","A convenience store is a small shop selling a subset of items you might find at a supermarket",0),
    c("shopping","clothes","A clothes or fashion store",0),
    c("shopping","florist","A store stelling flowers",0),
    c("shopping","chemist","A shop selling articles of personal hygiene, cosmetics, and householdcleaning products",0),
    c("shopping","bookshop","A book shop",0),
    c("shopping","butcher","A butcher",0),
    c("shopping","shoe_shop","A shoe shop",0),
    c("shopping","beverages","A place where you can buy alcoholic and non-alcoholic beverages",0),
    c("shopping","optician","A place where you can buy glasses",0),
    c("shopping","jeweller","A jewelry shop",0),
    c("shopping","gift_shop","A gift shop",NA),  ## NO_TARGET
    c("shopping","sports_shop","A shop selling sports equipment",0),
    c("shopping","stationery","A shop selling stationery for private and office use",0),
    c("shopping","outdoor_shop","A shop selling outdoor equiment",0),
    c("shopping","mobile_phone_shop","A shop for mobile phones",0),
    c("shopping","toy_shop","A toy store",0),
    c("shopping","newsagent","A shop selling mainly newspapersand magazines",NA),  ## NO_TARGET
    c("shopping","greengrocer","A shop selling fruit and vegetables",0),
    c("shopping","beauty_shop","A shop that provides personal beauty services like a nail salon ortanning salon",0),
    c("shopping","video_shop","A place where you can buy films",0),
    c("shopping","car_dealership","A car dealership",0),
    c("shopping","bicycle_shop","A bicycle shop",0),
    c("shopping","doityourself","A do-it-yourself shop where you can buy tools and building materials",0),
    c("shopping","furniture_shop","A furniture store",0),
    c("shopping","computer_shop","A computer shop",0),
    c("shopping","garden_centre","A place selling plants and gardening goods",0),
    c("shopping","hairdresser","A hair salon",0),
    c("shopping","car_repair","A car garage",0),
    c("shopping","car_rental","A place where you can rent a car",0),
    c("shopping","car_wash","A car wash",0),
    c("shopping","car_sharing","A car sharing station",0),
    c("shopping","bicycle_rental","A place where you can rent bicycles",0),
    c("shopping","travel_agent","A travel agency",0),
    c("shopping","laundry","A place where you can wash clothes or have them cleaned",0),
    c("shopping","vending_machine","An unspecified vending machine",NA), ## NO_TARGET
    c("shopping","vending_cigarette","A cigarette vending machine",NA), ## NO_TARGET
    c("shopping","vending_parking","A vending machine for parking tickets",0),
    c("money","bank","A bank",0),
    c("money","atm","A machine that lets you withdraw cash from your bank account",NA), ## NO_TARGET
    c("tourism","tourist_info","Something that provides information to tourists; may or many not be manned",0),
    c("tourism","tourist_map","A map displayed to inform tourists",NA), ## NO_TARGET
    c("tourism","tourist_board","A board with explanations aimed at tourists",NA), ## NO_TARGET
    c("tourism","tourist_guidepost","A guide post",0), ## NO_TARGET
    c("tourism","attraction","A tourist attraction",0),
    c("tourism","museum","A museum",0),
    c("tourism","monument","A monument",0),
    c("tourism","memorial","A memorial",0),
    c("tourism","art","A permanent work of art",0),
    c("tourism","castle","A castle",0),
    c("tourism","ruins","Ruins of historic significance",11),
    c("tourism","archaeological","An excavation site",NA), ## TEMPORARY
    c("tourism","wayside_cross","A wayside cross, not necessarily old",NA), ## NO_TARGET
    c("tourism","wayside_shrine","A wayside shrine",NA), ## NO_TARGET
    c("tourism","battlefield","A historic battlefield",0),
    c("tourism","fort","A fort",0),
    c("tourism","picnic_site","A picnic site",0),
    c("tourism","viewpoint","A viewpoint",0),
    c("tourism","zoo","A zoo",0),
    c("tourism","theme_park","A theme park",0),
    c("misc","toilet","Public toilets",NA), ## NO_TARGET
    c("misc","bench","A public bench",NA), ## NO_TARGET
    c("misc","drinking_water","A tap or other source of drinking water",NA), ## NO_TARGET
    c("misc","fountain","A fountain for cultural, decorative,or recreational purposes",NA), ## NO_TARGET
    c("misc","hunting_stand","A hunting stand",NA),  ## NO_TARGET
    c("misc","waste_basket","A waste basket",NA), ## NO_TARGET
    c("misc","camera_surveillance","A surveillance camera",NA), ## NO_TARGET
    c("misc","emergency_phone","An emergency telephone",NA), ## NO_TARGET
    c("misc","fire_hydrant","A firy hydrant",NA), ## NO_TARGET
    c("misc","emergency_access","An emergency access point (signposted place in e.g. woods thelocation of which is known to emergency services)",NA), ## NO_TARGET / NO_ACCESS
    c("misc","tower","A tower of some kind",NA), ## NO_IMPLICATION
    c("misc","tower_comms","A communications tower",NA), ## NO_IMPLICATION
    c("misc","water_tower","A water tower",19),
    c("misc","tower_observation","An observation tower",0),
    c("misc","windmill","A windmill",NA),  ## NO_TARGET / NO_ACCESS
    c("misc","lighthouse","A lighthouse",NA), ## NO_TARGET / NO_ACCESS
    c("misc","wastewater_plant","A wastewater treatment plant",0),
    c("misc","water_well","A facility to access underground aquifers",NA), ## NO_TARGET
    c("misc","water_mill","A mill driven by water. Often historic",NA),  ## NO_TARGET
    c("misc","water_works","A place where drinking water is processed",0),
    c("pofw","christian","A christian place of worship (usually a church) without one of the denominations below.",12),
    c("pofw","christian_anglican","A christian place of worship where  the denomination is known",12),
    c("pofw","christian_catholic","A christian place of worship where  the denomination is known",12),
    c("pofw","christian_evangelical","A christian place of worship where  the denomination is known",12),
    c("pofw","christian_lutheran","A christian place of worship where  the denomination is known",12),
    c("pofw","christian_methodist","A christian place of worship where  the denomination is known",12),
    c("pofw","christian_orthodox","A christian place of worship where  the denomination is known",12),
    c("pofw","christian_protestant","A christian place of worship where  the denomination is known",12),
    c("pofw","christian_baptist","A christian place of worship where  the denomination is known",12),
    c("pofw","christian_mormon","A christian place of worship where  the denomination is known",12),
    c("pofw","jewish","A jewish place of worship (usually a synagogue)",12),
    c("pofw","muslim","A muslim place of worhsip, (usually a mosque) without one ofthe denominations below",12),
    c("pofw","muslim_sunni","A Sunni muslim place of worship",12),
    c("pofw","muslim_shia","A Shia muslim place or worship",12),
    c("pofw","buddhist","A Buddhist place of worship",12),
    c("pofw","hindu","A Hindu place of worship",12),
    c("pofw","taoist","A Taoist place of worship",12),
    c("pofw","shintoist","A Shintoist place of worship",12),
    c("pofw","sikh","A Sikh place of worship",12),
    c("natural","spring","A spring, possibly source of a stream",NA),  ## NO_IMPLICATION
    c("natural","glacier","A glacier",14),
    c("natural","peak","A mountain peak",0),
    c("natural","cliff","A cliff",0),
    c("natural","volcano","A volcano",0),
    c("natural","tree","A tree",NA),  ## NO_IMPLICATION / NO_TARGET
    c("natural","mine","A mine",0),
    c("natural","cave_entrance","A cave entrance",0),
    c("natural","beach","A beach. (Note that beaches areonly rarely mapped as point features.)",0),
    c("traffic","traffic_signals","Traffic lights",NA), ## NO_TARGET
    c("traffic","mini_roundabout","A small roundabout without physical strucutre, usually just painted onto the road surface",NA), ## NO_TARGET
    c("traffic","stop","A stop sign",NA), ## NO_TARGET
    c("traffic","crossing","A place where the street is crossed by pedestrians or a railway",NA), ## NO_TARGET
    c("traffic","ford","A place where the road runs through a river or stream",NA), ## NO_TARGET
    c("traffic","motorway_junction","The place where a slipway enters or leaves a motorway",NA),  ## NO_ACCESS
    c("traffic","turning_circle","An area at the end of a street where vehicles can turn",0),
    c("traffic","speed_camera","A camera that photographs speeding vehicles",NA),  ## NO_TARGET
    c("traffic","street_lamp","A lamp illuminating the road",NA), ## NO_TARGET
    c("traffic","fuel","A gas station",0),
    c("traffic","service","A service area, usually along motorways",0),
    c("traffic","parking","A car park of unknown type",13),
    c("traffic","parking_site","A surface car park",13),
    c("traffic","parking_multistorey","A multi storey car park",13),
    c("traffic","parking_underground","An underground car park",13),
    c("traffic","parking_bicycle","A place to park your bicycle",NA), ## NO_TARGET
    c("traffic","slipway","A slipway",0),
    c("traffic","marina","A marina",0),
    c("traffic","pier","A pier",0),
    c("traffic","dam","A dam",0),
    c("traffic","waterfall","A waterfall",0),
    c("traffic","lock_gate","A lock gate",0),
    c("traffic","weir","A barrier built across a river or stream",0),
    c("transport","railway_station","A larger railway station of mainline rail services",17),
    c("transport","railway_halt","A smaller, local railway station, or subway station",0),
    c("transport","tram_stop","A tram stop",0),
    c("transport","bus_stop","A bus stop",0),
    c("transport","bus_station","A large bus station with multiple platforms",0),
    c("transport","taxi_rank","A taxi rank",0),
    c("transport","airport","A large airport",0),
    c("transport","airfield","A small airport or airfield",0),
    c("transport","helipad","A place for landing helicopters",NA), ## NO_ACCESS
    c("transport","apron","A apron (area where aircraft are parked)",0),
    c("transport","ferry_terminal","A ferry terminal",0),
    c("transport","aerialway_station","A station where cable cars or lifts alight",0),
    c("roads","motorway","Motorway/freeway",0),
    c("roads","trunk","Important roads, typically divided",0),
    c("roads","primary","Primary roads, typically national",0),
    c("roads","secondary","Secondary roads, typically regional",0),
    c("roads","tertiary","Tertiary roads, typically local",0),
    c("roads","unclassified","Smaller local roads",NA), ## NO_IMPLICATION
    c("roads","residential","Roads in residential areas",0),
    c("roads","living_street","Streets where pedestrians have priority",0),
    c("roads","pedestrian","Pedestrian only streets",0),
    c("roads","motorway_link","Roads that connect from one road to another of the same or lower category",0),
    c("roads","trunk_link","Roads that connect from one road to another of the same or lower category",0),
    c("roads","primary_link","Roads that connect from one road to another of the same or lower category",0),
    c("roads","secondary_link","Roads that connect from one road to another of the same or lower category",0),
    c("roads","service","Service roads for access to buildings, parking lots, etc",NA), ## NO_IMPLICATION
    c("roads","track","For agricultural use, in forests, etc. Often gravel roads",0),
    c("roads","track_grade1","Tracks can be assigned a 'tracktype' from 1 (asphalt or heavily compacted) to 5 (hardly visible). A detailed description is here: http://wiki.openstreetmap.org/wiki/Tracktype",0),
    c("roads","track_grade2","Tracks can be assigned a 'tracktype' from 1 (asphalt or heavily compacted) to 5 (hardly visible). A detailed description is here: http://wiki.openstreetmap.org/wiki/Tracktype",0),
    c("roads","track_grade3","Tracks can be assigned a 'tracktype' from 1 (asphalt or heavily compacted) to 5 (hardly visible). A detailed description is here: http://wiki.openstreetmap.org/wiki/Tracktype",NA), ## NO_TARGET
    c("roads","track_grade4","Tracks can be assigned a 'tracktype' from 1 (asphalt or heavily compacted) to 5 (hardly visible). A detailed description is here: http://wiki.openstreetmap.org/wiki/Tracktype",NA), ## NO_TARGET
    c("roads","track_grade5","Tracks can be assigned a 'tracktype' from 1 (asphalt or heavily compacted) to 5 (hardly visible). A detailed description is here: http://wiki.openstreetmap.org/wiki/Tracktype",NA), ## NO_TARGET
    c("roads","bridleway","Paths for horse riding",NA), ## NO_TARGET
    c("roads","cycleway","Paths for cycling",NA), ## NO_TARGET
    c("roads","footway","Footpaths",NA), ## NO_TARGET
    c("roads","path","Unspecified paths",NA), ## NO_IMPLICATION
    c("roads","steps","Flights of steps on footpaths",NA), ## NO_TARGET
    c("roads","unknown","Unknown type of road or path",NA), ## NO_IMPLICATION
    c("railways","rail","Regular railway tracks",NA),  ## NO_ACCESS
    c("railways","light_rail","Light railway tracks, often commuter railways",NA),  ## NO_ACCESS
    c("railways","subway","Underground railway tracks",NA),  ## NO_ACCESS
    c("railways","tram","Tram tracks (may be incident with roads)",NA),  ## NO_ACCESS
    c("railways","monorail","A monorail track",NA),  ## NO_ACCESS
    c("railways","narrow_gauge","A narrow gauge railway track",NA),  ## NO_ACCESS
    c("railways","miniature","A miniature railway track",NA),  ## NO_ACCESS
    c("railways","funicular","A funicular, or cable railway usually on a steep inlcine",NA),  ## NO_ACCESS
    c("railways","rack","A rack railway",NA),  ## NO_ACCESS
    c("railways","drag_lift","An overhead tow-line for skiers",NA),  ## NO_ACCESS
    c("railways","chair_lift","An open chairlift run",NA),  ## NO_ACCESS
    c("railways","cable_car","A cabin cable car run",NA),  ## NO_ACCESS
    c("railways","gondola","An aerialway where the cabins go around ina circle",NA),  ## NO_ACCESS
    c("railways","goods","An aerialway for the transport of goods",NA),  ## NO_ACCESS
    c("railways","other_lift","Another type of lift",NA),  ## NO_ACCESS
    c("waterways","river","A large river",NA),  ## NO_IMPLICATION
    c("waterways","stream","A smaller river or stream",NA),  ## NO_IMPLICATION
    c("waterways","canal","An artificial waterway",NA),  ## NO_IMPLICATION
    c("waterways","drain","A small drainage ditch or similar structure",NA), ## NO_IMPLICATION
    c("landuse","forest","A forest or woodland",0),
    c("landuse","park","A park",21),
    c("landuse","residential","A residential area",0),
    c("landuse","industrial","An industrial area",0),
    c("landuse","cemetery","A cemetery or graveyard",20),
    c("landuse","allotments","An area with small private gardens",0),
    c("landuse","meadow","A meadow, possibly used for grazing cattle",0),
    c("landuse","commercial","A commercial area",0),
    c("landuse","nature_reserve","A nature reserve",0),
    c("landuse","recreation_ground","An open green space for general recreation",21),
    c("landuse","retail","An area mainly used by shops",0),
    c("landuse","military","Military landuse, usually no access for civilians",NA), ## NO_ACCESS
    c("landuse","quarry","A quarry",0),
    c("landuse","orchard","An area used for growing fruit-bearingtrees",0),
    c("landuse","vineyard","An area used for growing grapes",0),
    c("landuse","scrub","An  area where scrub grows",0),
    c("landuse","grass","An area where grass grows",NA), ## NO_IMPLICATION
    c("landuse","heath","Heath areas",0), 
    c("landuse","national_park","A national park",0),
    c("landuse","farmland","Agricultural land (areas where crops are grown)",0),
    c("landuse","farmyard","Area of land with farm buildings and the shrubbery/trees around them",1),
    c("water","water","Unspecified bodies of water. Typically lakes, but can also be larger rivers, harbours, etc",NA),  ## NO_IMPLICATION
    c("water","reservoir","Artificial lakes, typically above a dam",0),
    c("water","river","Polygons for larger rivers",0),  ## NO_IMPLICATION
    c("water","dock","Dock (to repair ships, don't confuse it with the American term dock)",0),
    c("water","glacier","Glaciers",14),
    c("water","wetland","Swamp, bog, or marsh land",0),
    c("building","apartments","A building arranged into individual dwellings, often on separate floors. May also have retail outlets on the ground floor.",15),
    c("building","bungalow","A single-storey detached small house, Dacha.",15),
    c("building","cabin","A cabin is a small, roughly built house usually with a wood exterior and typically found in rural areas.",0),
    c("building","detached","A detached house, a free-standing residential building usually housing a single family.",15),
    c("building","dormitory","For a shared building, as used by college/university students (not a share room for multiple occupants as implied by the term in British English).",0),
    c("building","farm","A residential building on a farm (farmhouse).",1),
    c("building","ger","A permanent or seasonal round yurt or ger used as dwelling.",NA), ## TEMPORARY
    c("building","hotel","A building designed with separate rooms available for overnight accommodation.",8),
    c("building","house","A dwelling unit inhabited by a single household (a family or small group sharing facilities such as a kitchen).",15),
    c("building","houseboat","A boat used primarily as a home.",15),
    c("building","residential","A general tag for a building used primarily for residential purposes.",15),
    c("building","semidetached_house","A residential house that shares a common wall with another on one side.",15),
    c("building","static_caravan","A mobile home (semi)permanently left on a single site.",15),
    c("building","terrace","A single way used to define the outline of a linear row of residential dwellings, each of which normally has its own entrance, which form a terrace (row-house in North American English).",15),
    c("building","commercial","A building where non-specific commercial activities take place, not necessarily an office building.",0),
    c("building","industrial","A building where some industrial process takes place. Use warehouse if the purpose is known to be primarily for storage/distribution.",0),
    c("building","kiosk","A small one-room retail building.",10),
    c("building","office","An office building.",0),
    c("building","retail","A building primarily used for selling goods that are sold to the public.",0),
    c("building","supermarket","A building constructed to house a self-service large-area store.",9),
    c("building","warehouse","A building primarily used for the storage or goods or as part of a distribution system.",0),
    c("building","cathedral","A building that was built as a cathedral.",12),
    c("building","chapel","A building that was built as a chapel.",12),
    c("building","church","A building that was built as a church.",12),
    c("building","mosque","A mosque",12),
    c("building","religious","Unspecific religious building.",12),
    c("building","shrine","A building that was built as a shrine.",12),
    c("building","synagogue","A building that was built as a synagogue.",12),
    c("building","temple","A building that was built as a temple.",12),
    c("building","bakehouse","A building that was built as a bakehouse (i.e. for baking bread).",0),
    c("building","civic","For any civic amenity.",5),
    c("building","fire_station","A building which houses fire fighting equipment ready for use.",2),
    c("building","government","For government buildings in general, including municipal, provincial and divisional secretaries, government agencies and departments, town halls, (regional) parliaments and court houses.",5),
    c("building","hospital","A building which forms part of a hospital.",6),
    c("building","kindergarten","For any generic kindergarten buildings.",4),
    c("building","public","A building constructed as accessible to the general public (a town hall, police station, court house, etc.).",5),
    c("building","school","For any generic school buildings.",16),
    c("building","toilets","A toilet block",NA), ## NO_TARGET
    c("building","train_station","A building constructed to be a train station building, including buildings that are abandoned and used nowadays for a different purpose.",17),
    c("building","transportation","A building related to public transport.",0),
    c("building","university","A university building.",3),
    c("building","barn","An agricultural building used for storage and as a covered workplace.",0),
    c("building","conservatory","A building or room having glass or tarpaulin roofing and walls used as an indoor garden or a sunroom (winter garden).",NA), ## NO_IMPLICATION
    c("building","cowshed","A cowshed (cow barn, cow house) is a building for housing cows, usually found on farms.",0),
    c("building","farm_auxiliary","A building on a farm that is not a dwelling (use 'farm' or 'house' for the farm house).",1),
    c("building","greenhouse","A greenhouse is a glass or plastic covered building used to grow plants.",0), 
    c("building","stable","A stable is a building where horses are kept.",0),
    c("building","sty","A sty (pigsty, pig ark, pig-shed) is a building for raising domestic pigs, usually found on farms.",0),
    c("building","grandstand","The main stand, usually roofed, commanding the best view for spectators at racecourses or sports grounds.",0),
    c("building","pavilion","A sports pavilion usually with changing rooms, storage areas and possibly an space for functions & events.",0),
    c("building","riding_hall","A building that was built as a riding hall.",0),
    c("building","sports_hall","A building that was built as a sports hall.",0),
    c("building","stadium","A building constructed to be a stadium building, including buildings that are abandoned and used nowadays for a different purpose.",7),
    c("building","hangar","A hangar is a building used for the storage of airplanes, helicopters or space-craft.",0),
    c("building","hut","A hut is a small and crude shelter.",NA), ## NO_IMPLICATION / NO_TARGET
    c("building","shed","A shed is a simple, single-storey structure in a back garden or on an allotment that is used for storage, hobbies, or as a workshop.",NA), ## NO_IMPLICATION
    c("building","carport","A carport is a covered structure used to offer limited protection to vehicles, primarily cars, from the elements.",18),
    c("building","garage","A garage is a building suitable for the storage of one or possibly more motor vehicle or similar.",18),
    c("building","garages","A building that consists of a number of discrete storage spaces for different owners/tenants.",0),
    c("building","parking","Structure purpose-built for parking cars.",13),
    c("building","digester","A digester is a bioreactor for the production of inflatable biogas from biomass.",0),
    c("building","service","Service building usually is a small unmanned building with certain machinery (like pumps or transformers).",NA), ## NO_IMPLICATION
    c("building","transformer_tower","A transformer tower is a characteristic tall building comprising a distribution transformer and constructed to connect directly to a medium voltage overhead power line.",NA), ## NO_TARGET / NO_ACCESS
    c("building","water_tower","A water tower",19),
    c("building","bunker","A hardened military building.",NA), ## NO_ACCESS
    c("building","bridge","A building used as a bridge. Can also represent a gatehouse for drawbridges.",NA), ## NO_IMPLICATION
    c("building","construction","Used for buildings under construction.",NA), ## TEMPORARY
    c("building","roof","A structure that consists of a roof with open sides, such as a rain shelter, and also gas stations.",NA), ## NO_IMPLICATION
    c("building","ruins","Frequently used for a house or other building that is abandoned and in poor repair. However, some believe this usage is incorrect, and the tag should only be used for buildings constructed as fake ruins (for example sham ruins in an English landscape garden).",11)))
  
  colnames(feature_catalogue) <- c("layer","fclass","description","filter")
  
  feature_catalogue$layer       <- as.character(feature_catalogue$layer)
  feature_catalogue$fclass      <- as.character(feature_catalogue$fclass)
  feature_catalogue$description <- as.character(feature_catalogue$description)
  feature_catalogue$filter      <- as.integer(as.character(feature_catalogue$filter))
  
  return(feature_catalogue)
}

FCLASS_initiate_groups <- function()
{
  feature_groups <- data.frame(rbind(
    c(1,"group_farm",as.integer(length(feature_catalogue$layer)+1)),
    c(2,"group_emergency_services",as.integer(length(feature_catalogue$layer)+2)),
    c(3,"group_university",as.integer(length(feature_catalogue$layer)+3)),
    c(4,"group_kindergarten",as.integer(length(feature_catalogue$layer)+4)),
    c(5,"group_public_building",as.integer(length(feature_catalogue$layer)+5)),
    c(6,"group_hospital",as.integer(length(feature_catalogue$layer)+6)),
    c(7,"group_stadium",as.integer(length(feature_catalogue$layer)+7)),
    c(8,"group_hotel",as.integer(length(feature_catalogue$layer)+8)),
    c(9,"group_supermarket",as.integer(length(feature_catalogue$layer)+9)),
    c(10,"group_kiosk",as.integer(length(feature_catalogue$layer)+10)),
    c(11,"group_ruins",as.integer(length(feature_catalogue$layer)+11)),
    c(12,"group_religious_building",as.integer(length(feature_catalogue$layer)+12)),
    c(13,"group_parking",as.integer(length(feature_catalogue$layer)+13)),
    c(14,"group_glacier",as.integer(length(feature_catalogue$layer)+14)),
    c(15,"group_residential_building",as.integer(length(feature_catalogue$layer)+15)),
    c(16,"group_school",as.integer(length(feature_catalogue$layer)+16)),
    c(17,"group_railway_station",as.integer(length(feature_catalogue$layer)+17)),
    c(18,"group_garage",as.integer(length(feature_catalogue$layer)+18)),
    c(19,"group_water_tower",as.integer(length(feature_catalogue$layer)+19)),
    c(20,"group_graveyard",as.integer(length(feature_catalogue$layer)+20)),
    c(21,"group_park",as.integer(length(feature_catalogue$layer)+21))))
  
  colnames(feature_groups) <- c("group","title","index")
  
  feature_groups$group <- as.integer(as.character(feature_groups$group))
  feature_groups$title <- as.character(feature_groups$title)
  feature_groups$index <- as.integer(as.character(feature_groups$index))
  
  return(feature_groups)
}

FCLASS_create_long_names <- function(dataset)
{
  shapefile <- character(length(dataset$layer))
  for (i in 1:length(dataset$layer))  ## Concatenate long names for clear identification
  {
    if(dataset$layer[i] == "places")
    {
      shapefile[i] = paste("places",dataset$fclass[i],sep="_")
    }
    else if(dataset$layer[i] == "pofw")
    {
      shapefile[i] = paste("pofw",dataset$fclass[i],sep="_")
    }
    else if(dataset$layer[i] == "natural")
    {
      shapefile[i] = paste("natural",dataset$fclass[i],sep="_")
    }
    else if(dataset$layer[i] == "traffic")
    {
      shapefile[i] = paste("traffic",dataset$fclass[i],sep="_")
    }
    else if(dataset$layer[i] == "transport")
    {
      shapefile[i] = paste("transport",dataset$fclass[i],sep="_")
    }
    else if(dataset$layer[i] == "railways")
    {
      shapefile[i] = paste("railways",dataset$fclass[i],sep="_")
    }
    else if(dataset$layer[i] == "roads")
    {
      shapefile[i] = paste("roads",dataset$fclass[i],sep="_")
    }
    else if(dataset$layer[i] == "landuse")
    {
      shapefile[i] = paste("landuse",dataset$fclass[i],sep="_")
    }
    else if(dataset$layer[i] == "building")
    {
      shapefile[i] = paste("building",dataset$fclass[i],sep="_")
    }
    else if(dataset$layer[i] == "water")
    {
      shapefile[i] = paste("water",dataset$fclass[i],sep="_")
    }
    else if(dataset$layer[i] == "waterways")
    {
      shapefile[i] = paste("waterways",dataset$fclass[i],sep="_")
    }
    else
    {
      shapefile[i] = paste("pois",dataset$fclass[i],sep="_")
    }
  }
  return(shapefile)
}

FCLASS_generalise_catalogue <- function(dataset)
{
  features_unique <- unique(dataset$long_name)
  features_old <- c(NA)
  features_new <- c(NA)
  dataset <- add_column(dataset, "generalisation" = dataset$long_name)
  
  for (i in 1:length(features_unique)) ## checks whether this string is present in another string. According to the documentation this is used to specify subcategories. (eg. traffic_parking and traffic_parking_underground)
  {
    temp_reference <- grepl(paste(features_unique[i],"_",sep=""), features_unique, fixed=TRUE)  ## search for current term in whole column; underscore necessary to avoid e.g. 'pois_public_building' to be coerced to 'pois_pub'
    for (j in 1:length(temp_reference))
    {
      if(isTRUE(temp_reference[j]) & j != i )
      {
        features_old <- rbind(features_old,features_unique[j]) ## save to-be-overwritten values here
        features_new <- rbind(features_new,features_unique[i]) ## save overwrite values here
      }
    }
  }
  
  for (i in 1:length(dataset$long_name))  ## if current value exists in to-be-overwritten values, replace value with corresponding overwrite value
  {
    if(dataset$long_name[i] %in% features_old) ## is feature present in to-be-overwritten values?
    {
      dataset$generalisation[i] = features_new[match(dataset$long_name[i],features_old)]  ## find the index number by matching current value with to-be-overwritten values and use that to overwrite with generalised value.
      dataset$catalogue_index[i] <- dataset$catalogue_index[match(dataset$generalisation[i],dataset$generalisation)]
    }
    
    if(is.na(dataset$filter[i]) == TRUE)
    {
      dataset$catalogue_index[i] = NA
    }
    else if(dataset$filter[i] != 0)
    {
      dataset$generalisation[i] = feature_groups$title[dataset$filter[i]]
      dataset$catalogue_index[i] = feature_groups$index[dataset$filter[i]]
    }
  }
  return(dataset)
}