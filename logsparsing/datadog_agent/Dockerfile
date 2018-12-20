FROM datadog/agent:latest

RUN touch /etc/datadog-agent/conf.d/training.yaml
RUN echo "logs:\n  - type: tcp\n    port:10520\n    service: testtcp\n    source: training\n    tags: course:logparsing" >> /etc/datadog-agent/conf.d/training.yaml