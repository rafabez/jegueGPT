# JegueGPT - OpenAI Large Language Model Interface

JegueGPT is a Python-based interface for interacting with OpenAI's large language models. It provides a streamlined way to integrate and utilize OpenAI's powerful AI capabilities in your applications.

## Features
- Easy-to-use Python interface
- Configurable model parameters
- Simple deployment via Procfile
- Comprehensive error handling

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/jegueGPT.git
   cd jegueGPT
   ```

2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Set up your OpenAI API key:
   ```bash
   export OPENAI_API_KEY='your-api-key-here'
   ```

## Usage

Run the main script:
```bash
python bot_openai_large.py
```

The script will provide interactive prompts for using the OpenAI models.

## Configuration

You can configure the following environment variables:
- `OPENAI_API_KEY`: Your OpenAI API key (required)
- `MODEL_NAME`: Which OpenAI model to use (default: gpt-4)
- `TEMPERATURE`: Model temperature (default: 0.7)

## Contributing

We welcome contributions! Please follow these steps:
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
