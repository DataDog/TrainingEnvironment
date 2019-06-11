import blinker as _
import requests

from flask import Flask, Response, jsonify
from flask import request as flask_request

from ddtrace import tracer
from ddtrace.contrib.flask import TraceMiddleware

from bootstrap import create_app
from models import Thought

from time import sleep

app = create_app()
traced_app = TraceMiddleware(app, tracer, service='thinker-microservice', distributed_tracing=True)

# Tracer configuration
tracer.configure(hostname='agent')

@tracer.wrap(name='think')
def think(subject):
    tracer.current_span().set_tag('subject', subject)

    sleep(0.5)
    quote = Thought.query.filter_by(subject=subject).first()
    
    return quote

@app.route('/')
def think_microservice():
    # because we have distributed tracing, don't need to manually grab headers
    subject = flask_request.args.get('subject')
    thoughts = think(subject)
    return jsonify(thoughts.serialize())
