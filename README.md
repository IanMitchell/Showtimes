# Showtimes

**This project has been deprecated in favor of [Deschtimes](https://deschtimes.com) which you can find at [https://github.com/ianmitchell/deschtimes](https://github.com/ianmitchell/deschtimes)**

Showtimes is a fansub progress tracker that exposes an API for groups to use. It goes alongside [Aquarius](https://github.com/IanMitchell/aquarius) on Discord. It's intended to serve multiple groups, but needs some more development before I can open access.

## Getting Access

An official showtimes server is up and running for several groups; before I can open access to anyone there is some database and permission work that needs to happen on the Admin panel. Currently, users can edit any record in the database; we're working on adding scoping on this to prevent unauthorized data access.

If you'd like to get in contact, please contact me on Discord on the [Company Inc Server](http://discord.companyinc.company) or [Good Job Media Server](https://discord.gg/hQewDqS).

## Hosting

If you want to run your own Showtimes instance, I recommend hosting it on Heroku. It should deploy to it without much issue - to set your instance up, log into the rails console and run:

```ruby
> admin = Administrator.new(email: "<email>", password: "<pass>", name: "<name>")
> admin.save
```

You should be able to log into the Admin panel at https://yourdomain.com/admin and begin creating shows and groups!

## Feature Requests

If you have a feature you'd like to request, please open an issue on GitHub!
