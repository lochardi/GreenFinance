
# Install Python 3.13 if not available
pyenv install 3.13 --skip-existing

# Create virtual environment
pyenv local 3.13
$(pyenv which python) -m venv .venv

# Activate and install
source .venv/bin/activate
pip install --upgrade pip
pip install -e .
pip install ipykernel

echo "Done! Activate with: source .venv/bin/activate"