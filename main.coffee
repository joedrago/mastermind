Mastermind = require './Mastermind'
readline = require 'readline/promises'
colors = require 'colors'

drawColors = (colors) ->
  line = ""
  for color in colors
    line += switch color
      when 1
        "██ ".brightRed
      when 2
        "██ ".brightGreen
      when 3
        "██ ".brightBlue
      when 4
        "██ ".brightYellow
      when 5
        "██ ".brightCyan
      when 6
        "██ ".brightMagenta
      else
        ".. "
  return line

draw = (game) ->
  if game.done
    line = drawColors(game.answer)
  else
    line = drawColors([0,0,0,0])
  # line = drawColors(game.answer) # cheating
  console.log "#{line}\n\n"

  for guess in game.guesses by -1
    line = drawColors(guess.colors)
    line += "         "
    for hint in guess.hints
      line += switch hint
        when 1
          "o ".green
        when 2
          "o ".white
        else
          ""
    console.log "#{line}\n"

main = ->
  rl = readline.createInterface({ input: process.stdin, output: process.stdout })

  game = new Mastermind

  colorMap =
    "1": 1
    "2": 2
    "3": 3
    "4": 4
    "5": 5
    "6": 6
    r: 1
    g: 2
    b: 3
    y: 4
    c: 5
    m: 6

  error = null
  loop
    console.clear()
    draw(game)

    if error?
      console.log "\nERROR: #{error}\n".brightRed
    else
      console.log "\n\n"

    rawGuess = await rl.question('> ')
    if rawGuess == 'new'
      game.newGame()
      error = null
      continue

    error = null
    rawColors = rawGuess.split("").filter (a) -> a != " "
    if rawColors.length != 4
      error = "Your guess must be exactly 4 colors."
      continue
    colors = []
    for rawColor in rawColors
      rawColor = rawColor.toLowerCase()
      if not colorMap[rawColor]?
        error = "No such color as \"#{rawColor}\", please use one of: r,g,b,y,c,m"
      colors.push(colorMap[rawColor])
    if not error?
      error = game.guess(colors)

  rl.close()

main()
