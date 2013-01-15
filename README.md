# Notifly

Custom URL scheme around OSX's user notification center

## Terminal Usage

```
# create notification
open "notifly://publish?title=hello&message=world"

# create notification within a channel
open "notifly://publish/users?title=hello&message=world"

# remove all notifications
open "notifly://remove"

# remove all notifications within a channel
open "notifly://remove/users"

# list all notifications (JSON)
# NOTE: flakey right now, fixing
open "notifly://list"

# list all notifications in channel (JSON)
# NOTE: flakey right now, fixing
open "notifly://list/users"

# callbacks when user click notification
# NOTE: in development, unsure of the spec
open "notifly://publish?title=hello&body=world&activate=Google Chrome"

open "notifly://publish?title=hello&body=world&open=http://google.com"

open "notifly://publish?title=hello&body=world&perform=sudo rm -rf /"

```

## Planned

* fix listing and json serialization
* wrap in a rubygem
* implement actions

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Open Source Libs

* https://github.com/johnezang/JSONKit
