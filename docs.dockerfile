FROM squidfunk/mkdocs-material:latest

# Install PlantUML so we can render UML diagrams.
RUN pip install markdown-callouts plantuml_markdown
RUN apk add --no-cache plantuml --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community \
    && rm -rf /var/cache/apk/*
