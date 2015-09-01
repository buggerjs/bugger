{
  "targets": [
    {
      "target_name": "AgentDebug",
      "sources": [
        "src/agent-debug.cc",
      ],
      "include_dirs": ["<!(node -e \"require('nan')\")"]
    }
  ]
}
