server "staging.wftda.wiserstudios.com",
  user: "deploy",
  roles: %w{app db web},
  processes: %w{web},
  ssh_options: {
    forward_agent: true
  }
