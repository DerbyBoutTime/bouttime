GameState = require '../models/game_state'
class Exporter
  export: (game) ->
    version: '0.0.3'
    type: 'game'
    teams:
      home: @exportTeam game.home, 'home'
      away: @exportTeam game.away, 'away'
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
    date: (new Date).toJSON()
    color: team.colorBarStyle
    logos: [
            url: team.logo
    ]
  exportSkater: (skater) ->
    name: skater.name
    number: skater.number
    uuid: [skater?.id]
  exportOfficials: (game) ->
    name: 'officials'
    persons: game.officials.map (official) =>
      @exportOfficial official
    date: (new Date).toJSON()
  exportOfficial: (official) ->
    name: official
  exportPeriod: (game, periodNumber) ->
    number: periodNumber
    jams: @exportJams(game.home, game.away)
  exportJams: (home, away) ->
            fmtSkaterId = (team, skaterNumber) ->
                team + ":" + skaterNumber
            retval = []
            curJamEvents = []
            # extract the the lineup events
            addLineup = (teamid, jam) ->
                if jam.jammer
                    curJamEvents.push
                        event: "lineup"
                        skater: fmtSkaterId(teamid, jam.jammer.number)
                        position: "jammer"
                if jam.pivot
                    curJamEvents.push
                        event: "lineup"
                        skater: fmtSkaterId(teamid, jam.pivot.number)
                        position: if jam.noPivot then "blocker" else "pivot"
                if jam.blocker1
                    curJamEvents.push
                        event: "lineup"
                        skater: fmtSkaterId(teamid, jam.blocker1.number)
                        position: "blocker"
                if jam.blocker2
                    curJamEvents.push
                        event: "lineup"
                        skater: fmtSkaterId(teamid, jam.blocker2.number)
                        position: "blocker"
                if jam.blocker3
                    curJamEvents.push
                        event: "lineup"
                        skater: fmtSkaterId(teamid, jam.blocker3.number)
                        position: "blocker"
            # extract pass events
            hasInjury = false # TODO: change this to a list of injured skaters (could be more than one)
            addPasses = (teamid, jam) ->
                jammerId = fmtSkaterId(teamid, (if jam.jammer then jam.jammer.number else "???"))
                # this will not properly handle no pass being recorded to the original jammer in a star pass?
                # actually, we don't see where star passes are recorded at all yet
                for pass in jam.passes
                    curJamEvents.push
                        event: "pass"
                        number: pass.passNumber
                        score: pass.points
                        skater: jammerId
                        completed: !pass.nopass
                    if pass.calloff
                        curJamEvents.push
                            event: "call"
                            skater: jammerId
                    if pass.lead
                        curJamEvents.push
                            event: "lead"
                            skater: jammerId
                    if pass.lostLead
                        curJamEvents.push
                            event: "lost lead"
                            skater: jammerId
#                    if pass.starPassNumber
# TODO:                    figure out how star passes are recorded
                    # injuries should be part of the lineup information
                    # but if they aren't recorded, at least make sure this is here
                    if pass.injury and !hasInjury
                        hasInjury = true # only record it once
                        # TODO: we don't know what skater it was yet - that is in the lineup info
                        curJamEvents.push
                            event: "injury"
            addPenalties = (teamid, skaters, jamNum) ->
                for skater in skaters
                    for penalty in skater.penalties when  penalty.jamNumber == jamNum
                        curJamEvents.push
                            event: "penalty"
                            skater: fmtSkaterId(teamid, skater.number)
                            penalty: penalty.penalty.code
                            # Current, BT does not support expulsions other than Gross Misconduct
                            severity: "expulsion" if penalty.penalty.name == "Gross Misconduct"
            addBoxTrips = (teamid, skaters, jam) ->
                for statuses in jam.lineupStatuses
                    for position in ["jammer","pivot","blocker1","blocker2","blocker3"]
                        status = statuses[position]
                        skaterId = fmtSkaterId(teamid, jam[position].number) if status
                        startInBox = false
                        enterBox = false
                        exitBox = false
                        switch status
                            when 'went_to_box'
                                enterBox = true
                            when 'went_to_box_and_release'
                                enterBox = true
                                exitBox = true
                            when 'sat_in_box'
                                startInBox = true
                            when 'sat_in_box_and_released'
                                startInBox = true
                                exitBox = true
                            when 'continuing_penalty'
                                startInBox = true
                            when 'continuing_penalty_and_released'
                                startInBox = true
                                exitBox = true
                            when 'injured'
                                # if "call for injury" was checked, we want
                                # to set the skater here (if possible)
                                foundInjuryEvent = false
                                multipleInjuries = false
                                for injuryEvent in curJamEvents when injuryEvent.event == "injury"
                                    if injuryEvent.skater
                                        multipleInjuries = true
                                    else
                                        injuryEvent.skater = skaterId
                                        foundInjuryEvent = true
                                        break
                                if !foundInjuryEvent
                                    # either there was no "call for injury"
                                    # or else there were multiple injuries
                                    curJamEvents.push
                                        event: "injury"
                                        skater: skaterId
                                        notes: [
                                            note: if multipleInjuries then "Multiple injuries" else "Jam not marked as called for injury"
                                        ]
                        if enterBox
                            curJamEvents.push
                                event: "enter box"
                                skater: skaterId
                        if startInBox
                            # look up lineup for skaterId in this jam, mark as starting in box
                            for lineupEvent in curJamEvents when lineupEvent.event == "lineup" and lineupEvent.skater == skaterId
                                lineupEvent.start_in_box = true
                        if exitBox
                            curJamEvents.push
                                event: "exit box"
                                skater: skaterId
                            
            # TODO: determine period 1 vs period 2
            numJams = if home.jams.length > away.jams.length then home.jams.length else away.jams.length
            for jamNum in [1..numJams]
                homeJam = home.jams[jamNum-1]
                awayJam = away.jams[jamNum-1]
                curJamEvents = []
                hasInjury = false
                addLineup("home", homeJam) if homeJam
                addLineup("away", awayJam) if awayJam
                addPasses("home", homeJam) if homeJam
                addPasses("away", awayJam) if awayJam
                addPenalties("home", home.skaters, jamNum)
                addPenalties("away", away.skaters, jamNum)
                addBoxTrips("home", home.skaters, homeJam) if homeJam
                addBoxTrips("away", away.skaters, awayJam) if awayJam
                # add the jam  with it events to the period
                retval.push
                    number: jamNum
                    events: curJamEvents
            retval
module.exports = new Exporter()