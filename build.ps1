# Build semi annual images
$tags = @("1803", "1809")
foreach ($tag in $tags) {
 docker build `
 --build-arg TAG=$tag `
 -t "teamcity-server:latest-nanoserver-$tag" `
 -f nanoserver/Dockerfile .
}