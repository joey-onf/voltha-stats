# -*- makefile -*-

.PHONY: help
.DEFAULT_GOAL: help

##-------------------##
##---]  GLOBALS  [---##
##-------------------##
HIDE    ?= @

gen-dir := tmp
gen-raw := $(gen-dir)/raw
DIRS    += $(gen-dir)

docker-log       := $(gen-raw)/docker.search.log
docker-names     := $(gen-dir)/docker.names

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
all:

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
pull-stats: docker-names
	./pull-stats.sh '--markup' "$(docker-names)"

# pull_count:
#	curl -s https://hub.docker.com/v2/repositories/voltha/voltha-envoy \
#		| jq -r ".pull_count"

## -----------------------------------------------------------------------
## -----------------------------------------------------------------------
#voltha-search:
#	curl -o $@.log 'https://hub.docker.com/search?q=voltha'

## -----------------------------------------------------------------------
## Intent: docker-search will query dockerhub for a list of voltha*
##         image names.
## -----------------------------------------------------------------------
docker-all : docker-search docker-names docker-stars
docker-search: $(docker-log)

$(docker-log):
	@echo "** Docker image search: VOLTHA"
	$(HIDE)mkdir -p $(gen-raw)
	$(HIDE)docker search voltha \
	    | sort \
	    > $(docker-log)

docker-names: $(docker-log)
	@echo "** -----------------------------------------------------------------------"
	@echo "** Docker image names (search=voltha)"
	@echo "** -----------------------------------------------------------------------"
	$(HIDE)awk '{print $$1}' $(docker-log) \
	    | tail -n +2 \
	    | tee $(docker-names)

## -----------------------------------------------------------------------
## Intent: Format image names using markup syntax.
##         Table can be copy and pasted into jira using the </> insert op.
##   1) access wiki.*
##   2) Click + pulldown in the tool bar.
##   3) Select </> markup
##   4) Copy & paste text into the left handle panel.
##   5) Hit <tab> to render a grid with the image names.
##   6) If all is good click to save.
## -----------------------------------------------------------------------
docker-names-markup: $(docker-names)
	@echo '|| Repository || ONF || TLM || Downloads || Description ||'
	@awk '{print "| " $$1 " | | | | |" }' $(docker-names)

## -----------------------------------------------------------------------
## Intent: Extract star count, times an image was hilighted.
## -----------------------------------------------------------------------
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
	$(RM) -r $(DIRS)
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
	@echo "  docker-stars     Docker image star stats"
	@echo "  docker-names     A list of docker images to query"
	@echo "  docker-names-markup  markup docker-names for pasting into jira."
	@echo
	@echo "[STATS: docker]"
	@echo "  pull-stats       Image download stats"

# [EOF]
