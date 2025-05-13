# Use an official Swift image. Adjust the tag to your Swift version (e.g., 5.9, 6.0)
# Check https://hub.docker.com/_/swift for available tags
FROM swift:6.1-jammy AS builder

WORKDIR /build

# Copy Package.swift and Package.resolved to leverage Docker layer caching
COPY Package.swift .
#COPY Package.resolved . 

# Resolve dependencies first (caches this layer if no changes to manifest)
#RUN swift package resolve

# Copy the rest of the source code
COPY Sources/ Sources/
COPY Tests/ Tests/


# Build the specific executable in release mode
# Adjust --static-swift-stdlib if needed and supported by all dependencies
RUN swift build -c release --product MonsterBook -Xswiftc -diagnostic-style=llvm

# --- Runtime Stage ---
FROM ubuntu:jammy 

WORKDIR /app

# Copy the built executable from the builder stage
COPY --from=builder /build/.build/release/MonsterBook .

# Copy any runtime resources if needed (e.g., config files, assets)
# COPY --from=builder /build/Resources ./Resources 

# Expose port if your service listens on one (e.g., for HTTP)
# EXPOSE 8080 

CMD ["./MonsterBook"]
