#!/usr/bin/env python3

from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return 'This is a very basic page.'

if __name__ == '__main__':
    app.run()
