# http://gauravj.com/blog/2009/06/setting-asdoc-description-for-packages/
#alias adoc="/Applications/Adobe Flash Builder 4/sdks/4.1.0/bin//asdoc"
echo "Run from the main directory of juicekit-flex-core to generate asdocs"
echo ""
echo "Output will be generated in target/asdoc-output/"
"/Applications/Adobe Flash Builder 4/sdks/4.1.0/bin//asdoc" -doc-sources+=src/main/flex -package-description-file scripts/package-description-core.xml -main-title "JuiceKit Core API Documentation" -output target/asdoc-output/ -templates-path scripts/templates
open target/asdoc-output/index.html
