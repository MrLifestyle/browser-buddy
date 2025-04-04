# Browser Buddy

A browser automation agent that combines web scraping, content summarization, and podcast generation capabilities.

## Features

- **Web Automation**: Navigate URLs and handle authenticated sites using Playwright
- **Content Summarization**: Extract and summarize article content with bullet points
- **Podcast Creation**: Convert summaries into natural spoken audio with multiple voice options
- **API**: Full REST API for programmatic access
- **Web UI**: Modern, user-friendly interface for all functionality

## Installation Guide

### Prerequisites

- Python 3.8+
- [Homebrew](https://brew.sh/) (for Mac users)
- ffmpeg (for audio processing)

### Step 1: Clone the Repository

```bash
git clone https://github.com/yourusername/browser-buddy.git
cd browser-buddy
```

### Step 2: Set Up the Virtual Environment

The app uses a virtual environment to isolate dependencies. Our setup script will create this automatically:

```bash
chmod +x run.sh
./run.sh --help
```

This will:
- Create a virtual environment named `browser-buddy-env`
- Install all Python dependencies from `requirements.txt`
- Install Playwright and its browsers

### Step 3: Install System Dependencies

For macOS users (using Homebrew):
```bash
brew install ffmpeg
```

For Linux users:
```bash
sudo apt update
sudo apt install ffmpeg
```

For Windows users:
- Download and install ffmpeg from [ffmpeg.org](https://ffmpeg.org/download.html)
- Add ffmpeg to your system PATH

### Step 4: Install an LLM Engine

The app uses [Ollama](https://ollama.ai) for local LLM processing:

1. Install Ollama from [ollama.ai](https://ollama.ai/download)
2. Pull the required models:
```bash
ollama pull mistral-openorca  # Primary model for summarization
ollama pull llama2            # Alternative model (optional)
```

### Step 5: Configure the Application (Optional)

You can configure Browser Buddy by creating a `.env` file:

```bash
cp .env.example .env
```

Edit `.env` to customize settings like:
- API ports
- Default LLM model
- TTS settings

## Usage Guide

### Starting the Application

1. Start the API server:
```bash
./run.sh api --api-port 6969
```

2. In a new terminal, start the UI server:
```bash
./run.sh ui --ui-port 6970 --api-port 6969
```

3. Open your browser to http://localhost:6970

### Using the Web Interface

#### Content Summarization

1. Go to the home page
2. Enter a URL in the "Summarize URL" section
3. Select your preferred LLM model
4. Click "Generate Summary"
5. The task will be processed, and you'll be redirected to results page

#### Podcast Generation

1. Go to the home page
2. Enter a URL in the "Generate Podcast" section
3. Select your preferred:
   - LLM model for text generation
   - Voice option (multiple accents and genders available)
   - Output format (MP3 or WAV)
4. Click "Generate Podcast"
5. Once processed, you can listen to or download the audio

### Voice Options

Browser Buddy supports multiple voices with various accents:

| Voice ID | Description | Sound |
|----------|-------------|-------|
| en_us_001 | US English (Male - Fred) | Clear, authoritative |
| en_us_002 | US English (Female - Samantha) | Professional, balanced |
| en_gb_001 | UK English (Male - Daniel) | Formal British accent |
| en_gb_002 | UK English (Female - Moira) | Warm Irish accent |
| en_au_001 | Indian (Male - Rishi) | Indian accent |
| en_au_002 | Australian (Female - Karen) | Australian accent |
| neutral | Neutral (Fred) | Balanced US accent |

#### Testing Voice Options

To help you choose the best voice for your podcasts, Browser Buddy includes a voice testing utility:

```bash
# Make sure your virtual environment is activated
source browser-buddy-env/bin/activate

# Run the voice testing utility
python tools/test_voices.py
```

This will play a sample of each available voice so you can hear how they sound before creating podcasts.

### Command Line Usage

You can also use Browser Buddy directly from the command line:

```bash
# Summarize a URL
./run.sh summarize -u https://example.com/article -m mistral-openorca

# Generate a podcast from a URL
./run.sh podcast -u https://example.com/article -m mistral-openorca

# Specify custom output directory
./run.sh podcast -u https://example.com/article -o my-podcasts
```

### Using the API

Browser Buddy provides a RESTful API for integration with other systems:

#### Summarize a URL
```bash
curl -X POST -H "Content-Type: application/json" \
  -d '{"url": "https://example.com/article", "model": "mistral-openorca"}' \
  http://localhost:6969/summarize
```

#### Generate a Podcast
```bash
curl -X POST -H "Content-Type: application/json" \
  -d '{"url": "https://example.com/article", "model": "mistral-openorca", "voice": "en_gb_001", "output_format": "mp3"}' \
  http://localhost:6969/podcast
```

#### Check Task Status
```bash
curl http://localhost:6969/jobs/job_id_from_previous_response
```

## Troubleshooting

### Common Issues

1. **Missing ffmpeg**: If podcast generation fails with "ffmpeg not found", install ffmpeg as described in Step 3.

2. **Port already in use**: If you see an error like `address already in use`, try different ports:
```bash
./run.sh api --api-port 7000
./run.sh ui --ui-port 7001 --api-port 7000
```

3. **LLM Errors**: If summarization fails, ensure Ollama is running:
```bash
ollama serve  # Start the Ollama server
```

4. **Module not found errors**: Ensure you're running in the activated environment:
```bash
source browser-buddy-env/bin/activate
```

## License

MIT

## Acknowledgements

This project was inspired by:
- [Browser-use](https://github.com/browser-use/browser-use)
- [Agent-zero](https://github.com/frdel/agent-zero)
- [OpenWebUI](https://github.com/open-webui/open-webui) 