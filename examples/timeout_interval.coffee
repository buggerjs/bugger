
setTimeout(
  ->
    i = setInterval(
      ->
        clearInterval i
        console.log 'ok'
        setTimeout(
          -> process.exit 0
          100
        )
      20
    )
  50
)
