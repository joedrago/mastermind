class Mastermind
  @MAX_COLORS: 6

  constructor: ->
    @newGame()

  newGame: ->
    @done = false
    @next = 0
    @answer = []
    for i in [0...4]
      @answer.push 1 + (Math.floor(Math.random() * Mastermind.MAX_COLORS))
    # @answer = [3,4,3,4] # debug hack
    @guesses = []
    for i in [0...10]
      @guesses.push {
        colors: [0,0,0,0]
        # colors: [
        #   1 + (Math.floor(Math.random() * Mastermind.MAX_COLORS))
        #   1 + (Math.floor(Math.random() * Mastermind.MAX_COLORS))
        #   1 + (Math.floor(Math.random() * Mastermind.MAX_COLORS))
        #   1 + (Math.floor(Math.random() * Mastermind.MAX_COLORS))
        # ]
        hints: [0,0,0,0]
        # hints: [
        #   1 + (Math.floor(Math.random() * 2))
        #   1 + (Math.floor(Math.random() * 2))
        #   1 + (Math.floor(Math.random() * 2))
        #   1 + (Math.floor(Math.random() * 2))
        # ]
      }

  guess: (colors) ->
    if @done
      return

    @guesses[@next].colors = colors

    answerCounts = []
    for i in [0..Mastermind.MAX_COLORS]
      answerCounts[i] = 0
    for a in @answer
      answerCounts[a] += 1

    perfect = 0
    almost = 0
    wasPerfect = [false, false, false, false]
    for color, colorIndex in colors
      if color == @answer[colorIndex]
        perfect += 1
        answerCounts[color] -= 1
        wasPerfect[colorIndex] = true
    for color, colorIndex in colors
      if not wasPerfect[colorIndex] and (answerCounts[color] > 0)
        answerCounts[color] -= 1
        almost += 1

    if perfect == 4
      @done = true

    for i in [0...4]
      hint = 0
      if perfect > 0
        hint = 1
        perfect -= 1
      else if almost > 0
        hint = 2
        almost -= 1
      @guesses[@next].hints[i] = hint

    @next += 1
    if @next == @guesses.length
      @done = true

    return null


module.exports = Mastermind
