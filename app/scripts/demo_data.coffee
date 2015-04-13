module.exports = 
  state: 'pregame'
  jamNumber: 0
  periodNumber: 0
  jamClock:
    time: 90*60*1000
    display: "90:00"
  periodClock: 
    time: 0
    display: "0"
  home:
    name: "Atlanta Rollergirls"
    initials: "ARG"
    colorBarStyle:
      backgroundColor: "#2082a6"
      color: "#ffffff"
    logo: "/images/team_logos/Atlanta.png"
    isTakingOfficialReview: false
    isTakingTimeout: false
    hasOfficialReview: true
    timeouts: 3
    skaters: [
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
    jams: [
      jamNumber: 1
      noPivot: false
      starOass: false
      pivot: null
      blocker1: null
      blocker2: null
      blocker3: null
      jammer: null
      passes: [
        passNumber: 1
        points: 0
        jammer: null
        injury: false
        lead: false
        lostLead: false
        calloff: false
        nopass: false
      ]
      lineupStatuses: []
    ]
    penaltyBoxStates: []
  away:
    name: "Gotham Rollergirls"
    initials: "GRG"
    colorBarStyle:
      backgroundColor: "#f50031"
      color: "#ffffff"
    logo: "/images/team_logos/Gotham.png"
    isTakingOfficialReview: false
    isTakingTimeout: false
    hasOfficialReview: true
    timeouts: 3
    skaters: [
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
    jams: [
      jamNumber: 1
      noPivot: false
      starPass: false
      pivot: null
      blocker1: null
      blocker2: null
      blocker3: null
      jammer: null
      passes: [
        passNumber: 1
        points: 0
        jammer: null
        injury: false
        lead: false
        lostLead: false
        calloff: false
        nopass: false
      ]
      lineupStatuses: []
    ]
    penaltyBoxStates: []
  penalties: [
    {name: "High Block"
    code: "A"}
    ,
    {name: "Insubordination"
    code: "N"}
    ,
    {name: "Back Block"
    code: "B"}
    ,
    {name: "Skating Out of Bnds."
    code: "S"}
    ,
    {name: "Elbows"
    code: "E"}
    ,
    {name: "Cutting the Track"
    code: "X"}
    ,
    {name: "Forearms"
    code: "F"}
    ,
    {name: "Delay of Game"
    code: "Z"}
    ,
    {name: "Misconduct"
    code: "G"}
    ,
    {name: "Dir. of Game Play"
    code: "C"}
    ,
    {name: "Blocking with Head"
    code: "H"}
    ,
    {name: "Out of Bounds"
    code: "O"}
    ,
    {name: "Low Block"
    code: "L"}
    ,
    {name: "Out of Play"
    code: "P"}
    ,
    {name: "Multi-Player Block"
    code: "M"}
    ,
    {name: "Illegal Procedure"
    code: "I"}
    ,
    {name: "Gross Misconduct"
    code: "G"}
  ]