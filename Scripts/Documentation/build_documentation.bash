
#-------------------------------------------------------------------------------
# Clean the existing docs.
rm -rf docs/
mkdir docs

#cd youmag-universal-v-2

#-------------------------------------------------------------------------------
# Launch documentation generation
#--search-undocumented-doc \

BASE_URL="http://youmag-wiki.vaseltior.com/public"
echo "$BASE_URL"

./Scripts/Documentation/appledoc \
--templates ./Scripts/Documentation/Templates/ \
--docsetutil-path /Applications/Xcode.app/Contents/Developer/usr/bin/docsetutil \
--verbose 3 \
--project-name "OMGrauFramework" \
--project-version "1.0" \
--project-company "Samuel Grau" \
--company-id "com.vaseltior" \
--no-create-docset \
--docset-atom-filename "$2.atom" \
--docset-feed-name "%PROJECT Docs" \
--docset-feed-url "$BASE_URL/docs/$2/publish/%DOCSETATOMFILENAME" \
--docset-package-filename "$2.xar" \
--docset-package-url "$BASE_URL/docs/$2/publish/%DOCSETPACKAGEFILENAME" \
--publish-docset \
--create-html \
-d \
-n \
-u \
--explicit-crossref \
--preprocess-headerdoc \
--print-information-block-titles \
--keep-intermediate-files \
--warn-undocumented-member \
--warn-undocumented-object \
--warn-empty-description \
--warn-unknown-directive \
--warn-invalid-crossref \
--warn-missing-arg \
--output docs \
./OMGrauFramework


#--docset-feed-url "http://vaseltior.github.com/SGBaseFramework/sgbaseframeworkdocset.atom" \
#--docset-package-url  "http://vaseltior.github.com/SGBaseFramework/com.vaseltior.sgbaseframework.xar" \
