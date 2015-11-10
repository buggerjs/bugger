{
  "targets": [
    {
      "target_name": "DebugThread",
      "sources": [
        "src/module.cc",
        "src/thread.cc",
        "src/thread-proxy.cc",
      ],
      "include_dirs": ["<!(node -e \"require('nan')\")"]
    }
  ]
}
