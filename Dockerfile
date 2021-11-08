# This Dockerfile uses the multi-stage build pattern:
# https://docs.docker.com/develop/develop-images/multistage-build/
# This avoids baking build dependencies (in this case, the Go compiler) into
# the final Docker image.

# First we declare a build container based on golang:l.16-alpine, called builder
# The builder has to be an alpine image for the binary to run on alpine:3
FROM golang:1.16-alpine as builder

# The builder compiles our code and writes the binary to /build/hello
WORKDIR /build
COPY hello.go .
RUN go build -o hello hello.go

# Next, we declare a new container, based on alpine:3, which will be the
# basis for the final Docker image
FROM alpine:3

# We copy the binary from the builder into the alpine image, and set it as the
# default command for this container.
WORKDIR /
COPY --from=builder /build/hello .
CMD ["/hello"]

# Finally Docker takes the last declared container (in our case, our alpine
# container) and uses it to create the final image. The builder is cached, but
# not included in the image.
