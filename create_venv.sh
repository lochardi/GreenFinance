#!/usr/bin/env bash
set -euo pipefail

# Usage examples:
#   ./create_venv.sh
#   ./create_venv.sh numpy scipy plotly

PYTHON_VERSION="3.13"
VENV_DIR=".venv"
REQ_FILE="requirements.txt"

if command -v pyenv >/dev/null 2>&1; then
	echo "[1/5] pyenv detected: install/use Python ${PYTHON_VERSION}"
	pyenv install "${PYTHON_VERSION}" --skip-existing
	pyenv local "${PYTHON_VERSION}"
	PYTHON_BIN="$(pyenv which python)"
else
	echo "[1/5] pyenv not found: using system python3"
	PYTHON_BIN="$(command -v python3)"
fi

echo "[2/5] Create virtual environment in ${VENV_DIR}"
"${PYTHON_BIN}" -m venv "${VENV_DIR}"

echo "[3/5] Activate venv and upgrade pip"
source "${VENV_DIR}/bin/activate"
python -m pip install --upgrade pip

echo "[4/5] Install project libraries"
if [[ -f "${REQ_FILE}" ]]; then
	echo "Installing from ${REQ_FILE}..."
	pip install -r "${REQ_FILE}"
else
	echo "No ${REQ_FILE} found, skipping."
fi

if [[ "$#" -gt 0 ]]; then
	echo "Installing extra packages from command line: $*"
	pip install "$@"
fi

# Ensure notebook support is available
pip install ipykernel
python -m ipykernel install --user --name greenfinance --display-name "Python (greenfinance)" || true

echo "[5/5] Done"
echo "Activate with: source ${VENV_DIR}/bin/activate"
echo "Add libraries in ${REQ_FILE} or pass them as arguments to this script."