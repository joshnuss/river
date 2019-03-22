#!/bin/bash

# Start 5 servers
elixir --name peer1@127.0.0.1 -S mix run --no-halt &
elixir --name peer2@127.0.0.1 -e 'Node.connect(:"peer1@127.0.0.1")' -S mix run --no-halt &
elixir --name peer3@127.0.0.1 -e 'Node.connect(:"peer1@127.0.0.1")' -S mix run --no-halt &
elixir --name peer4@127.0.0.1 -e 'Node.connect(:"peer1@127.0.0.1")' -S mix run --no-halt &
elixir --name peer5@127.0.0.1 -e 'Node.connect(:"peer1@127.0.0.1")' -S mix run --no-halt &

# Wait for them to find each other
sleep 1

# Form the RAFT cluster
elixir --name shell@127.0.0.1 -S mix run --no-halt formation.exs
