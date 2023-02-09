# -*- makefile -*-

.PHONY: tags
.DEFAULT_GOAL: tags

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
all:

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
pull-stats:
	./pull-stats.sh

# pull_count:
#	curl -s https://hub.docker.com/v2/repositories/voltha/voltha-envoy \
#		| jq -r ".pull_count"

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
voltha-search:
	https://hub.docker.com/search?q=voltha

docker-log   := docker.search.log
docker-names := docker.names

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
docker-all : docker-search docker-names docker-stars
docker-search:
	docker search voltha | tee $(docker-log)

docker-names: $(docker-log)
	@awk '{print $$1}' $(docker-log) > docker.raw.names
	@tail -n +2 docker.raw.names > $(docker-names)

docker-stars : $(docker-log)
	@cut -c87- $(docker-log) \
	    | sed -e 's/[[:blank:]]*//' \
	    | awk '{print $$1}' \
	    > docker.raw.stars
	@tail -n +2 docker.raw.stars > docker.stars

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
tags:
	xargs -n1 --arg-file=$(docker-names) --verbose ./gather_tags.sh

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
clean:
	$(RM) -r tags
	$(RM) docker.search.log
	$(RM) docker*.names
	$(RM) docker*.stars
	$(RM) voltha.repo.stats
	$(RM) log

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
help ::
	@echo "Usage: $(MAKE) [options] [target] ..."
	@echo "Options:"
	@echo
	@echo "Targets:"
	@echo "  voltha-search    Display available docker images for voltha"
	@echo "  pull-stats       Report on download image stats"
	@echo
	@echo "[DATA STREAM]"
	@echo "  docker-all       Query api and create input data files"
	@echo "  docker-search    Raw data query"
	@echo "  docker-names     A list of docker images to query"
	@echo "  docker-stars     Docker image star stats"

# [EOF]
