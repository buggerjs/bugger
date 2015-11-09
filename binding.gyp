{
  "targets": [
    {
      "target_name": "DebugThread",
      "sources": [
        "src/debug-thread.cc",
      ],
      "include_dirs": ["<!(node -e \"require('nan')\")"]
    }
  ]
}
