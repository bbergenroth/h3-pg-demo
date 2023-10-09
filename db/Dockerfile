FROM postgres:16-bookworm

RUN apt-get update && \
	apt-mark hold locales && \
	apt-get install -y --no-install-recommends \
	build-essential \
	cmake \
	postgresql-server-dev-16 \
	postgresql-16-postgis-3 \
	pgxnclient && \
    pgxn install h3 && \
    apt-get remove -y build-essential postgresql-server-dev-16 cmake && \
    apt-get autoremove -y && \
    apt-mark unhold locales && \
    rm -rf /var/lib/apt/lists/*

