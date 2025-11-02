# Use official Flutter image
FROM ghcr.io/cirruslabs/flutter:3.35.7

# Set working directory
WORKDIR /app

# Copy pubspec files
COPY pubspec.* ./

# Get dependencies
RUN flutter pub get

# Copy source code
COPY . .

# Build web app
RUN flutter build web --release

# Expose port (not needed for Vercel but good practice)
EXPOSE 8080

# Serve the built app (Vercel will handle this)
CMD ["flutter", "build", "web", "--release"]
