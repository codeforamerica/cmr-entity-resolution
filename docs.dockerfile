FROM ghcr.io/astral-sh/uv:python3.15-trixie-slim

# Match the host user's IDs so the server can write to the mounted source.
ARG UID=1000
ARG GID=1000

# Install dependencies outside of /docs so the mounted source doesn't hide them.
ENV UV_PROJECT_ENVIRONMENT=/opt/venv \
    UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    PATH="/opt/venv/bin:$PATH"

WORKDIR /docs
COPY pyproject.toml uv.lock .python-version ./
RUN uv sync --locked --no-install-project

RUN groupadd --gid "$GID" docs \
    && useradd --uid "$UID" --gid docs --no-create-home --shell /usr/sbin/nologin docs
USER docs

EXPOSE 8000
CMD ["zensical", "serve", "--dev-addr", "0.0.0.0:8000"]
