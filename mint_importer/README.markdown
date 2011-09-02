# Mint.com Transaction Importer

This software aims to enable users to import their previous history (more than 90 days older) into Mint.com


# Usage

Configure your username and password inside the file _login.yml_. After that, just type:
    ruby main.rb
and the transactions found inside transactions.csv will be imported to Mint.com


# Limitations

Mint.com does not allow manual trasactions to be _Exclude from mint_ or _Transfer_ of any kind. Because of that
make sure these categories are commented out inside _mint.yml_. If the transaction category is not found inside
this file, then it will be categorized as _:unknown_, which is also set inside the same YAML file.


