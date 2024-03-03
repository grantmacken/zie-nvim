SHELL=/bin/bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --silent
CONFIG := $(HOME)/.config/nvim
rwildcard = $(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))
luaList  := $(call rwildcard,lua,*.lua)
luaBuild := $(patsubst lua/%.lua,$(CONFIG)/lua/%.lua,$(luaList)) 

afterList  := $(call rwildcard,after,*.lua)
afterBuild := $(patsubst after/%.lua,$(CONFIG)/after/%.lua,$(afterList))

initBuild := $(CONFIG)/init.lua

default: $(initBuild) $(luaBuild) $(afterBuild)

info:
	echo $(initBuild) 
	echo $(luaBuild) 
	echo $(afterBuild) | sed s% %--%g


$(CONFIG)/lua/%.lua: lua/%.lua
	mkdir -p $(dir $@)
	echo $(notdir $<)
	cp $< $@

$(CONFIG)/after/%.lua: after/%.lua
	mkdir -p $(dir $@)
	echo $(notdir $<)
	cp $< $@

$(CONFIG)/init.lua: init.lua
	mkdir -p $(dir $@)
	echo $(notdir $<)
	cp $< $@

clean: 
	rm -R $(CONFIG) || true

