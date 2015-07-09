GameState = require '../models/game_state'
class Exporter
  export: (game) ->
    version: '0.0.1'
    type: 'game'
    teams:
      home: @exportTeam game.home, 'Home'
      away: @exportTeam game.away, 'Away'
      officials: @exportOfficials (game)
    periods:
      1: @exportPeriod(game, 1)
      2: @exportPeriod(game, 2)
    venue:
      name: game.venue
    uuid: game.id
    date: game.date
    time: game.time
    timers: []
    expulsions: []
    suspensions: []
    signatures: []
    association: 'WFTDA'
  exportTeam: (team, level) ->
    name: team.name
    abbreviation: team.initials
    persons: team.skaters.map (skater) =>
      @exportSkater(skater)
    level: level
    date: Date.now()
    color: team.colorBarStyle
    logos: [team.logo]
  exportSkater: (skater) ->
    name: skater.name
    number: skater.number
    uuid: skater?.id
  exportOfficials: (game) ->
    name: 'Officials'
    persons: game.officials.map (official) =>
      @exportOfficial official
    level: 'Officials'
    date: Date.now()
  exportOfficial: (official) ->
    name: official
  exportPeriod: (game, periodNumber) ->
    events = {}
    game.away.jams.forEach (jam) =>
      events[jam.jamNumber] = @exportJamEvents(jam)
    game.home.jams.forEach (jam) =>
      if events[jam.jamNumber]?
        events[jam.jamNumber] = events[jam.jamNumber].concat @exportJamEvents(jam)
      else
        events[jam.jamNumber] = @exportJamEvents(jam)
    Object.keys(events).map (number) ->
      number: number
      events: events[number]
  exportJamEvents: (jam) ->
    passes = jam.passes.map (pass) ->
      event: 'pass'
      number: pass.passNumber
      score: pass.points
      skater: pass.jammer?.id
      completed: not pass.noPass
    lineup = ['jammer', 'pivot', 'blocker1', 'blocker2', 'blocker3'].map (position) ->
      event: 'line up'
      skater: jam[position]?.id
      position: position
    events = passes.concat(lineup)
    if jam.starPass
      events.push
        event: 'star pass'
        skater: jam.jammer?.id
        completed: true
    jam.passes.forEach (pass) ->
      if pass.lead
        events.push
          event: 'lead'
          skater: pass.jammer?.id
      if pass.lostLead
        events.push
          event: 'lost lead'
          skater: pass.jammer?.id
      if pass.injury
        events.push
          event: 'injury'
          skater: pass.jammer?.id
      if pass.calloff
        events.push
          event: 'call'
          skater: pass.jammer?.id
    events
module.exports = new Exporter()