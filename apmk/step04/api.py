import blinker as _
import requests

from flask import Flask, Response
from flask import jsonify
from flask import request as flask_request

from ddtrace import tracer, patch, config
from ddtrace.contrib.flask import TraceMiddleware


# Tracer configuration
tracer.configure(hostname='agent')
patch(requests=True)

# enable distributed tracing for requests
# to send headers (globally)
config.requests['distributed_tracing'] = True

app = Flask('api')
traced_app = TraceMiddleware(app, tracer, service='thinker-api')


@app.route('/think/')
def think_handler():
    thoughts = requests.get('http://thinker:5001/', params={
        'subject': flask_request.args.getlist('subject', str),
    }).text
    return Response(thoughts, mimetype='application/json')
