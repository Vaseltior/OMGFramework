#!/bin/sh

pwd
./Scripts/documentation/appledoc \
--templates ./Scripts/documentation/Templates/ \
--project-name appledoc \
--project-company "youmag" \
--company-id com.youmag \
--warn-undocumented-object \
--warn-undocumented-member \
--warn-empty-description \
--warn-unknown-directive \
--output ~/help \
--no-create-html \
--explicit-crossref \
--ignore "*.m" \
--search-undocumented-doc \
./OMGrauFramework

#--keep-undocumented-objects \
#--keep-undocumented-members \
