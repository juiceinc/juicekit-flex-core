echo "Deploying site to localhost to test"
jekyll
sudo cp -r _site/* /Library/Webserver/Documents/
sudo chmod -R 777 /Library/Webserver/Documents/*
open http://localhost/index.html
