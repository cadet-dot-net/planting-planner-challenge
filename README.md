# Planter

## Pre-requisites
- Erlang 26.1+
- Elixir 1.15+
- Phoenix 1.7+

## Setup
To start your Phoenix server:

* Run `mix setup` to install and setup dependencies
* 
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

This opens up [`localhost:4000`](http://localhost:4000) to visit.

## Testing

I manually hit these endpoints with some sample data. (Sample data taken from challenge repo)

Mostly manual testing with APIs.

Checking for status codes in GET APIs:
```
curl -I http://localhost:4001/api/plans
curl -I http://localhost:4001/api/plans/:id
curl -I http://localhost:4001/api/plans/:id/score
curl -I http://localhost:4001/api/gardens
curl -I http://localhost:4001/api/gardens/:id
```

Data routes:

downloading the sample plan csv and sending it to the server with:
```
curl -F "file=@plan.csv" http://localhost:4001/api/plan/new
```

doing the same for the sample garden csv:
```
curl -F "file=@garden.csv" http://localhost:4001/api/plan/new
```

