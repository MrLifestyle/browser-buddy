#!/bin/bash

# Browser Buddy Runner Script

# Default values
MODE="help"
PORT_API=8000
PORT_UI=8080
URL=""
MODEL="mistral-openorca"
OUTPUT_DIR="output"

# Set up virtual environment if it doesn't exist
if [ ! -d "browser-buddy-env" ]; then
    echo "Setting up virtual environment..."
    python3 -m venv browser-buddy-env
    source browser-buddy-env/bin/activate
    pip install --upgrade pip
    pip install -r requirements.txt
    pip install "lxml[html_clean]"  # Required dependency for newspaper3k
    pip install python-multipart  # Required for FastAPI forms
    playwright install
else
    source browser-buddy-env/bin/activate
    # Check if playwright is installed
    if ! command -v playwright &> /dev/null && ! python -c "import playwright" &> /dev/null; then
        echo "Installing missing dependencies..."
        pip install -r requirements.txt
        pip install "lxml[html_clean]"  # Required dependency for newspaper3k
        pip install python-multipart  # Required for FastAPI forms
        playwright install
    fi
fi

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -h|--help)
            MODE="help"
            shift
            ;;
        api)
            MODE="api"
            shift
            ;;
        ui)
            MODE="ui"
            shift
            ;;
        summarize)
            MODE="summarize"
            shift
            ;;
        podcast)
            MODE="podcast"
            shift
            ;;
        -u|--url)
            URL="$2"
            shift
            shift
            ;;
        -m|--model)
            MODEL="$2"
            shift
            shift
            ;;
        -o|--output)
            OUTPUT_DIR="$2"
            shift
            shift
            ;;
        --api-port)
            PORT_API="$2"
            shift
            shift
            ;;
        --ui-port)
            PORT_UI="$2"
            shift
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Run the appropriate mode
case $MODE in
    help)
        echo "Browser Buddy - Web Automation and Content Processing"
        echo ""
        echo "Usage: ./run.sh [mode] [options]"
        echo ""
        echo "Modes:"
        echo "  api                 Start the API server"
        echo "  ui                  Start the Web UI"
        echo "  summarize           Summarize a URL"
        echo "  podcast             Generate a podcast from a URL"
        echo ""
        echo "Options:"
        echo "  -h, --help          Show this help message"
        echo "  -u, --url URL       URL to process (required for summarize/podcast)"
        echo "  -m, --model MODEL   LLM model to use (default: mistral-openorca)"
        echo "  -o, --output DIR    Output directory (default: output)"
        echo "  --api-port PORT     API server port (default: 8000)"
        echo "  --ui-port PORT      UI server port (default: 8080)"
        echo ""
        echo "Examples:"
        echo "  ./run.sh api                           # Start the API server"
        echo "  ./run.sh ui                           # Start the Web UI"
        echo "  ./run.sh summarize -u https://example.com/article  # Summarize an article"
        echo "  ./run.sh podcast -u https://example.com/article -m mixtral  # Generate podcast with Mixtral model"
        ;;
    api)
        echo "Starting API server on port $PORT_API..."
        export PYTHONPATH=$PWD
        python -c "from src.api.server import start_server; start_server(port=$PORT_API)"
        ;;
    ui)
        echo "Starting Web UI on port $PORT_UI..."
        export PYTHONPATH=$PWD
        BROWSER_BUDDY_API_PORT="$PORT_API" python -c "import os; print(f'API Port: {os.environ.get(\"BROWSER_BUDDY_API_PORT\")}'); from src.ui.server import start_ui; start_ui(port=$PORT_UI)"
        ;;
    summarize)
        if [ -z "$URL" ]; then
            echo "Error: URL is required for summarize mode"
            exit 1
        fi
        echo "Summarizing URL: $URL"
        python src/main.py --url "$URL" --output "$OUTPUT_DIR" --mode summarize --model "$MODEL"
        ;;
    podcast)
        if [ -z "$URL" ]; then
            echo "Error: URL is required for podcast mode"
            exit 1
        fi
        echo "Creating podcast from URL: $URL"
        python src/main.py --url "$URL" --output "$OUTPUT_DIR" --mode podcast --model "$MODEL"
        ;;
esac