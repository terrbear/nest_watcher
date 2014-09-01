nest_watcher
============

To run this on your own setup, download the repository, bundle install, and copy credentials_example.yml to credentials.yml, and fill in the fields with values for your own API access.

Run it as a cronjob every 30 minutes, and you'll have historical data in no time (well, starting at the time your cronjob starts).

The credentials file supports ERB, if you'd prefer not to write your values into the file.
