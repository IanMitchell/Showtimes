# Showtimes

Showtimes is a fansub progress tracker that exposes an API for groups to use. It goes alongside [Aquarius](https://github.com/IanMitchell/aquarius) on Discord. It's intended to serve multiple groups, but needs some more development before I can open access. If you would like to help with this process, 

## Getting Access

An official showtimes server is up and running for several groups; before I can open access to anyone there is some database and permission work that needs to happen on the Admin panel.

1. Currently each view loads each record - [the collection method needs to be overridden](https://github.com/TrestleAdmin/trestle/issues/217) to filter by current user
2. Instead of Shows being the single source of truth, Groups need to be. Shows should be attached to groups, and Shows should no longer be unique.
3. Admins should only be able to edit items they own
4. The Administrators pane should be hidden from all users

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
