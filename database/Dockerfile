FROM postgres:12

ARG image_url='https://github.com/octodemo-db/bookstore'
ARG version=0
ARG changelist=main

LABEL org.opencontainers.image.authors GitHub Solutions Engineering
LABEL org.opencontainers.image.url ${image_url}
LABEL org.opencontainers.image.documentation ${image_url}/database/README.md
LABEL org.opencontainers.image.source ${image_url}
LABEL org.opencontainers.image.version ${version}
LABEL org.opencontainers.image.revision ${changelist}
LABEL org.opencontainers.image.vendor GitHub
LABEL org.opencontainers.image.licenses MIT
LABEL org.opencontainers.image.title GitHub Solutions Engineering Bookstore
LABEL org.opencontainers.image.description Database Container for bookstore demo

# Inject the initialization scripts in to the container
COPY db-scripts/* /docker-entrypoint-initdb.d/
