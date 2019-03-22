# River

Example distributed Key/Value cluster using [RabbitMQ's RAFT implementation](https://github.com/rabbitmq/ra)

## Installation

```bash
git clone https://github.com/joshnuss/river.git
cd river
mix do deps.get, compile
```

## Starting the cluster

Run boot script. It forms a cluster of 5 peers, and elects a leader.

```bash
./boot.sh
```

## License

MIT
