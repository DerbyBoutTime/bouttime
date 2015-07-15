
AppDispatcher = require './dispatcher/app_dispatcher'
{ActionTypes} = require './constants'
module.exports =
  init: () ->
    GameState = require './models/game_state'
    Team = require './models/team'
    Skater = require './models/skater'
    homeSkaters = [
      {name: "Wild Cherri"
      number: "6"
      penalties: []}
      ,
      {name: "Rebel Yellow"
      number: "12AM"
      penalties: []}
      ,
      {name: "Agent Maulder"
      number: "X13"
      penalties: []}
      ,
      {name: "Alassin Sane"
      number: "1973"
      penalties: []}
      ,
      {name: "Amelia Scareheart"
      number: "B52"
      penalties: []}
      ,
      {name: "Belle of the Brawl"
      number: "32"
      penalties: []}
      ,
      {name: "Bruze Orman"
      number: "850"
      penalties: []}
      ,
      {name: "ChokeCherry"
      number: "86"
      penalties: []}
      ,
      {name: "Hollicidal"
      number: "1013"
      penalties: []}
      ,
      {name: "Jammunition"
      number: "50CAL"
      penalties: []}
      ,
      {name: "Jean-Juke Picard"
      number: "1701"
      penalties: []}
      ,
      {name: "Madditude Adjustment"
      number: "23"
      penalties: []}
      ,
      {name: "Nattie Long Legs",
      number: "504"
      penalties: []}
      ,
      {name: "Ozzie Kamakazi"
      number: "747"
      penalties: []}
    ]
    awaySkaters = [
      {name: "Ana Bollocks"
      number: "00"
      penalties: []}
      ,
      {name: "Bonita Apple Bomb"
      number: "4500º"
      penalties: []}
      ,
      {name: "Bonnie Thunders"
      number: "340"
      penalties: []}
      ,
      {name: "Caf Fiend"
      number: "314"
      penalties: []}
      ,
      {name: "Claire D. Way"
      number: "1984"
      penalties: []}
      ,
      {name: "Davey Blockit"
      number: "929"
      penalties: []}
      ,
      {name: "Donna Matrix",
      number: "2"
      penalties: []}
      ,
      {name: "Fast and Luce"
      number: "17"
      penalties: []}
      ,
      {name: "Fisti Cuffs"
      number: "241"
      penalties: []}
      ,
      {name: "Hyper Lynx"
      number: "404"
      penalties: []}
      ,
      {name: "Mick Swagger"
      number: "53"
      penalties: []}
      ,
      {name: "Miss Tea Maven"
      number: "1706"
      penalties: []}
      ,
      {name: "OMG WTF"
      number: "753"
      penalties: []}
      ,
      {name: "Puss 'n Glues"
      number: "999 Lives"
      penalties: []}
    ]
    GameState.new 
      name: "Demo Game"
      venue: "The Internet"
      date: "07/31/2015"
      time: "5:00 PM"
      home:
        name: "Atlanta"
        initials: "ARG"
        colorBarStyle:
          backgroundColor: "#2082a6"
          color: "#ffffff"
        logo: "/images/team_logos/Atlanta.png"
        skaters: homeSkaters
      away:
        name: "Gotham"
        initials: "GGRD"
        colorBarStyle:
          backgroundColor: "#f50031"
          color: "#ffffff"
        logo: "/images/team_logos/Gotham.png"
        skaters: awaySkaters
