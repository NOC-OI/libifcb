#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR
cd ..
bash scripts/get-test-data.sh
mkdir -p dist
mkdir -p testout
python3 -m build
pip install --ignore-installed --no-deps dist/libifcb*.whl
python3 scripts/test.py
# python3 -m twin upload --repository testpypi dist/*
