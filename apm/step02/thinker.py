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
    # continue the span from the called service
    trace_id = flask_request.headers.get("X-Datadog-Trace-Id")
    parent_id = flask_request.headers.get("X-Datadog-Parent-Id")
    if trace_id and parent_id:
        span = tracer.current_span()
        span.trace_id = int(trace_id)
        span.parent_id = int(parent_id)

    subject = flask_request.args.get('subject')
    thoughts = think(subject)
    return Response(thoughts, mimetype='application/json')
