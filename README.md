# Asmo: Asset Mover

This is a tool that moves assets between S3 buckets while updating a MySQL database.

## Getting Started

Asmo takes advantage of the Nix package manager, and you can get set up by
[installing Nix](https://nixos.org/download.html), and then running `nix-shell`
from the project directory. You be put in an isolated shell with all
dependencies installed.

_To start the infrastructure and communicate with AWS, you will need to
authenticate with the AWS CLI tool, so Asmo can use its credentials (in
`~/.aws`). The AWS CLI tool is available in the Nix shell._

From the Nix shell, run the following commands:

1. `terraform init` to set up the terraform tool using the providers installed by Nix
2. `terrafrom apply` to create the infrastructure resources (S3 buckets and MySQL database)
3. `mix deps.get` to download the Elixir dependencies used by the project (say 'yes' to rebar3 and hex)
4. `mix reset_table` to create an assets table in the database

You should now be ready to give it a try. First, populate some assets with the following command:

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

You can check the distribution again and see that the assets have been moved:

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

#### MySQL Configuration

You might want to run your own instance of MySQL instead of one managed by AWS.
For that case, you don't want the database settings picked up from the
Terraform state.

To do that, edit the body of `db_options()` in `lib/asmo/application.ex` to
return a Keyword list with the right values for `:hostname`, `:database`,
`:username` and `:password`, and leave the other fields as-is.
