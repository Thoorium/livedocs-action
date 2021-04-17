# Container image that runs your code
FROM thoorium/livedocs:dev-generator

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]