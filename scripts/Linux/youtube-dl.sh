# https://stackoverflow.com/questions/32482230/how-to-set-up-default-download-location-in-youtube-dl
youtube-dl -i -a youtube-dl.list -o "~/Downloads/%(title)s-%(id)s.%(ext)s"
