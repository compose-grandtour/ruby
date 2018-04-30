# The Grand Tour - Ruby
A set of example applications that will add word/definition pairs to a database running on Compose.

This repo contains the apps written in Ruby 2.5.0 and uses the Sinatra web framework.

## Running the Examples

To run from the command-line:
- navigate to the example-<db> directory
- export your Compose connection string as an environment variable
- run the application `ruby <db>-example.rb`

The application will be served on `http://localhost:4567` and can be opened in a browser.