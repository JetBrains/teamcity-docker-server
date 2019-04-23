$tags = @("1803", "1809")

foreach ($tag in $tags) {
 docker build `
 -t "teamcity-server:latest-nanoserver-$tag" `
 -f "nanoserver/$tag/Dockerfile" .
}