# Asmo: Asset Mover

This is a tool that moves assets between S3 buckets while updating a MySQL database.

## Getting Started

Asmo takes advantage of the Nix package manager, and you can get set up by
[installing Nix](https://nixos.org/download.html), and then running `nix-shell`
from the project directory. You be put in an isolated shell with all
dependencies installed.

_[To start the infrastructure and communicate with AWS, you will need to
authenticate with the AWS CLI tool, so Asmo can use its credentials (in
`~/.aws`). The AWS CLI tool is available in the Nix shell.]_

From the Nix shell, run the following commands:

1. `terraform init` to set up the terraform tool using the providers installed by Nix
- `terrafrom apply` to create the infrastructure resources (S3 buckets and MySQL database)
- `mix deps.get` to download the Elixir dependencies used by the project
- `mix reset_table` to create an assets table in the database

You should not be ready to give it a try. First, populate some asssets with the following command:

```
$ mix populate [number_of_assets] [offset of the first id]
Populated images/avatar-1.png
Populated avatar/avatar-2.png
...
```

The default values for the number of assets and offset are 1000 and 1 respectively.

At this point you can check what the distribution of assets looks like:

```
$ mix check
Legacy: 502
Modern: 498
```

It's time to move the legacy assets to the modern bucket:

```
$ mix move
Moved images/avatar-1.png to avatar/avatar-2.png
...
```

Finally, you can check the distribution again to assert the assets have been moved:

```
$ mix check
Legacy: 0
Modern: 1000
```

## Configuration

Look at the `config/config.exs` file for settings and their values. The important ones are:

- `legacy`/`modern`: tuples containing the bucket names and the key/filename pattern
- `chunk_size`: number of assets that are enqueued to be processed together
- `db_pool_size`: size of database connection pool
- `process_pool_size`: number of assets that are processed in parallel
