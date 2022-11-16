# Show all the just recepies available
default:
    just --list

# Builds a docker image from the Dockerfile
build:
    docker build . -t nvim-dockerized:latest
