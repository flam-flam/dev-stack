#!/bin/sh

info () {
    echo "> $1"
}

warn () {
    echo "!!! $1"
}

error () {
    echo "!!! $1"; exit 1
}

info "Checking .env is set up correctly..."
[ -f "../.env" ] && info "Found .env" || error ".env not found. Please copy 'example.env' in this repo and add your reddit secrets to it."
grep "^REDDIT_CLIENT_ID" ../.env 1> /dev/null || error "REDDIT_CLIENT_ID is not set in .env"
grep "^REDDIT_CLIENT_SECRET" ../.env 1> /dev/null || error "REDDIT_CLIENT_ID is not set in .env"

info "Checking whether all required repos are here..."
required_repos="dispatcher-service comment-service submission-service helm-charts"
for repo in $required_repos; do
  [ -d "../../$repo" ] && info "$repo: ok" || error "Repository '$repo' doesn't exist at the same level as this repo. Clone it: 'git clone git@github.com:flam-flam/$repo.git'"
done

info "Building Helm chart dependencies..."
helm repo add flam-flam https://flam-flam.github.io/helm-charts
helm dependency build ../../helm-charts/charts/flam-flam
