alias River.Store

# Connect to peer1, it will notify us of all other nodes
Node.connect(:"peer1@127.0.0.1")

# Wait for Node.connect to do it's thing
Process.sleep(500)

# List of members is all nodes, except this one
members = Node.list() -- [node()]

# The state machine uses River.Store, default config is empty map
state_machine = {:module, Store, %{}}

# Start the cluster, call it :my_cluster
:ra.start_cluster(:my_cluster, state_machine, members)

# Wait for a leader to be elected
Process.sleep(500)

# Print some metrics
# :ra.overview() |> IO.inspect

# Pick a random server to communicate with
random_server = Node.list() |> Enum.random()

# Make request to random server id
# All responses include the current leader, so save it for future requests
{:ok, leader} = Store.write(random_server, :foo, 1) |> IO.inspect(label: "write")

# Run more commands
Store.read(leader, :foo) |> IO.inspect(label: "read")
Store.delete(leader, :foo) |> IO.inspect(label: "delete")
Store.read(leader, :foo) |> IO.inspect(label: "read")
