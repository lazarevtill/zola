#!/bin/bash

# Zola + Supabase Docker Setup Script
# This script helps you set up Zola with self-hosted Supabase

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
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

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Generate random string
generate_secret() {
    openssl rand -base64 32 | tr -d "=+/" | cut -c1-32
}

# Main setup function
main() {
    echo "🚀 Zola + Supabase Docker Setup"
    echo "================================"
    echo

    # Check prerequisites
    print_status "Checking prerequisites..."
    
    if ! command_exists docker; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi

    if ! command_exists docker-compose; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi

    print_success "Prerequisites check passed"
    echo

    # Ask for deployment type
    echo "Select deployment type:"
    echo "1) Supabase + Zola (Cloud AI models)"
    echo "2) Supabase + Zola + Ollama (Fully self-hosted)"
    echo
    read -p "Enter your choice (1 or 2): " deployment_type

    case $deployment_type in
        1)
            COMPOSE_FILE="docker-compose.supabase.yml"
            INCLUDE_OLLAMA=false
            print_status "Selected: Supabase + Zola deployment"
            ;;
        2)
            COMPOSE_FILE="docker-compose.supabase-ollama.yml"
            INCLUDE_OLLAMA=true
            print_status "Selected: Supabase + Zola + Ollama deployment"
            ;;
        *)
            print_error "Invalid choice. Exiting."
            exit 1
            ;;
    esac

    echo

    # Check if .env.supabase already exists
    if [ -f ".env.supabase" ]; then
        print_warning ".env.supabase already exists"
        read -p "Do you want to overwrite it? (y/N): " overwrite
        if [[ ! $overwrite =~ ^[Yy]$ ]]; then
            print_status "Using existing .env.supabase file"
            echo
        else
            setup_environment
        fi
    else
        setup_environment
    fi

    # Start services
    print_status "Starting Docker services..."
    docker-compose -f "$COMPOSE_FILE" --env-file .env.supabase up -d

    # Wait for services to be ready
    print_status "Waiting for services to start..."
    sleep 10

    # Check service health
    check_services

    # Download Ollama models if needed
    if [ "$INCLUDE_OLLAMA" = true ]; then
        setup_ollama_models
    fi

    # Print success message
    print_success "Deployment completed successfully!"
    echo
    echo "🌐 Access your services:"
    echo "   • Zola App: http://localhost:3000"
    echo "   • Supabase Studio: http://localhost:8000"
    echo "   • Supabase API: http://localhost:8000"
    if [ "$INCLUDE_OLLAMA" = true ]; then
        echo "   • Ollama API: http://localhost:11434"
    fi
    echo
    echo "📚 Next steps:"
    echo "   1. Open Supabase Studio and verify the database schema"
    echo "   2. Configure your AI model API keys in .env.supabase"
    echo "   3. Test the application by creating a chat"
    echo
    echo "📖 For more information, see DOCKER_DEPLOYMENT.md"
}

