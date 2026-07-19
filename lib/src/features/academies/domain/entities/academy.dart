class Academy {
  const Academy({
    required this.id,
    required this.name,
    required this.url,
    required this.coach,
    required this.address,
    required this.phone,
    required this.schedule,
    required this.badge,
    required this.latitude,
    required this.longitude
  });

  final String id;
  final String name;
  final String url;
  final String coach;
  final String address;
  final String phone;
  final String schedule;
  final String badge;
  final double latitude;
  final double longitude;

  static const mockAcademies = <Academy>[
  Academy(
  id: '1',
  coach: '',
  badge: 'Academia Federada',
  name: 'Guerreros Club de Artes Marciales',
  address: 'Av. de las Américas 10-84',
  phone:'+593 99 314 8868',
  schedule: 'Lun - Vier 4:45 a 9 PM',
  url:'https://lh3.googleusercontent.com/gps-cs-s/APNQkAHUz6X9Z4p6fJS3nret9_QpR7rPDLXOMXKGu0K783wQ6ZYcsR1KgaH5xznQA8_OfA-7eh9m3tNKLS-wLk8GIGkClIawgsJsdoBG99fc3tgE6q8pu1_mxBqpKTus0pROz76qog-x=s1024-v1',
  latitude: -2.8890411,
  longitude:-79.0154981,),

  Academy(
  id: '1',
  coach: '',
  schedule: 'Lun - Vier 4:45 a 9 PM',
  badge: 'Academia Federada',
  name: 'Club de Artes Marciales Hnos. Pintado',
  address: 'Luis Moscoso, y y Carmela Malo',
  phone:'+593 98 131 2716',
  url:'https://lh3.googleusercontent.com/gps-cs-s/APNQkAHs-LmFbr3GCN-wiGlBDxZL5niTCJa09XjFlM0QhYA5RNDQ8pbH8i6Btnps-MVxW7Iz3zpkwCSeZciqLcr7Qut5Qy1Bfii_lNKm82D9-gLvM2fOBFUP9iinNWn5d2Gjzw9r_wEo=s1024-v1',
  latitude:-2.9074963,
  longitude:-79.0396272),
  Academy(
  id: '1',
  coach: '',
  schedule: 'Lun - Vier 4:45 a 9 PM',
  badge: 'Academia Federada',
  name: 'JB SPORTS Artes Marciales',
  address: 'Av. Abelardo J. Andrade, y y José Ortega M., Cuenca',
  phone:'+593 98 584 7967',
  url:'https://lh3.googleusercontent.com/gps-cs-s/APNQkAFtAOGWsXOIw284Hligha1behyKrZUSuxjOQtnH9W4YQdX13xPXftVU6m8CS0iedmaT-W2J5nd4vPmd5FMjC1DAruT9USyx2iQ40hDPQUi3Afg1eYDSZLs-y2G_6O4jyfma4kUDnLQ_ocRH=s1024-v1',
  latitude:-2.9104004999999997,
  longitude:-79.0212413),

  Academy(
  id: '1',
  coach: '',
  schedule: 'Lun - Vier 4:45 a 9 PM',
  badge: 'Academia Federada',
  name: 'JB SPORTS Artes Marciales',
  address: 'Av. Abelardo J. Andrade, y y José Ortega M.',
  phone:'+593 98 584 7967',
  url:'https://lh3.googleusercontent.com/gps-cs-s/APNQkAH4eXmIH7L7RqzyCD5zmD4af3PEh10k5gKO0nFKrkd59ZpFv5GKtUldKcm0zbAFDdZDCk9ZjryAIa_AllUmvChlbrsRFPCuBrB7CMxtgKNcKYQFky7vTYgbtRvEbv3b0lk2qbJ3xg=s1024-v1',
  latitude:-2.8840516,
  longitude: -79.0159065),

  Academy(
  id: '1',
  coach: '',
  schedule: 'Lun - Vier 4:45 a 9 PM',
  badge: 'Academia Federada',
  name: 'Taekwondo 360	Martial arts school',
  address:'Valle del Catamayo',
  phone:'+593 95 898 9947',
  url:'https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=S5bYHlP-t82bGTZpKRM-tQ&cb_client=search.gws-prod.gps&w=80&h=92&yaw=142.2443&pitch=0&thumbfov=100',
  latitude:-2.8957052,
  longitude:-79.0174127),

  Academy(
  id: '1',
  coach: '',
  schedule: 'Lun - Vier 4:45 a 9 PM',
  badge: 'Academia Federada',
  name: 'MW Chango Taekwondo	Martial arts school',
  address:'Carlos Vintimilla',
  phone:'+593 7-409-4392',
  url:'lh6.googleusercontent.com/Qkn2Vz-8ALGr24apbYDUoYC0plZqbrGSry2oSF60gYEs6EdrEY78IlEVve3x6ec=s1024-v1',
  latitude:-2.8958475999999997,
  longitude:-79.026129),
    Academy(
      id: '2',
      coach: '',
      schedule: 'Lun - Vier 3 PM - 9 PM',
      badge: 'Academia',
      name: 'Chango Academy Taekwondo',
      address: '4228+Q47, Cuenca, Ecuador',
      phone: '+593 99 273 0020',
      url: 'https://lh3.googleusercontent.com/gps-cs-s/APNQkAG2B3fEwFyJhcA2CbGOBV6ov5z14NyTi8x9ogzwNC10ssHoiQDX099W69KSuTDDhyAdK2Z15HYdkFu_QJZ4JrkWS_BXbm5OXvpL3ZBVshYGJSosl7y5sT0FpYvxnz94LRTYChE=s1024-v1',
      latitude: -2.8980846,
      longitude: -78.9846984,
    ),

    Academy(
      id: '3',
      coach: '',
      schedule: 'Lun - Vie 5 AM - 10 PM',
      badge: 'Academia',
      name: 'INFINITE MARTIAL ARTS',
      address: '010206, Cuenca, Ecuador',
      phone: '+593 95 895 8445',
      url: 'https://lh3.googleusercontent.com/gps-cs-s/APNQkAH-5HnCi0PMqzHAYE9QeRHMinSkGtypQBuzDTy1mRUaxThiBCruRWtNRfiFfDhjnsNY7oYIP--QaxNF6P5o97noxLOlDLWF7gf2lBMBIEmJDWFPShjPgWzuwQR4arKHI8yv0uE8=s1024-v1',
      latitude: -2.9048112,
      longitude: -79.0485171,
    ),

    Academy(
      id: '4',
      coach: '',
      schedule: 'Lun - Vie 4 PM - 8:30 PM',
      badge: 'Academia',
      name: 'MOO SUL DOJANG IÑIGUEZ',
      address: 'Cayapas y De los Puruhaes, Cuenca',
      phone: '+593 98 720 5615',
      url: 'https://lh3.googleusercontent.com/gps-cs-s/APNQkAGL6YtHa7gseXGptJRii18vxA7WBiZxfktC7rDQyesoJwUgULll7_swqutkKgdhqK-wpXreuK7b_iariiFSLRKl6UfhJklriSrZ-ZylsrUFd7sqHTJCeTrzGa_uUJyFJcbG2QE5cA=s1024-v1',
      latitude: -2.8874264,
      longitude: -78.9739439,
    ),

    Academy(
      id: '5',
      coach: '',
      schedule: 'Lun - Vie 3 PM - 8 PM',
      badge: 'Academia',
      name: 'MOODUKKWAN HORANGI DOJANG',
      address: 'Caupolicán y Av. Yana Urco, Cuenca',
      phone: '+593 99 500 5015',
      url: 'https://lh3.googleusercontent.com/gps-cs-s/APNQkAHWdLPqw2Vdx0kCbxgj7DnhH8QymvzncXql7XbimM03iZUeHEGIv2JVJLamkd1qZ_oh00NB7jlDGLg_leAAkWXEVFElgZ41JfQNBA1-pATOAPVXpRbgM7gyb_MemX2hslI0GWyFnw=s1024-v1',
      latitude: -2.893765,
      longitude: -78.9765653,
    ),

    Academy(
      id: '6',
      coach: '',
      schedule: '',
      badge: 'Academia',
      name: 'KAMIKAZE KENTO',
      address: 'Av. Loja, Cuenca',
      phone: '+593 98 087 0014',
      url: 'https://lh3.googleusercontent.com/LYACDS6xSS_A1YbZt8nXUqcIEsBDVWVFu0wJGcM275zLS3zEKBvKDA5R82fsI9c=s1024-v1',
      latitude: -2.9171434,
      longitude: -79.0338497,
    ),

    Academy(
      id: '7',
      coach: '',
      schedule: 'Lun - Vie 3 PM - 9 PM',
      badge: 'Academia',
      name: 'SAMURAI TEAM PREDADOR ARTES MARCIALES',
      address: 'Antonio Neumane y Enrique Espín 2-06, Cuenca',
      phone: '+593 96 299 1379',
      url: 'https://lh3.googleusercontent.com/gps-cs-s/APNQkAFsR3mY6d47TIBSKoQlpvz4LhruYwM-CdLyHQouMQXu-vUnbRDcE2mPN_2JKjhNOAh-dzP_VLZAJac28oBHLfEy76_zDIVVrDvaJfPZPpGqvcZ-XaNUtPL5peHnYhkwGLEueUcKiXZUhdV6=s1024-v1',
      latitude: -2.8818651,
      longitude: -78.9910463,
    ),

    Academy(
      id: '8',
      coach: '',
      schedule: 'Lun - Vie 5 AM - 9 PM',
      badge: 'Academia',
      name: 'Gimnasio de Artes Marciales MC',
      address: 'Av. Huayna Cápac y Alfonso Malo 3-23, Cuenca',
      phone: '+593 99 332 7625',
      url: 'https://lh3.googleusercontent.com/gps-cs-s/APNQkAGOTaQQvtNmNbVISXSGTzOIzEaj5NmqBBt1fTXM7AaphPsJDBDdqXWSZZURy1W2Rcmq7wMHAwa0g0tyfT-AGblpNazUxxrgm4nq-zXJyB0oLIk3q5u3dz9Mv0RHKruT2VVN6AIL=s1024-v1',
      latitude: -2.9046148,
      longitude: -78.9966989,
    ),

    Academy(
      id: '9',
      coach: '',
      schedule: 'Lun - Vie 7 AM - 9 PM',
      badge: 'Academia',
      name: 'Dojo Artes Marciales Cuenca',
      address: 'Victoria del Portete y Batallón Rifles, Cuenca',
      phone: '+593 99 996 6148',
      url: 'https://lh3.googleusercontent.com/gps-cs-s/APNQkAFzZRd9Rdt5LNyZCGdkztVfSwa7LW5-Wyb147Axt4fC4wuiUFY5lFnqO6SbGhKeGKx7it3Ot5XJX8r6YUQXdP29R-aj86oU6bqE_4B2pigybSXs8pC4PbW87OC-ohqIpEbqG7CEBw=s1024-v1',
      latitude: -2.8808543,
      longitude: -78.9672111,
    ),

    Academy(
      id: '10',
      coach: '',
      schedule: 'Lun - Jue 7:15 AM - 9:15 PM',
      badge: 'Academia',
      name: 'ZT Taekwondo',
      address: '010107 Cuenca, Ecuador',
      phone: '+593 99 879 2452',
      url: 'https://lh3.googleusercontent.com/gps-cs-s/APNQkAGUXGEL1S5rbzYXFdHquVgLjG1_bs1riZVfTCHEcRLjva4YwcbtKKj0aSmNWGbJmDqsAbFsYusYExVIFl1RRiHhHVO8zN1K9pRdGXYnT0Ay1nGgxJ7xEYGk7E9mFDbOL3-uiF5R=s1024-v1',
      latitude: -2.8962381,
      longitude: -78.9796521,
    ),

  ];
}
