#!/bin/bash

# StitchMe Development Environment Setup Script

echo "🏥 Setting up StitchMe development environment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Flutter is installed
check_flutter() {
    print_status "Checking Flutter installation..."
    if command -v flutter &> /dev/null; then
        FLUTTER_VERSION=$(flutter --version | head -n 1)
        print_success "Flutter found: $FLUTTER_VERSION"
    else
        print_error "Flutter not found. Please install Flutter first."
        exit 1
    fi
}

# Check if Node.js is installed
check_node() {
    print_status "Checking Node.js installation..."
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node --version)
        print_success "Node.js found: $NODE_VERSION"
    else
        print_error "Node.js not found. Please install Node.js first."
        exit 1
    fi
}

# Check if Python is installed
check_python() {
    print_status "Checking Python installation..."
    if command -v python3 &> /dev/null; then
        PYTHON_VERSION=$(python3 --version)
        print_success "Python found: $PYTHON_VERSION"
    else
        print_error "Python 3 not found. Please install Python 3 first."
        exit 1
    fi
}

# Install Flutter dependencies
setup_flutter() {
    print_status "Setting up Flutter dependencies..."
    
    # Install root dependencies
    flutter pub get
    
    # Install Flutter app dependencies
    cd apps/flutter_app
    flutter pub get
    cd ../..
    
    # Install shared package dependencies
    for package in packages/*/; do
        if [ -f "$package/pubspec.yaml" ]; then
            print_status "Installing dependencies for $package"
            cd "$package"
            flutter pub get
            cd ../..
        fi
    done
    
    print_success "Flutter dependencies installed"
}

# Install Node.js dependencies
setup_node() {
    print_status "Setting up Node.js dependencies..."
    
    # API service
    if [ -f "services/api/package.json" ]; then
        print_status "Installing API service dependencies..."
        cd services/api
        npm install
        cd ../..
    fi
    
    # Realtime service
    if [ -f "services/realtime/package.json" ]; then
        print_status "Installing realtime service dependencies..."
        cd services/realtime
        npm install
        cd ../..
    fi
    
    print_success "Node.js dependencies installed"
}

# Install Python dependencies
setup_python() {
    print_status "Setting up Python dependencies..."
    
    # AI service
    if [ -f "services/ai-service/requirements.txt" ]; then
        print_status "Installing AI service dependencies..."
        cd services/ai-service
        
        # Create virtual environment if it doesn't exist
        if [ ! -d "venv" ]; then
            python3 -m venv venv
        fi
        
        # Activate virtual environment and install dependencies
        source venv/bin/activate
        pip install -r requirements.txt
        deactivate
        
        cd ../..
    fi
    
    print_success "Python dependencies installed"
}

# Create environment files
setup_env_files() {
    print_status "Setting up environment files..."
    
    # Root .env file
    if [ ! -f ".env" ]; then
        cp .env.example .env 2>/dev/null || echo "# StitchMe Environment Variables
SUPABASE_URL=your_supabase_url_here
SUPABASE_ANON_KEY=your_supabase_anon_key_here
SUPABASE_SERVICE_KEY=your_supabase_service_key_here

# Development
NODE_ENV=development
DEBUG=true

# Services
API_PORT=3000
AI_SERVICE_PORT=8000
SIGNALING_PORT=3001" > .env
        print_warning "Created .env file. Please update with your actual values."
    fi
    
    # API service .env
    if [ ! -f "services/api/.env" ] && [ -f "services/api/.env.example" ]; then
        cp services/api/.env.example services/api/.env
    fi
    
    # AI service .env
    if [ ! -f "services/ai-service/.env" ] && [ -f "services/ai-service/env.example" ]; then
        cp services/ai-service/env.example services/ai-service/.env
    fi
    
    print_success "Environment files created"
}

# Run Flutter doctor
run_flutter_doctor() {
    print_status "Running Flutter doctor..."
    flutter doctor
}

# Main setup function
main() {
    echo "🚀 Starting StitchMe development setup..."
    echo ""
    
    # Check prerequisites
    check_flutter
    check_node
    check_python
    
    echo ""
    print_status "Prerequisites check passed!"
    echo ""
    
    # Setup dependencies
    setup_flutter
    setup_node
    setup_python
    
    # Setup environment
    setup_env_files
    
    # Final checks
    run_flutter_doctor
    
    echo ""
    print_success "🎉 StitchMe development environment setup complete!"
    echo ""
    echo "Next steps:"
    echo "1. Update .env files with your actual configuration values"
    echo "2. Set up your Supabase project"
    echo "3. Run 'flutter run -d chrome' to start the Flutter app"
    echo "4. Run 'npm run dev' in services/api to start the API server"
    echo "5. Run 'python main.py' in services/ai-service to start the AI service"
    echo ""
    echo "For more information, check the README.md file."
}

# Run main function
main
