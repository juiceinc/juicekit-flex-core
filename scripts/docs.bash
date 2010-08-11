# http://gauravj.com/blog/2009/06/setting-asdoc-description-for-packages/
echo "Run from the main directory of juicekit-flex-core to generate asdocs"
echo ""
echo "Output will be generated in target/asdoc-output/"
asdoc -doc-sources+=src/main/flex -package-description-file scripts/package-description-core.xml -main-title "JuiceKit Core API Documentation" -output target/asdoc-output/
open target/asdoc-output/index.html
