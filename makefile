#Get the current name and version from info.json
PACKAGE_NAME := $(shell cat info.json|jq -r .name)
VERSION_STRING := $(shell cat info.json|jq -r .version)
OUTPUT_NAME := $(PACKAGE_NAME)_$(VERSION_STRING)

#Directory to build in
BUILD_DIR := .build
OUTPUT_DIR := $(BUILD_DIR)/$(OUTPUT_NAME)
CONFIG = ./$(OUTPUT_DIR)/config.lua

PKG_COPY := $(wildcard *.md) $(wildcard *.txt) $(wildcard graphics) $(wildcard locale) $(wildcard sounds)

#find all JSON, LUA, and PNG files
SED_FILES := $(shell find . -iname '*.json' -type f -not -path "./.*/*") $(shell find . -iname '*.lua' -type f -not -path "./.*/*")
PNG_FILES := $(shell find ./graphics -iname '*.png' -type f)

OUT_FILES := $(SED_FILES:%=$(OUTPUT_DIR)/%)

SED_EXPRS := -e 's/{{MOD_NAME}}/$(PACKAGE_NAME)/g'
SED_EXPRS += -e 's/{{VERSION}}/$(VERSION_STRING)/g'

all: release

release: clean package

git: tag
	git checkout master
	git merge develop master
	git checkout develop
	git push --all
	git push --tags

package-copy: $(PKG_DIRS) $(PKG_FILES)
	@mkdir -p $(OUTPUT_DIR)
ifneq ($(PKG_COPY),)
	@cp -r $(PKG_COPY) $(OUTPUT_DIR)
endif

$(OUTPUT_DIR)/%.lua: %.lua
	@mkdir -p $(@D)
	@sed $(SED_EXPRS) $< > $@


$(OUTPUT_DIR)/%: %
	@mkdir -p $(@D)
	@sed $(SED_EXPRS) $< > $@

tag:
	git add .
	git commit -m "Preparing Release $(VERSION_STRING)"
	git tag -f v$(VERSION_STRING)

optimize:
	@echo Please wait, Optimizing Graphics.
	@for name in $(PNG_FILES); do \
		pngquant --skip-if-larger -q --strip --ext .png --force $(OUTPUT_DIR)'/'$$name; \
	done

#Remove debug switches from config file if present
nodebug:
	@[ -e ./$(CONFIG)/config.lua ] && \
	echo Removing debug switches from config.lua && \
	sed -i 's/^\(.*DEBUG.*=\).*/\1 false/' $(CONFIG) && \
	sed -i 's/^\(.*LOGLEVEL.*=\).*/\1 0/' $(CONFIG) && \
	sed -i 's/^\(.*loglevel.*=\).*/\1 0/' $(CONFIG) || \
	echo No Config Files

#Run luacheck on files in build directiory
check:
	@wget -q --no-check-certificate -O ./$(BUILD_DIR)/.luacheckrc https://raw.githubusercontent.com/Nexela/Factorio-luacheckrc/master/.luacheckrc
	#sed -i 's/exclude_files/_exclude_files_/' ./$(BUILD_DIR)/.luacheckrc
	luacheck ./$(OUTPUT_DIR)/ --codes --config ./$(BUILD_DIR)/.luacheckrc --include-files "**/.*/*"

package: package-copy $(OUT_FILES) check nodebug
	@cp -r stdlib $(BUILD_DIR)/$(OUTPUT_NAME)/stdlib
	@cd $(BUILD_DIR) && zip -rq $(OUTPUT_NAME).zip $(OUTPUT_NAME)
	@echo $(OUTPUT_NAME).zip ready

clean:
	@echo Removing Build Directory.
	@rm -rf $(BUILD_DIR)
