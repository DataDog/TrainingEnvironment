import requests

from flask import Flask, Response, jsonify
from flask import request as flask_request

from ddtrace import tracer
from ddtrace.contrib.flask import TraceMiddleware

from thoughts import thoughts
from time import sleep

# Tracer configuration
tracer.configure(hostname='agent')

app = Flask('api')
traced_app = TraceMiddleware(app, tracer, service='thinker-microservice')

@tracer.wrap(name='think')
def think(subject):
    tracer.current_span().set_tag('subject', subject)

    sleep(0.5)
    return thoughts[subject]

@app.route('/')
def think_microservice():
    subject = flask_request.args.get('subject')
    thoughts = think(subject)
    return Response(thoughts, mimetype='application/json')
