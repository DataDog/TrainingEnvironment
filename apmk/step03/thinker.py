import blinker as _
import requests

from flask import Flask, Response
from flask import jsonify
from flask import request as flask_request

from ddtrace import tracer
from ddtrace.contrib.flask import TraceMiddleware

from thoughts import thoughts
from time import sleep

# Tracer configuration
tracer.configure(hostname='agent')

app = Flask('api')
traced_app = TraceMiddleware(app, tracer, service='thinker-microservice', distributed_tracing=True)

@tracer.wrap(name='think')
def think(subject):
    tracer.current_span().set_tag('subject', subject)

    sleep(0.5)
    return thoughts[subject]

@app.route('/')
def think_microservice():
    # because we have distributed tracing, don't need to manually grab headers
    subject = flask_request.args.get('subject')
    thoughts = think(subject)
    return Response(thoughts, mimetype='application/json')
