import requests

from flask import Flask, Response, jsonify
from flask import request as flask_request

from ddtrace import tracer
from ddtrace.contrib.flask import TraceMiddleware


# Tracer configuration
tracer.configure(hostname='agent')

app = Flask('api')
traced_app = TraceMiddleware(app, tracer, service='thinker-api')


@app.route('/think/')
def think_handler():
    thoughts = requests.get('http://thinker:5001/',params={
        'subject': flask_request.args.getlist('subject', str),
    }).content
    return Response(thoughts, mimetype='application/json')