# Setup environment file
setup_environment() {
    print_status "Setting up environment file..."
    
    # Copy template
    cp env.supabase.example .env.supabase

    # Generate secrets
    print_status "Generating secure secrets..."
    POSTGRES_PASSWORD=$(generate_secret)
    JWT_SECRET=$(generate_secret)
    LOGFLARE_API_KEY=$(generate_secret)
    CSRF_SECRET=$(generate_secret)

    # Update secrets in .env.supabase
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s/POSTGRES_PASSWORD=.*/POSTGRES_PASSWORD=$POSTGRES_PASSWORD/" .env.supabase
        sed -i '' "s/JWT_SECRET=.*/JWT_SECRET=$JWT_SECRET/" .env.supabase
        sed -i '' "s/LOGFLARE_API_KEY=.*/LOGFLARE_API_KEY=$LOGFLARE_API_KEY/" .env.supabase
        sed -i '' "s/CSRF_SECRET=.*/CSRF_SECRET=$CSRF_SECRET/" .env.supabase
    else
        # Linux
        sed -i "s/POSTGRES_PASSWORD=.*/POSTGRES_PASSWORD=$POSTGRES_PASSWORD/" .env.supabase
        sed -i "s/JWT_SECRET=.*/JWT_SECRET=$JWT_SECRET/" .env.supabase
        sed -i "s/LOGFLARE_API_KEY=.*/LOGFLARE_API_KEY=$LOGFLARE_API_KEY/" .env.supabase
        sed -i "s/CSRF_SECRET=.*/CSRF_SECRET=$CSRF_SECRET/" .env.supabase
    fi

    # Set Ollama URL if needed
    if [ "$INCLUDE_OLLAMA" = true ]; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s/OLLAMA_URL=.*/OLLAMA_URL=http:\/\/ollama:11434/" .env.supabase
        else
            sed -i "s/OLLAMA_URL=.*/OLLAMA_URL=http:\/\/ollama:11434/" .env.supabase
        fi
    fi

    print_success "Environment file created with secure secrets"
    
    # Ask for API keys
    echo
    print_status "AI Model API Keys (optional - you can add these later):"
    echo "You can skip these for now and add them later to .env.supabase"
    echo
    
    read -p "OpenAI API Key (optional): " openai_key
    if [ ! -z "$openai_key" ]; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s/OPENAI_API_KEY=.*/OPENAI_API_KEY=$openai_key/" .env.supabase
        else
            sed -i "s/OPENAI_API_KEY=.*/OPENAI_API_KEY=$openai_key/" .env.supabase
        fi
    fi

    read -p "Anthropic API Key (optional): " anthropic_key
    if [ ! -z "$anthropic_key" ]; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s/ANTHROPIC_API_KEY=.*/ANTHROPIC_API_KEY=$anthropic_key/" .env.supabase
        else
            sed -i "s/ANTHROPIC_API_KEY=.*/ANTHROPIC_API_KEY=$anthropic_key/" .env.supabase
        fi
    fi

    echo
}

# Check if services are running
check_services() {
    print_status "Checking service health..."
    
    # Wait for database
    for i in {1..30}; do
        if docker exec supabase-db pg_isready -U postgres >/dev/null 2>&1; then
            print_success "Database is ready"
            break
        fi
        if [ $i -eq 30 ]; then
            print_error "Database failed to start"
            exit 1
        fi
        sleep 2
    done

    # Check Zola app
    for i in {1..30}; do
        if curl -s http://localhost:3000/api/health >/dev/null 2>&1; then
            print_success "Zola app is ready"
            break
        fi
        if [ $i -eq 30 ]; then
            print_warning "Zola app may not be ready yet (this is normal on first start)"
        fi
        sleep 2
    done

    # Check Supabase API
    for i in {1..30}; do
        if curl -s http://localhost:8000/rest/v1/ >/dev/null 2>&1; then
            print_success "Supabase API is ready"
            break
        fi
        if [ $i -eq 30 ]; then
            print_warning "Supabase API may not be ready yet"
        fi
        sleep 2
    done
}

# Setup Ollama models
setup_ollama_models() {
    print_status "Setting up Ollama models..."
    
    # Wait for Ollama to be ready
    for i in {1..60}; do
        if curl -s http://localhost:11434/api/tags >/dev/null 2>&1; then
            print_success "Ollama is ready"
            break
        fi
        if [ $i -eq 60 ]; then
            print_error "Ollama failed to start"
            return 1
        fi
        sleep 2
    done

    echo
    print_status "Available models to download:"
    echo "1) llama3.2:latest (4GB) - General purpose"
    echo "2) codellama:7b (3.8GB) - Code generation"
    echo "3) mistral:7b (4.1GB) - Fast and efficient"
    echo "4) Skip model download"
    echo
    read -p "Select models to download (comma-separated, e.g., 1,2,3): " model_choice

    IFS=',' read -ra MODELS <<< "$model_choice"
    for model in "${MODELS[@]}"; do
        case $model in
            1)
                print_status "Downloading llama3.2:latest..."
                docker exec ollama ollama pull llama3.2:latest
                ;;
            2)
                print_status "Downloading codellama:7b..."
                docker exec ollama ollama pull codellama:7b
                ;;
            3)
                print_status "Downloading mistral:7b..."
                docker exec ollama ollama pull mistral:7b
                ;;
            4)
                print_status "Skipping model download"
                break
                ;;
            *)
                print_warning "Invalid model choice: $model"
                ;;
        esac
    done

    print_success "Ollama setup completed"
}

# Run main function
main "$@" 